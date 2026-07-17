*** Settings ***
Resource    ../../resources/user_registration_keywords.robot
Resource    ../../resources/home_page_keywords.robot
Resource    ../../resources/common_keywords/common_keywords.robot
Variables    ../../resources/test_data/user_data.json

Test Setup    Start Test Case
Test Teardown    Close Browser


*** Test Cases ***
Home page Verifification
    [Documentation]  Para Bank home page test
    [Tags]    sanity    Regression
    Title Should Be    ParaBank | Welcome | Online Banking
    

Home Page Navigation Links Should Be Present
    [Documentation]    Verify the main navigation links are present on the home page
    [Tags]    sanity    Regression
    Verify Nav Links

New User Registration
    [Documentation]    This test will register a new user
    [Tags]    Regression
    Open User Registration Section
    ${unique_username}=    Generate Random Username    ${user_data.username}
    Enter User Registration Data    ${user_data.first_name}    ${user_data.last_name}    ${user_data.street}    ${user_data.city}    ${user_data.state}    ${user_data.zip_code}    ${user_data.phone}    ${user_data.ssn}    ${unique_username}    ${user_data.password}


Verify Left Menu
    [Documentation]    This will Verify the left menu on the Home page
    [Tags]    Regression
    Verify left Menu keyword
    
    
    

    





