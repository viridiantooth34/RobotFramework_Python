*** Settings ***
Documentation    To validate the login form
Library    SeleniumLibrary
Test Setup       Open the browser with the Mortage Payment url
Test Teardown    Close Browser Session
Resource        resource.robot

*** Variables ***
${Error_Message_Login}  xpath://div[contains(text(),' username/password.')]


*** Test Cases ***
Validate Unsuccessful Login
    #Open the browser with the Mortage Payment url
    Fill the login Form    ${login_username}    ${login_incorrect_password}
    Wait until it checks and display error message
    Verify error message is correct



*** Keywords ***

Fill the login Form
    [Arguments]    ${username}    ${password}
    Input Text    xpath://input[@id='username']    ${username}    #robotframework support id, xpath, css
    Input Password    xpath://input[@id='password']    ${password}
    Click Button    id:signInBtn
Wait until it checks and display error message
    Wait Until Element Is Visible    ${Error_Message_Login}    timeout=10

Verify error message is correct
    ${result}=    Get Text    ${Error_Message_Login}
    Should Be Equal As Strings    ${result}    Incorrect username/password.
    Capture Page Screenshot
    Log To Console    error msg is ${result}
