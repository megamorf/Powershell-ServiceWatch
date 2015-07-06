Function Export-ServiceWatchKnowledgebase
{
<#
.Synopsis
   Exports all KB items including the default ones
.DESCRIPTION
   Uses a session object for the login and exports
   all items to a location that the ServiceWatch server
   service account can access.
   
   The default is local system so the server cannot 
   export to network share.
.EXAMPLE
   $Session | Export-ServiceWatchKnowledgebase

    Destination                ExportSuccessful Response
    -----------                ---------------- --------
    C:\temp\exports\2015-07-06             True <html>...
.EXAMPLE
   $Session | Export-ServiceWatchKnowledgebase -Destination D:\exports

    Destination                ExportSuccessful Response
    -----------                ---------------- --------
    D:\Exports                             True <html>...
#>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        $Session,

        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Alias('URI')]
        [string]$BaseUri = 'http://srvmgt025.mydomain.internal:8080',

        [string]
        $Destination = $( 'C:\temp\exports\' + (Get-Date -Format 'yyyy-MM-dd') )
    )
    
    ## GET CSRF Token ##
    $URI = $BaseUri + '/jmx?inspect_mbean=Neebula:service=KnowledgeBase#exportKb'
    $Response = Invoke-WebRequest -WebSession $Session  -Method Get -Uri $URI
    
    # the page layout forces us to find the token this way
    $element = $Response.ParsedHtml.getElementsByName('invoke_op') | Where-Object value -eq exportKb    
    $CsrfToken = ($element.parentElement | Where-Object name -eq 'csrf').value

    ## Build Request Body ##
    $URI = $BaseUri + '/jmx'
    $Body = "invoke_mbean=Neebula:service=KnowledgeBase&invoke_op=exportKb&csrf=$CsrfToken&path=$Destination"

    $Response2 =  Invoke-RestMethod -WebSession $Session -Method Post -Uri $URI -Body $Body

    # a bit hacky, I know
    $Result = [pscustomobject]@{ 
        'Destination' = $Destination; 
        'ExportSuccessful' = $false ; 
        'Response' = $Response2
    }  

    if( $Response2.Contains('<pre>Exported:') ) { $Result.ExportSuccessful = $true }

    $Result
}