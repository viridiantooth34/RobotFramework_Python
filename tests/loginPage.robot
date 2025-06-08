*** Settings ***
Documentation    To validate the login form
Library    SeleniumLibrary
Test Teardown    Close Browser Session
#Resource

*** Variables ***
${Error_Message_Login}  xpath://div[contains(text(),' username/password.')]


*** Test Cases ***
Validate Unsuccessful Login
    Open the browser with the Mortage Payment url
    Fill the login Form
    Wait until it checks and display error message
    Verify error message is correct

*** Keywords ***
Open the browser with the Mortage Payment url
    Create Webdriver    Chrome
    Go To    https://rahulshettyacademy.com/loginpagePractise/
Fill the login Form
    Input Text    xpath://input[@id='username']    amazon123    #robotframework support id, xpath, css
    Input Password    xpath://input[@id='password']    amazon123
    Click Button    id:signInBtn
Wait until it checks and display error message
    Wait Until Element Is Visible    ${Error_Message_Login}    timeout=10

Verify error message is correct
    ${result}=    Get Text    ${Error_Message_Login}
    Should Be Equal As Strings    ${result}    Incorrect username/password.
Close Browser Session
    Close Browser