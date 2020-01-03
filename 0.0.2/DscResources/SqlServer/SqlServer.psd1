@{
    RootModule           = 'SqlServer.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = 'b97ab54f-bb65-4571-95da-b14fa73ecc32'

    Author               = 'NA'

    CompanyName          = 'NA'

    Copyright            = 'NA'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #    @{ ModuleName = 'ComputerManagementDsc'; ModuleVersion = '5.2.0.0' }
    #)

    DscResourcesToExport = @('SqlServer')
}