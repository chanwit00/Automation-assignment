*** Settings ***
Resource    ../../resources/keywords/common.robot

*** Variables ***
${CONFIG}    ${None}
${PAGE}      ${None}
${iframe}    //iframe[@src='/bizone/converter']

*** Keywords ***

Open Application and Login To CCB
    Load Config
    ${download_dir}=    Set Variable    ${EXECDIR}${/}downloads
    Create Directory    ${download_dir}
    New Browser    ${CONFIG}[browser]    headless=${CONFIG}[headless]
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
    Click    ${iframe} >>> //button[normalize-space()='Create new file']
    Log To Console    ✅ Clicked create new file button


Verify detail in modal default Upload file to edit transaction when click create new file
    ${msg}=    Get Text    ${iframe} >>> //p[contains(text(),'Support only ttb format')]
    ${expected}=    Set Variable    ${CONFIG}[Expected_messages][Upload_file_to_edit_transaction_detail]
    Should Contain    ${msg}    ${expected}
    Log To Console    ✅ Upload file modal verified
    Click    ${iframe} >>> //p[normalize-space()='Upload file to edit transaction']
    Click    ${iframe} >>> //button[normalize-space()='Confirm']


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
    Log To Console    ✅ File uploaded: ${filename}


Verify file uploaded successfully
    Wait For Elements State    ${iframe} >>> //p[text()='File Uploaded Successfully']    visible    ${CONFIG}[timeouts][element_wait]
    ${msg}=    Get Text    ${iframe} >>> //p[text()='File Uploaded Successfully']
    ${expected}=    Set Variable    ${CONFIG}[Expected_messages][Upload_payment_file_success]
    Should Contain    ${msg}    ${expected}
    Log To Console    ✅ File upload success verified


Verify file name should be display correctly
    [Arguments]    ${filename}
    ${displayed_filename}=    Get Text    ${iframe} >>> //p[text()='${filename}']
    Should Be Equal As Strings    ${displayed_filename}    ${filename}
    Log To Console    ✅ File name displayed correctly: ${filename}


Click next button on create payment import file page
    Wait For Elements State    ${iframe} >>> //button[normalize-space()='Next']    enabled    ${CONFIG}[timeouts][element_wait]
    Click    ${iframe} >>> //button[normalize-space()='Next']


Input Tax ID
    Wait For Elements State    ${iframe} >>> //input[@data-testid="textfield__tax_id"]    visible    ${CONFIG}[timeouts][element_wait]
    Fill Text    ${iframe} >>> //input[@data-testid="textfield__tax_id"]    ${CONFIG}[Tax ID]
    Log To Console    ✅ Input Tax ID: ${CONFIG}[Tax ID]


Verify Payment Type Options with:
    [Arguments]    ${expected_options}
    FOR    ${value}    IN    @{expected_options}
        Get Element    ${iframe} >>> select[data-testid="dropdown-testid-payment_type"] >> option[value="${value}"]
    END
    ${actual_count}=    Get Element Count    ${iframe} >>> select[data-testid="dropdown-testid-payment_type"] >> option[value]:not([value=""])
    ${expected_count}=    Get Length    ${expected_options}
    Should Be Equal As Numbers    ${actual_count}    ${expected_count}
    Log To Console    ✅ Payment type options verified: ${expected_options}


Input information for create new file with payment type: '${payment_type}' with debit account: '${debit_account}' and with date: '${current_date}'
    Get Text    ${iframe} >>> //div[contains(@class,"Modal_modal--header")]/p    should be    Fill information
    Click element when ready    //label[text()="Debit Account"]/parent::div
    Click element when ready    //div[@id="portal-top-layer"]//p[text()="${debit_account}"]
    Click element when ready    //div[contains(@class,"InputBox_input")]/select[@name="payment_type"]/parent::div
    Click element when ready    //li[@data-testid="dropdown-list-${payment_type}"]
    Fill Text    ${iframe} >>> //label[text()="Effective Date"]/following-sibling::input    ${current_date}
    Press Keys    ${iframe} >>> //label[text()="Effective Date"]/following-sibling::input    Enter
    Check And Fill Company Address
    Log To Console    ✅ Fill information completed successfully


Click confirm button
    Wait For Elements State    ${iframe} >>> //button[normalize-space()='Confirm']    enabled    ${CONFIG}[timeouts][element_wait]
    Click    ${iframe} >>> //button[normalize-space()='Confirm']
    Log To Console    ✅ Clicked confirm button


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
    Log To Console    ✅ File summary verified successfully


Click Generate File Button And Wait For Download
    Click    ${iframe} >>> //footer/button[normalize-space()='Generate file']
    Log To Console    ✅ Clicked Generate file button
    Sleep    2s    # Wait for download to start




# Validate Downloaded File Name and should be download successful
#     ${download_dir}=    Set Variable    ${EXECDIR}${/}downloads
#     ${expected_date}=    Get Current Date    result_format=%d%m%y
    
    
#     # Check Windows Downloads folder
#     ${downloads_folder}=    Evaluate    os.path.join(os.path.expanduser('~'), 'Downloads')    modules=os
    
#     # Wait for file to appear (max 30 seconds)
#     ${pattern}=    Set Variable    DDS_${expected_date}_*_27.txt
    
#     Wait Until Keyword Succeeds    30s    1s
#     ...    File Should Exist In Folder    ${downloads_folder}    ${pattern}
    
#     # Get the downloaded file
#     @{files}=    List Files In Directory    ${downloads_folder}    ${pattern}    absolute=True
#     ${downloaded_file}=    Get Latest File By Modified Time    ${downloads_folder}    ${pattern}
    
#     ${filename}=    Evaluate    os.path.basename(r'${downloaded_file}')    modules=os
#     Log To Console    Filename: ${filename}
    
#     # Verify pattern
#     Should Match Regexp    ${filename}    ^DDS_\\d{6}_\\d{6}_27\\.txt$
#     Should Contain    ${filename}    ${expected_date}
    
#     # Copy to project downloads folder
#     Create Directory    ${download_dir}
#     ${target_path}=    Set Variable    ${download_dir}${/}${filename}
#     Copy File    ${downloaded_file}    ${target_path}
    
#     Log To Console    ✅ Filename pattern verified and file saved: ${target_path}
    
#     RETURN    ${target_path}

