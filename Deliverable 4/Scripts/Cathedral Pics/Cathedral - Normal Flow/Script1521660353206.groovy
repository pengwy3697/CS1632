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

WebUI.callTestCase(findTestCase('Common Test/All 5 Links Present'), [:], FailureHandling.STOP_ON_FAILURE)

'Common utility to traverse to home  page and verify existence of logo'
WebUI.callTestCase(findTestCase('Common Test/Go To Home'), [:], FailureHandling.STOP_ON_FAILURE)

'Click on Cathedral link'
WebUI.click(findTestObject('href/Cathedral href'))

WebUI.callTestCase(findTestCase('Common Test/Logo Present'), [:], FailureHandling.STOP_ON_FAILURE)

'Check the presence of an ordered list that contains the number \'1\''
WebUI.verifyElementPresent(findTestObject('XPath/ol_1'), 1)

'Check the presence of an ordered list that contains the number \'2\''
WebUI.verifyElementPresent(findTestObject('XPath/ol_2'), 1)

'Check the presence of an ordered list that contains the number \'3\''
WebUI.verifyElementPresent(findTestObject('XPath/ol_3'), 1)

'Verify \'Sunny Cathedral\' image is present'
WebUI.verifyElementPresent(findTestObject('image/Sunny'), 5)

'Verify \'Alpenglow Cathedral\' image is present'
WebUI.verifyElementPresent(findTestObject('image/Alpenglow'), 5)

'Verify \'Old Cathedral\' image is present'
WebUI.verifyElementPresent(findTestObject('image/Old'), 5)

WebUI.closeBrowser()

