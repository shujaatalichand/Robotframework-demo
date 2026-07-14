*** Settings ***
Library    Collections
Resource    ../../resources/user_registration_keywords.robot
Resource    ../../resources/home_page_keywords.robot
Resource    ../../resources/common_keywords/common_keywords.robot
Library    ../../execution/lib/Parabanklib.py
Variables    ../../resources/test_data/user_data.json

Test Setup    Start Test Case
Test Teardown    Close Browser

*** Test Cases ***
Open New Savings Account
    [Documentation]    This will open a new account for the user
    [Tags]    newtest
    Open User Registration Section
    ${unique_username}=    Generate Random Username    ${user_data.username}
    ${registration_payload}=    Copy Dictionary    ${user_data}
    Set To Dictionary    ${registration_payload}    username=${unique_username}
    create_user    ${registration_payload}    ${URLS.${ENV}}
    Login    ${unique_username}    ${user_data.password}
    Open New Account    savings


Open New Checking Account
    [Documentation]    This will open a new account for the user
    [Tags]    newtest
    Open User Registration Section
    ${unique_username}=    Generate Random Username    ${user_data.username}
    ${registration_payload}=    Copy Dictionary    ${user_data}
    Set To Dictionary    ${registration_payload}    username=${unique_username}
    create_user    ${registration_payload}    ${URLS.${ENV}}
    Login    ${unique_username}    ${user_data.password}
    Open New Account    checkings