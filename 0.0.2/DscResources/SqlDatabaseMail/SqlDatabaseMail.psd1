@{
    RootModule           = 'SqlDatabaseMail.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = '6e4d7b04-079f-4deb-b627-f194596e348d'

    Author               = 'NA'

    CompanyName          = 'NA'

    Copyright            = 'NA'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #    @{ ModuleName = 'ComputerManagementDsc'; ModuleVersion = '5.2.0.0' }
    #)

    DscResourcesToExport = @('SqlDatabaseMail')
}