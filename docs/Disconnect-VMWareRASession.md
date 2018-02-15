---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Disconnect-VMWareRASession

## SYNOPSIS
Disconnect VMWare Rest API Session

## SYNTAX

```
Disconnect-VMWareRASession [[-vCenter] <String>] [[-sessionID] <String>]
```

## DESCRIPTION
Disconnect VMWare Rest API Session

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Disconnect-VMWareRASession -vCenter $vCenter -sessionID $sessionID
```

## PARAMETERS

### -vCenter
FQDN of server to connect to to end session

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sessionID
vmware-api-session-id to be closed

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author: Travis Sobeck

## RELATED LINKS

