*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem


*** Variables ***
${ENV}     prod
&{URLS}    prod= https://parabank.parasoft.com/parabank    local= http://localhost:8080/parabank
${BROWSER}    chrome
*** Keywords ***
Start Test Case
    ${headless}=    Get Environment Variable    HEADLESS    default=false
    IF    '${headless}' == 'true'
        Open Browser    ${URLS.${ENV}}    ${BROWSER}    options=binary_location="/usr/bin/chromium";add_argument("--headless=new");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--disable-gpu");add_argument("--window-size=1920,1080")    executable_path=/usr/bin/chromedriver
    ELSE
        Open Browser    ${URLS.${ENV}}    ${BROWSER}
        Maximize Browser Window
    END

Close Browser
    SeleniumLibrary.Close Browser