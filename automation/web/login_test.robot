*** Settings ***
Resource    ../../resources/keywords/login_keywords.robot
Suite Setup    Open Application and Login To CCB
Test Teardown    Close Browser

*** Test Cases ***
TS001_TC007: Create new file : Upload file TBank format - CMS001
    [Documentation]    Create new file : Upload file TBank format
    ...    - CMS001
    [Tags]    lab1_happy_case    happy_case
    Go To Create Payment Import File From Payment
    Click create new file button
    Verify detail in modal default Upload file to edit transaction when click create new file
    Verify Upload payment file page should be display correctly
    Upload File To Drop Zone    CONVERT_CMS001.txt
    
    # Verify file uploaded successfully
    # Verify file name: 'CONVERT_CMS001.txt' should be display correctly
    # Click next button on create payment import file page
    # Input Tax ID
    # ${expected_payment_types}=    Create List    DCS    DDS    PAY
    # Verify payment type options with: '${expected_payment_types}'
    # Input information for create new file with payment type: 'DDS' with debit account: '${transaction_data.debit_account}' and with date: '${current_date}'
    # Click confirm button
    # Verify File summary should be display correctly with file details: '${file_data.TS001_TC007}'
    # Click button with locator: '//footer/button[text()="Generate file"]' with: filename: DDS_${current_date_abbreviated_year}_${current_time}_27.txt should be download successful
    # Verify generate file toast message should be display correctly with '27' records  
    # Verify file '${file_obj}' should be exist with file name: 'DDS_${current_date_abbreviated_year}_${current_time}_27.txt'
    # @{file_paths}=    Create List    ${file_obj}[saveAs]