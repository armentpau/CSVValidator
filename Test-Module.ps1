<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.154
	 Created on:   	9/21/2018 8:52 PM
	 Created by:   	PaulDeArment
	 Organization: 	
	 Filename:     	Test-Module.ps1
	===========================================================================
	.DESCRIPTION
	The Test-Module.ps1 script lets you test the functions and other features of
	your module in your PowerShell Studio module project. It's part of your project,
	but it is not included in your module.

	In this test script, import the module (be careful to import the correct version)
	and write commands that test the module features. You can include Pester
	tests, too.

	To run the script, click Run or Run in Console. Or, when working on any file
	in the project, click Home\Run or Home\Run in Console, or in the Project pane, 
	right-click the project name, and then click Run Project.
#>


#Explicitly import the module for testing
Import-Module Pester
Import-Module 'CSVValidator'

Describe "Test CSVValidator" {
	$testPath = "TestDrive:\test.csv"
	[pscustomobject]@{
		"Name"  = "TestFile"
		"Data"  = "JustSomeData"
		"Extra" = "Extra Header"
	} | Export-Csv $testPath -NoTypeInformation
	It "Testing headers on a csv file are valid with extra headers" {
		$results = Test-CSV -Path $testPath -headers @("Name", "Data")
		$results.csvValid | Should be $true
	}
	It "Testing headers on a csv file is invalid with extra headers with DisallowHeadersWithoutRules switch"{
		$results = Test-CSV -Path $testPath -Headers @("Name", "Data") -DisallowHeadersWithoutRules
		$results.csvvalid | Should be $false
	}
	It "Testing that Headers not in rules is true"{
		$results = Test-CSV -Path $testPath -Headers @("Name", "Data")
		$results.HeadersInRules | Should be $true
	}
	It "Testing that Headers not in rules is true"{
		$results = Test-CSV -Path $testPath -Headers @("Name", "Data","Extra")
		$results.HeadersInRules | Should be $true
	}
	It "Testing that Headers not in rules is false"{
		$results = Test-CSV -Path $testPath -Headers @("Name", "Data") -DisallowHeadersWithoutRules
		$results.HeadersInRules | Should be $false
	}
	It "Testing missing headers are identified"{
		$results = Test-CSV -Path $testPath -Headers @("Name", "Data", "Extra","Temp")
		$results.missingheaders | Should be "Temp"
	}
}