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
            -ContentType 'application/json' -UseBasicParsing
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
            -ContentType 'application/json' -UseBasicParsing
        if($return.StatusCode -ne 200){throw "Failed to logout"}
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRACluster
function Get-VMWareRACluster {
    <#
        .Synopsis
            Get details about cluster by name or list of all clusters from the VMWare Rest API

        .DESCRIPTION
            Get details about cluster by name or list of all clusters from the VMWare Rest API

        .PARAMETER vCenter
            FQDN of server to connect to

        .PARAMETER sessionID
            vmware-api-session-id from Connect-vmwwarerasession

        .PARAMETER name
            name of the cluster, case sensitivity required 

        .OUTPUTS
            Cluster objects, which includes the name, ID, and HA/DRS enablement settings.
        .Notes
            Author: Aaron Smith
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
        ## Construct url
        $url = "https://$vCenter/rest/vcenter/cluster"

        if ($name)
        {
            $url += "?filter.names=$name"
        }

        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
        return(($return.Content | ConvertFrom-Json).value)
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAHost
function Get-VMWareRAHost {
    <#
        .Synopsis
            Get details about host by name or list of all hosts from the VMWare Rest API

        .DESCRIPTION
            Get details about host by name or list of all hosts from the VMWare Rest API

        .PARAMETER vCenter
            FQDN of server to connect to

        .PARAMETER sessionID
            vmware-api-session-id from Connect-vmwwarerasession

        .PARAMETER name
            name of the host, case sensitivity required

        .PARAMETER hostID
            ID of the host

        .PARAMETER cluster
            name of the cluster to obtain host list from, case sensitivity required

        .PARAMETER clusterID
            ID of the cluster to obtain host list from. Overrides cluster parameter if also specified.

        .OUTPUTS   
            Host objects, which includes the name, ID, connection and power status

        .Notes
            Author: Aaron Smith
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [string]$name,

        [string]$hostID,

        [string]$cluster,

        [string]$clusterID
    )

    Begin
    {
    }
    Process
    {
        if ($cluster)
        {
            if (-not ($clusterID = (Get-VMWareRACluster -vCenter $vCenter -sessionID $sessionID -name $cluster).cluster))
            {
                throw "Cluster $cluster not found by name"
            }
        }

        ## Construct url
        $url = "https://$vCenter/rest/vcenter/host"

        [System.Collections.ArrayList] $urlFilters = New-Object System.Collections.ArrayList

        if ($name)
        {
            [void] $urlFilters.add("filter.names=$name")
        }

        if ($hostID)
        {
            [void] $urlFilters.add("filter.hosts=$hostID")
        }

        if ($clusterID)
        {
            [void] $urlFilters.add("filter.clusters=$clusterID")
        }

        if ($urlFilters.Count -gt 0)
        {
            $url += "?"

            foreach ($urlFilterItem in $urlFilters)
            {
                $url += $urlFilterItem + "&"
            }
        }

        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
        return(($return.Content | ConvertFrom-Json).value)
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRANetworks
function Get-VMWareRANetworks {
    <#
        .Synopsis
            Get a list of Networks
        
        .DESCRIPTION
            Get a list of Networks
        
        .PARAMETER vCenter
            FQDN of server to connect to

        .PARAMETER sessionID
            vmware-api-session-id from Connect-vmwwarerasession
        
        .PARAMETER filter
            Filster string to narrow down list of networks
        
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

        [string]$filter
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        $url = "https://$vCenter/rest/vcenter/network"
        $return = ((Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing).Content | ConvertFrom-Json).value
        $_.name
        if ($filter){$return = $return | Where-Object {$_.name -match $filter}}
        return $return
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
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID } -ContentType 'application/json' -UseBasicParsing
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
            Get VM objects by name from the VMWare Rest API.  Supports wildcards and handles case sensitivity issues.

        .DESCRIPTION
            Get details about vm or a list of vms from VMWare Rest API.  Supports wildcards and handles case sensitivity issues.
            Able to return more than 1000 objects by working around the current limitation of the REST APIs.

        .PARAMETER vCenter
            FQDN of server to connect to

        .PARAMETER sessionID
            vmware-api-session-id from Connect-vmwwarerasession

        .PARAMETER name
            name of the VM, case sensitivity not required. Supports wildcard character *.

        .PARAMETER computer
            Alias to name

        .PARAMETER vmID
            ID of vm, or leave this and vmID blank to get a full list

        .PARAMETER host
            name of host to return list of VMs from, case sensitivity required

        .PARAMETER hostID
            ID of host to return list of VMs from. Overrides host parameter if also specified.

        .PARAMETER cluster
            Name of cluster to return list of VMs from (able to return more then 1000 VMs), case sensitivity required.

        .PARAMETER clusterID
            ID of cluster to return list of VMs from (able to return more then 1000 VMs.) Overrides cluster parameter if specified.

        .PARAMETER detailed
            Add this switch to output detailed contents of the VM

        .OUTPUTS
            List of VM objects based on parameters specified.

        .Notes
            Author: Aaron Smith, Travis Sobeck
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$vCenter,
        
        [Parameter(Mandatory)]
        [string]$sessionID,

        [Alias('computer')]
        [string]$name,

        [string]$vmID,

        [string]$hostName,

        [string]$hostID,

        [string]$cluster,

        [string]$clusterID,

        [switch]$detailed
    )

    Begin
    {
    }
    Process
    {
        if($name)
        {
            if(($vmID = Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $name))
            {
                $url = "https://$vCenter/rest/vcenter/vm/$vmID"
                $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
                return(($return.Content | ConvertFrom-Json).value)        
            }
        }
        if($vmID)
        {
            $url = "https://$vCenter/rest/vcenter/vm/$vmID"
            $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
            return(($return.Content | ConvertFrom-Json).value)
        }
        Write-Verbose "No exact match, checking for other matches"
        if ($cluster)
        {
            if (-not ($clusterID = (Get-VMWareRACluster -vCenter $vCenter -sessionID $sessionID -name $cluster).cluster))
            {
                throw "Cluster $cluster not found by name"
            }
        }

        if ($hostName)
        {
            if (-not ($hostID = (Get-VMWareRAHost -vCenter $vCenter -sessionID $sessionID -name $hostName).host))
            {
                throw "VMHost $hostName not found by name"
            }
        }

        ## List of VMs compiled from queries for return
        [System.Collections.ArrayList] $vmList = New-Object System.Collections.ArrayList

        ## Construct url
        $url = "https://$vCenter/rest/vcenter/vm"

        [System.Collections.ArrayList] $urlFilters = New-Object System.Collections.ArrayList

        if ($hostID)
        {
            [void] $urlFilters.add("filter.hosts=$hostID")
        }

        if ($urlFilters.Count -gt 0)
        {
            $url += "?"

            foreach ($urlFilterItem in $urlFilters)
            {
                $url += $urlFilterItem + "&"
            }

            $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing

            foreach ($returnItem in (($return.Content | ConvertFrom-Json).value))
            {
                [void] $vmList.Add($returnItem)
            }
        }
        else
        {
            [Array] $hostList = $null

            if ($clusterID)
            {
                $hostList = Get-VMWareRAHost -vCenter $vCenter -sessionID $sessionID -clusterID $clusterID
            }
            else
            {
                $hostList = Get-VMWareRAHost -vCenter $vCenter -sessionID $sessionID
            }

            foreach ($hostItem in $hostList)
            {
                $hostID = $hostItem.host
                $url = "https://$vCenter/rest/vcenter/vm?filter.hosts=$hostID"

                $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
                
                foreach ($returnItem in (($return.Content | ConvertFrom-Json).value))
                {
                    [void] $vmList.Add($returnItem)
                }
            }
        }

        [System.Collections.ArrayList] $detailedVMList = New-Object System.Collections.ArrayList
        if ($name)
        {
            foreach ($vmItem in $vmList)
            {
                if ($vmItem.name -like "$name")
                {                    
                    if ($detailed){
                        $obj = Get-VMWareRAVM -vCenter $vcenter -sessionID $sessionID -vmID $vmItem.vm
                        Add-Member -InputObject $obj -MemberType NoteProperty -Name 'id' -Value $vmItem.vm
                        [void] $detailedVMList.add($obj)
                    }
                    else{[void] $detailedVMList.add($vmItem)}
                }
            }
            return $detailedVMList
        }
        else
        {
            if ($detailed){
                foreach ($vmItem in $vmList)
                {
                    $obj = Get-VMWareRAVM -vCenter $vcenter -sessionID $sessionID -vmID $vmItem.vm
                    Add-Member -InputObject $obj -MemberType NoteProperty -Name 'id' -Value $vmItem.vm
                    [void] $detailedVMList.add($obj)
                }
                return $detailedVMList
            }
            return $vmList
        }
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
        $return = ((Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing).Content | ConvertFrom-Json).value.vm
        if($return.count -gt 1){Throw "Retuned more than one result $return"}
        return $return
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVMMac
function Get-VMWareRAVMMac {
    <#
        .Synopsis
            Get the Mac address for a vm of a connected NIC

        .DESCRIPTION
            Get the Mac address for a vm, look at  GET /vcenter/vm/{vm}/hardware/ethernet for a more complete look at nics

        .PARAMETER vCenter
            FQDN of server to connect to

        .PARAMETER sessionID
            vmware-api-session-id from Connect-vmwwarerasession

        .PARAMETER compter
            name of vm, or leave this and vmID blank to get a full list

        .PARAMETER vmID
            ID of vm, or leave this and vmID blank to get a full list

        .PARAMETER nicLabel
            label of target nic, useful with multiple nics

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

        [Parameter(Mandatory,ParameterSetName='vmName')]
        [string]$computer,

        [Parameter(Mandatory,ParameterSetName='vmID')]
        [string]$vmID,

        [string]$nicLabel
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        if($computer){$nics = (Get-VMWareRAVM -vCenter $vCenter -sessionID $sessionID -computer $computer).nics.value}
        else{$nics = (Get-VMWareRAVM -vCenter $vCenter -sessionID $sessionID -vmID $vmID).nics.value}
        if ($nicLabel){$nics = $nics | Where-Object {$_.label -eq $nicLabel}}
        if (($nics | Where-Object{$_.state -eq 'CONNECTED'}).count -gt 1){Throw "Multiple nics specify nic label"}
        if (-not $nics){Throw "No connected nics"}
        return $nics.mac_address
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
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
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

        [string]$name,

        [string]$category
    )

    Begin
    {
    }
    Process
    {
        ## 
        [System.Collections.ArrayList]$tagList = @() 
        $url = "https://$vCenter/rest/com/vmware/cis/tagging/tag"
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
        $tags = ($return.Content | ConvertFrom-Json).value
        if ($name)
        {
            $tags | ForEach-Object {
                $tag = Get-VMWareRATagByID -vCenter $vCenter -sessionID $sessionID -tagID $_
                if ($tag.name -eq $name){$null = $tagList.Add($tag)}
            }
            if ($tagList.Count -eq 0){throw "unable to find tag named $name"}
            elseif ($category)
            {
                $catID = (Get-VMWareRATagCategory -vCenter $vCenter -sessionID $sessionID -category $category).ID
                $tagList | Where-Object {$_.category_id -eq $catID}
            }
            elseif($tagList.Count -eq 1){return $tagList}
            else{throw "Multiple tags $name found, specify a category"}
        }
        else{$tags | ForEach-Object {return (Get-VMWareRATagByID -vCenter $vCenter -sessionID $sessionID -tagID $_)}}
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVTagCategory
function Get-VMWareRATagCategory {
<#
    .Synopsis
        Get-vmware Tag Category via Rest API
    
    .DESCRIPTION
        Get-vmware Tag Category via Rest API
    
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

        [string]$category
    )

    Begin
    {
    }
    Process
    {
        ## There isn't 
        $url = "https://$vCenter/rest/com/vmware/cis/tagging/category"
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
        $categorys = ($return.Content | ConvertFrom-Json).value
        $categorys
        if ($category){$categorys | ForEach-Object {if (((Get-VMWareRATagCategoryByID -vCenter $vCenter -sessionID $sessionID -categoryID $_).Name) -eq $category){return (Get-VMWareRATagCategoryByID -vCenter $vCenter -sessionID $sessionID -categoryID $_);break}}}
        else{$categorys | ForEach-Object {return (Get-VMWareRATagCategoryByID -vCenter $vCenter -sessionID $sessionID -categoryID $_)}}
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
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
        return(($return.Content | ConvertFrom-Json).value)
    }
    End
    {
    }
}
#endregion

#region Get-VMWareRAVTagCategoryByID
function Get-VMWareRATagCategoryByID {
<#
    .Synopsis
        Get-vmware Tag Category by ID via Rest API
    
    .DESCRIPTION
        Get-vmware Tag Category by ID via Rest API
    
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
        [string]$categoryID
    )

    Begin
    {
    }
    Process
    {
        ## Construct url
        $url = "https://$vCenter/rest/com/vmware/cis/tagging/category/id:$categoryID"
        $return = Invoke-WebRequest -Uri $url -Method Get -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
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

        #[ValidateSet('VirtualMachine',IgnoreCase = $false)]
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
        $return = Invoke-WebRequest -Uri $url -Method Post -Body $json -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
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
        $return = Invoke-WebRequest -Uri $url -Method Post -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
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
        $spec["disks"] = [System.Collections.ArrayList]@(@{"new_vmdk"= @{"capacity"= ([math]::pow( 1024, 3 ) * $diskSizeGB).ToString();"name"= "disk1"};"type"= "SCSI"})
        if ($secondDiskSizeGB){$null = $spec["disks"].add(@{"new_vmdk"= @{"capacity"= ([math]::pow( 1024, 3 ) * $secondDiskSizeGB).ToString();"name"= "disk2"};"type"= "SCSI"})}

        # construct json
        $json = @{'spec' = $spec} | ConvertTo-Json -Depth 5
        return (((Invoke-WebRequest -Uri $url -Method Post -Headers @{'vmware-api-session-id'=$sessionID;'Accept' = 'application/json'} -ContentType 'application/json' -Body $json -UseBasicParsing).Content | convertfrom-json).value)
    }
    End
    {
    }
}
#endregion

#region Remove-VMWareISO
function Remove-VMWareISO {
<#
    .Synopsis
        Sets CD-ROM backing to Client Device (removes mounted iso)
    
    .DESCRIPTION
        Sets CD-ROM backing to Client Device (removes mounted iso)

    .PARAMETER vCenter
        FQDN of server to connect to

    .PARAMETER sessionID
        vmware-api-session-id from Connect-vmwwarerasession
    
    .PARAMETER computer
        name of vm

    .EXAMPLE
        
        
    .OUTPUTS
        Returns $true if CD-ROM backing is updated is remove.  Throws error if not

    .Notes
        Author: Kyle Weeks
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
        Try{
            # Get VM ID, and device id of CD-ROM
            $vmID = Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $computer
            $cdRomID =  (Get-VMWareRAVM -vCenter $vCenter -sessionID $sessionID -computer $computer).cdroms.key
        
            ## Construct url
            $url = "https://$vCenter/rest/vcenter/vm/$vmID/hardware/cdrom/$cdRomID"

            # Construct body
            $body = @{spec=@{allow_guest_control='true';backing=@{type="CLIENT_DEVICE"}}} |ConvertTo-Json
        
            # Unmount ISO
            $return = Invoke-WebRequest -Uri $url -Method Patch -Headers @{'vmware-api-session-id'=$sessionID} -Body $body -ContentType 'application/json' -UseBasicParsing
            return($return.StatusDescription)
        }
        
        catch{throw $Error}
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
        try{
            ## Check current powerstate, if on, power off.  This also checks for existence.
            if((Get-VMWareRAVM -vCenter $vCenter -sessionID $sessionID -computer $computer).power_state -eq 'POWERED_ON')
            {
                Write-Warning "$computer is currently powered on, attempting to poweroff"
                $null = Set-VMWareRAVMpower -vCenter $vCenter -sessionID $sessionID -computer $computer -state stop
                Start-Sleep -Seconds 3
            }
            ## Construct url
            $vmID = Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $computer
            $url = "https://$vCenter/rest/vcenter/vm/$vmID"
            $return = Invoke-WebRequest -Uri $url -Method Delete -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
            if ($return.StatusCode -eq 200){return($true)}
            else{Throw "Failed to remove $computer $return"}
        }
        catch{throw $Error}
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
        $return = Invoke-WebRequest -Uri $url -Method Post -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
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

        #[ValidateSet('VirtualMachine',IgnoreCase = $false)]
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
        $return = Invoke-WebRequest -Uri $url -Method Post -Body $json -Headers @{'vmware-api-session-id'=$sessionID} -ContentType 'application/json' -UseBasicParsing
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
            return ((Invoke-WebRequest -Uri $url -Method Post -Headers @{'vmware-api-session-id'=$sessionID;'Accept' = 'application/json'} -ContentType 'application/json' -UseBasicParsing).content | convertfrom-json).value
        }
        catch{return $false}
    }
    End
    {
    }
}
#endregion
