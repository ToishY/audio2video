<#
    .SYNOPSIS 
      Batch convert audio files to video files
    .DESCRIPTION
      AUDIO2VIDEO makes it easy to batch convert your audio files to video files using FFMPEG. The user is asked to
      specify the directory with audio files, an image to display on top of the video and a JSON file containing settings for encoding the video.
      Optionally, the user can also specify the audio extension (default '.mp3') which he wants to convert and also the video extension (default '.mp4')
      for the output video file.
    .EXAMPLE
      >> Windows
      powershell -executionpolicy bypass -File .\audio2video.ps1 -dir "C:\Users\Kintoki\Music" -img "C:\Users\Kintoki\Pictures\testpattern.png" -vid_preset "C:\Users\Kintoki\Documents\video_preset.json"
      >> Linux
      pwsh audio2video.ps1 -dir "/path/to/Kintoki/Music" -img "/path/to/Kintoki/Pictures/testpattern.png" -vid_preset "/path/to/Kintoki/Documents/video_preset.json" -audio_ext '.wav' -video_ext '.flv'
    .NOTES
      This script was made with the intention to make it easier to upload music to YouTube (which only accepts video files).
    .CREDITS
      Made by:        ToishY
      Github:         https://github.com/ToishY/audio2video
      Last modified:  7-3-2019 03:03
#>

#------------- ARGUMENTS START ------------- #
param (
    [Parameter(Mandatory=$true)]
    [string]$dir, #input dir
    [Parameter(Mandatory=$true)]
    [string]$img, #placeholder image
    [Parameter(Mandatory=$true)]
    [string]$vid_preset, #json file with ffmpeg options
    [Parameter(Mandatory=$false)]
    [string]$audio_ext = ".mp3", #audio input extension
    [Parameter(Mandatory=$false)]
    [string]$video_ext = ".mp4" #video output extension
)
#------------- ARGUMENTS END ------------- #
$ErrorActionPreference = "Stop"
#------------- FUNCTIONS START -------------#
function QuoteString{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$myStr
    )

    return ('"{0}"' -f $myStr)
}

function Check-Presets {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$jsonFile
    )

    #convert json to object
    $jsonObject = Get-Content $jsonFile | ConvertFrom-Json

    #create ordered hashtable for easy access
    $htable = [ordered]@{}

    #put content into table
    $jsonObject.psobject.properties | Foreach { $htable[$_.Name] = $_.Value }

    #put non-empty values in list
    $v = New-Object System.Collections.Generic.List[System.Object]
    foreach ($h in $htable.GetEnumerator()){
        if($($h.Value)){
            $v.Add($($h.Name) + " " + $($h.Value))
        }
    }

    #join elements with space delimiter
    $res = $v -join ' '
    if($res -notlike "*-c:v*"){
        Write-Error "The JSON file was either empty or does not contain a video codec (-c:v). Please check again.";
    }
    return $res
}
#------------- FUNCTIONS END -------------#
#------------- START MAIN -------------#
$img = QuoteString -myStr $img

#Get files in directory with specified extension
$files = Get-ChildItem $dir | Where-Object {$_.Extension -eq $audio_ext} 
#Start batch loop
for ($i=0; $i -lt $files.Count; $i++) {
    $caudio = QuoteString -myStr ($files[$i].FullName)
    $outdir = QuoteString -myStr ($dir + ([IO.Path]::DirectorySeparatorChar) + ([System.IO.Path]::GetFileNameWithoutExtension($files[$i].FullName)) + $video_ext)

    #Check the ffmpeg preset settings from JSON
    $vidsettings = Check-Presets -jsonFile $vid_preset
    $ffcommand = "ffmpeg -loop 1 -y -i $img -i $caudio -shortest $vidsettings -c:a copy $outdir"

    #Execute
    Write-Host ">> Executing command:`n$ffcommand"
    Invoke-Expression $ffcommand
    Write-Host ">> Conversion OK; file saved in $outdir"
}
