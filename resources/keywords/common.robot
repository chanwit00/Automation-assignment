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

