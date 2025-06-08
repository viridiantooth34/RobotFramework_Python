*** Settings ***
Documentation    A resource file with suitable keywords and variables
...    It is created by Subhayan
Library    SeleniumLibrary
Library    OperatingSystem
*** Variables ***
${url}    https://rahulshettyacademy.com/loginpagePractise/
${login_username}    rahulshettyacademy
${login_incorrect_password}    amazon123
${login_password}    learning



*** Keywords ***
Open the browser with the Mortage Payment url
    Create Webdriver    Edge
    Go To    ${url}
    Maximize Browser Window

Close Browser Session
    Close Browser