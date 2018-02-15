---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Test-VMWareRASession

## SYNOPSIS
Test for valid and active VMWare Rest API Session

## SYNTAX

```
Test-VMWareRASession [[-vCenter] <String>] [[-sessionID] <String>]
```

## DESCRIPTION
Test for valide and active VMWare Rest API Session

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Test-VMWareRASession -vCenter $vCenter -sessionID $sessionID
```

## PARAMETERS

### -vCenter
FQDN of server to test connection against

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
vmware-api-session-id to be tested

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

### If there is a valid and active connection, the funciton will return details about the connection.  If not, the function will return $false

## NOTES
Author: Travis Sobeck

## RELATED LINKS

