@{
    RootModule           = 'SqlServerFileSystem.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = '8391f0b7-ee3c-4742-aae6-f8565b8a54c2'

    Author               = 'NA'

    CompanyName          = 'NA'

    Copyright            = 'NA'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #    @{ ModuleName = 'ComputerManagementDsc'; ModuleVersion = '5.2.0.0' }
    #)

    DscResourcesToExport = @('SqlServerFileSystem')
}