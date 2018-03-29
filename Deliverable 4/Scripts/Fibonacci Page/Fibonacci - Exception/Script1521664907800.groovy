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

data = data = findTestData('ExceptionTestData')

WebUI.openBrowser('')

'Navigate to Factorial link directly'
WebUI.navigateToUrl(Fibonacci_link)

'Click on Submit'
WebUI.click(findTestObject('GUI elements/Submit button'), FailureHandling.STOP_ON_FAILURE)

'Internal Server Error will occur at this step'
WebUI.verifyElementNotPresent(findTestObject('Exception elements/Internal Server Error'), 1, FailureHandling.CONTINUE_ON_FAILURE)

for (def index : (0..data.getRowNumbers() - 1)) {
    'Go back to prior page'
    WebUI.back()

    'Enter input value using test File'
    WebUI.setText(findTestObject('GUI elements/Text element'), data.getValue(1, index + 1))

    'Click on Submit'
    WebUI.click(findTestObject('GUI elements/Submit button'), FailureHandling.STOP_ON_FAILURE)

    'Internal Server Error will occur at this step'
    WebUI.verifyElementNotPresent(findTestObject('Exception elements/Internal Server Error'), 1, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()

