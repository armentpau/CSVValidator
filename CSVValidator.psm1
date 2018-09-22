<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.154
	 Created on:   	9/21/2018 8:52 PM
	 Created by:   	PaulDeArment
	 Organization: 	
	 Filename:     	CSVValidator.psm1
	-------------------------------------------------------------------------
	 Module Name: CSVValidator
	===========================================================================
#>

$scriptPath = Split-Path $MyInvocation.MyCommand.Path

#region Load Public Functions
try
{
	Get-ChildItem "$scriptPath\Public" -filter *.ps1 | Select-Object -ExpandProperty FullName | ForEach-Object{
		. $_
	}
}
catch
{
	Write-Warning "There was an error loading $($function) and the error is $($psitem.tostring())"
	exit
}
