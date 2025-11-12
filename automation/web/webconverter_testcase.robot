*** Settings ***
Resource    ../../resources/keywords/webcon_keywords.robot
Resource    ../../resources/keywords/common.robot

Suite Setup    Open Application and Login To CCB
# Test Teardown  Delete Downloaded Files

*** Variables ***



*** Test Cases ***
TS001_TC007: Create new file : Upload file TBank format - CMS001
    [Documentation]    Create new file : Upload file TBank format - CMS001
    [Tags]    lab1_happy_case    happy_case

    Go To Create Payment Import File From Payment
    Click Create New File Button
    Verify detail in modal default Upload file to edit transaction when click create new file
    Verify Upload Payment File Page Should Be Display Correctly
    Upload File To Drop Zone    CONVERT_CMS001.txt
    Verify File Uploaded Successfully
    Verify File Name Should Be Display Correctly    CONVERT_CMS001.txt
    Click Next Button On Create Payment Import File Page
    Input Tax ID
    ${expected_payment_types}=    Create List    DCS    DDS    PAY
    Verify Payment Type Options with:    ${expected_payment_types}
    ${transaction_data.debit_account}=    Set Variable    612 1 00882 2
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Input information for create new file with payment type: 'DDS' with debit account: '${transaction_data.debit_account}' and with date: '${current_date}'
    Click Confirm Button
    Set To Dictionary    ${file_data.TS001_TC007}    Effective_Date=${current_date}
    Verify File summary should be display correctly with file details:  ${file_data.TS001_TC007}
    ${current_date_abbreviated_year}=    Get Current Date    result_format=%d%m%y
    ${current_time}=     Get Current Date    result_format=%H%M%S
    # Click button with locator: '//footer/button[text()="Generate file"]' with: filename: DDS_${current_date_abbreviated_year}_${current_time}_27.txt should be download successful
    Click Generate File Button And Wait For Download Validate Downloaded and should be download successful File name:   DDS_${current_date_abbreviated_year}_${current_time}_27.txt
    # ...      DDS_${current_date_abbreviated_year}_${current_time}_27.txt
    # Verify generate file toast message should be display correctly with '27' records   
    # Verify file should be exist and file name:  DDS_${current_date_abbreviated_year}_${current_time}_27.txt
