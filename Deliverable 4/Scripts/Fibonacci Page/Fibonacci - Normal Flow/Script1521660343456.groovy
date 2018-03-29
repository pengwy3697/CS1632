import static com.kms.katalon.core.checkpoint.CheckpointFactory.findCheckpoint
import static com.kms.katalon.core.testcase.TestCaseFactory.findTestCase
import static com.kms.katalon.core.testdata.TestDataFactory.findTestData
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.checkpoint.Checkpoint as Checkpoint
import com.kms.katalon.core.checkpoint.CheckpointFactory as CheckpointFactory
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as MobileBuiltInKeywords
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import com.kms.katalon.core.testcase.TestCase as TestCase
import com.kms.katalon.core.testcase.TestCaseFactory as TestCaseFactory
import com.kms.katalon.core.testdata.TestData as TestData
import com.kms.katalon.core.testdata.TestDataFactory as TestDataFactory
import com.kms.katalon.core.testobject.ObjectRepository as ObjectRepository
import com.kms.katalon.core.testobject.TestObject as TestObject
import com.kms.katalon.core.webservice.keyword.WSBuiltInKeywords as WSBuiltInKeywords
import com.kms.katalon.core.webservice.keyword.WSBuiltInKeywords as WS
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUiBuiltInKeywords
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import internal.GlobalVariable as GlobalVariable
import com.kms.katalon.core.testdata.InternalData as InternalData

data = findTestData('FibonacciTestData')

'Common utility to traverse to home  page and verify existence of logo'
WebUI.callTestCase(findTestCase('Common Test/All 5 Links Present'), [:], FailureHandling.STOP_ON_FAILURE)

'Common utility to traverse to home  page and verify existence of logo'
WebUI.callTestCase(findTestCase('Common Test/Go To Home'), [:], FailureHandling.STOP_ON_FAILURE)

'Click on Fibonacci link'
WebUI.click(findTestObject('href/Fibonacci href'))

'Check for presence of logo after click'
WebUI.verifyElementPresent(findTestObject('image/Logo'), 0)

'Verify \'Submit\' button is present'
WebUI.verifyElementPresent(findTestObject('GUI elements/Submit button'), 1)

'Loop'
for (def index : (0..data.getRowNumbers() - 1)) {
    'Enter input value using test File'
    WebUI.setText(findTestObject('GUI elements/Text element'), data.getValue(1, index + 1))

    'Click on Submit'
    WebUI.click(findTestObject('GUI elements/Submit button'))

    'Compare output with expected value retrieved from test file'
    WebUI.verifyElementText(findTestObject('GUI elements/Div jumbotron'), data.getValue(2, index + 1))

    WebUI.back()
}

WebUI.closeBrowser()

