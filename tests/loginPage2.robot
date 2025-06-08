*** Settings ***
Documentation    To validate the login form
Library    SeleniumLibrary
Library    Collections
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
    Wait until it checks and display error message
    Verify error message is correct
Validate Successful Login
    Fill the login Form    ${login_username}    ${login_password}
    Click on the checkbox for Terms and Conditions
    Click on sign in button
    Validate Successful Login to the home page

Validate e2e process to add an item in the cart and checkout

    Fill the login Form    ${login_username}    ${login_password}
    Click on the checkbox for Terms and Conditions
    Click on sign in button
    Validate Successful Login to the home page
    Validate the list of items present in home page
    Validate the item is added to the cart    ${item_Count_global}    ${getProduct}    ${numberOfItems}
    Validate the item is checked out from the cart page





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
    #Capture Page Screenshot
    Log To Console    error msg is ${result}

Click on the checkbox for Terms and Conditions
    Select Checkbox    xpath://input[@id='terms']

Click on sign in button
    Click Button    id:signInBtn

Validate Successful Login to the home page
    Wait Until Element Is Visible    xpath://a[contains(text(),'ProtoCommerce Home')]    timeout=10
    ${homePageTitle}=    Get Text    xpath://a[contains(text(),'ProtoCommerce Home')]
    Should Be Equal As Strings    ${homePageTitle}    ProtoCommerce Home
#    Log To Console    the title of the home page is ${homePageTitle}

Validate the list of items present in home page
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
    ####PurchasePage
    Wait Until Element Is Visible    xpath://input[@value='Purchase']    timeout=10
#    Click Element    xpath://input[@value='Purchase']
    Execute JavaScript    document.querySelector("input[value='Purchase']").click()
#    Sleep    10s
#    Click Button    xpath://input[@value='Purchase']
    Wait Until Element Is Visible    xpath://strong[contains(text(),'Success!')]
    ${successMessage}=    Get Text    xpath://strong[contains(text(),'Success!')]
    Should Be Equal As Strings    ${successMessage}    Success!

