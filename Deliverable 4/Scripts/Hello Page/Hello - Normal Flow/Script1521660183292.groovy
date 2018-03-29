import static com.kms.katalon.core.checkpoint.CheckpointFactory.findCheckpoint
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
import static com.kms.katalon.core.testcase.TestCaseFactory.findTestCase
import static com.kms.katalon.core.testdata.TestDataFactory.findTestData
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject

'Common utility to verify all 5 links accessible'
WebUI.callTestCase(findTestCase('Common Test/All 5 Links Present'), [:], FailureHandling.STOP_ON_FAILURE)

'Common utility to traverse to home  page and verify existence of logo'
WebUI.callTestCase(findTestCase('Common Test/Go To Home'), [:], FailureHandling.STOP_ON_FAILURE)

'Click on Hello href'
WebUI.click(findTestObject('href/Hello href'), FailureHandling.STOP_ON_FAILURE)

'Check for presence of logo after click'
WebUI.verifyElementPresent(findTestObject('image/Logo'), 0)

'Compare expected output to variable defined'
WebUI.verifyElementText(findTestObject('GUI elements/Div jumbotron'), Var_hello)

WebUI.closeBrowser()

