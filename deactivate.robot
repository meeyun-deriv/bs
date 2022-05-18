*** Settings ***
Documentation    Suite description
Resource    common.robot


*** Keywords ***
Go to deactivate account page
    Click element   //*[@class="account-settings-toggle"]
    Wait until page contains element    dc_deactivate-account_link   20
    Click element   dc_deactivate-account_link
    Wait until page contains    Ensure to close all your positions

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
    Input text     txtPass     dummypw     # fill in password
    Click element   //*[@name="login"]      # click login button in oauth page
    Wait until page contains    Would you like to reactivate your account?
    Wait until page contains element    btnGrant   # reactivate button
    Click element   btnGrant
    Wait until page contains element    //*[text()="Deposit"]//parent::button     20    # wait until deposit button appears
    Wait until page does not contain element    //*[@aria-label="Loading interface..."]     60      # wait until top right loading interface disappears


*** Test Cases ***
Deactivate account
    Login
    Go to deactivate account page
    wait until page contains element    //*[text()="Continue to account deactivation"]//parent::button
    Click element   //*[text()="Continue to account deactivation"]//parent::button
    Tick checkbox     //*[@name="I have other financial priorities"]//parent::label
    Tick checkbox     //*[@name="I want to stop myself from trading"]//parent::label
    Tick checkbox     //*[@name="I'm no longer interested in trading"]//parent::label
    # following disabled because max 3
    element should be disabled    //*[@name="I prefer another trading website"]
    element should be disabled     //*[@name="I prefer another trading website"]
    element should be disabled     //*[@name="The platforms aren't user-friendly"]
    element should be disabled     //*[@name="Making deposits and withdrawals is difficult"]
    element should be disabled     //*[@name="The platforms lack key features or functionality"]
    element should be disabled     //*[@name="Customer service was unsatisfactory"]
    element should be disabled     //*[@name="I'm deactivating my account for other reasons"]
    Input text    //*[@name="other_trading_platforms"]      helooo
    Input text    //*[@name="do_to_improve"]      HEYHEY
    Click element   //*[text()="Continue"]//parent::button
    Wait until page contains element    //*[text()="Deactivate"]//parent::button    5
    Click element   //*[text()="Deactivate"]//parent::button
    Wait until page contains        We’re sorry to see you leave.
    Login to activate again









