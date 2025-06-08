*** Settings ***
Documentation    A resource file with suitable keywords and variables
...    It is created by Subhayan
Library    SeleniumLibrary
Library    OperatingSystem
*** Variables ***
${url}    https://rahulshettyacademy.com/loginpagePractise/
${login_username}    amazon123
${login_incorrect_password}    amazon123
${login_password}    amazon123


*** Keywords ***
Open the browser with the Mortage Payment url
    Create Webdriver    Chrome
    Go To    ${url}
    Maximize Browser Window

Close Browser Session
    Close Browser