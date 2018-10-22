function New-CSVValidationRule
{
	param
	(
		[Parameter(Mandatory = $false)]
		[AllowEmptyCollection()]
		[AllowNull()]
		[AllowEmptyString()]
		[ValidateCount(0, 0)]
		[ValidateLength(0, 0)]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('')]
		[ValidateRange(0, 0)]
		[ValidateScript()]
		[ValidateSet( , IgnoreCase = $true)]
		$test
	)
	
	#TODO: Place script here
}
