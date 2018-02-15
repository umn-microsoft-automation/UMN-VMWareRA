---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Get-VMWareRACluster

## SYNOPSIS
Get details about cluster by name or list of all clusters from the VMWare Rest API

## SYNTAX

```
Get-VMWareRACluster [-vCenter] <String> [-sessionID] <String> [[-name] <String>]
```

## DESCRIPTION
Get details about cluster by name or list of all clusters from the VMWare Rest API

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
name of the cluster, case sensitivity required

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

## INPUTS

## OUTPUTS

### Cluster objects, which includes the name, ID, and HA/DRS enablement settings.

## NOTES
Author: Aaron Smith

## RELATED LINKS

