function InitOutFolder($path)
{
    if (Test-Path $path) 
    {
        Remove-Item "$path\*" -Recurse -Force
    } else 
    {
        New-Item -ItemType Directory -Path $path | Out-Null
    }
}


function PackFile($hfile, $outFolder)
{
    Write-Host "Pack to ["$hfile.name"]" -ForegroundColor Yellow

    $outPath = "$outFolder/$($hfile.name)";

    "" | Out-File $outPath -Encoding utf8
    
    foreach ($file in $hfile.files) 
    {
        # Write-Host "Packing:" $file

        $filename = Split-Path $file -Leaf
        "<BKFile name=$($filename)>`n`n" | Add-Content $outPath -Encoding utf8

        Get-Content $file | Add-Content $outPath -Encoding utf8

        "`n</BKFile name=$($filename)>`n`n" | Add-Content $outPath -Encoding utf8
    }

}



# [Main Entry]


Clear-Host

Write-Host "`n`n`n`n"

Write-Host @"
   ██████╗  ██████╗ ██████╗ ███████╗██████╗  █████╗  ██████╗██╗  ██╗███████╗██████╗
  ██╔════╝ ██╔═══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
  ██║      ██║   ██║██║  ██║█████╗  ██████╔╝███████║██║     █████╔╝ █████╗  ██████╔╝
  ██║      ██║   ██║██║  ██║██╔══╝  ██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
  ╚██████╗ ╚██████╔╝██████╔╝███████╗██║     ██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
   ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
"@ -ForegroundColor Green


$files = Get-ChildItem .\Configs\*.json

Write-Host "`n============[Config-List-Start]===========`n" -ForegroundColor Blue
foreach ($file in $files) 
{
    $json = Get-Content $file.FullName -Raw | ConvertFrom-Json
    Write-Host "[Config]: $($file.name) Export: $($json.isExport)"
}
Write-Host "`n============[Config-List-End]===========`n" -ForegroundColor Blue


foreach ($file in $files) 
{
    $json = Get-Content $file.FullName -Raw | ConvertFrom-Json

    if($json.isExport -eq $false)
    {
        continue;
    }

    $fileName = $file.name -replace '.json', ''
    $outFolder = "./PackOut/$fileName";

    InitOutFolder($outFolder);

    Write-Host "`n`n==========[Export-Start-$fileName]==========`n" -ForegroundColor Green

    foreach ($hfile in $json.packList) 
    {
        PackFile $hfile $outFolder
    }
    
    Write-Host "`n==========[Export-End-$fileName]==========`n`n" -ForegroundColor Green
}