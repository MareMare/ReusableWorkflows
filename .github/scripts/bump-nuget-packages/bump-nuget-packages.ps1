#!/usr/bin/env pwsh

# 使用方法
# ほかの ps1 から利用する場合
# . ".\dev\pwsh\bump-nuget-packages.ps1" 
# Invoke-Dotnet-Outdated "src" "bb.csv" -VersionLock "Major"
#
using namespace System.Linq;

function Invoke-Dotnet-Outdated {
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Directory,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputCsvFile,

        [ValidateNotNullOrEmpty()]
        [string]$VersionLock = "None",

        [string]$IncludePackagesCsv = "",
        [string]$ExcludePackagesCsv = ""
    )
    # include/exclude
    $Private:include = Resolve-CommandArgs -CommandFlag "-inc" -ValuesCsv $IncludePackagesCsv
    $Private:exclude = Resolve-CommandArgs -CommandFlag "-exc" -ValuesCsv $ExcludePackagesCsv
    Write-Host "incs: $Private:include"
    Write-Host "excs: $Private:exclude"

    if (Test-Path -Path $OutputCsvFile){
        # 出力先のファイルを削除しておきます。
        Remove-Item -Path $OutputCsvFile
    }

    # dotnet-outdated ツールを実行します。
    $exe="dotnet-outdated $Private:include $Private:exclude -u -vl $VersionLock -of Csv -o $OutputCsvFile $Directory"
    Write-Host $exe
    Invoke-Expression $exe | Out-Host

    return (Test-Path $OutputCsvFile) ? $true : $false
}

function Get-ReportBodyText {
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Csv_file
    )
    $Private:eol = "`r`n"

    # CSV を読み込み、先頭列（プロジェクト名）でグループ化します。
    $Private:csv = Import-Csv $Csv_file -Header @("f1","f2","f3","f4","f5","f6")
    $Private:grouped = $Private:csv | Group-Object -Property f1 -AsHashTable -CaseSensitive
    
    # 先頭列（プロジェクト名）毎に markdown table 形式のレポートを生成します。
    $Private:project_bodies = @()
    $Private:sortedKeys = $Private:grouped.Keys | Sort-Object
    foreach($Private:key in $Private:sortedKeys){
        $Private:records = $Private:grouped[$Private:key] | Sort-Object -Property f3
    
        $Private:md_table_header = @("|package|from|to|", "|--|--|--|")
        $Private:md_table_items = [Enumerable]::ToArray([Enumerable]::Select(
            $Private:records,
            [Func[object,string]]{
                param($x) "|``{0}``|{1}|{2}|" -f $x.f3, $x.f4, $x.f5
            }))

        $Private:md_table_elements `
            = @("$Private:eol## {0}$Private:eol" -f $Private:key) `
            + @($Private:md_table_header) `
            + @($Private:md_table_items)
        $Private:md_table = [string]::Join($Private:eol, $Private:md_table_elements)
        
        $Private:project_bodies += @($Private:md_table)
    }
    
    $Private:result = [string]::Join($Private:eol, $Private:project_bodies)
    return $Private:result
}

function Resolve-CommandArgs {
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$CommandFlag,

        [string]$ValuesCsv = ""
    )
    if ([string]::IsNullOrEmpty($ValuesCsv)){
        return ''
    }
    $Private:params = [Enumerable]::Select(
        $ValuesCsv.Split(','),
        [Func[object,string]]{
            param($x) "{0} {1}" -f $CommandFlag, ([string]$x).Trim()
        })
    $Private:result = [string]::Join(' ', $Private:params)
    return $Private:result
}
