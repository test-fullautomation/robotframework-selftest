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
import sys
import os
from robot import run_cli, rebot_cli
import subprocess

BASE_DIR = os.path.split(os.path.abspath(__file__))[0]
TESTCASE_DIR = os.path.join(BASE_DIR, 'testcases')

# Define components and variants for selftest execution
# By defaults, all sub directories under testcases folder are used as COMPONENTS
COMPONENTS = [f.name for f in os.scandir(TESTCASE_DIR) if f.is_dir()]
# COMPONENTS = ['variants', 'connectivity']
VARIANTS   = ['default', 'variant_1', 'variant_2']

PYTHON = 'python' if sys.platform.startswith('win') else "python3"
ROBOT_CMD  = [f'{os.environ["RobotPythonPath"]}/{PYTHON}', '-m', 'robot.run']
REBOT_CMD  = [f'{os.environ["RobotPythonPath"]}/{PYTHON}', '-m', 'robot.rebot']

OS_VARIANT = 'Win10' if sys.platform == "win32" else "OSD5"

def run_all_selftest():
    output_dir = os.path.join(BASE_DIR, 'output')
    rebot_args = ['--name', 'SelfTest',
                    '--outputdir', output_dir, 
                    '--output', f'sumary_output.xml',
                    '--report', f'sumary_report.html',
                    '--log', f'sumary_log.html']
    for component in COMPONENTS:
        outfile = run_cmpt_selftest(component)
        rebot_args.append(outfile)
    # merge Component results

    res = subprocess.run([*REBOT_CMD, *rebot_args], capture_output=True)
    print(f"Sumary report: {output_dir}")
        
def run_cmpt_selftest(cmpt):
    
    if cmpt == "variants":
        # output_dir = os.path.join(BASE_DIR, 'testcases', 'output')
        output_dir = os.path.join(BASE_DIR, 'output')
        rebot_args = ['--name', cmpt,
                      '--outputdir', output_dir, 
                      '--output', f'{cmpt}.xml',
                      '--report', f'{cmpt}_report.html',
                      '--log', f'{cmpt}_log.html']
        for variant in VARIANTS:
            
            outfile = run_robot(cmpt, variant)
            
            rebot_args.append(outfile)

        # merge Variant results
        res = subprocess.run([*REBOT_CMD, *rebot_args], capture_output=True)
        # outfile = os.path.join(BASE_DIR, 'testcases', 'out', f'{cmpt}_output.xml')
        outfile = os.path.join(output_dir, f'{cmpt}.xml')
    else:
        outfile = run_robot(cmpt)

    return outfile

def run_robot(cmpt, variant=None):
    variable = ''
    suitename = cmpt
    # output = os.path.join(BASE_DIR, 'testcases', 'out', f'{suitename}.xml') 
    output_dir = os.path.join(BASE_DIR, 'output') 
    if variant:
        variable = f'variant:{variant}'
        suitename  = f'{cmpt}.{variant}'
        # output   = os.path.join(BASE_DIR, 'testcases', cmpt, 'out', f'{suitename}.xml') 
        output_dir = os.path.join(BASE_DIR, 'output', cmpt)
        if variant == 'default':
            variable = ''
    else:
        variable = f'variant:{OS_VARIANT}'

    robot_target = os.path.join(BASE_DIR, 'testcases', cmpt)
    print(f'>>> Execute {suitename} ...')

    vars = []
    if variable:
        vars.extend(['--variable', variable])

    res = subprocess.run([*ROBOT_CMD, '--name', suitename, *vars,
                        '--outputdir', output_dir, 
                        '--output', f'{suitename}.xml', 
                        '--report', f'{cmpt}_report.html',
                        '--log', f'{cmpt}_log.html', 
                        robot_target], capture_output=True)

    outfile = os.path.join(output_dir, f'{suitename}.xml')
    print(outfile)
    return outfile

if __name__ == "__main__":
    run_all_selftest()