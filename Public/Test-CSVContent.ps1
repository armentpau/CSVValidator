function Test-CSVContent
{
	[CmdletBinding(SupportsShouldProcess = $false)]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[ValidateScript({ test-path $_ })]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('.csv')]
		[Alias('File', 'FilePath', 'csv', 'csvfile')]
		[string]$Path,
		[hashtable]$ValidationRules
	)
	
	BEGIN
	{
		try
		{
			Write-Verbose "Attempting to import CSV data from $($Path)."
			$csvData = Import-Csv $Path -ErrorAction Stop
			Write-Verbose "Successfully imported CSV data from $($Path)."
		}
		catch
		{
			throw "There was an error importing data from $($Path).  The error is $($psitem.tostring())"
		}
		
		try
		{
			Write-Verbose "Attempting to import headers into variable CSVHeader"
			$CSVHeader = $csvData[0] | Get-Member | where-object{ $_.MemberType -eq 'NoteProperty' }
			Write-Verbose "Successfully imported headers into variable CSVHeader"
		}
		catch
		{
			throw "There was no data in the CSV file $($Path).  The script is unable to validate headers on this file."
		}
		$validDataRows = [System.Collections.ArrayList]@()
		$invalidDataRows = [System.Collections.arraylist]@()
		$csvRowNumber = 2
	}
	PROCESS
	{
		foreach ($item in $csvData)
		{
			foreach ($header in $csvheader.name)
			{
				if ($ValidationRules.get_item($header))
				{
					$rule = $ValidationRules.get_item($header)
					$expression = "$($rule)`$testValid=$($item.$($header))"
					try
					{
						Invoke-Expression $expression -ErrorAction Stop
						$validDataRows.add((New-Object -TypeName System.Management.Automation.PSObject -Property ([ordered]@{
									"Rule" = $($rule)
									"Value" = $($item.$($header))
									"Row"  = $($csvRowNumber)
									"Header" = $($header)
									"Error" = $null
						}))) | Out-Null
					}
					catch
					{
						$invalidDataRows.add((New-Object -TypeName System.Management.Automation.PSObject -Property ([ordered]@{
									"Rule" = $($rule)
									"Value" = $($item.$($header))
									"Row"  = $($csvRowNumber)
									"Header" = $($header)
									"Error" = $($psitem.tostring())
								}))) | Out-Null
					}
				}
			}
			$csvRowNumber++
		}
	}
	END
	{
		New-Object -TypeName System.Management.Automation.PSObject -Property @{
			"ValidRows" = $validDataRows
			"InvalidRows" = $invalidDataRows
		}
	}
}