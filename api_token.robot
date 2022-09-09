*** Settings ***
Documentation    To test API token page
Library     SeleniumLibrary
Resource    common.robot


*** Keywords ***


*** Test Cases ***
Create new API token
    Login    # refer steps in login.robot
    # go to API token page
    Wait Until Page Does Not Contain Element    dt_core_header_acc-info-preloader    20    # wait account switcher finish loading
    Wait Until Page Contains Element    //*[@class="account-settings-toggle"]    5
    Click element   //*[@class="account-settings-toggle"]
    Wait until page contains element    dc_api-token_link   20
    Click element   dc_api-token_link
    Wait until page contains    Copy and paste the token into the app.    20
    
    # create new API token with name = imtesting
    Click element   //*[text()="Read"]//parent::label   # tick read scope
    Click element   //*[text()="Trade"]//parent::label  # tick trade scope
    Click element   //*[text()="Payments"]//parent::label   # tick payments scope
    Click element   //*[text()="Admin"]//parent::label      # tick admin scope
    Click element   //*[text()="Trading information"]//parent::label      # tick trading information scope
    ${token_name}=    Set Variable    imtesting
    Input text      //*[@name="token_name"]     ${token_name}
    Click element   //*[text()="Create"]//parent::button    # click create button
    Wait until page contains element    //*[@class="da-api-token__table"]//self::span[text()="${token_name}"]     10    # wait until api token created
    
    # verify created token has the selected scope (PS:xpath written this way so that other created API do not effect the test)
    Page Should Contain Element     //*[text()="imtesting"]//ancestor::tr[@class="da-api-token__table-cell-row"]//self::div[text()="Read"]
    Page Should Contain Element     //*[text()="imtesting"]//ancestor::tr[@class="da-api-token__table-cell-row"]//self::div[text()="Trade"]
    Page Should Contain Element     //*[text()="imtesting"]//ancestor::tr[@class="da-api-token__table-cell-row"]//self::div[text()="Payments"]
    Page Should Contain Element     //*[text()="imtesting"]//ancestor::tr[@class="da-api-token__table-cell-row"]//self::div[text()="Admin"]
    Page Should Contain Element     //*[text()="imtesting"]//ancestor::tr[@class="da-api-token__table-cell-row"]//self::div[text()="Trading information"]

    # delete the token to reset the test condition (PS:xpath written this way so that other created API do not effect the test)
    Wait Until Page Contains Element    //*[text()="imtesting"]//ancestor::tr[@class="da-api-token__table-cell-row"]//self::*[@data-testid="dt_token_delete_icon"]    5
    Click element   //*[text()="imtesting"]//ancestor::tr[@class="da-api-token__table-cell-row"]//self::*[@data-testid="dt_token_delete_icon"]
    Wait until page contains element    //*[text()="Yes, delete"]//parent::button    10  # wait until yes button appears
    Click element   //*[text()="Yes, delete"]//parent::button
    Wait until page does not contain    //*[@class="da-api-token__table"]//self::span[text()="${token_name}"]   10




