---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version:
schema: 2.0.0
---

# Get-VMWareRADatastore

## SYNOPSIS
Get Datastore objects by name,ID,or filter from the VMWare Rest API. 
Supports wildcards and handles case sensitivity issues.

## SYNTAX

```
Get-VMWareRADatastore [-vCenter] <String> [-sessionID] <String> [[-name] <String>] [[-datastoreID] <String>]
 [[-folder] <String>] [[-datacenter] <String>] [[-type] <String>] [<CommonParameters>]
```

## DESCRIPTION
et Datastore objects by name,ID,or filter from the VMWare Rest API. 
Supports wildcards and handles case sensitivity issues.
Able to return more than 1000 objects by working around the current limitation of the REST APIs.

## EXAMPLES

### Example 1
```powershell
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
name of the datastore, case sensitivity not required.
Supports wildcard character *.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -datastoreID
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

### -folder
Array\[string\] of folders to filter on

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

### -datacenter
Datacenters that must contain the datastore

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

### -type
One of \['VMFS', 'NFS', 'NFS41', 'CIFS', 'VSAN', 'VFFS', 'VVOL'\]

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### List of VM objects based on parameters specified.
## NOTES
Author: Aaron Smith, Travis Sobeck

## RELATED LINKS
