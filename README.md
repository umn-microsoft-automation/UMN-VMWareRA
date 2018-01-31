# UMN-VMWareRA
Powershell wrappers for interacting with VMWare 6.5+ Rest API

Functions

Get-VMWareRAVMMac
This function is used to grab the mac address of a sincle connected nic.  Look at 'GET /vcenter/vm/{vm}/hardware/ethernet' to get more information about all nics associated with a vm

New-VMWareRAVM
diskSizeGB will take an array of Integers to build multiple disks.  You can still use secondDiskSizeGB and it will work as expected
