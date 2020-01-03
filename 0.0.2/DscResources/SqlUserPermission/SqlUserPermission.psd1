@{
    RootModule           = 'SqlUserPermission.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = '364161e7-c892-42f3-8acc-035bd693593b'

    Author               = 'NA'

    CompanyName          = 'NA'

    Copyright            = 'NA'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #    @{ ModuleName = 'ComputerManagementDsc'; ModuleVersion = '5.2.0.0' }
    #)

    DscResourcesToExport = @('SqlUserPermission')
}