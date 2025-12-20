Set WshShell = CreateObject("WScript.Shell")
backupPath = WshShell.ExpandEnvironmentStrings("%USERPROFILE%\Desktop\Server-Backup.bat")
WshShell.Run """" & backupPath & """", 7, False
