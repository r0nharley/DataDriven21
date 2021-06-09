# RobotFramework
Test automation Robot Framework POC

Robot Framework is a generic test automation framework for acceptance testing and acceptance test-driven development (ATDD). It has easy-to-use tabular test data syntax and it utilizes the keyword-driven testing approach. Its testing capabilities can be extended by test libraries implemented either with Python or Java, and users can create new higher-level keywords from existing ones using the same syntax that is used for creating test cases.

Please refer to the robot framework Git Repo for system requirements and pre conditions (Python): https://github.com/robotframework/robotframework/blob/master/INSTALL.rst

Because robotframework-selenium2library v1.8.0 is currently incompatible with Python 3 (cf. https://github.com/robotframework/Selenium2Library/issues/573), <b>make sure you are using Python 2</b>.

<b>Clone the Rentlytics Regression Test Repo:</b>

https://github.com/rentlytics/RobotFramework

<b>Install Robot Framework w/ pip:</b>

<pre>pip install robotframework</pre>

<b>Install the Selenium 2 Library for RF w/ pip:</b>

<pre>pip install robotframework-selenium2library</pre>

<b>Install the diff library</b>

<pre>pip install -U robotframework-difflibrary</pre>

<b>Install chromedriver</b>

<pre>brew install chromedriver</pre>

<b>Install PhantomJS</b>

<pre>npm install phantomjs</pre>

<b>Copy password variables</b>
* Create an <i>.env</i> file at the root of your local repo
* Copy the content of LastPass "TestAutomationUsers (local use)" to the <i>.env</i> file
* Run <pre>source .env</pre>

<b>Run the tests</b>

Kick off Prod 1 test: 

<pre>robot -d results hasdataprod/hasdatabh/tests/bh_has_data.robot hasdataprod/hasdatalivcor/tests/livcor_has_data.robot hasdataprod/hasdatawinterwood/tests/winterwood_has_data.robot</pre>

Kick off Staging Test:

<pre>robot -d results hasdatastage/hasdatabh/tests/bh_has_data.robot hasdatastage/hasdatalivcor/tests/livcor_has_data.robot hasdatastage/hasdatawinterwood/tests/winterwood_has_data.robot</pre>


Kick off Prod 1 and Stage Diff Test tests: 

<pre>robot -d results hasdataprod/hasdatabh/tests/bh_has_data.robot hasdataprod/hasdatalivcor/tests/livcor_has_data.robot hasdataprod/hasdatawinterwood/tests/winterwood_has_data.robot hasdatastage/hasdatabh/tests/bh_has_data.robot hasdatastage/hasdatalivcor/tests/livcor_has_data.robot hasdatastage/hasdatawinterwood/tests/winterwood_has_data.robot</pre>


## Important Folder Locations

| Folder 						| Use								|
|-------------------------------|-----------------------------------|
| HasDataTest/HasDataBH			| Test suite for regression tests. 	| 
| HasDataTest/Reports/BH		| Test Data for regression tests. 	| 
| HasDataProd					| Test suite for production			|
| HasDataStage					| Test suite for staging			|
| RegressionCentral				| Test suite for dotcom				|


## To Deploy a Test Branch to RobotFramework
* Make changes to RobotFramework
  * Create a new branch (`git checkout -b {name-of-robot-framework-branch}`)
  * Ex) Deploy a report to HasDataTest/Reports/BH
  * Commit your changes (`git commit -am 'your message'`)
  * push your changes `git push`
* Run your test in the RobotFramework 
  * `export CIRCLE_TOKEN={get this from lastpass}`
  * `./trigger-build.sh --branch {name-of-robot-framework-branch}`
* Check for the build here: https://circleci.com/gh/rentlytics/regression-test
* After the first run is complete, it retriggers an additional build.
* Merge your pr.
