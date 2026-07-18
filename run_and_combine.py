#!/usr/bin/env python3
"""Run the Robot Framework suite once per tag via run-docker-tests.sh,
then merge the per-tag output.xml files into one combined report/log."""

import argparse
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent
IMAGE_NAME = "robotframework-demo"
DEFAULT_TAGS = ["sanity", "Regression", "accounts"]


def build_image() -> int:
    print("=== Building Docker image ===")
    result = subprocess.run(["docker", "build", "-t", IMAGE_NAME, "."], cwd=REPO_ROOT)
    return result.returncode


def run_tag(tag: str, env: str, browser: str) -> tuple[str, int]:
    cmd = [
        "./run-docker-tests.sh",
        "--include", tag,
        "--variable", f"ENV:{env}",
        "--variable", f"BROWSER:{browser}",
        "--outputdir", f"results/{tag}",
        "testsuites/",
    ]
    # Capture output so parallel workers don't interleave on stdout;
    # printed as a block once the run finishes.
    result = subprocess.run(cmd, cwd=REPO_ROOT, capture_output=True, text=True)
    print(f"\n=== Tag '{tag}' finished (exit {result.returncode}) ===")
    print(result.stdout)
    if result.returncode != 0:
        print(result.stderr, file=sys.stderr)
    return tag, result.returncode


def combine_results(tags: list[str]) -> int:
    results_dir = REPO_ROOT / "results"
    outputs = [tag for tag in tags if (results_dir / tag / "output.xml").exists()]
    if not outputs:
        print("No output.xml files found to combine.", file=sys.stderr)
        return 1

    container_outputs = [f"/robot/results/{tag}/output.xml" for tag in outputs]
    cmd = [
        "docker", "run", "--rm",
        "-v", f"{results_dir}:/robot/results",
        "--entrypoint", "python3",
        IMAGE_NAME,
        "-m", "robot.rebot",
        "--merge",
        "--outputdir", "/robot/results/combined",
        "--output", "output.xml",
        "--log", "log.html",
        "--report", "report.html",
        *container_outputs,
    ]
    print(f"\n=== Combining results from: {', '.join(outputs)} ===")
    result = subprocess.run(cmd, cwd=REPO_ROOT)
    return result.returncode


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--tags", nargs="+", default=DEFAULT_TAGS,
                         help=f"Tags to run, one container run each (default: {DEFAULT_TAGS})")
    parser.add_argument("--env", default="prod", help="ENV variable (default: prod)")
    parser.add_argument("--browser", default="chrome", help="BROWSER variable (default: chrome)")
    parser.add_argument("--workers", type=int, default=1,
                         help="Number of tag runs to execute concurrently (default: 1, sequential)")
    args = parser.parse_args()

    # Build once up front so concurrent run-docker-tests.sh calls all hit
    # a warm cache instead of racing each other on `docker build`.
    if build_image() != 0:
        print("Docker build failed.", file=sys.stderr)
        return 1

    failed_tags = []
    with ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = [executor.submit(run_tag, tag, args.env, args.browser) for tag in args.tags]
        for future in as_completed(futures):
            tag, code = future.result()
            if code != 0:
                failed_tags.append(tag)

    combine_code = combine_results(args.tags)

    combined_dir = REPO_ROOT / "results" / "combined"
    print(f"\nCombined report: file://{combined_dir / 'report.html'}")
    print(f"Combined log:    file://{combined_dir / 'log.html'}")

    if failed_tags:
        print(f"\nTag runs with failures: {', '.join(failed_tags)}", file=sys.stderr)

    if failed_tags or combine_code != 0:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
