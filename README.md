# UMN-VMWareRA

Powershell wrappers for interacting with VMWare 6.5+ Rest API

Functions

Get-VMWareRAVMMac
This function is used to grab the mac address of a single connected nic.  Look at 'GET /vcenter/vm/{vm}/hardware/ethernet' to get more information about all nics associated with a vm

New-VMWareRAVM
diskSizeGB will take an array of Integers to build multiple disks.  You can still use secondDiskSizeGB and it will work as expected

## Releases

### 1.2.8 - 1/31/22

Added -scsiBusType input to New-VMWareRAVM. Non-mandatory, and will use ESXi environment's preferred default if not specified. If specified, any virtual drives will be attached to this bus.

### 1.2.7 -- 2/26/19

Fixed a bug with Get-VMWareRAVM when the $computer variable is set in your current environment

### 1.2.6 -- 1/14/19

Update function New-VMWareRAVM to support NicType as an option.

### 1.2.5 -- 8/2/18

Update function Get-VMWareVM -detailed switch fixed

### 1.2.4 -- 7/31/18

Update function Get-VMWareRAVMID

### 1.2.3 -- 6/25/18

Add function Get-VMWareRADatastore

### 1.2.2 -- 6/19/18

BugFix Get-VMWareRAVM using -vmid switch was throwing error, failed to define URL

### 1.2.1 -- 2/15/18

Add docs and code signing.

### Prior to 1.2.1

Send array of integers to disksizeGB in newVM function  .Fix get-vmwareravm function to return ID.  Return null if Get-VMWareRAVMID cant find ID.  Fix recursion issue.  Update Get-VMWareRAVMID so ignore case sensitivity.  Fix Get-VMWareRAVTag, Addfuctions to get host and cluster, expand get vm to do a better search, Add function Get-VMWareRAVMMac, Add -UseBasicParsing switch to invoke-webrequest to run on server-core