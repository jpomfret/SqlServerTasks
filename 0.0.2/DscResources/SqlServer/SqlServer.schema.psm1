Configuration SqlServer {
    Param(
        [Parameter(Mandatory)]
        [ValidateSet('Regular','CDriveOnly')]
        [String]$DiskStyle,

        [Parameter(Mandatory)]
        [ValidateSet('Baseline')]
        [string]$Type,

        [Parameter(Mandatory)]
        [string]$SqlVersion,

        [Parameter(Mandatory)]
        [string]$SqlEdition,

        [Parameter()]
        [string[]]$InstallFeatures,

        [Parameter()]
        [string]$SqlInstanceName = 'MSSQLSERVER'

    )
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName SqlServerDsc
    Import-DscResource -ModuleName NetworkingDsc


    $envLetter = $AllNodes.NodeName[2]

    # These are required but not used since we are using MSAs
    $SQLSvcAccount = New-Object System.Management.Automation.PSCredential(('DOM_WFLD\{0}I1$' -f ($AllNodes.NodeName).Substring(2)), $('mypassword' | ConvertTo-SecureString -asPlainText -Force))
    $AgtSvcAccount = New-Object System.Management.Automation.PSCredential(('DOM_WFLD\{0}A1$' -f ($AllNodes.NodeName).Substring(2)), $('mypassword' | ConvertTo-SecureString -asPlainText -Force))

    $SAPwd = New-Object System.Management.Automation.PSCredential('sa', $('Password1234!' | ConvertTo-SecureString -asPlainText -Force))

    SqlSetup Install_SQL
    {
        SourcePath           = ("\\svpfile01\NetworkSoftware\MSSqlServer\SPADE\SQL{0}\{1}\" -f $SqlVersion, $SqlEdition)
        UpdateEnabled        = $true
        UpdateSource         = ("\\svpfile01\NetworkSoftware\MSSqlServer\SPADE\SQL{0}\Updates\" -f $SqlVersion)
        InstanceName         = $SqlInstanceName
        Features             = ($InstallFeatures -join ',')
        SQLSvcAccount        = $SQLSvcAccount
        AgtSvcAccount        = $AgtSvcAccount

        SQLSysAdminAccounts  = 'DOM_WFLD\RL-SQLADMIN'
        InstallSQLDataDir    = ("{0}:\SQLInstall{1}" -f $drive, $envLetter)
        SQLUserDBDir         = ("{0}:\SQLData{1}" -f $drive, $envLetter)
        SQLUserDBLogDir      = ("{0}:\Database Logs{1}" -f $drive, $envLetter)
        SQLTempDBDir         = ("{0}:\SQLData{1}" -f $drive, $envLetter)
        SQLTempDBLogDir      = ("{0}:\Database Logs{1}" -f $drive, $envLetter)

        SecurityMode         = 'SQL'
        SAPwd                = $SAPwd
    }

    SqlServerNetwork ChangeTcpIpOnDefaultInstance
    {
        DependsOn            = '[SqlSetup]Install_SQL'
        InstanceName         = $SqlInstanceName
        ProtocolName         = 'Tcp'
        IsEnabled            = $true
        TCPPort              = '1433'
        RestartService       = $true
    }

    SqlWindowsFirewall AllowFirewall {
        DependsOn           = '[SqlSetup]Install_SQL'
        InstanceName        = $SqlInstanceName
        Features            = ($InstallFeatures -join ',')
        SourcePath          = ("\\InstallFiles\SQL{0}\developer\" -f $SqlVersion)
    }

}