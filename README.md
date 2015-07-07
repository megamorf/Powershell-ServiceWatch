# Powershell-ServiceWatch
Powershell functions for ServiceWatch (from ServiceNow) related tasks

The ServiceWatch Powershell module currently contains `4` functions:

```powershell
PS C:\> Import-Module ServiceWatch
PS C:\> Get-Command -Module ServiceWatch

CommandType     Name                                               ModuleName
-----------     ----                                               ----------
Function        Export-ServiceWatchKnowledgebase                   ServiceWatch
Function        Get-ServiceWatchStatus                             ServiceWatch
Function        Get-ServiceWatchVersion                            ServiceWatch
Function        New-ServiceWatchSession                            ServiceWatch
```

Get-ServiceWatchVersion is the only function that can be run without having to create a session with `New-ServiceWatchSession` first.

Functions can be runs as follows:

```powershell
$session = New-ServiceWatchSession -cn srvmgt025
$session | Get-ServiceWatchVersion
$session | Get-ServiceWatchStatus 
$session | Export-ServiceWatchKnowledgebase -Destination D:\exports\
```
