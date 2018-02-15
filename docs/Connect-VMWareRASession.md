---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Connect-VMWareRASession

## SYNOPSIS
Connect to VMWare Rest API Session

## SYNTAX

```
Connect-VMWareRASession [[-vCenter] <String>] [[-vmwareCreds] <PSCredential>]
```

## DESCRIPTION
Connect to VMWare Rest API Session

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$sessionID = Connect-VMWareRASession  -vCenter $vCenter -vmwareCreds $vmwareApiCred
```

## PARAMETERS

### -vCenter
FQDN of server to connect to

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

### -vmwareCreds
PS credential of user that has access

```yaml
Type: PSCredential
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

### Function will return the a Session ID that will be used as an Auth token in other functions in this module

## NOTES
Author: Travis Sobeck

## RELATED LINKS

