---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Get-VMWareRAVM

## SYNOPSIS
Get VM objects by name from the VMWare Rest API. 
Supports wildcards and handles case sensitivity issues.

## SYNTAX

```
Get-VMWareRAVM [-vCenter] <String> [-sessionID] <String> [[-name] <String>] [[-vmID] <String>]
 [[-hostName] <String>] [[-hostID] <String>] [[-cluster] <String>] [[-clusterID] <String>] [-detailed]
```

## DESCRIPTION
Get details about vm or a list of vms from VMWare Rest API. 
Supports wildcards and handles case sensitivity issues.
Able to return more than 1000 objects by working around the current limitation of the REST APIs.

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -vCenter
FQDN of server to connect to

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sessionID
vmware-api-session-id from Connect-vmwwarerasession

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -name
name of the VM, case sensitivity not required.
Supports wildcard character *.

```yaml
Type: String
Parameter Sets: (All)
Aliases: computer

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -vmID
ID of vm, or leave this and vmID blank to get a full list

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hostName
name of host to return list of VMs from, case sensitivity required

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hostID
ID of host to return list of VMs from.
Overrides host parameter if also specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -cluster
Name of cluster to return list of VMs from (able to return more then 1000 VMs), case sensitivity required.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -clusterID
ID of cluster to return list of VMs from (able to return more then 1000 VMs.) Overrides cluster parameter if specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -detailed
Add this switch to output detailed contents of the VM

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### List of VM objects based on parameters specified.

## NOTES
Author: Aaron Smith, Travis Sobeck

## RELATED LINKS

