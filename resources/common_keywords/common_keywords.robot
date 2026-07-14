*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${ENV}     prod    
&{URLS}    prod= https://parabank.parasoft.com/parabank    local= http://localhost:8080/parabank
${BROWSER}    chrome
*** Keywords ***
Start Test Case
    Open Browser    ${URLS.${ENV}}    ${BROWSER}
    Maximize Browser Window

Close Browser
    SeleniumLibrary.Close Browser