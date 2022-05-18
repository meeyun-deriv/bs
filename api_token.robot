*** Settings ***
Documentation    To test API token page
Library     SeleniumLibrary
Resource    common.robot


*** Keywords ***
Go to API token page
    Click element   //*[@class="account-settings-toggle"]
    Wait until page contains element    dc_api-token_link   20
    Click element   dc_api-token_link
    Wait until page contains    Copy and paste the token into the app.



*** Test Cases ***
Create new API token
    Login
    Go to API token page
    Click element   //*[text()="Read"]//parent::label   # tick read scope
    Click element   //*[text()="Trade"]//parent::label  # tick trade scope
    Click element   //*[text()="Payments"]//parent::label   # tick payments scope
    Click element   //*[text()="Admin"]//parent::label
    Click element   //*[text()="Trading information"]//parent::label
    Input text      //*[@name="token_name"]     imtesting
    Click element   //*[text()="Create"]//parent::button    # click create button
    Wait until page contains element    (//*[@class="da-api-token__table-cell-row"]/td/span)[1]     # wait until api created. Table has 1 row
    ${token_name}=  Get text    (//*[@class="da-api-token__table-cell-row"]/td/span)[1]
    log to console      ${token_name}
    Should be equal     ${token_name}   imtesting
    Wait until page contains element    (//*[@class="da-api-token__table-cell-row"]/td/span)[1]     # wait until api has delete button
    Wait until page contains element    //*[text()="Delete"]//parent::button     # wait until api has delete button
    Click element   //*[text()="Delete"]//parent::button
    Wait until page contains element    //*[text()="Yes"]//parent::button    10  # wait until yes button appears
    capture page screenshot     yesbutton.png
    sleep   3
    Click element   //*[text()="Yes"]//parent::button
    Wait until page does not contain    imtesting   10




