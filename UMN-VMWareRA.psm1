###
# Copyright 2017 University of Minnesota, Office of Information Technology

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

#region Connect-VMWareRASession
function Connect-VMWareRASession {
<#
    .Synopsis
        Connect to VMWare Rest API Session
    
    .DESCRIPTION
        Connect to VMWare Rest API Session
    
    .PARAMETER vCenter
        FQDN of server to connect to        
    
    .PARAMETER vmwareCreds
        PS credential of user that has access
    
    .EXAMPLE
        $sessionID = Connect-VMWareRASession  -vCenter $vCenter -vmwareCreds $vmwareApiCred

    .OUTPUTS
        Function will return the a Session ID that will be used as an Auth token in other functions in this module

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [ValidateNotNullOrEmpty()]
        [string]$vCenter,

        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$vmwareCreds
    )

    Begin
    {
    }
    Process
    {
        ## Convert the Pscred into a basic auth hash
        $auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($vmwareCreds.UserName+':'+$vmwareCreds.GetNetworkCredential().Password))
        ## Construct url
        $url = "https://$vCenter/rest/com/vmware/cis/session"
        $return = Invoke-WebRequest -Uri $url -Method Post `
            -Headers @{'vmware-use-header-authn' = 'asdfypaf';'vmware-api-session-id'='null';'Accept' = 'application/json';'Authorization' = "Basic $auth"} `
            -ContentType 'application/json'
        if($return.StatusCode -ne 200){throw "Failed to login $return"}
        return ($return.Content | convertfrom-json).value
    }
    End
    {
    }
}
#endregion

#region Disconnect-VMWareRASession 
function Disconnect-VMWareRASession {
<#
    .Synopsis
       Disconnect VMWare Rest API Session

    .DESCRIPTION
        Disconnect VMWare Rest API Session

    .PARAMETER vCenter
        FQDN of server to connect to to end session

    .PARAMETER sessionID
        vmware-api-session-id to be closed
    
    .EXAMPLE
        Disconnect-VMWareRASession -vCenter $vCenter -sessionID $sessionID
        
    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [ValidateNotNullOrEmpty()]
        [string]$vCenter,
        
        [ValidateNotNullOrEmpty()]
        [string]$sessionID
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        $url = "https://$vCenter/rest/com/vmware/cis/session"
        $return = Invoke-WebRequest -Uri $url -Method Delete  `
            -Headers @{'vmware-api-session-id'=$sessionID;'Accept' = 'application/json'} `
            -ContentType 'application/json'
        if($return.StatusCode -ne 200){throw "Failed to logout"}
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVOpen
function Get-VMWareRAOpen {
<#
    .Synopsis
        This is an open function to get anything from https://$vCenter/apiexplorer/#/ that supports a Get method
    
    .DESCRIPTION
        This is an open function to get anything from https://$vCenter/apiexplorer/#/ that supports a Get method
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession
    
    .PARAMETER api
        specific api section to select from Currently cis, appliance, content, api, vcenter

    .PARAMETER section
        section to get information about

    .PARAMETER specific
        many of the section allow you to narrow down to a specific item in a section by some kind of ID, you do need to review the docs to find out what ID .. or jsut guess until you get it right

    
    .EXAMPLE
        
        
    .OUTPUTS
        

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Parameter(Mandatory)]
        [string]$api,

        [Parameter(Mandatory)]
        [string]$section,

        [string]$specific
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        if ($api -eq 'cis' -or $api -eq 'content' -or $api -eq 'vapi'){$url = "https://$vCenter/rest/com/vmware/$api/$section"} # some adds /com/vmware
        else{$url = "https://$vCenter/rest/$api/$section"}
        if ($specific){$url += "/$specific"}
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        return(($return.Content | ConvertFrom-Json).value)
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVM
function Get-VMWareRAVM {
<#
    .Synopsis
        Get details about vm or a list of vms from VMWare Rest API
    
    .DESCRIPTION
        Get details about vm or a list of vms from VMWare Rest API
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession
    
    .PARAMETER compter
        name of vm, or leave blank to get a full list
    
    .EXAMPLE
        
        
    .OUTPUTS
        

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [string]$computer
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        if($computer){$vmID = Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $computer}
        $url = "https://$vCenter/rest/vcenter/vm/$vmID"
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        return(($return.Content | ConvertFrom-Json).value)
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVMID
function Get-VMWareRAVMID {
<#
    .Synopsis
        Get vm ID for a specific vm from VMWare Rest API
    
    .DESCRIPTION
        Get vm ID for a specific vm from VMWare Rest API
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession
    
    .PARAMETER vmID
    
    .EXAMPLE
        
        
    .OUTPUTS
        vmware ID, needed for other functions in this module

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Parameter(Mandatory)]
        [string]$computer
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        $url = "https://$vCenter/rest/vcenter/vm?filter.names=$computer"
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        return(($return.Content | ConvertFrom-Json).value.vm)
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVMpower
function Get-VMWareRAVMpower {
<#
    .Synopsis
        Get vm ID for a specific vm from VMWare Rest API
    
    .DESCRIPTION
        Get vm ID for a specific vm from VMWare Rest API
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession
    
    .PARAMETER computer
    
    .EXAMPLE
        
        
    .OUTPUTS
        vmware ID, needed for other functions in this module

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Parameter(Mandatory)]
        [string]$computer
    )

    Begin
    {
    }
    Process
    {
        $vmID = Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $computer
        ## Construct url
        $url = "https://$vCenter/rest/vcenter/vm/$vmID/power"
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        return(($return.Content | ConvertFrom-Json).value.state)
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVTag
function Get-VMWareRATag {
<#
    .Synopsis
        Get-vmware Tag via Rest API
    
    .DESCRIPTION
        Get-vmware Tag via Rest API
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER name

    
    .EXAMPLE
        
        
    .OUTPUTS
        

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [string]$name
    )

    Begin
    {
    }
    Process
    {
        ## There isn't 
        $url = "https://$vCenter/rest/com/vmware/cis/tagging/tag"
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        $tags = ($return.Content | ConvertFrom-Json).value
        if ($name){$tags | ForEach-Object {if (((Get-VMWareRATagByID -vCenter $vCenter -sessionID $sessionID -tagID $_).Name) -eq $name){return (Get-VMWareRATagByID -vCenter $vCenter -sessionID $sessionID -tagID $_);break}}}
        else{$tags | ForEach-Object {return (Get-VMWareRATagByID -vCenter $vCenter -sessionID $sessionID -tagID $_)}}
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVTagByID
function Get-VMWareRATagByID {
<#
    .Synopsis
        Get-vmware Tag by ID via Rest API
    
    .DESCRIPTION
        Get-vmware Tag by ID via Rest API
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER tagID

    
    .EXAMPLE
        
        
    .OUTPUTS
        

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Parameter(Mandatory)]
        [string]$tagID
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        $url = "https://$vCenter/rest/com/vmware/cis/tagging/tag/id:$tagID"
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        return(($return.Content | ConvertFrom-Json).value)
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVMTagsAttachedToObject
function Get-VMWareRAVMTagsAttachedToObject {
<#
    .Synopsis
        Get list of objects a tag is attached to an object
    
    .DESCRIPTION
        Get list of objects a tag is attached to an object
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession
    
    .PARAMETER type
        type of object, for example 'virtualMachine'

    .PARAMETER id
        id of object, for example if its a vm, use Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $computer to get its id
    
    .EXAMPLE
        
        
    .OUTPUTS
        JSON data of ids/types

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Parameter(Mandatory)]
        [string]$id,

        [Parameter(Mandatory)]
        [string]$type
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        $url = "https://$vCenter/rest/com/vmware/cis/tagging/tag-association?~action=list-attached-tags"
        $json = @{"object_id" = @{"type"=$type;"id"=$id}} | ConvertTo-Json -Depth 3
        $return = Invoke-WebRequest -Uri $url -Method Post -Body $json -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        ($return.Content | ConvertFrom-Json).value | ForEach-Object {Get-VMWareRATagByID -vCenter $vCenter -sessionID $sessionID -tagID $_}
        #return(($return.Content | ConvertFrom-Json).value)
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVMTagAttachList
function Get-VMWareRAVMTagAttachList {
<#
    .Synopsis
        Get list of objects a tag is attached to
    
    .DESCRIPTION
        Get list of objects a tag is attached to
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession
    
    .PARAMETER tagID
    
    .EXAMPLE
        
        
    .OUTPUTS
        JSON data of ids/types

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Parameter(Mandatory)]
        [string]$tagID
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        $url = "https://$vCenter/rest/com/vmware/cis/tagging/tag-association/id:$tagID`?~action=list-attached-objects"
        $return = Invoke-WebRequest -Uri $url -Method Post -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        return(($return.Content | ConvertFrom-Json).value)
    }
    End
    {
    }
}
#endregion

#region New-VMWareRAVM
function New-VMWareRAVM {
<#
    .Synopsis
        Build new VM via VMWare Rest API
    
    .DESCRIPTION
        Build new VM via VMWare Rest API
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession
    
    .EXAMPLE
        
        
    .OUTPUTS
        

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Parameter(Mandatory)]
        [string]$computer,

        [int]$memoryGB = 4,

        [int]$NumCpu = 2,

        [int]$corePerSocket = 1,
        
        #[string]$notes,

        [Parameter(Mandatory)]
        [int]$diskSizeGB,

        [int]$secondDiskSizeGB,

        [Parameter(Mandatory)]
        [string]$network,

        #[string[]]$tags, # api has not supported this yet

        [string]$isoPath,

        [Parameter(Mandatory)]
        [string]$folder,

        [Parameter(Mandatory)]
        [string]$cluster,

        [Parameter(Mandatory)]
        [string]$datastore,

        [string]$bootSource = 'CDROM',

        [string]$hardwareVersion = 'VMX_11',

        [string]$guestOS = 'WINDOWS_9_SERVER_64'
    )

    Begin
    {
    }
    Process
    {
        ## Validate that the vm to be built doesn't already exists.  This is a littel awkward.  If the vm exists, throw an error.  If it doesn't Get-VM actual throws an error, so catch it but move on because that's the desired result
        if ((Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $computer) -ne $null){Throw "Vm with name $computer already exists $_.Exception.Message"}

        ## Construct url
        $url = "https://$vCenter/rest/vcenter/vm"
        # construct hash table for JSON
        $spec = @{'placement' = @{'cluster'= $cluster;'folder'= $folder;'datastore'= $datastore};
          'name'= $computer;
          'boot'= @{'type'= $bootSource};#'efi_legacy_boot'= $true;'delay'= 0;
          'hardware_version'= $hardwareVersion;
          'guest_OS'= $guestOS;          
          "nics"= @(@{"backing"= @{"type"= "DISTRIBUTED_PORTGROUP";"network"= $network};"allow_guest_control"= $true;"mac_type"= "GENERATED";"start_connected"= $true;"type"= "VMXNET3"});
          "memory"= @{"hot_add_enabled"= $true;"size_MiB"= (1024 * $memoryGB)};
          "cpu"= @{"count"= $NumCpu;"hot_add_enabled"= $true;"hot_remove_enabled"= $true;"cores_per_socket"= $corePerSocket};          
        } # close 'spec'
        if ($isoPath){$spec["cdroms"]= [array]@(@{"backing"= @{"iso_file"= $isoPath;"type"= "ISO_FILE"};"start_connected"= $true;"allow_guest_control"= $true;"type"= "SATA"});}
        $spec["disks"] = [System.Collections.ArrayList]@(@{"new_vmdk"= @{"capacity"= ([math]::pow( 1024, 3 ) * $diskSizeGB);"name"= "disk1"};"type"= "SCSI"})
        if ($secondDiskSizeGB){$null = $spec["disks"].add(@{"new_vmdk"= @{"capacity"= ([math]::pow( 1024, 3 ) * $secondDiskSizeGB);"name"= "disk2"};"type"= "SCSI"})}

        # construct json
        $json = @{'spec' = $spec} | ConvertTo-Json -Depth 5
        return (((Invoke-WebRequest -Uri $url -Method Post -Headers @{'vmware-api-session-id'=$sessionID;'Accept' = 'application/json'} -ContentType 'application/json' -Body $json).Content | convertfrom-json).value)
    }
    End
    {
    }
}
#endregion

#region Remove-VMWareRAVM
function Remove-VMWareRAVM {
<#
    .Synopsis
        Remove vm from VMWare Rest API
    
    .DESCRIPTION
        Remove vm from VMWare Rest API
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession
    
    .PARAMETER computer
        name of vm

    .EXAMPLE
        
        
    .OUTPUTS
        Returns $true if vm is remove.  Throws error if not

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Parameter(Mandatory)]
        [string]$computer
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        $vmID = Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $computer
        $url = "https://$vCenter/rest/vcenter/vm/$vmID"
        $return = Invoke-WebRequest -Uri $url -Method Delete -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        if ($return.StatusCode -eq 200){return($true)}
        else{Throw "Failed to remove $computer $return"}
    }
    End
    {
    }
}
#endregion

#region Set-VMWareRAVMpower
function Set-VMWareRAVMpower {
<#
    .Synopsis
        Get vm ID for a specific vm from VMWare Rest API
    
    .DESCRIPTION
        Get vm ID for a specific vm from VMWare Rest API
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession
    
    .PARAMETER computer
    
    .EXAMPLE
        
        
    .OUTPUTS
        vmware ID, needed for other functions in this module

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Parameter(Mandatory)]
        [string]$computer,

        [ValidateSet('reset','start','stop','suspend')]
        [string]$state
    )

    Begin
    {
    }
    Process
    {
        $vmID = Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $computer
        ## Construct url
        $url = "https://$vCenter/rest/vcenter/vm/$vmID/power/$state"
        $return = Invoke-WebRequest -Uri $url -Method Post -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        return($return.StatusDescription)
    }
    End
    {
    }
}
#endregion

#region Set-VMWareRAVMTagAttachedToObject
function Set-VMWareRAVMTagAttachedToObject {
<#
    .Synopsis
        Add tags to an object
    
    .DESCRIPTION
        Add tags to an object
    
    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession

    .PARAMETER tagID
        ID of tag to be added
    
    .PARAMETER type
        type of object, for example 'virtualMachine'

    .PARAMETER id
        id of object, for example if its a vm, use Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $computer to get its id
    
    .EXAMPLE
        
        
    .OUTPUTS
        JSON data of ids/types

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Parameter(Mandatory)]
        [string]$tagid,
        
        [Parameter(Mandatory)]
        [string]$id,

        [Parameter(Mandatory)]
        [string]$type
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        $url = "https://$vCenter/rest/com/vmware/cis/tagging/tag-association/id:$tagId`?~action=attach"
        $json = @{"object_id" = @{"type"=$type;"id"=$id}} | ConvertTo-Json -Depth 3
        $return = Invoke-WebRequest -Uri $url -Method Post -Body $json -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json'
        if ($return.StatusCode -eq 200){return $true}
    }
    End
    {
    }
}
#endregion

#region Test-VMWareRASession
function Test-VMWareRASession {
<#
    .Synopsis
        Test for valid and active VMWare Rest API Session
    
    .DESCRIPTION
        Test for valide and active VMWare Rest API Session
    
    .PARAMETER vCenter
        FQDN of server to test connection against

    .PARAMETER sessionID
        vmware-api-session-id to be tested
    
    .EXAMPLE
        Test-VMWareRASession -vCenter $vCenter -sessionID $sessionID
        
    .OUTPUTS
        If there is a valid and active connection, the funciton will return details about the connection.  If not, the function will return $false

    .Notes
        Author: Travis Sobeck
#>
    [CmdletBinding()]
    Param
    (
        [ValidateNotNullOrEmpty()]
        [string]$vCenter,
        
        [ValidateNotNullOrEmpty()]
        [string]$sessionID
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        $url = "https://$vCenter/rest/com/vmware/cis/session?~action=get"
        try{
            return ((Invoke-WebRequest -Uri $url -Method Post -Headers @{'vmware-api-session-id'=$sessionID;'Accept' = 'application/json'} -ContentType 'application/json').content | convertfrom-json).value
        }
        catch{return $false}
    }
    End
    {
    }
}
#endregion
