Configuration SqlDatabaseMail {
    Param(
        [Parameter()]
        [String]$AccountName = 'Primary Account',

        [Parameter()]
        [String]$ProfileName = 'Dbas',

        [Parameter()]
        [String]$DisplayName = 'Dbas',

        [Parameter(Mandatory)]
        [String]$EmailAddress,

        [Parameter(Mandatory)]
        [String]$ReplyToAddress,

        [Parameter(Mandatory)]
        [String]$MailServerName,

        [Parameter()]
        [String]$Description = 'Account Used by mail profiles'

    )
    Import-DscResource -ModuleName SqlServerDsc

    SqlServerDatabaseMail EnableDatabaseMail {
        Ensure               = 'Present'
        ServerName           = $AllNodes.NodeName
        InstanceName         = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]
        AccountName          = $AccountName
        ProfileName          = $ProfileName
        EmailAddress         = $EmailAddress
        ReplyToAddress       = $ReplyToAddress
        DisplayName          = $DisplayName
        MailServerName       = $MailServerName
        Description          = $Description
    }
}