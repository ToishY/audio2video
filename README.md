# audio2video
Audio2Video is powershell script that makes it easy to convert audio batches to video files.

### Description
AUDIO2VIDEO makes it easy to batch convert your audio files to video files using FFMPEG. The user is asked to specify the directory of the audio files, an image to display on top of the video and a JSON file containing settings for encoding the video. Optionally, the user can also specify the audio extension (default '.mp3') and also the video extension (default '.mp4') for the output video file.

### OS
Works on the following operating systems:
- Windows (tested Windows 10)
- Linux (tested Ubuntu 18.04)

### Software
The following programs have to be installed on your system:
- Powershell
- FFmpeg

### How To Use
- Windows
```sh
powershell -executionpolicy bypass -File .\audio2video.ps1 -dir "C:\Users\Kintoki\Music" -img "C:\Users\Kintoki\Pictures\testpattern.png" -vid_preset "C:\Users\Kintoki\Documents\video_preset.json"
```

- Linux
```sh
pwsh audio2video.ps1 -dir "/path/to/Kintoki/Music" -img "/path/to/Kintoki/Pictures/testpattern.png" -vid_preset "/path/to/Kintoki/Documents/video_preset.json" -audio_ext '.wav' -video_ext '.flv'
```
