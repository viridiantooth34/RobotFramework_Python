*** Settings ***
Documentation    To validate the login form
Library    SeleniumLibrary
Library    Collections
Library    String
Test Setup       Open the browser with the Mortage Payment url
Test Teardown    Close Browser Session
Resource        resource.robot

*** Variables ***
${Error_Message_Login}  xpath://div[contains(text(),' username/password.')]
${getProduct}     Nokia Edge
${numberOfItems}    3


*** Test Cases ***
Validate Unsuccessful Login
    Fill the login Form    ${login_username}    ${login_incorrect_password}
    Click on sign in button
    Wait until it checks and display error message
    Verify error message is correct

Validate Successful Login
    Fill the login Form    ${login_username}    ${login_password}
    Click on the checkbox for Terms and Conditions
    Click on sign in button
    Validate Successful Login to the home page

Validate all the options in Login Page
    Fill the login Form    ${login_username}    ${login_password}
    Select User in Login Page
    Click on the checkbox for Terms and Conditions
    Select 'Teacher' option from the dropdown
    Click on sign in button
    Validate Successful Login to the home page

Validate e2e process to add an item in the cart and checkout
    Fill the login Form    ${login_username}    ${login_password}
    Select User in Login Page
    Click on the checkbox for Terms and Conditions
    Select 'Teacher' option from the dropdown
    Click on sign in button
    Validate Successful Login to the home page
    Validate the list of items present in home page
    Validate the item is added to the cart    ${item_Count_global}    ${getProduct}    ${numberOfItems}
    Validate the item is checked out from the cart page

Validate Document Request Page
    Click on the Document Request Page
    Validate the Document Request Page is displayed
    Copy the email address from the Document Request Page
    Validate that the user is present in the Login Page
    Fill the login Form    ${emailAddressInDocumentRequestPage_Global}    ${login_password}







*** Keywords ***

Fill the login Form
    #Login Page
    [Arguments]    ${username}    ${password}
    Input Text    xpath://input[@id='username']    ${username}    #robotframework support id, xpath, css
    Input Password    xpath://input[@id='password']    ${password}
    Sleep    1s

    
Wait until it checks and display error message
    #Login Page
    Wait Until Element Is Visible    ${Error_Message_Login}    timeout=10

Verify error message is correct
    #Login Page
    ${result}=    Get Text    ${Error_Message_Login}
    Should Be Equal As Strings    ${result}    Incorrect username/password.
    #Capture Page Screenshot
    Log To Console    error msg is ${result}

Select User in Login Page
    #Login Page
    Click Element    xpath://span[contains(text(),' User')]
    Wait Until Element Is Visible    id:okayBtn
    Sleep    2s
    Click Element    xpath://button[@id='okayBtn']

Click on the checkbox for Terms and Conditions
    #Login Page
    Wait Until Element Is Visible    xpath://input[@id='terms']    timeout=10
    Select Checkbox    xpath://input[@id='terms']

Select 'Teacher' option from the dropdown
    #Login Page
    Select From List By Value    xpath://select[@class='form-control']    teach

Click on sign in button
    #Login Page
    Click Button    id:signInBtn

Validate Successful Login to the home page
    #Home Page
    Wait Until Element Is Visible    xpath://a[contains(text(),'ProtoCommerce Home')]    timeout=10
    ${homePageTitle}=    Get Text    xpath://a[contains(text(),'ProtoCommerce Home')]
    Should Be Equal As Strings    ${homePageTitle}    ProtoCommerce Home
#    Log To Console    the title of the home page is ${homePageTitle}


Validate the list of items present in home page
    #Home Page
    Wait Until Element Is Visible    xpath://h4[@class='card-title']

    @{itemList_Page} =    Get WebElements    xpath://h4[@class='card-title']
    ${counter}=    Set Variable    0
    @{itemList_Text} =    Create List
    &{item_Count} =	Create Dictionary
    @{itemList_User} =    Create List    iphone X    Samsung Note 8    Nokia Edge    Blackberry

    FOR    ${item_Page}    IN    @{itemList_Page}
        ${items_text}=    Get Text    ${item_Page}
        ${counter}=    Evaluate    ${counter} + 1
#        Log To Console    ${items_text} and ${counter}\n
        Append To List	${itemList_Text}	${items_text}
        ${item_Count}[${items_text}] =	Set Variable	${counter}
    END
    Set Global Variable    &{item_Count_global}    &{item_Count}
    Lists Should Be Equal    ${itemList_Text}    ${itemList_User}
#    Log To Console    ${item_Count}

Validate the item is added to the cart
    #Cart Page
    [Arguments]    ${item_Count_global}    ${productName}    ${countOfProducts}
    ${itemIndex} =	Get From Dictionary	${item_Count_global}	${productName}
    Click Button    xpath:(//button[text()='Add '])[${itemIndex}]
    Wait Until Element Is Visible    xpath://a[contains(text(),'Checkout')]   timeout=10
    Click Element    xpath://a[contains(text(),'Checkout')]
    ${itemNameInCartPage}=    Get Text    //h4[@class='media-heading']
    Log To Console    Your product is ${itemNameInCartPage}
    Should Be Equal As Strings    ${itemNameInCartPage}    ${productName}
    Wait Until Element Is Visible    xpath://button[@type='button'][contains(text(),'Checkout')]
    Click Button    xpath://button[@type='button'][contains(text(),'Checkout')]

Validate the item is checked out from the cart page
    #Purchase Page
    Wait Until Element Is Visible    xpath://input[@value='Purchase']    timeout=10
    Execute JavaScript    document.querySelector("input[value='Purchase']").click()
    Wait Until Element Is Visible    xpath://strong[contains(text(),'Success!')]
    ${successMessage}=    Get Text    xpath://strong[contains(text(),'Success!')]
    Should Be Equal As Strings    ${successMessage}    Success!

Click on the Document Request Page
    #Home Page
    Wait Until Element Is Visible    xpath://a[@class='blinkingText'][contains(text(),'InterviewQues/ResumeAssistance/Material')]
    Click Element    xpath://a[@class='blinkingText'][contains(text(),'InterviewQues/ResumeAssistance/Material')]
    Switch Window    NEW

Validate the Document Request Page is displayed
    #Document Request Page
    Wait Until Element Is Visible    xpath://h1[text()='Documents request']
    ${actualHeaderInDocumentRequestPage}=    Get Text    xpath://h1[text()='Documents request']
    Should Be Equal As Strings    ${actualHeaderInDocumentRequestPage}    DOCUMENTS REQUEST

Copy the email address from the Document Request Page
    #Document Request Page
    ${paragraphInDocumentRequestPage}=    Get Text    xpath://p[@class='im-para red']
    ${paragraphInDocumentRequestPage_List} =    Split String    ${paragraphInDocumentRequestPage}
    ${emailAddressInDocumentRequestPage}=    Get From List	${paragraphInDocumentRequestPage_List}	4
    Log To Console    ${emailAddressInDocumentRequestPage}
    Switch Window    MAIN
    Set Global Variable    ${emailAddressInDocumentRequestPage_Global}    ${emailAddressInDocumentRequestPage}

Validate that the user is present in the Login Page
    ${actualTitle}=    Get Title
    Should Be Equal As Strings    ${actualTitle}    LoginPage Practise | Rahul Shetty Academy
