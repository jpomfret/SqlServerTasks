@{
    ModuleVersion        = '0.0.2'

    GUID                 = '5ac7d6e6-a6b5-473d-a97f-f6777524a6b3'

    Author               = 'Jess Pomfret'

    CompanyName          = 'NA'

    DscResourcesToExport = @('*')

    Description          = 'DSC composite resources for managing SQL Server'

    PrivateData          = @{

        PSData = @{

            Tags                       = @('DSC', 'Configuration', 'Composite', 'Resource', 'SQLServer')

            ExternalModuleDependencies = @('PSDesiredStateConfiguration')

        }
    }
}