---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version:
schema: 2.0.0
---

# Get-VMWareRAVMpower

## SYNOPSIS
Get vm ID for a specific vm from VMWare Rest API

## SYNTAX

```
Get-VMWareRAVMpower [-vCenter] <String> [-sessionID] <String> [-computer] <String> [<CommonParameters>]
```

## DESCRIPTION
Get vm ID for a specific vm from VMWare Rest API

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Travis Sobeck

## RELATED LINKS
