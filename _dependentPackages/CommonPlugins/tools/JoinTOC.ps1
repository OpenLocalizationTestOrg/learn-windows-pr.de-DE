param (
    [parameter(mandatory=$true)]
    [hashtable]$ParameterDictionary
)

$currentDir = $($MyInvocation.MyCommand.Definition) | Split-Path
$joinTOCExeFilePath = Join-Path $currentDir "JoinTOC.exe"
# Main
$errorActionPreference = 'Stop'

$repositoryRoot = $ParameterDictionary.environment.repositoryRoot
$logFilePath = $ParameterDictionary.environment.logFile

$skipServicePage = $false
pushd $repositoryRoot
$publicGitUrl = & git config --get remote.origin.url
if ($publicGitUrl.EndsWith(".git"))
{
    $publicGitUrl = $publicGitUrl.Substring(0, $publicGitUrl.Length - 4)
}
$publicGitUrl = $publicGitUrl.ToLower()
Write-Host $publicGitUrl
if ($publicGitUrl.StartsWith("https://github.com/microsoftdocs/azure-docs-sdk-java.") -or $publicGitUrl.StartsWith("https://github.com/microsoftdocs/azure-docs-sdk-dotnet."))
{
	$skipServicePage = $true
}
popd

$baseFolder = $repositoryRoot
$jobs = $ParameterDictionary.docset.docsetInfo.JoinTOCPlugin
if (!$jobs)
{
	$jobs = $ParameterDictionary.environment.publishConfigContent.JoinTOCPlugin
}
if ($jobs -isnot [system.array])
{
    $jobs = @($jobs)
}
foreach($JoinTOCConfig in $jobs)
{
	$topTOC = $null
	$conceptualTOC = Join-Path $baseFolder $JoinTOCConfig.ConceptualTOC
	$refTOCUrl = $JoinTOCConfig.ReferenceTOCUrl
	$conceptualTOCUrl = $JoinTOCConfig.ConceptualTOCUrl
	$landingPageFolder = $JoinTOCConfig.OutputFolder
    $allArgs = @("-l", "$logFilePath", "-r", "$repositoryRoot");

	if ($skipServicePage)
	{
		$allArgs += "-skipGeneratingServicePage";
	}

	if (-not [string]::IsNullOrEmpty($JoinTOCConfig.TopLevelTOC))
    {
		$topTOC = Join-Path $baseFolder $JoinTOCConfig.TopLevelTOC
		if (-not (Test-Path $topTOC))
		{
			$fallbackRepoRoot = Join-Path $repositoryRoot _repo.en-us
			$topTOC = Join-Path $fallbackRepoRoot $JoinTOCConfig.TopLevelTOC
		}
        $allArgs += "-topLevelTOC";
        $allArgs += "$topTOC";
    }

	if (-not [string]::IsNullOrEmpty($JoinTOCConfig.ReferenceTOC))
    {
		$refTOC = Join-Path $baseFolder $JoinTOCConfig.ReferenceTOC
        $allArgs += "-refTOC";
        $allArgs += "$refTOC";
    }

	if (-not [string]::IsNullOrEmpty($conceptualTOC) -and (Test-Path $conceptualTOC))
    {
        $allArgs += "-conceptualTOC";
        $allArgs += "$conceptualTOC";
    }

	if (-not [string]::IsNullOrEmpty($refTOCUrl))
    {
        $allArgs += "-refTOCUrl";
        $allArgs += "$refTOCUrl";
    }

	if (-not [string]::IsNullOrEmpty($conceptualTOCUrl))
    {
        $allArgs += "-conceptualTOCUrl";
        $allArgs += "$conceptualTOCUrl";
    }

	if ($JoinTOCConfig.HideEmptyNode)
	{
		$allArgs += "-hideEmptyNode";
	}

	if ($JoinTOCConfig.ContainerPageMetadata)
	{
		$allArgs += "-landingPageMetadata";
		$meta = $JoinTOCConfig.ContainerPageMetadata;
		$json = ConvertTo-Json $meta -Compress
		$json = $json -replace """","\"""
		$allArgs += "$json";
	}

	if ($JoinTOCConfig.ContainerPageYamlMime)
	{
		$allArgs += "-landingPageYamlMime";
		$mime = $JoinTOCConfig.ContainerPageYamlMime;
		$allArgs += "$mime";
	}

	if (-not [string]::IsNullOrEmpty($landingPageFolder))
    {
		$landingPageFolder = Join-Path $baseFolder $landingPageFolder
        $allArgs += "-o";
        $allArgs += "$landingPageFolder";
    }

    $printAllArgs = [System.String]::Join(' ', $allArgs)
    echo "Executing $joinTOCExeFilePath $printAllArgs" | timestamp
    & "$joinTOCExeFilePath" $allArgs
    if ($LASTEXITCODE -ne 0)
    {
        exit $LASTEXITCODE
    }

	$outputFolder = $currentDictionary.environment.outputFolder

	$fusionTOCOutputFolder = Join-Path $outputFolder "_fusionTOC"
	New-Item -ItemType Directory -Force -Path $fusionTOCOutputFolder
	if (-not [string]::IsNullOrEmpty($landingPageFolder))
	{
		& robocopy $landingPageFolder $fusionTOCOutputFolder *.yml *.md /s
	}
	if (-not [string]::IsNullOrEmpty($topTOC) -and (Test-Path $topTOC))
	{
		copy-item $topTOC "$fusionTOCOutputFolder/TopLevelTOC.yml" -Force
	}
	if (-not [string]::IsNullOrEmpty($refTOC))
	{
		$refTOC = $refTOC -replace "\.md$",".yml"
		copy-item $refTOC "$fusionTOCOutputFolder/ReferenceTOC.yml" -Force 
	}
	if (-not [string]::IsNullOrEmpty($conceptualTOC))
	{
		$conceptualTOC = $conceptualTOC -replace "\.md$",".yml"
	    copy-item $conceptualTOC "$fusionTOCOutputFolder/ConceptualTOC.yml" -Force 
	}
}

exit 0

