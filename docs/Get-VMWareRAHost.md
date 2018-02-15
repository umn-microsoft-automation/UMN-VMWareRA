---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Get-VMWareRAHost

## SYNOPSIS
Get details about host by name or list of all hosts from the VMWare Rest API

## SYNTAX

```
Get-VMWareRAHost [-vCenter] <String> [-sessionID] <String> [[-name] <String>] [[-hostID] <String>]
 [[-cluster] <String>] [[-clusterID] <String>]
```

## DESCRIPTION
Get details about host by name or list of all hosts from the VMWare Rest API

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
name of the host, case sensitivity required

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

### -hostID
ID of the host

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

### -cluster
name of the cluster to obtain host list from, case sensitivity required

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

### -clusterID
ID of the cluster to obtain host list from.
Overrides cluster parameter if also specified.

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

## INPUTS

## OUTPUTS

### Host objects, which includes the name, ID, connection and power status

## NOTES
Author: Aaron Smith

## RELATED LINKS

