Configuration SqlServerFileSystem {
    param (
        [Parameter(Mandatory)]
        [String]$Style
    )

    Import-DscResource -ModuleName PsDesiredStateConfiguration

    $envLetter = $AllNodes.NodeName[2]

    if($style -eq 'Regular') {
        $drive = "D"
    }
    elseif($style -eq "CDriveOnly") {
        $drive = "C"
    }

    File ("{0}_\SQLInstall{1}" -f $drive, $envLetter) {
        Type = 'Directory'
        DestinationPath = ("{0}:\SV{1}1SQL1" -f $drive, $envLetter)
        Ensure = 'Present'
    }
    #tempdb
    File ("{0}_\SQLData{1}" -f $drive, $envLetter) {
        Type = 'Directory'
        DestinationPath = ("{0}:\SQLData{1}" -f $drive, $envLetter)
        Ensure = 'Present'
    }
    File ("{0}_\SQL\Database Logs{1}" -f $drive, $envLetter) {
        Type = 'Directory'
        DestinationPath = ("{0}:\Database Logs{1}" -f $drive, $envLetter)
        Ensure = 'Present'
    }

    #databases
    File ("{0}_\SQLData{1}" -f $drive, $envLetter) {
        Type = 'Directory'
        DestinationPath = ("{0}:\SQLData{1}" -f $drive, $envLetter)
        Ensure = 'Present'
    }
    File ("{0}_\Database Logs{1}" -f $drive, $envLetter) {
        Type = 'Directory'
        DestinationPath = ("{0}:\Database Logs{1}" -f $drive, $envLetter)
        Ensure = 'Present'
    }

}