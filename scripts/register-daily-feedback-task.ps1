$ErrorActionPreference = "Stop"

$script = "D:\Cursor\luna-app\scripts\collect-beta-feedback.ps1"
$taskName = "LocaloopDailyFeedbackDigest"

$action = New-ScheduledTaskAction `
  -Execute "powershell.exe" `
  -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$script`""

$trigger = New-ScheduledTaskTrigger -Daily -At 9:00AM

Register-ScheduledTask `
  -TaskName $taskName `
  -Action $action `
  -Trigger $trigger `
  -Description "Daily Localoop beta feedback digest to docs/feedback/" `
  -Force | Out-Null

Write-Host "Registered Windows task: $taskName (daily 09:00)" -ForegroundColor Green
Write-Host "Digest folder: D:\Cursor\luna-app\docs\feedback\" -ForegroundColor Green
