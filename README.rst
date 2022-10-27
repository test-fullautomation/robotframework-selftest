.. Copyright 2020-2022 Robert Bosch GmbH

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

Package Description
===================

Table of Contents
-----------------

-  `Getting Started <#getting-started>`__
-  `How to install <#how-to-install>`__
-  `Selftest testsuite structure <#selftest-testsuite-structure>`__
-  `How to execute <#how-to-execute>`__
-  `Contribution <#contribution>`__
-  `Sourcecode Documentation <#documentation>`__
-  `Feedback <#feedback>`__
-  `About <#about>`__

   -  `Maintainers <#maintainers>`__
   -  `Contributors <#contributors>`__
   -  `License <#license>`__
   


Getting Started
---------------
The RobotFramework AIO selftest contains robot testsuite which is executed to 
verify all functionalities of RobotFramework AIO and its extensions.

This selftest is triggered along with the build pipeline of RobotFramework AIO 
to verfy the built packages.

The purpose of this selftest is to ensure the quality of the RobotFramework
AIO packages before releasing to the users.

An overviev about helpful extensions of the RobotFramework can be found here:
test-fullautomation_

How to install
--------------
Clone the robotframework-selftest_ repository to your machine.

After that you can directly navigate to the subfolders of your local repository 
folder.

Selftest testsuite structure
----------------------------
Selftest testsuite contains:

- ``run_selftest.py``: the test executer which controls the robot test execution.

- ``config`` folder: the configurations (variants, parameters, testbench config, 
  ...) for the whole testsuite.

- ``helpers`` folder: helpful tools for selftest execution such as 
  TCP/IP server and sample DLT application.

- ``resources`` folder: RobotFramework resource/library files.

- ``testcases`` folder: all robot test cases for the selftest execution.

How to execute
--------------
Before excuting the selftest testsuite on your machine, you need to adapt the
``__TESTBENCH__CONFIG`` to fit with your setup environment.

E.g:

- adapt ``__TESTBENCH__CONFIG.hw.internal.SSH`` object to configure for ssh 
  connection test cases.
- set ``__TESTBENCH__CONFIG.sw.has_serial` to value ``true``/``false`` to turn 
  on/off the execution of Serial test cases. (features switch)

  In case the value ``false`` is set, Serial test cases will be skipped 
  (``SKIP`` status) when executing selftest.

.. note::

   Regarding to DLT test cases with **DLTSelftestApp**: The **DLTSelftestApp**
   (is included in ``helpers/DLT`` folder) should be installed on the target 
   machine first.

   Then, **dlt-daemon** service and **DLTSelftestApp** application should be 
   started before executing the DLT test cases. So that the DLT library 
   can communicate with **DLTSelftestApp** application for verification.


Execute below command to start the selftest:

   python run_selftest.py


The outputs (result, log, report, ...) of selftest can be found under ``output`` 
folder as soon the execution completed.

Contribution
------------
We are always searching support and you are cordially invited to help to improve 
robotframework-selftest_ testsuite.

Feedback
--------
Please feel free to give any feedback to us via

Email to: `Robot Framework Support Group`_

Issue tracking: `robotframework-selftest Issues`_

About
-----
Maintainers
~~~~~~~~~~~
`Thomas Pollerspöck`_

`Tran Duy Ngoan`_

Contributors
~~~~~~~~~~~~

`Nguyen Huynh Tri Cuong`_

`Mai Dinh Nam Son`_

`Tran Hoang Nguyen`_

`Holger Queckenstedt`_

License
~~~~~~~

Copyright 2020-2022 Robert Bosch GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    |License: Apache v2|

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


.. |License: Apache v2| image:: https://img.shields.io/pypi/l/robotframework.svg
   :target: http://www.apache.org/licenses/LICENSE-2.0.html
.. _Robot Framework Support Group: mailto:RobotFrameworkSupportGroup@bcn.bosch.com
.. _Thomas Pollerspöck: mailto:Thomas.Pollerspoeck@de.bosch.com
.. _Holger Queckenstedt: mailto:Holger.Queckenstedt@de.bosch.com
.. _Tran Duy Ngoan: mailto:Ngoan.TranDuy@vn.bosch.com
.. _Nguyen Huynh Tri Cuong: mailto:Cuong.NguyenHuynhTri@vn.bosch.com
.. _Mai Dinh Nam Son: mailto:Son.MaiDinhNam@vn.bosch.com
.. _Tran Hoang Nguyen: mailto:Nguyen.TranHoang@vn.bosch.com
.. _test-fullautomation: https://github.com/test-fullautomation
.. _robotframework-selftest: https://github.com/test-fullautomation/robotframework-selftest
.. _robotframework-selftest Issues: https://github.com/test-fullautomation/robotframework-selftest/issues