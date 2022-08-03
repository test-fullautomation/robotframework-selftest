#  Copyright 2020-2022 Robert Bosch Car Multimedia GmbH
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
*** Settings ***
Resource         ../../resources/selftest_resource.robot
Library          RobotFramework_Testsuites    WITH NAME    testsuites
Suite Setup      Variant Setup
Suite Teardown   testsuites.testsuite_teardown
Test Setup       testsuites.testcase_setup
Test Teardown    testsuites.testcase_teardown

*** Variables ***
${CONNECTION_NAME}     ${EMPTY}
${global_param_file}   ./config/common/params_global_common.json
${preprocessor_file}   ./config/common/preprocessor_definitions_common.json

*** Keywords ***
Variant Setup
    testsuites.testsuite_setup    ./config/variants_config.json
    ${ALL_VARS}    Get Variables
    Set Suite Variable    ${ALL_VARS}    ${ALL_VARS}

*** Test Cases ***
Variant: configuration
    IF  "\${variant}" in $ALL_VARS
        Should Be Equal    ${CONFIG.Project}    ${variant}
    ELSE
        Should Be Equal    ${CONFIG.Project}    default
    END

    Should Be Equal    ${CONFIG.WelcomeString}    Hello... ROBFW is running now!

Variant: defined global parameters
    ${globalVars}=     Parse Data From Json     ${global_param_file}
    Should Be Equal    ${gGlobalFloatParam}     ${globalVars}[gGlobalFloatParam]
    Should Be Equal    ${gGlobalStructure.testing}    ${globalVars}[gGlobalStructure][testing]

    IF  "\${variant}" in $ALL_VARS
        IF     "${variant}" == "variant_1"
            Should Be Equal As Integers    ${gGlobalIntParam}      2
            Should Be Equal    ${gGlobalString}         ${globalVars}[gGlobalString]
            Should Be Equal    ${gGlobalStructure.general}    variant1
        ELSE IF    "${variant}" == "variant_2"
            Should Be Equal    ${gGlobalIntParam}   ${globalVars}[gGlobalIntParam]
            Should Be Equal    ${gGlobalString}         New string for variant 2
            Should Be Equal    ${gGlobalStructure.general}    variant2
        END
    ELSE
        Should Be Equal    ${gGlobalIntParam}   ${globalVars}[gGlobalIntParam]
        Should Be Equal    ${gGlobalString}         ${globalVars}[gGlobalString]
        Should Be Equal    ${gGlobalStructure.general}    ${globalVars}[gGlobalStructure][general]
    END

Variant: undefined global parameters
    IF  "\${variant}" in $ALL_VARS
        IF     "${variant}" == "variant_1"
            Should Be Equal    ${gGlobalVariant1}       Specific global parameter for variant 1
            Variable Is Not Defined  gGlobalVariant2
            Variable Is Not Defined  gGlobalStructure.variant2
        ELSE IF    "${variant}" == "variant_2"
            Variable Is Not Defined  gGlobalVariant1
            Should Be Equal    ${gGlobalVariant2}       Specific global parameter for variant 2
            Should Be Equal    ${gGlobalStructure.variant2}   new global param for variant 2
        END
    ELSE
        Variable Is Not Defined  gGlobalVariant1
        Variable Is Not Defined  gGlobalVariant2
        Variable Is Not Defined  gGlobalStructure.variant2
    END

Variant: defined preprocessors
    ${preproVars}=     Parse Data From Json     ${preprocessor_file}
    Should Be Equal    ${gPreproFloatParam}     ${preproVars}[gPreproFloatParam]
    Should Be Equal    ${gPreproStructure.testing}    ${preproVars}[gPreproStructure][testing]
    Should Be Equal    ${gPreproTest.Param01.checkParam01}    ${preproVars}[gPreproTest][Param01][checkParam01]
    Should Be Equal    ${gPreproTest.Param01.checkParam02}    ${preproVars}[gPreproTest][Param01][checkParam02]

    IF  "\${variant}" in $ALL_VARS
        IF    "${variant}" == "variant_1"
            Should Be Equal As Integers    ${gPreprolIntParam}      2
            Should Be Equal    ${gPreproString}         ${preproVars}[gPreproString]
            Should Be Equal    ${gPreproStructure.general}    variant1
        ELSE IF    "${variant}" == "variant_2"
            Should Be Equal    ${gPreprolIntParam}      ${preproVars}[gPreprolIntParam]
            Should Be Equal    ${gPreproString}         New string for variant 2
            Should Be Equal    ${gPreproStructure.general}    variant2
        END 
    ELSE
        Should Be Equal    ${gPreprolIntParam}      ${preproVars}[gPreprolIntParam]
        Should Be Equal    ${gPreproString}         ${preproVars}[gPreproString]
        Should Be Equal    ${gPreproStructure.general}    ${preproVars}[gPreproStructure][general]
    END
    

Variant: undefined preprocessors
    IF  "\${variant}" in $ALL_VARS
        IF     "${variant}" == "variant_1"
            Should Be Equal    ${gPreproVariant1}       Specific preprocessor definition for variant 1
            Variable Is Not Defined  gPreproVariant2
            Variable Is Not Defined  gPreproStructure.variant2
        ELSE IF    "${variant}" == "variant_2"
            Variable Is Not Defined  gPreproVariant1
            Should Be Equal    ${gPreproVariant2}       Specific preprocessor definition for variant 2
            Should Be Equal    ${gPreproStructure.variant2}   new preprocessor definitions for variant 2
        END
    ELSE
        Variable Is Not Defined  gPreproVariant1
        Variable Is Not Defined  gPreproVariant2
        Variable Is Not Defined  gPreproStructure.variant2
    END