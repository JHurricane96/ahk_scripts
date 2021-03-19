#UseHook
#SingleInstance Force ; The script will Reload if launched while already running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
#KeyHistory 0 ; Ensures user privacy when debugging is not needed
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability

DetectHiddenWindows, On  ; Allows a script's hidden main window to be detected.
SetTitleMatchMode, 2  ; Avoids the need to specify the full path of the file below.

setTimer, windowWatch, 500

windowWatch:
  if WinActive("Remote Desktop ahk_class ApplicationFrameWindow") {
    if (!active) {
      active := true
      ; Suspend desktop switcher
      PostMessage, 0x111, 65404,,, desktop_switcher.ahk ahk_class AutoHotkey
      suspend on
      Sleep 50
      suspend off
    }
  } else if active {
    active := false
    ; Resume desktop switcher
    PostMessage, 0x111, 65404,,, desktop_switcher.ahk ahk_class AutoHotkey
  }
return


; Be careful if using a hotkey with an Alt or Win modifier. The modifier's
; keyup event may trigger a system action. AHK is supposed to work around this,
; but it doesn't seem to work in this case.
; See http://www.autohotkey.com/forum/topic22378.html for a related discussion.
#IfWinActive, Remote Desktop ahk_class ApplicationFrameWindow
^CapsLock::
  ; MsgBox
  ; Need a short sleep here for focus to restore properly.
  ; Sleep 50
  MouseGetPos x, y
  MouseMove 1700, 0
  Sleep 300
  Click 1800 0
  MouseMove x, y
  ; PostMessage, 0x112, 0xF020,,, Remote Desktop ahk_class ApplicationFrameWindow
  ; WinClose Remote Desktop ahk_class ApplicationFrameWindow
return
#IfWinActive