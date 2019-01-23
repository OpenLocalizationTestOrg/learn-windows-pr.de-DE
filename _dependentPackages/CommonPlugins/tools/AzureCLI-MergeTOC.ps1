# Parameters
param(
    [parameter(mandatory=$true)]
    [hashtable]$ParameterDictionary
)

# Functions
function Insert-RefTOC
{
    param([System.Collections.Generic.List[System.String]] $finalLines,
        [System.Collections.Generic.List[System.String]] $autogenTocFileContent,
        [String] $topRefGroupName,
        [String] $prefix)

    $firstLine = $true
    foreach($line in $autogenTocFileContent)
    {
        if($firstLine)
        {
            $firstLine = $false
            $originalTitle = Find-TocTitle $line
            $line = $line.Replace($originalTitle, $topRefGroupName)
        }
        $line = $line -replace '\][ ]*\([ ]*([a-zA-Z])','](_AUTOGENDOCPATH_$1'
        $line = $line.Replace("_AUTOGENDOCPATH_", "../$refTocFolderName/")
        $finalLines.Add($prefix + $line)
    }
}

function Find-TocTitle
{
    param([String] $line)

    if([String]::IsNullOrWhiteSpace($line))
    {
        return $null
    }
    $leftPos = $line.IndexOf('[');
    $rightPos = $line.IndexOf(']');
    if($leftPos -ge 0 -and $rightPos -gt $leftPos)
    {
        return $line.Substring($leftPos + 1, $rightPos - $leftPos -1)
    }
    return $null
}

# Script
Write-Host "Start to merge TOC"
$refTocFolderName = $null
$conceptTocFolderName = $null
$mergeMDTocPlugin = $ParameterDictionary.environment.publishConfigContent.MergeMDTocPlugin
if ($mergeMDTocPlugin)
{
    Write-Host "Get folder names from parameters"
    $refTocFolderName = $mergeMDTocPlugin.AutogenTocFolder
    $conceptTocFolderName = $mergeMDTocPlugin.ConceptTocFolder
    
}
else
{
    Write-Host "Get folder names from local"
    $refTocFolderName = 'docs-ref-autogen'
    $conceptTocFolderName  = 'docs-ref-conceptual'
    
}
$folders = Get-ChildItem -Path $repositoryRoot -Directory
ForEach($folder in $folders)
{
    Write-Host "Start to merge TOC for $folder"
    $folderPath = [System.IO.Path]::Combine($repositoryRoot, $folder)
    $subFolders = Get-ChildItem -Path $folderPath -Directory -Name
    if ($subFolders -contains $refTocFolderName -and $subFolders -contains $conceptTocFolderName)
    {
        $refTocFolder = [System.IO.Path]::Combine($folderPath, $refTocFolderName)
        $conceptTocFolder = [System.IO.Path]::Combine($folderPath, $conceptTocFolderName)
        # Finds TOC files
        $conceptTocFile = [System.IO.Path]::Combine($conceptTocFolder, "TOC.md")
        if(-not (Test-Path $conceptTocFile))
        {
            Write-Host "Conceptual toc file $conceptTocFile doesn't exist"
            exit(1)
        }
        $autogenTocFile = [System.IO.Path]::Combine($refTocFolder, "TOC.md")
        if(-not (Test-Path $autogenTocFile))
        {
            Write-Host "ref toc file $autogenTocFile doesn't exist"
            exit(1)
        }
        # Gets Toc contents
        $conceptTocFileContent = Get-Content $conceptTocFile
        $autogenTocFileContent = Get-Content $autogenTocFile
        # Merges Toc contents
        $mergedTocContent = New-Object System.Collections.Generic.List[System.String]
        $includeRefDoc = $false
        $level = 0
        foreach($line in $conceptTocFileContent)
        {
            if([System.String]::IsNullOrWhiteSpace($line))
            { 
                break 
            }

            $curLevel = 0
            $index = 0;
            while($index -lt $line.Length -and $line[$index] -eq '#')
            {
                ++$index
                ++$curLevel
            }
            if($curLevel -eq 0)
            {
                Write-Host "Unexpected toc content: $line"
                exit(1)
            }
            if($level -eq 0 -and $curLevel -ne 1)
            {
                Write-Host "First toc line must be start with only one #: $line"
                exit(1)
            }
            if($curLevel -gt $level + 1)
            {
                Write-Host "Invalid toc line: $line"
                exit(1)
            }
            $level = $curLevel

            if($line.IndexOf("TOC.md", [System.StringComparison]::OrdinalIgnoreCase) -ge 0)
            {
                $includeRefDoc = $true
                $prefixIndent = "#"*($level-1)
                $topRefGroupName = Find-TocTitle $line
                Insert-RefTOC $mergedTocContent $autogenTocFileContent $topRefGroupName $prefixIndent
            }
            else
            {
                $mergedTocContent.Add($line)
            }
        }

        # Replaces conceptual TOC file
        Set-Content $conceptTocFile $mergedTocContent
        Write-Host "Complete merging TOC for $folder"
    }
}
Write-Host "Complete merging TOC"