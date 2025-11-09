*** Settings ***
Library    Browser
Library    ../yaml_loader.py
Library    OperatingSystem  

*** Variables ***
${CONFIG}    ${None}
${PAGE}      ${None}

*** Keywords ***

Load Config
    ${DATA}=    Load YAML    ${EXECDIR}/config/settings.yaml
    Set Suite Variable    ${CONFIG}    ${DATA}
    Log To Console    >>> CONFIG LOADED


Verify Message From Page Should Match Config
    [Arguments]    ${CONFIG}    ${locator}    ${expected_message_key}
    ${actual}=    Get Text    ${locator}
    ${expected}=    Set Variable    ${CONFIG}[Expected_messages][${expected_message_key}]
    Log To Console    Actual: ${actual}
    Log To Console    Expected: ${expected}
    Should Contain    ${actual}    ${expected}


Open Application and Login To CCB
    Load Config
    New Browser    ${CONFIG}[browser]    headless=${CONFIG}[headless]
    ${PAGE}=    New Page    ${CONFIG}[url]
    Set Suite Variable    ${PAGE}    
    Wait For Elements State    //input[@type='text']    visible    ${CONFIG}[timeouts][element_wait]
    # Username
    Fill Text    //input[@type='text']    ${CONFIG}[CCBUSER][username]
    Click    //button[normalize-space()='Next']
    # Password
    Fill Text    //input[@type='password']    ${CONFIG}[CCBUSER][password]
    Click    //button[normalize-space()='Next']
    Wait For Elements State    //ca-dashboard-widget[@id='DashboardFinancialSummaryComponent']    visible    ${CONFIG}[timeouts][element_wait]


Go To Create Payment Import File From Payment
    Click    //span[normalize-space()='Payment']
    Wait For Elements State    //span[normalize-space()='Create payment Import file']    visible    ${CONFIG}[timeouts][element_wait]
    Click    //span[normalize-space()='Create payment Import file']
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //p[contains(text(),'For Thanachart iBiz customer')]    visible    ${CONFIG}[timeouts][element_wait]
    Wait For Elements State    //iframe[@src='/bizone/converter']    visible    ${CONFIG}[timeouts][element_wait]
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //button[normalize-space()='Create new file']    visible    ${CONFIG}[timeouts][element_wait]
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //button[normalize-space()='Convert file']    visible    ${CONFIG}[timeouts][element_wait]
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //button[normalize-space()='Recipient lists']    visible    ${CONFIG}[timeouts][element_wait]


Click create new file button
    Click    //iframe[@src='/bizone/converter'] >>> //button[normalize-space()='Create new file']
    Log To Console    Clicked create new file button


Verify detail in modal default Upload file to edit transaction when click create new file
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //p[normalize-space()='Select type']    visible    ${CONFIG}[timeouts][element_wait]
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //p[normalize-space()='Create new file']    visible    ${CONFIG}[timeouts][element_wait]
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //p[normalize-space()='Upload file to edit transaction']    visible    ${CONFIG}[timeouts][element_wait]        
    ${msg}=    Get Text    //iframe[@src='/bizone/converter'] >>> //p[contains(text(),'Support only ttb format')]
    ${expected}=    Set Variable    ${CONFIG}[Expected_messages][Upload_file_to_edit_transaction_detail]
    Should Contain    ${msg}    ${expected}
    Log To Console    >>> Upload file to edit transaction detail (Matched: ${expected})
    Click    //iframe[@src='/bizone/converter'] >>> //p[normalize-space()='Upload file to edit transaction']
    Click    //iframe[@src='/bizone/converter'] >>> //button[normalize-space()='Confirm']


Verify Upload payment file page should be display correctly
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //p[normalize-space()='Upload payment file']    visible    ${CONFIG}[timeouts][element_wait]
    ${msg}=    Get Text    //iframe[@src='/bizone/converter'] >>> //p[contains(text(),'You can edit detail in existing file')]
    ${expected}=    Set Variable    ${CONFIG}[Expected_messages][Upload_payment_file_detail]
    Should Contain    ${msg}    ${expected}
    Log To Console    >>> Upload payment file detail (Matched: ${expected})
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //div[@data-testid='dropbox-testid']   visible    ${CONFIG}[timeouts][element_wait]
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //button[normalize-space()='Next']    disabled    ${CONFIG}[timeouts][element_wait]
    Take Screenshot

Upload File To Drop Zone
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${CURDIR}${/}..${/}..${/}resources${/}testdata${/}common${/}Web_Converter${/}${filename}
    File Should Exist    ${file_path}
    Upload File By Selector    //iframe[@src='/bizone/converter'] >>> //input[@type='file']    ${file_path}
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> //button[normalize-space()='Next']    enabled    ${CONFIG}[timeouts][element_wait]
    Log To Console    File uploaded: ${filename}