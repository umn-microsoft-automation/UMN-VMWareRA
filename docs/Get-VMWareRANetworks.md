---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Get-VMWareRANetworks

## SYNOPSIS
Get a list of Networks

## SYNTAX

```
Get-VMWareRANetworks [-vCenter] <String> [-sessionID] <String> [[-filter] <String>]
```

## DESCRIPTION
Get a list of Networks

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```

```

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

### -filter
Filster string to narrow down list of networks

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

### vmware ID, needed for other functions in this module

## NOTES
Author: Travis Sobeck

## RELATED LINKS

