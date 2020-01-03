Configuration SqlUserPermission {
    param (
        [Parameter(Mandatory)]
        [hashtable[]]$Users
    )
    Import-DscResource -ModuleName SqlServerDsc

    foreach ($user in $Users) {
        if (-not $user.ContainsKey('Ensure'))
        {
            $user.Ensure = 'Present'
        }

        ## add login
        if($user.Name -like 'DOMAIN\*')
        {
            $addLogin = @{
                Ensure       = $user.Ensure
                Name         = $user.Name
                LoginType    = $user.Type
                ServerName   = $AllNodes.NodeName
                InstanceName = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]
                Disabled     = $user.Disabled, $false | Select-Object -First 1
            }

            $executionName = $addLogin.Name
            (Get-DscSplattedResource -ResourceName SqlServerLogin -ExecutionName $executionName -Properties $addLogin -NoInvoke).Invoke($addLogin)
        }
        else
        {
            #sqllogin
            # TODO: password dynamically and securely?
            $sqlCred = New-Object System.Management.Automation.PSCredential($user.Name, $('Password1234!' | ConvertTo-SecureString -asPlainText -Force))
            $addLogin = @{
                Ensure                         = $user.Ensure
                Name                           = $user.Name
                LoginType                      = $user.Type
                ServerName                     = $AllNodes.NodeName
                InstanceName                   = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]
                LoginCredential                = $sqlCred
                LoginMustChangePassword        = $false
                LoginPasswordExpirationEnabled = $false
                LoginPasswordPolicyEnforced    = $true
                Disabled                       = $user.Disabled, $false | Select-Object -First 1

            }

            $executionName = $addLogin.Name
            (Get-DscSplattedResource -ResourceName SqlServerLogin -ExecutionName $executionName -Properties $addLogin -NoInvoke).Invoke($addLogin)
        }

        ## add database users
        if ($user.ContainsKey('Database'))
        {
            foreach ($db in $user.Database)
            {
                $addUser = @{
                    Name         = $user.Name
                    Ensure       = $user.Ensure
                    ServerName   = $AllNodes.NodeName
                    InstanceName = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]
                    UserType     = 'Login'
                    LoginName    = $user.Name
                    DatabaseName = $db.Name
                }
                $executionName = ("{0}_{1}" -f $addUser.Name, $db.Name)
                (Get-DscSplattedResource -ResourceName SqlDatabaseUser -ExecutionName $executionName -Properties $addUser -NoInvoke).Invoke($addUser)

                $addToRole = @{
                    Ensure           = $user.Ensure
                    ServerName       = $AllNodes.NodeName
                    InstanceName     = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]
                    Name             = $db.Role
                    Database         = $db.Name
                    MembersToInclude = $user.Name
                }

                $executionName = ("{0}_{1}_{2}" -f $addUser.Name, $db.Name, $addToRole.Name)
                (Get-DscSplattedResource -ResourceName SqlDatabaseRole -ExecutionName $executionName -Properties $addToRole -NoInvoke).Invoke($addToRole)

            }
        }
    }

    foreach ($role in $Users.Server.Role | select -Unique)
    {
        $user = ($users | where {$_.server.role -eq $role}).name -join (',')
        $serverRole = @{
            Ensure           = 'Present'
            ServerName       = $AllNodes.NodeName
            InstanceName     = ($AllNodes.SqlServer.SqlInstanceName,'MSSQLSERVER' -ne $null)[0]
            ServerRoleName   = $role
            MembersToInclude = ($users | where {$_.Server.Role -eq $role -and ($_.Server.Ensure -eq 'Present' -or (!$_.Server.Ensure))}).Name
            MembersToExclude = ($users | where {$_.Server.Role -eq $role -and $_.Server.Ensure -eq 'Absent'}).Name
        }

        $executionName = ("{0}" -f  $role)
        (Get-DscSplattedResource -ResourceName SqlServerRole -ExecutionName $executionName -Properties $serverRole -NoInvoke).Invoke($serverRole)

    }
}