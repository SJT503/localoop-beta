# 注册 Windows 每天 9:00 自动汇总反馈（可选）

```powershell
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File D:\Cursor\luna-app\scripts\collect-beta-feedback.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 9:00AM
Register-ScheduledTask -TaskName "LocaloopBetaFeedback" -Action $action -Trigger $trigger -Description "Daily Localoop beta feedback digest"
```

取消：

```powershell
Unregister-ScheduledTask -TaskName "LocaloopBetaFeedback" -Confirm:$false
```

摘要文件在：`docs\feedback\`
