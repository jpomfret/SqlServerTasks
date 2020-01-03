Configuration SqlServerConfig {
    Param(
        [Parameter()]
        [hashtable[]]$Configurations,

        [hashtable]$Memory
    )
    Import-DscResource -ModuleName SqlServerDsc

    foreach ($config in $Configurations) {
        $config.ServerName = $AllNodes.NodeName
        $config.InstanceName = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]

        $executionName = $config.OptionName.Replace(' ','_')
        (Get-DscSplattedResource -ResourceName SqlServerConfiguration -ExecutionName $executionName -Properties $config -NoInvoke).Invoke($config)
    }

    if($Memory) {
        $Memory.ServerName = $AllNodes.NodeName
        $Memory.InstanceName = $AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' | Select-Object -First 1

        $executionName = 'MemoryConfig'
        (Get-DscSplattedResource -ResourceName SqlServerMemory -ExecutionName $executionName -Properties $Memory -NoInvoke).Invoke($Memory)
    }
}

