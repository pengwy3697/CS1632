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
import org.openqa.selenium.Keys as Keys

'Common utility to traverse to home  page and verify existence of logo'
WebUI.callTestCase(findTestCase('Common Test/All 5 Links Present'), [:], FailureHandling.STOP_ON_FAILURE)

'Common utility to traverse to home  page and verify existence of logo'
WebUI.callTestCase(findTestCase('Common Test/Go To Home'), [:], FailureHandling.STOP_ON_FAILURE)

'Get the welcome text from Home page using XPath'
welcomeStr = WebUI.getText(findTestObject('XPath/p_Welcome element'))

'Get the taught by text from Home page using XPath'
def taughtBy = WebUI.getText(findTestObject('XPath/p_Taught element'))

'Use Reg Ex to verify \'Welcome, friend, to a land of pure calculation.\''
WebUI.verifyMatch(welcomeStr, 'Welcome, friend,(\\s)*[\\r\\n]*to a land of pure calculation.[\\r\\n]*[A-Z\\s]+$', true)

'Use Reg Ex to erify "Used for CS1632 Software Quality Assurance, taught by Bill Laboon"'
WebUI.verifyMatch(taughtBy, 'Used for CS1632 Software Quality Assurance,(\\s)*[\\r\\n]*taught by Bill Laboon', true)

WebUI.closeBrowser()

