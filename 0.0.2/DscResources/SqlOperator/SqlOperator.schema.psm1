Configuration SqlOperator {
    Param(
        [Parameter(Mandatory)]
        [hashtable[]]$Operators
    )
    Import-DscResource -ModuleName SqlServerDsc

    foreach ($op in $Operators) {

        $op.ServerName = $AllNodes.NodeName
        $op.InstanceName = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]

        if (-not $op.ContainsKey('Ensure'))
        {
            $op.Ensure = 'Present'
        }

        if ($op.ContainsKey('Failsafe'))
        {
            $failsafe = @{
                ServerName         = $op.ServerName
                InstanceName       = $op.InstanceName
                Name               = $op.Name
                NotificationMethod = $op.Failsafe
            }
            $op.Remove('Failsafe')
            # SetSqlAgentFailsafe
            $executionName = ("Failsafe_{0}" -f $failsafe.Name.Replace(' ','_'))
            (Get-DscSplattedResource -ResourceName SqlAgentFailsafe -ExecutionName $executionName -Properties $failsafe -NoInvoke).Invoke($failsafe)

        }

        # SqlAgentOperator
        $executionName = $op.Name.Replace(' ','_')
        (Get-DscSplattedResource -ResourceName SqlAgentOperator -ExecutionName $executionName -Properties $op -NoInvoke).Invoke($op)

    }
}