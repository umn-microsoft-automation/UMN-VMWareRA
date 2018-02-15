---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Set-VMWareRAVMpower

## SYNOPSIS
Get vm ID for a specific vm from VMWare Rest API

## SYNTAX

```
Set-VMWareRAVMpower [-vCenter] <String> [-sessionID] <String> [-computer] <String> [[-state] <String>]
```

## DESCRIPTION
Get vm ID for a specific vm from VMWare Rest API

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
{{Fill computer Description}}

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

### -state
{{Fill state Description}}

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

## INPUTS

## OUTPUTS

### vmware ID, needed for other functions in this module

## NOTES
Author: Travis Sobeck

## RELATED LINKS

