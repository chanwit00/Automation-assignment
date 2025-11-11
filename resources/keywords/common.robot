*** Settings ***
Library    Browser
Library    ../yaml_loader.py
Library    OperatingSystem
Library    Collections
Library    DateTime

*** Variables ***
${CONFIG}    ${None}
${PAGE}      ${None}



*** Keywords ***
Load Config
    ${DATA}=    Load YAML    ${EXECDIR}/config/settings.yaml
    Set Suite Variable    ${CONFIG}    ${DATA}
    Log To Console    >>> CONFIG LOADED


Click element when ready
    [Arguments]    ${locator}
    Wait For Elements State    //iframe[@src='/bizone/converter'] >>> ${locator}    visible    ${CONFIG}[timeouts][element_wait]
    Click    //iframe[@src='/bizone/converter'] >>> ${locator}


Check And Fill Company Address
    ${address_visible}=    Run Keyword And Return Status    
    ...    Wait For Elements State    //iframe[@src="/bizone/converter"] >>> //label[normalize-space()="Company Address"]/parent::div//textarea[@name="company_address"]    visible    timeout=2s
    
    IF    ${address_visible}
        ${company_address}=    Set Variable    ${CONFIG}[Company Address]
        Fill Text    //iframe[@src="/bizone/converter"] >>> //label[normalize-space()="Company Address"]/parent::div//textarea[@name="company_address"]    ${company_address}
        Log To Console    Filled Company Address: ${company_address}
    ELSE
        Log To Console    Company Address field not required or not visible
    END

Download SuggestedFilename
    [Arguments]    ${download_object}
    ${filename}=    Evaluate    $download_object.suggested_filename if hasattr($download_object, 'suggested_filename') else $download_object['suggestedFilename']
    RETURN    ${filename}


File Should Exist In Folder
    [Arguments]    ${folder}    ${pattern}
    @{files}=    List Files In Directory    ${folder}    ${pattern}
    ${count}=    Get Length    ${files}
    Should Be True    ${count} > 0    msg=Waiting for file matching ${pattern}...

Get Latest File By Modified Time
    [Arguments]    ${folder}    ${pattern}
    @{files}=    List Files In Directory    ${folder}    ${pattern}    absolute=True
    ${latest}=    Set Variable    ${EMPTY}
    ${latest_time}=    Set Variable    ${0}
    
    FOR    ${file}    IN    @{files}
        ${mtime}=    Get Modified Time    ${file}    epoch
        IF    ${mtime} > ${latest_time}
            ${latest_time}=    Set Variable    ${mtime}
            ${latest}=    Set Variable    ${file}
        END
    END
    
    RETURN    ${latest}
