---
external help file: UMN-VMWareRA-help.xml
Module Name: UMN-VMWareRA
online version:
schema: 2.0.0
---

# New-VMWareRAVM

## SYNOPSIS
Build new VM via VMWare Rest API

## SYNTAX

```
New-VMWareRAVM [-vCenter] <String> [-sessionID] <String> [-computer] <String> [[-memoryGB] <Int32>]
 [[-NumCpu] <Int32>] [[-corePerSocket] <Int32>] [-diskSizeGB] <Int32[]> [[-secondDiskSizeGB] <Int32>]
 [-network] <String> [[-isoPath] <String>] [-folder] <String> [-cluster] <String> [-datastore] <String>
 [[-bootSource] <String>] [[-hardwareVersion] <String>] [[-guestOS] <String>] [[-nicType] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Build new VM via VMWare Rest API

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

### -memoryGB
{{Fill memoryGB Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 4
Accept pipeline input: False
Accept wildcard characters: False
```

### -NumCpu
{{Fill NumCpu Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -corePerSocket
{{Fill corePerSocket Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -diskSizeGB
\[string\]$notes,

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -secondDiskSizeGB
{{Fill secondDiskSizeGB Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -network
{{Fill network Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -isoPath
\[string\[\]\]$tags, # api has not supported this yet

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -folder
{{Fill folder Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -cluster
{{Fill cluster Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -datastore
{{Fill datastore Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -bootSource
{{Fill bootSource Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: CDROM
Accept pipeline input: False
Accept wildcard characters: False
```

### -hardwareVersion
{{Fill hardwareVersion Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: VMX_11
Accept pipeline input: False
Accept wildcard characters: False
```

### -guestOS
{{Fill guestOS Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: WINDOWS_9_SERVER_64
Accept pipeline input: False
Accept wildcard characters: False
```

### -nicType
{{Fill nicType Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: VMXNET3
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
