@{
    RootModule           = 'SqlServerConfig.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = 'df989851-0ed0-4973-9a74-730771e61a87'

    Author               = 'NA'

    CompanyName          = 'NA'

    Copyright            = 'NA'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #    @{ ModuleName = 'ComputerManagementDsc'; ModuleVersion = '5.2.0.0' }
    #)

    DscResourcesToExport = @('SqlServerConfig')
}