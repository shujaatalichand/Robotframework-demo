*** Settings ***
Library    SeleniumLibrary
Variables    ./selectors.py



*** Keywords ***
Open User Registration Section
    Click Element   ${user_registraion_link}
    wait until page contains element    ${registration_page_div}

Login
    [Arguments]    ${username}    ${password}
    Input Text    ${username_login_field}    ${username}
    Input Text    ${password_login_field}    ${password}
    Click Button    ${login_btn}
    Wait Until Page Contains    Accounts Overview

Verify Nav Links
    FOR    ${link}    IN    @{nav_links}
        Page Should Contain Link    ${link}
    END

Verify left Menu keyword
    ${link_count}=    Get Element Count    ${left_menu_list_css}
    FOR    ${index}    IN RANGE    1    ${link_count} + 1
        ${text_of_element}=    Get Text    ${left_menu_list}(${index})
        ${list_index}=    Evaluate    ${index} - 1
        ${expected_text}=    Set Variable    ${left_menu}[${list_index}]
        Should Be Equal As Strings    ${text_of_element}    ${expected_text}
    END
