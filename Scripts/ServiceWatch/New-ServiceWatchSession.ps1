Function New-ServiceWatchSession
{
<#
.Synopsis
   Returns a session object
.DESCRIPTION
   Uses a credential object for the login and returns 
   a session object to access the ServiceWatch web service
.EXAMPLE
   New-ServiceWatchSession -Credential (Get-Credential)

    Uri                      Session
    ---                      -------
    http://srvmgt025:8080    Microsoft.PowerShell.Commands.WebRequestSession
.EXAMPLE
   $Session = New-ServiceWatchSession -Credential $Credential -Computername 'services'

    $Session

    Uri                      Session
    ---                      -------
    http://services:8080     Microsoft.PowerShell.Commands.WebRequestSession
.EXAMPLE
   $Session = New-ServiceWatchSession -Credential $Credential -Computername 'services' -Port 443 -Protocol https

    $Session
    
    Uri                      Session
    ---                      -------
    https://services:443     Microsoft.PowerShell.Commands.WebRequestSession

#>
    [CmdletBinding(DefaultParametersetName='BaseUri')]
    Param(
        [Parameter(ParameterSetName='BaseUri')]
        [ValidateScript({($_ -as [System.URI]).AbsoluteURI -ne $null})]
        [Alias('URI')]
        [string]$BaseUri = 'http://srvmgt025.mydomain.internal:8080',

        [Parameter(ParameterSetName='HostnamePort',ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [Alias('Host','Hostname','CN')] 
        [string]$Computername = 'srvmgt025',

        [Parameter(ParameterSetName='HostnamePort')]
        [ValidateRange(1,65535)]
        [int]$Port = 8080,

        [Parameter(ParameterSetName='HostnamePort')]
        [ValidateSet('http','https')]
        [string]$Protocol = 'http',

        [Parameter(ParameterSetName='BaseUri')]
        [Parameter(ParameterSetName='HostnamePort')]
        [Parameter(Mandatory=$true)]
        $Credential
    )

    # Create login uri  
    if($PSCmdlet.ParameterSetName -eq 'HostnamePort')
    {
        $BaseUri = '{0}://{1}:{2}' -f $Protocol,$Computername,$port
    }
    $Uri = $BaseUri.trim('/') + '/orchestrator/j_spring_security_check'
 
    $credentialString = 'j_username={0}&j_password={1}' -f $Credential.UserName, $Credential.GetNetworkCredential().password

    $result = Invoke-WebRequest -uri $uri -Method POST -Body $credentialString -SessionVariable Session

    [pscustomobject]@{'BaseUri' = $BaseUri; 'Session' = $Session }

}