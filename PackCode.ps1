$json = Get-Content "./PackCodeCfg.json" -Raw | ConvertFrom-Json
$fileList_h = $json.fileList_h;
$fileList_cpp = $json.fileList_cpp;


function PackFile($hfile)
{
    Write-Host "Pack to ["$hfile.name"]" 

    $outPath = "./PackOut/$($hfile.name)";
    "" | Out-File $outPath -Encoding utf8
    foreach ($file in $hfile.files) 
    {
        Write-Host "Packing:" $file

        $filename = Split-Path $file -Leaf
        "<BKFile name=$($filename)>`n`n" | Add-Content $outPath -Encoding utf8

        Get-Content $file | Add-Content $outPath -Encoding utf8

        "`n</BKFile name=$($filename)>`n`n" | Add-Content $outPath -Encoding utf8
    }

}


Write-Host "==========[Files]=========="

foreach ($hfile in $fileList_h ) 
{
    PackFile($hfile)
}