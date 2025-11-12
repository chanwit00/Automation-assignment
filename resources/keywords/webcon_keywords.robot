*** Settings ***
Resource    ../../resources/keywords/common.robot


*** Keywords ***

Open Application and Login To CCB
    Load Config
    ${download_dir}=    Set Variable    ${EXECDIR}${/}downloads
    Create Directory    ${download_dir}

    New Browser    ${CONFIG}[browser]    headless=${CONFIG}[headless]
    ${context_args}=    Create Dictionary    acceptDownloads=${True}
    New Context    &{context_args}

    ${PAGE}=    New Page    ${CONFIG}[url]
    Set Suite Variable    ${PAGE}
    Wait For Elements State    //input[@type='text']    visible    ${CONFIG}[timeouts][element_wait]
    Fill Text    //input[@type='text']    ${CONFIG}[CCBUSER][username]
    Click    //button[normalize-space()='Next']
    Fill Text    //input[@type='password']    ${CONFIG}[CCBUSER][password]
    Click    //button[normalize-space()='Next']
    Wait For Elements State    //ca-dashboard-widget[@id='DashboardFinancialSummaryComponent']    visible    ${CONFIG}[timeouts][element_wait]


Go To Create Payment Import File From Payment
    Click    //span[normalize-space()='Payment']
    Wait For Elements State    //span[normalize-space()='Create Payment Import File']    visible    ${CONFIG}[timeouts][element_wait]
    Click    //span[normalize-space()='Create Payment Import File']
    Wait For Elements State    ${iframe} >>> //p[contains(text(),'For Thanachart iBiz customer')]    visible    ${CONFIG}[timeouts][element_wait]


Click create new file button
    Click element when ready    //button[normalize-space()='Create new file']


Verify detail in modal default Upload file to edit transaction when click create new file
    ${msg}=    Get Text    ${iframe} >>> //p[contains(text(),'Support only ttb format')]
    ${expected}=    Set Variable    ${CONFIG}[Expected_messages][Upload_file_to_edit_transaction_detail]
    Should Contain    ${msg}    ${expected}
    Click element when ready    //p[normalize-space()='Upload file to edit transaction']
    Click element when ready    //button[normalize-space()='Confirm']


Verify Upload payment file page should be display correctly
    Wait For Elements State    ${iframe} >>> //p[normalize-space()='Upload payment file']    visible    ${CONFIG}[timeouts][element_wait]
    ${msg}=    Get Text    ${iframe} >>> //p[contains(text(),'You can edit detail in existing file')]
    ${expected}=    Set Variable    ${CONFIG}[Expected_messages][Upload_payment_file_detail]
    Should Contain    ${msg}    ${expected}
    Wait For Elements State    ${iframe} >>> //div[@data-testid='dropbox-testid']    visible    ${CONFIG}[timeouts][element_wait]


Upload File To Drop Zone
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${CURDIR}${/}..${/}..${/}resources${/}testdata${/}common${/}Web_Converter${/}${filename}
    File Should Exist    ${file_path}
    Upload File By Selector    ${iframe} >>> //input[@type='file']    ${file_path}
    Wait For Elements State    ${iframe} >>> //button[normalize-space()='Next']    enabled    ${CONFIG}[timeouts][element_wait]


Verify file uploaded successfully
    Wait For Elements State    ${iframe} >>> //p[text()='File Uploaded Successfully']    visible    ${CONFIG}[timeouts][element_wait]
    ${msg}=    Get Text    ${iframe} >>> //p[text()='File Uploaded Successfully']
    ${expected}=    Set Variable    ${CONFIG}[Expected_messages][Upload_payment_file_success]
    Should Contain    ${msg}    ${expected}


Verify file name should be display correctly
    [Arguments]    ${filename}
    ${displayed_filename}=    Get Text    ${iframe} >>> //p[text()='${filename}']
    Should Be Equal As Strings    ${displayed_filename}    ${filename}


Click next button on create payment import file page
    Click element when ready    //button[normalize-space()='Next']


Input Tax ID
    Wait For Elements State    ${iframe} >>> //input[@data-testid="textfield__tax_id"]    visible    ${CONFIG}[timeouts][element_wait]
    Fill Text    ${iframe} >>> //input[@data-testid="textfield__tax_id"]    ${CONFIG}[Tax ID]


Verify Payment Type Options with:
    [Arguments]    ${expected_options}
    FOR    ${value}    IN    @{expected_options}
        Get Element    ${iframe} >>> select[data-testid="dropdown-testid-payment_type"] >> option[value="${value}"]
    END
    ${actual_count}=    Get Element Count    ${iframe} >>> select[data-testid="dropdown-testid-payment_type"] >> option[value]:not([value=""])
    ${expected_count}=    Get Length    ${expected_options}
    Should Be Equal As Numbers    ${actual_count}    ${expected_count}


Input information for create new file with payment type: '${payment_type}' with debit account: '${debit_account}' and with date: '${current_date}'
    Get Text    ${iframe} >>> //div[contains(@class,"Modal_modal--header")]/p    should be    Fill information
    Click element when ready    //label[text()="Debit Account"]/parent::div
    Click element when ready    //div[@id="portal-top-layer"]//p[text()="${debit_account}"]
    Click element when ready    //div[contains(@class,"InputBox_input")]/select[@name="payment_type"]/parent::div
    Click element when ready    //li[@data-testid="dropdown-list-${payment_type}"]
    Fill Text    ${iframe} >>> //label[text()="Effective Date"]/following-sibling::input    ${current_date}
    Press Keys    ${iframe} >>> //label[text()="Effective Date"]/following-sibling::input    Enter
    Check And Fill Company Address


Click confirm button
    Click element when ready    //button[normalize-space()='Confirm']


Verify File summary should be display correctly with file details:
    [Arguments]    ${expected_data}
    Wait For Elements State    ${iframe} >>> //p[normalize-space()='File Summary']    visible    ${CONFIG}[timeouts][element_wait]
    ${ui_payment_type}=        Get Text    ${iframe} >>> //div[contains(@class,'css-v0elue')]//p[normalize-space()='Payment']/following-sibling::p
    ${ui_effective_date}=      Get Text    ${iframe} >>> //div[contains(@class,'css-v0elue')]//p[normalize-space()='Effective Date']/following-sibling::p
    ${ui_transaction_count}=   Get Text    ${iframe} >>> //div[contains(@class,'css-v0elue')]//p[normalize-space()='Transaction(s)']/following-sibling::p
    ${ui_total_amount}=        Get Text    ${iframe} >>> //div[contains(@class,'css-v0elue')]//p[normalize-space()='Total amount']/following-sibling::p
    Should Be Equal As Strings    ${ui_payment_type}       ${expected_data}[Payment_Type]
    Should Be Equal As Strings    ${ui_effective_date}     ${expected_data}[Effective_Date]
    Should Be Equal As Strings    ${ui_transaction_count}  ${expected_data}[Transaction_Count]
    Should Contain               ${ui_total_amount}       ${expected_data}[Total_Amount]


Click Generate File Button And Wait For Download Validate Downloaded and should be download successful File name:
    [Arguments]    ${filename}
    ${download_dir}=    Set Variable    ${EXECDIR}${/}downloads
    Create Directory    ${download_dir}
    ${target_path}=    Set Variable    ${download_dir}${/}${filename}
    ${download_promise}=    Promise To Wait For Download    saveAs=${target_path}
    Click element when ready    //footer/button[normalize-space()='Generate file']
    ${download_info}=    Wait For    ${download_promise}      
    File Should Exist    ${target_path}
       
    
Verify generate file toast message should be display correctly with '27' records
    Wait For Elements State    ${iframe} >>> //p[contains(text(), 'File generated successfully 27 records.')]    visible    ${CONFIG}[timeouts][element_wait]
    ${tost}=    Get Text    ${iframe} >>> //p[contains(text(), 'File generated successfully 27 records.')]    should be    ${CONFIG}[Expected_messages][Generate_file_success]


Verify file should be exist and file name:
    [Arguments]    ${filename}
    ${download_dir}=    Set Variable    ${EXECDIR}${/}downloads
    ${target_path}=    Set Variable    ${download_dir}${/}${filename}
    File Should Exist    ${target_path}


Delete Downloaded Files
    ${download_dir}=    Set Variable    ${EXECDIR}${/}downloads
    Remove Directory    ${download_dir}    recursive=${True}