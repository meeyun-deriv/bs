*** Settings ***
Documentation    Suite description
Library     SeleniumLibrary
Library     String
Resource    common.robot

*** Keywords ***


Clear Input Field
    [Arguments]    ${input_field}
    Wait Until Page Contains Element    ${input_field}    5
    ${current_value}=    Get Element Attribute    ${input_field}    value
    ${value_length}=    Get Length    ${current_value}
    # sometimes text cursor starts from the middle, so delete front and back characters
    Repeat Keyword    ${value_length}    Press Keys    ${input_field}   BACKSPACE
    Repeat Keyword    1   Press Keys    ${input_field}   DELETE

Select market
    [arguments]     ${market}   ${underlying}
    Wait until page does not contain element    //*[@class="chart-container__loader"]     60    # wait until chart finish loading
    Wait until page does not contain element    //*[contains(@class,"initial-loader")]     60    # wait until chart finish loading
    Wait until page contains element    //*[@class="cq-symbol-select-btn"]     40    # wait until market selection menu appears
    Click element   //*[@class="cq-symbol-select-btn"]
    # wait until market dropdown expanded
    Wait until page contains element    //*[@class="sc-dialog cq-menu-dropdown cq-menu-dropdown-enter-done"]     5
    Wait until page contains element    ${market}     5    # wait until market appears in menu
    Click element   ${market}
    Wait until page contains element    //*[@class="ic-icon ic-1HZ10V"]     5    # wait R_10_1s underlying
    Click element   ${underlying}
    # wait until market dropdown collapsed
    Wait until page does not contain element    //*[@class="sc-dialog cq-menu-dropdown cq-menu-dropdown-enter-done"]     5

Select contract type and contract parameters
    [arguments]     ${contract_type}
    Wait until page contains element    dt_contract_dropdown     5    # wait contract type menu appears
    Click element   dt_contract_dropdown
    Wait until page contains element    ${contract_type}     5    # wait until page contains rise fall option
    Click element   ${contract_type}     # buy rise contract
    Input text   dt_amount_input     10

Click buy button
    [arguments]     ${button}
    Wait until element is enabled    ${button}     5    # wait until button enabled
    Click element   ${button}

*** Test Cases ***
Loginok
    Login

Buy rise contract
    Login
    Select market   //*[@class="ic-icon ic-synthetic_index"]   //*[@class="ic-icon ic-1HZ10V"]
    Select contract type and contract parameters    dt_contract_rise_fall_item
    Click buy button    dt_purchase_put_button
    [Teardown]  Close browser

Buy lower contract
    # use payout and custom payout amount
    Login
    Select market   //*[@class="ic-icon ic-forex"]      //*[@class="sc-mcd__item sc-mcd__item--frxAUDUSD "]
    Select contract type and contract parameters    dt_contract_high_low_item
    Click element   dc_payout_toggle_item
    wait until page contains element    //*[@id="dc_payout_toggle_item" and contains(@class, "active")]     5   # wait until pauyout toggle active
    Clear Input Field   dt_amount_input
    Input text   dt_amount_input     15.50
    Click buy button    dt_purchase_put_button
    [Teardown]  Close browser

Check relative barrier error
    Login
    Select market   //*[@class="ic-icon ic-forex"]      //*[@class="sc-mcd__item sc-mcd__item--frxAUDUSD "]
    Select contract type and contract parameters    dt_contract_high_low_item
    Clear Input Field   //*[@name="duration"]
    Input text   //*[@name="duration"]     2
    Clear Input Field   dt_barrier_1_input
    Input text   dt_barrier_1_input     +1.00
    Wait until page contains
    [Teardown]  Close browser

Check multiplier contract parameter
    Login
    #---------------------
    # only stake, no payout
    #---------------------
    Select market   //*[@class="ic-icon ic-synthetic_index"]   //*[@class="sc-mcd__item sc-mcd__item--R_50 "]
    Select contract type and contract parameters    dt_contract_multiplier_item
    Page should not contain     Payout
    #---------------------
    # Only deal cancellation or take profit/stop loss is allowed
    #---------------------
    Click element     //*[@id="dc_take_profit-checkbox_input"]//parent::label
    Wait until page contains element    //*[@id="dc_take_profit-checkbox_input" and @checked]   # TP is checked
    Click element     //*[@id="dc_stop_loss-checkbox_input"]//parent::label
    Wait until page contains element    //*[@id="dc_stop_loss-checkbox_input" and @checked]   # SL is checked
    Click element     //*[@id="dt_cancellation-checkbox_input"]//parent::label
    Wait until page contains element    //*[@id="dt_cancellation-checkbox_input" and @checked]   # DC is checked
    Page should not contain element     //*[@for="dc_take_profit-checkbox_input"]/span[@class="dc-checkbox__box dc-checkbox__box--active"]    # TP is not checked
    Page should not contain element     //*[@for="dc_stop_loss-checkbox_input"]/span[@class="dc-checkbox__box dc-checkbox__box--active"]    # SL is not checked
    #---------------------
    # Multiplier value selection should have x20, x40, x60, x100, x200
    #---------------------
    Click element     (//*[@id="dropdown-display"])[1]   # click multiplier value
    Wait until page contains element    //*[@id="dropdown-display" and contains(@class, "clicked")]     # multiplier dropdown is expanded
    # should contain this multiplier value in dropdown selection
    Page should contain element     //*[@id="20"]
    Page should contain element     //*[@id="40"]
    Page should contain element     //*[@id="60"]
    Page should contain element     //*[@id="100"]
    Page should contain element     //*[@id="200"]
    #---------------------
    # Deal cancellation fee should correlates with the stake value
    #---------------------
    Clear Input Field   dt_amount_input
    Input text   dt_amount_input     10
    Wait until page contains element    //*[@class="trade-container__price-info-currency"]      # wait until DC value appears
    ${dc_stake_10}=     Get text     //*[@class="trade-container__price-info-currency"]
    ${dc_stake_10} =     Replace String     ${dc_stake_10}    USD    ${EMPTY}
    Clear Input Field   dt_amount_input
    Input text   dt_amount_input     100
    Wait until page contains element    //*[@class="trade-container__price-info-currency"]      # wait until DC value appears
    ${dc_stake_100}=     Get text     //*[@class="trade-container__price-info-currency"]
    ${dc_stake_100} =     Replace String     ${dc_stake_100}    USD     ${EMPTY}
    Should be true   ${dc_stake_100}>${dc_stake_10}
    #---------------------
    # Maximum stake is 2000 USD
    #---------------------
    Clear Input Field   dt_amount_input
    Input text   dt_amount_input     2001
    Wait until page contains    Maximum stake allowed is 2000.00.
    #---------------------
    # Minimum stake is 1 USD
    #---------------------
    Clear Input Field   dt_amount_input
    Input text   dt_amount_input     0.50
    Wait until page contains    Please enter a stake amount that's at least 1.00
    #---------------------
    # + button in take profit field should be incremental of 1 USD
    #---------------------
    ${current_stake_value}=     Get element attribute   dt_amount_input     value
    Click Element   dt_amount_input_add     # click + button in stake field
    Wait until element is enabled    dt_purchase_multup_button
    ${stake_value_after_plus}=     Get element attribute   dt_amount_input     value
    ${expected_stake_after_added}=    Evaluate    ${current_stake_value}+1
    ${expected_stake_after_added}=    Evaluate      "%.2f" % ${expected_stake_after_added}
    Should be equal     ${expected_stake_after_added}    ${stake_value_after_plus}
    #---------------------
    # - button in take profit field should be decremental of 1 USD
    #---------------------
    Clear Input Field   dt_amount_input
    Input text   dt_amount_input     3.00
    Wait until element is enabled    dt_purchase_multup_button
    ${current_stake_value}=     Get element attribute   dt_amount_input     value
    Click Element   dt_amount_input_sub         # click - button in stake field
    Wait until element is enabled    dt_purchase_multup_button
    ${stake_value_after_minus}=     Get element attribute   dt_amount_input     value
    ${expected_stake_after_minus}=    Evaluate    ${current_stake_value}-1
    ${expected_stake_after_minus}=    Evaluate      "%.2f" % ${expected_stake_after_minus}
    Should be equal     ${expected_stake_after_minus}    ${stake_value_after_minus}
    #---------------------
    # Deal cancellation duration only has these options: 5, 10, 15, 30 and 60 min
    #---------------------
    Click Element   (//*[@id="dropdown-display"])[2]    # click cancellation duration dropdown
    Wait until page contains element    //*[@id="dropdown-display" and contains(@class, "clicked")]     # cancellation duration dropdown is expanded
    Page should contain element     5m
    Page should contain element     10m
    Page should contain element     15m
    Page should contain element     30m
    Page should contain element     60m
