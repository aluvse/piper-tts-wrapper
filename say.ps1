param(
    [Parameter(Mandatory=$true)] [string]$text, 
    [string]$lang="en",
    [float]$speed=1.3
)

$voiceDir = "YOUR-VOICES-FOLDER"
$outputDir = "YOUR-OUTPUT-FOLDER"

[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if (!(Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

$modelFile = switch ($lang) {
    "de" { "de_DE-thorsten-high.onnx" }
    "dem" { "de_DE-thorsten_emotional-medium.onnx" }
    "pl" { "pl_PL-bass-high.onnx" }
    "en" { "en_US-ryan-high.onnx" }
    default { "en_US-ryan-high.onnx" }
}
$model = Join-Path $voiceDir $modelFile

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$tempWav = Join-Path $outputDir "temp_${timestamp}.wav"
$finalOpus = Join-Path $outputDir "${lang}_${timestamp}.opus"


Write-Host ">>> Generating voice..." -ForegroundColor Gray
$text | piper --model $model --output_file $tempWav --length_scale $speed 2>$null


if (Test-Path $tempWav) {
    Write-Host ">>> Compressing to Opus..." -ForegroundColor Gray

    ffmpeg -loglevel error -i $tempWav -c:a libopus -b:a 24k -y $finalOpus


    Remove-Item $tempWav -ErrorAction SilentlyContinue
}


if (Test-Path $finalOpus) { 
    Write-Host "`n[Success] Opus saved: $finalOpus" -ForegroundColor Cyan
} else {
    Write-Host "`n[Error] Something went wrong." -ForegroundColor Red
}
