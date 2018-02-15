---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Remove-VMWareRAVM

## SYNOPSIS
Remove vm from VMWare Rest API

## SYNTAX

```
Remove-VMWareRAVM [-vCenter] <String> [-sessionID] <String> [-computer] <String>
```

## DESCRIPTION
Remove vm from VMWare Rest API

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

### -computer
name of vm

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### Returns $true if vm is remove.  Throws error if not

## NOTES
Author: Travis Sobeck

## RELATED LINKS

