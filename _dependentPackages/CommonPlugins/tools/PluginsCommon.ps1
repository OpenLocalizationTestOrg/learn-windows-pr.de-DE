Function Invoke-Git {
    [cmdletbinding()]
    param(
        [parameter(Position = 0,
                   ValueFromRemainingArguments = $true)]
        $Arguments,
        [validatescript({
            if(-not (Get-Command $_))
            {
                throw "Could not find command at GitPath [$_]"
            }
        })]
        $GitPath = 'git.exe'
    )

    $Path = (Resolve-Path $PWD.Path).Path
    $argsStr = $Arguments -join " "
	Write-Host "$Path> Git.exe $argsStr"
	$process = RunExeProcess($GitPath) ($argsStr) ($Path)
    if ($process.ExitCode -ne 0)
    {
        $processErrorMessage = $process.StandardError
        $errorMessage = "Run Git command $argsStr failed. Error: $processErrorMessage"
        ConsoleErrorAndExit($errorMessage) ($process.ExitCode)
    }
	else
	{
		Write-Host $process.StandardOutput
	}
}