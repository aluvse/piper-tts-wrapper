param(
    [Parameter(Mandatory=$true)] [string]$inputFile, 
    [string]$lang="de",
    [float]$speed=1.2
)


$voiceDir = "PATH-WHERE-YOUR-VOICES"
$outputDir = "PATH-WHERE-TO-SAVE"


[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

if (!(Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }


$modelFile = switch ($lang) {
    "de"  { "de_DE-thorsten-high.onnx" }
    "dem" { "de_DE-thorsten_emotional-medium.onnx" }
    "pl"  { "pl_PL-bass-high.onnx" }
    "en"  { "en_US-ryan-high.onnx" }
    default { "en_US-ryan-high.onnx" }
}
$model = Join-Path $voiceDir $modelFile


$lines = Get-Content -Path $inputFile -Encoding UTF8
$results = @()
$count = 1

Write-Host ">>> Starting mass processing: $($lines.Count) lines" -ForegroundColor Yellow

foreach ($line in $lines) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    

    $baseName = "$($lang)_audio_$count"
    $tempWav  = Join-Path $outputDir "$baseName.wav"
    $opusName = "$baseName.opus"
    $opusPath = Join-Path $outputDir $opusName
    
    Write-Host "[$count] Processing: $($line.Substring(0, [Math]::Min(20, $line.Length)))..." -ForegroundColor Gray


    $line | piper --model $model --output_file $tempWav --length_scale $speed 2>$null
    
    if (Test-Path $tempWav) {

        ffmpeg -loglevel quiet -i $tempWav -c:a libopus -b:a 24k -y $opusPath
        

        Remove-Item $tempWav -ErrorAction SilentlyContinue
        

        $results += [PSCustomObject]@{
            id    = $count
            text  = $line
            audio = "[sound:$opusName]" 
        }
    }
    $count++
}


$results | ConvertTo-Json -Depth 2 | Out-File -FilePath (Join-Path $outputDir "map.json") -Encoding UTF8

Write-Host "`n[Done] Generated $($count-1) Opus files and map.json" -ForegroundColor Cyan