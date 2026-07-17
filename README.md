# Robotframework-demo

Robot Framework + SeleniumLibrary UI/API automation suite for the
[ParaBank](https://parabank.parasoft.com/parabank) demo banking application.
It covers home page sanity checks, user registration, login, and account
creation (savings/checking) flows.

CI runs the `sanity` suite headlessly on every push/PR via
[.github/workflows/ci.yml](.github/workflows/ci.yml). Licensed under
[MIT](LICENSE).

## Repo structure

```
.
├── requirements.txt              # Python/Robot Framework dependencies
├── Dockerfile                    # Containerized test runner (headless Chromium)
├── run-docker-tests.sh           # Build + run the Docker image, print report links
├── testsuites/
│   └── parabank/
│       ├── homepage.robot        # Home page sanity & regression tests
│       └── account-services.robot# Registration, login, account creation tests
├── resources/
│   ├── common_keywords/
│   │   └── common_keywords.robot # Shared keywords, ENV/BROWSER/URLS variables
│   ├── home_page_keywords.robot  # Home page & navigation keywords
│   ├── user_registration_keywords.robot # Registration/account keywords
│   ├── selectors.py              # Locators used by the keyword files
│   └── test_data/
│       └── user_data.json        # Test data fixtures
├── execution/
│   └── lib/
│       └── Parabanklib.py        # Custom Python library (e.g. API user creation)
├── chromedriver/, geckodriver/, firefox/  # Local browser binaries (gitignored)
└── results/                      # Robot Framework test output (gitignored)
```

## Prerequisites

- Python 3.10+
- Google Chrome and/or Firefox installed locally

## Install dependencies

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Configuration

Environment and browser are controlled via Robot Framework variables defined
in [resources/common_keywords/common_keywords.robot](resources/common_keywords/common_keywords.robot):

| Variable  | Default | Description |
|-----------|---------|-------------|
| `ENV`     | `prod`  | Selects the base URL from the `URLS` dictionary (`prod` or `local`) |
| `BROWSER` | `chrome`| Browser used by SeleniumLibrary (`chrome`, `firefox`, etc.) |

Both can be overridden from the command line without editing any files.

## Running the tests

Run the full suite (defaults to `prod` / `chrome`):

```bash
robot --outputdir results testsuites/
```

### Run against a specific environment

```bash
# Production (https://parabank.parasoft.com/parabank)
robot --outputdir results --variable ENV:prod testsuites/

# Local (http://localhost:8080/parabank)
robot --outputdir results --variable ENV:local testsuites/
```

### Run with a specific browser

```bash
robot --outputdir results --variable BROWSER:chrome testsuites/
robot --outputdir results --variable BROWSER:firefox testsuites/
```

### Combine environment and browser

```bash
robot --outputdir results --variable ENV:local --variable BROWSER:firefox testsuites/
```

### Run by tag

Available tags: `sanity`, `Regression`, `newtest`.

```bash
# Only sanity checks
robot --outputdir results --include sanity testsuites/

# Only regression tests, against local env, on firefox
robot --outputdir results --include Regression --variable ENV:local --variable BROWSER:firefox testsuites/

# Exclude a tag
robot --outputdir results --exclude newtest testsuites/
```

## Running the tests with Docker

No local Python/Chrome setup required — the image bundles headless Chromium
and its matching driver.

```bash
./run-docker-tests.sh
```

This builds the `robotframework-demo` image, runs the full suite in a
container, and bind-mounts `results/` so the log/report/output files land
directly in the repo (no manual copy step). It finishes by printing clickable
links to `results/report.html` and `results/log.html`.

Equivalent manual steps:

```bash
docker build -t robotframework-demo .
docker run --rm -v "$(pwd)/results:/robot/results" robotframework-demo
```

The container always runs headless (`HEADLESS=true` is set in the
[Dockerfile](Dockerfile)); running `robot`/`Open Browser` directly on your
host (outside Docker) still opens a normal visible browser. The image only
has Chrome/Chromium installed, so `BROWSER` must stay `chrome`.

### Parameterize env / browser / tags

The image's `ENTRYPOINT` is `python3 -m robot --outputdir results`, with
`CMD` defaulting to `testsuites/`. Any arguments you pass after the image
name replace that default `CMD` and are appended to the entrypoint — so the
same `--variable`/`--include` flags used for local runs (see
[Configuration](#configuration) and [Run by tag](#run-by-tag) above) work
here too, just remember to end with `testsuites/`. `run-docker-tests.sh`
forwards any arguments you give it the same way.

```bash
# Full suite against prod (same as no args at all)
./run-docker-tests.sh --variable ENV:prod --variable BROWSER:chrome testsuites/

# Only sanity-tagged tests against prod
./run-docker-tests.sh --variable ENV:prod --include sanity testsuites/

# Only regression-tagged tests against prod
./run-docker-tests.sh --variable ENV:prod --include Regression testsuites/
```

Equivalent raw `docker run` form:

```bash
docker run --rm -v "$(pwd)/results:/robot/results" robotframework-demo \
  --variable ENV:prod --variable BROWSER:chrome --include sanity testsuites/
```

## Test output

Logs, reports, and screenshots are written to `results/` (ignored by git —
see [.gitignore](.gitignore)). Open `results/report.html` or
`results/log.html` after a run to review results.
