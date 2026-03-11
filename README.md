# Piper TTS PowerShell Wrapper

A lightweight PowerShell utility to generate speech using the [Piper](https://github.com/rhasspy/piper) TTS engine. This script simplifies the process of creating `.wav` files with specific voices and adjustable playback speeds.

## Setup

### 1. Install Piper

* Download the Windows binary from the [Piper GitHub Releases](https://github.com/rhasspy/piper/releases).
* Extract it to a local folder (e.g., `C:\Users\Leves\BINS\piper\`).

### 2. Add Piper to System PATH

To call `piper` from any directory, you must add its location to your Environment Variables:

1. Search for **"Edit the system environment variables"** in Windows.
2. Click **Environment Variables** > **System variables** > **Path** > **Edit**.
3. Click **New** and add the folder path where `piper.exe` is located.
4. Restart your terminal.

### 3. Download Voice Models

You need `.onnx` and `.json` files for each language. Download them from the [Piper Voices Repository](https://huggingface.co/rhasspy/piper-voices/tree/main):

Place these files in your configured `$voiceDir`.

## Usage

Update the `$voiceDir` and `$outputDir` paths in `say.ps1` before running.

### Generate Speech

Open PowerShell and run the script with your desired parameters:

**English (Default):**

```powershell
.\say.ps1 -text "Hello world"

```

**German (Slow speed):**

```powershell
.\say.ps1 -text "Guten Tag" -lang "de" -speed 1.5

```

**Polish:**

```powershell
.\say.ps1 -text "Dzień dobry" -lang "pl"

```

## Parameters

* `-text`: The string you want to convert to audio (Mandatory).
* `-lang`: Language code (`en`, `de`, `pl`). Defaults to `en`.
* `-speed`: The `length_scale` factor. Higher is slower (e.g., 1.5), lower is faster (e.g., 0.8). Defaults to 1.2.

---

Would you like me to help you create a `.gitignore` file to prevent your `.wav` files and large `.onnx` models from being uploaded to GitHub?
