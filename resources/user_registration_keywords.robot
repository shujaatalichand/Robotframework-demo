*** Settings ***
Library    SeleniumLibrary
Variables    ./selectors.py
*** Variables ***

*** Keywords ***
Generate Random Username
    [Arguments]    ${base_username}
    ${random}=    Evaluate    random.randint(1000, 9999)    random
    RETURN    ${base_username}${random}

Enter User Registration Data
    [Arguments]    ${first_name}    ${last_name}    ${street}    ${city}    ${state}    ${zip_code}    ${phone}    ${ssn}    ${username}    ${password}
    Input Text    ${first_name_field}    text=${first_name}
    Input Text    ${last_name_field}    text=${last_name}
    Input Text    ${street_field}    text=${street}
    Input Text    ${city_field}    text=${city}
    Input Text    ${state_field}    text=${state}
    Input Text    ${zip_code_field}    text=${zip_code}
    Input Text    ${phone_field}    text=${phone}
    Input Text    ${ssn_field}    text=${ssn}
    Input Text    ${username_field}    text=${username}
    Input Text    ${password_field}    text=${password}
    Input Text    ${repeated_password_field}    text=${password}
    Click Button    ${submitBtn}
    Wait Until Page Contains    ${user_creation_success_msg}

Open New Account
    [Arguments]    ${account_type}=savings
    Click Element    ${open_new_account_link}
    Page Should Contain    Open New Account
    IF    '${account_type}' == 'savings'
        Select From List By Value    ${account_type_select}    1
    ELSE
        Select From List By Value    ${account_type_select}    0
    END


    Click Element    ${open_new_account_submit_btn}
    Page Should Contain    Account Opened!

