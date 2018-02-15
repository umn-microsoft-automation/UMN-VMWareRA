---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version: 
schema: 2.0.0
---

# Get-VMWareRAVMMac

## SYNOPSIS
Get the Mac address for a vm of a connected NIC

## SYNTAX

### vmName
```
Get-VMWareRAVMMac -vCenter <String> -sessionID <String> -computer <String> [-nicLabel <String>]
```

### vmID
```
Get-VMWareRAVMMac -vCenter <String> -sessionID <String> -vmID <String> [-nicLabel <String>]
```

## DESCRIPTION
Get the Mac address for a vm, look at  GET /vcenter/vm/{vm}/hardware/ethernet for a more complete look at nics

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
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -computer
{{Fill computer Description}}

```yaml
Type: String
Parameter Sets: vmName
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -vmID
ID of vm, or leave this and vmID blank to get a full list

```yaml
Type: String
Parameter Sets: vmID
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -nicLabel
label of target nic, useful with multiple nics

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author: Travis Sobeck

## RELATED LINKS

