Configuration SqlServerDatabase {
    Param(
        [Parameter(Mandatory)]
        [hashtable[]]$Databases
    )
    Import-DscResource -ModuleName SqlServerDsc

    foreach ($db in $Databases) {

        $db.ServerName = $AllNodes.NodeName
        $db.InstanceName = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]

        if (-not $db.ContainsKey('Ensure'))
        {
            $db.Ensure = 'Present'
        }

        $owner = @{}
        if ($db.ContainsKey('Owner'))
        {
            $owner.ServerName = $db.ServerName
            $owner.InstanceName = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]
            $owner.Database = $db.Name
            $owner.Name     = $db.Owner

            $db.Remove('Owner')
        }

        $recoveryModel = @{}
        if ($db.ContainsKey('RecoveryModel'))
        {
            $recoveryModel.ServerName    = $db.ServerName
            $recoveryModel.InstanceName  = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]
            $recoveryModel.Name          = $db.Name
            $recoveryModel.RecoveryModel = $db.RecoveryModel

            $db.Remove('RecoveryModel')
        }


        # SqlDatabase
        $executionName = $db.Name.Replace(' ','_')
        (Get-DscSplattedResource -ResourceName SqlDatabase -ExecutionName $executionName -Properties $db -NoInvoke).Invoke($db)

        # SqlDatabaseOwner
        if($owner.Contains('Name')) {
            $executionName = "$($owner.Database.Replace(' ','_'))_Owner"
            (Get-DscSplattedResource -ResourceName SqlDatabaseOwner -ExecutionName $executionName -Properties $owner -NoInvoke).Invoke($owner)
        }

        # SqlDatabaseRecoveryModel
        if($recoveryModel.Contains('RecoveryModel')) {
            $executionName = "$($owner.Database.Replace(' ','_'))_RecoveryModel"
            (Get-DscSplattedResource -ResourceName SqlDatabaseRecoveryModel -ExecutionName $executionName -Properties $recoveryModel -NoInvoke).Invoke($recoveryModel)
        }
    }
}