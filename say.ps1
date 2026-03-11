<#
.SYNOPSIS
    A PowerShell wrapper for Piper TTS.
.DESCRIPTION
    Generates .wav files from text using Piper TTS with support for multiple languages and adjustable speed.
.PARAMETER text
    The text to be converted to speech.
.PARAMETER lang
    Language selection: 'en' (default), 'de', or 'pl'.
.PARAMETER speed
    Speech speed (length_scale). 1.0 is normal, 1.2 is slower (default), 0.8 is faster.
#>

param(
    [Parameter(Mandatory=$true)] [string]$text, 
    [string]$lang="en",
    [float]$speed=1.2
)

# --- Configuration ---
# By default, the script looks for voices in a folder named 'piper-voices' 
# and saves audio to 'output' inside the same directory where the script is located.
# You can change these to absolute paths if you prefer (e.g., "C:\MyVoices").
$voiceDir = Join-Path $PSScriptRoot "piper-voices"
$outputDir = Join-Path $PSScriptRoot "output"

# Force UTF8 for international character support
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Ensure output directory exists
if (!(Test-Path $outputDir)) { 
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null 
}

# 1. Model selection logic
$modelFile = switch ($lang) {
    "de" { "de_DE-thorsten-high.onnx" }
    "pl" { "pl_PL-bass-high.onnx" }
    "en" { "en_US-ryan-high.onnx" }
    default { "en_US-ryan-high.onnx" }
}

$model = Join-Path $voiceDir $modelFile

# Check if the model file exists
if (!(Test-Path $model)) {
    Write-Host "[Error] Voice model not found at: $model" -ForegroundColor Red
    Write-Host "Tip: Create a 'piper-voices' folder next to this script and put your .onnx files there." -ForegroundColor Yellow
    return
}

# 2. File name generation
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$fileName = Join-Path $outputDir "${lang}_${timestamp}.wav"

# 3. Execution
Write-Host "Generating audio..." -ForegroundColor Gray
$text | piper --model $model --output_file $fileName --length_scale $speed

# 4. Result check
if (Test-Path $fileName) { 
    Write-Host "`n[Success] Audio saved: $fileName" -ForegroundColor Cyan
} else {
    Write-Host "`n[Error] Piper failed. Check if 'piper' is in your Windows PATH." -ForegroundColor Red
}
