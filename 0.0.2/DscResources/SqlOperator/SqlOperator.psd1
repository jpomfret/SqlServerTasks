@{
    RootModule           = 'SqlOperator.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = '1104a12a-c228-4bcb-aeb8-3c6e201116d9'

    Author               = 'NA'

    CompanyName          = 'NA'

    Copyright            = 'NA'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #    @{ ModuleName = 'ComputerManagementDsc'; ModuleVersion = '5.2.0.0' }
    #)

    DscResourcesToExport = @('SqlOperator')
}