Function Get-ServiceWatchVersion {
<#
.Synopsis
   Retrieves the current servicewatch version
.DESCRIPTION
   Retrieves the current servicewatch version by parsing the
   html contents of the login page since there doesn't seem
   to be an API for that.
.EXAMPLE
   Get-ServiceWatchVersion
.EXAMPLE
   Get-ServiceWatchVersion -BaseUri 'https://services.mydomain.internal'
.EXAMPLE
   Get-ServiceWatchVersion -Computername services
.EXAMPLE
   Get-ServiceWatchVersion -Computername services -Port 443 -Protocol https
#>
    [CmdletBinding(DefaultParametersetName='BaseUri')]
    Param(
    [Parameter(ParameterSetName='BaseUri',ValueFromPipelineByPropertyName=$true)]
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
    [string]$Protocol = 'http'

    )

    if($PSCmdlet.ParameterSetName -eq 'HostnamePort')
    {
        $BaseUri = '{0}://{1}:{2}' -f $Protocol,$Computername,$port
    }
    $Uri = $BaseUri.trim('/') + '/login.jsp'


    try {
        $request = Invoke-WebRequest -Uri $uri 
        [void]( $request.content -match '>Version\s*(?<version>[^\s]+)' )
        [pscustomobject]@{'Uri' = "$Uri"; 'Version' = $matches['version']}
    }

    catch {
        Write-Error -Message 'There was an error parsing the ServiceWatch login page.'
    }
}
