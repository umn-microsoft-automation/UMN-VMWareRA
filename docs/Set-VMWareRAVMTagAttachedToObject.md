---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Set-VMWareRAVMTagAttachedToObject

## SYNOPSIS
Add tags to an object

## SYNTAX

```
Set-VMWareRAVMTagAttachedToObject [-vCenter] <String> [-sessionID] <String> [-tagid] <String> [-id] <String>
 [[-type] <String>]
```

## DESCRIPTION
Add tags to an object

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

### -tagid
ID of tag to be added

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

### -id
id of object, for example if its a vm, use Get-VMWareRAVMID -vCenter $vCenter -sessionID $sessionID -computer $computer to get its id

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -type
type of object, for example 'virtualMachine'

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

## INPUTS

## OUTPUTS

### JSON data of ids/types

## NOTES
Author: Travis Sobeck

## RELATED LINKS

