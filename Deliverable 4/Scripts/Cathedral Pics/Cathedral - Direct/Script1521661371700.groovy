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

WebUI.openBrowser('')

'Navigate to Cathedral page directly'
WebUI.navigateToUrl(Cathedral_link)

'Check the presence of an ordered list with index \'1\''
WebUI.verifyElementPresent(findTestObject('XPath/ol_1'), 1)

'Check the presence of an ordered list with index \'2\''
WebUI.verifyElementPresent(findTestObject('XPath/ol_2'), 1)

'Check the presence of an ordered list with index \'3\''
WebUI.verifyElementPresent(findTestObject('XPath/ol_3'), 1)

'Verify \'Sunny Cathedral\' image is present'
WebUI.verifyElementPresent(findTestObject('image/Sunny'), 3)

'Verify \'Alpenglow Cathedral\' image is present'
WebUI.verifyElementPresent(findTestObject('image/Alpenglow'), 3)

'Verify \'Old Cathedral\' image is present'
WebUI.verifyElementPresent(findTestObject('image/Old'), 3)

WebUI.closeBrowser()

