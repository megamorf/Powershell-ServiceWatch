Function Get-ServiceWatchStatus
{
<#
.Synopsis
   Returns the servicewatch server status
.DESCRIPTION
   Uses a session object for the login and returns the
   health status of the server.
.EXAMPLE
   $Session | Get-ServiceWatchStatus

    status tooltip
    ------ -------
    GREEN  All collectors are active.
#>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        $Session,

        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Alias('URI')]
        [string]$BaseUri = 'http://srvmgt025.mydomain.internal:8080'
    )
    
    $URI = $BaseUri + '/ws/systemHealth/systemHealthStatus'
    $response  = Invoke-restmethod -Uri $URI -WebSession $Session -Method Get

    $response.systemHealthDTO

    <#
    $error[0].ErrorDetails.Message
    Category   : InvalidOperation
    Activity   : Invoke-RestMethod
    Reason     : WebException
    TargetName : System.Net.HttpWebRequest
    TargetType : HttpWebRequest
    #>
}