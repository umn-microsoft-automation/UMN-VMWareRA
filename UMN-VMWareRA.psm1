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
        Get IPv4 from vmware if VM is running with integration tools installed
    .DESCRIPTION
        Long description
    .PARAMETER vCenter

    .PARAMETER vmwareCreds
    .EXAMPLE
        a
    .EXAMPLE
    A   nother example of how to use this cmdlet
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
        Get IPv4 from vmware if VM is running with integration tools installed
    .DESCRIPTION
        Long description
    .PARAMETER vCenter

    .PARAMETER vmwareCreds
    .EXAMPLE
        a
    .EXAMPLE
    A   nother example of how to use this cmdlet
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