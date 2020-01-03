@{
    RootModule           = 'SqlServerDatabase.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = 'f0c008b9-8e9a-441a-90ae-63811c068498'

    Author               = 'NA'

    CompanyName          = 'NA'

    Copyright            = 'NA'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #    @{ ModuleName = 'ComputerManagementDsc'; ModuleVersion = '5.2.0.0' }
    #)

    DscResourcesToExport = @('SqlServerDatabase')
}