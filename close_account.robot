*** Settings ***
Documentation    Suite description
Resource    common.robot


*** Keywords ***
Go to close account page
    Click element   //*[@class="account-settings-toggle"]
    Wait until page contains element    //*[@id="/account/closing-account"]   20
    Click element   //*[@id="/account/closing-account"]
    Wait until page contains    If you close your account

Tick checkbox
    [arguments]    ${locator}
    Wait until page contains element    ${locator}
    Click element   ${locator}
    Sleep   1

Login to activate again
    Open browser    https://app.deriv.com    chrome
    set window size     1280    1024    # set a bigger window size
    Wait until page does not contain element    //*[@aria-label="Loading interface..."]     60      # wait until top right loading interface disappears
    Wait until page contains element    dt_login_button     30
    Click element   dt_login_button     # click log in button
    Wait until page contains element    txtEmail     20     # wait for email field available in oauth page
    Input text     txtEmail     dummy@dummy.com     # fill in email
    Input text     txtPass     dummy     # fill in password
    Click element   //*[@name="login"]      # click login button in oauth page
    Wait until page contains    Want to start trading on Deriv again?
    Wait until page contains element    btnGrant   # reactivate button
    Click element   btnGrant
    Wait until page contains element    //*[text()="Deposit"]//parent::button     20    # wait until deposit button appears
    Wait until page does not contain element    //*[@aria-label="Loading interface..."]     60      # wait until top right loading interface disappears


*** Test Cases ***
Close account
    Login
    Go to close account page
    wait until page contains element    //*[text()="Close my account"]//parent::button
    Click element   //*[text()="Close my account"]//parent::button
    Tick checkbox     //*[@name="financial-priorities"]//parent::label
    Tick checkbox     //*[@name="stop-trading"]//parent::label
    Tick checkbox     //*[@name="not-interested"]//parent::label
    # following disabled because max 3
    element should be disabled    //*[@name="another-website"]
    element should be disabled     //*[@name="not-user-friendly"]
    element should be disabled     //*[@name="difficult-transactions"]
    element should be disabled     //*[@name="lack-of-features"]
    element should be disabled     //*[@name="unsatisfactory-service"]
    element should be disabled     //*[@name="other-reasons"]
    Input text    //*[@name="other_trading_platforms"]      helooo
    Input text    //*[@name="do_to_improve"]      HEYHEY
    Click element   //*[text()="Continue"]//parent::button
    Wait until page contains element        //*[text()="Close account"]//parent::button    5
    Click element   //*[text()="Close account"]//parent::button
    Wait until page contains        We’re sorry to see you leave.
    Login to activate again









