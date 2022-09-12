*** Settings ***
Documentation    Suite description
Library     SeleniumLibrary


*** Keywords ***
Login
    Open browser    https://app.deriv.com    chrome
    set window size     1280    1024    # set a bigger window size
    Wait until page does not contain element    //*[@aria-label="Loading interface..."]     60      # wait until top right loading interface disappears
    Wait until page contains element    dt_login_button     30
    Click element   dt_login_button     # click log in button
    Wait until page contains element    txtEmail     20     # wait for email field available in oauth page
    Input text     txtEmail     dummy@dummy.com     # fill in email
<<<<<<< HEAD
    Input text     txtPass     dummyPassword     # fill in password
=======
    Input text     txtPass     dummy     # fill in password
>>>>>>> 7d5a335a273db5de0c0f92279d77a72f09e5e810
    Click element   //*[@name="login"]      # click login button in oauth page
    Wait until page contains element    //*[text()="Deposit"]//parent::button     20    # wait until deposit button appears
    Wait until page does not contain element    //*[@aria-label="Loading interface..."]     60      # wait until top right loading interface disappears
    Switch to virtual

Switch to virtual
    wait until page contains element    dt_core_account-info_acc-info   20
    click element   dt_core_account-info_acc-info
    wait until page contains element    dt_core_account-switcher_demo-tab   10
    click element   dt_core_account-switcher_demo-tab
    wait until page contains element   //*[@id="dt_core_account-switcher_demo-tab" and contains(@class, "active")]
    wait until page contains element   //*[contains(@id,"dt_VRTC")]
    click element   //*[contains(@id,"dt_VRTC")]
    Wait Until Page Does Not Contain Element    dt_core_header_acc-info-preloader    20    # wait account switcher finish loading






