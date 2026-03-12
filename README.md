
# Piper TTS PowerShell Wrapper

A production-ready PowerShell toolchain for Speech Synthesis (TTS). Orchestrates **Piper** for inference and **FFmpeg** for encoding, optimized for high-density audio asset generation.

## Technical Features

* **Dual-Stage Pipeline**: Implements a WAV-to-Opus workflow, reducing storage requirements by up to 15x while maintaining vocal clarity.
* **Batch Processing**: Automated high-throughput synthesis from plaintext datasets.
* **Manifest Generation**: Exports a `map.json` linking source text to generated artifacts for database or Anki integration.
* **Encoding Stability**: Enforces UTF-8 console and input handling for multilingual support (German, Polish, etc.).

## Setup

### 1. Requirements

* **Piper**: Download Windows binary from [Piper GitHub Releases](https://github.com/rhasspy/piper/releases).
* **FFmpeg**: Required for Opus encoding. Download from [ffmpeg.org](https://ffmpeg.org/download.html).
* **System PATH**: Ensure both `piper` and `ffmpeg` are added to your Environment Variables.

### 2. Voice Models

Download `.onnx` and `.json` files from the [Piper Voices Repository](https://huggingface.co/rhasspy/piper-voices/tree/main) and place them in your `$voiceDir`.

## Usage

### Individual Synthesis (`say.ps1`)

```powershell
.\say.ps1 -text "Ich möchte ein Studienkolleg besuchen" -lang "de" -speed 1.3

```

### Bulk Processing (`mass_say.ps1`)

Expects a UTF-8 encoded `.txt` file with one phrase per line:

```powershell
.\mass_say.ps1 -inputFile "vocab.txt" -lang "de" -speed 1.2

```

## Parameters

* `-text` / `-inputFile`: The content to convert (Mandatory).
* `-lang`: Language code (`en`, `de`, `dem` (emotional), `pl`). Defaults to `de`.
* `-speed`: The `length_scale` factor. Higher is slower (e.g., 1.5). Defaults to 1.2.

## Output

Files are saved to your `$outputDir` in `.opus` format.
Mass processing generates a `map.json`:

```json
[
  {
    "id": 1,
    "text": "Guten Tag",
    "audio": "[sound:de_audio_1.opus]"
  }
]

```

## Troubleshooting

* **Encoding**: Ensure input files are UTF-8 encoded without BOM to prevent character corruption.
* **FFmpeg**: If encoding fails, verify FFmpeg is accessible via terminal and you have write permissions for the destination directory.
