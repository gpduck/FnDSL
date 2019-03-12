class FnDSL {
    [Int32]$IndentLevel = 4
    [Bool]$IndentEnabled = $true
    [System.Collections.ArrayList]$Parameters = (New-Object System.Collections.ArrayList)
    [System.Collections.ArrayList]$HelpParameters = (New-Object System.Collections.ArrayList)
    [string]$BeginBlock
    [string]$ProcessBlock
    [String]$EndBlock
    [string]GetIndent() {
        if($This.IndentEnabled) {
            return " " * $This.IndentLevel
        } else {
            return ""
        }
    }
    [string]GetBegin() {
        return $This.GetBodyBlock("Begin")
    }
    [string]GetProcess() {
        return $This.GetBodyBlock("Process")
    }
    [string]GetEnd() {
        return $This.GetBodyBlock("End")
    }
    [string]GetBodyBlock($Name) {
        $BlockName = "${Name}Block"
        if($This."$BlockName") {
            $MyIndent = $This.GetIndent()
return @"
${MyIndent}$Name {
${MyIndent}    $($This."$Blockname")
${MyIndent}}
"@
        } else {
            return ""
        }
    }
    [string]GetHelpParameters() {
        if($This.HelpParameters.Count -gt 0) {
            return ($This.HelpParameters | ForEach-Object {
                ".PARAMETER $($_.Name)`n$($_.Description)"
            }) -Join "`n`n"
        } else {
            return ""
        }
    }
    [string]GetParamBlock() {
        $MyIndent = $This.GetIndent()
        if($This.Parameters.Count -gt 0) {
            return "${MyIndent}param(`n$($This.Parameters -Join ",`n`n")`n${MyIndent})"
        } else {
            return "${MyIndent}param()"
        }
    }
    [void]IncreaseIndent() {
        $This.IndentLevel += 4
    }
    [void]DecreaseIndent() {
        $This.IndentLevel -= 4
    }
}

class HelpParameter {
    [String]$Name
    [String]$Description
}

function _Function {
    param(
        $Name,

        [System.Management.Automation.ScriptBlock]$Body = {},

        [Switch]$CmdletBinding = $true,

        [switch]$SupportsShouldProcess,

        [ValidateSet("None","Low","Medium","High")]
        $ConfirmImpact,

        $DefaultParameterSetName,

        [Switch]$ExternalHelp,

        $Description = "AUTO GENERATED FUNCTION"
    )
    $FnDSL = New-Object FnDSL
    $Script:__FnDSL = $FnDsl
    $MyIndent = $FnDsl.GetIndent()

    &$Body

    $CmdletBindingValues = @()
    if($SupportsShouldProcess) {
        $CmdletBindingValues += 'SupportsShouldProcess=$True'
    }
    if($DefaultParameterSetName) {
        $CmdletBindingValues += "DefaultParameterSetname='$DefaultParameterSetName'"
    }
    if($ConfirmImpact) {
        $CmdletBindingValues += "ConfirmImpact='$ConfirmImpact'"
    }
    if($CmdletBinding -or $CmdletBindingValues.Count -gt 0) {
        $CmdletBindingAttribute = "${MyIndent}[CmdletBinding($($CmdletBindingValues -join ','))]"
    }
    If(!$ExternalHelp) {
        $Help = @"
<#
.DESCRIPTION
$Description`n
$($FnDSL.GetHelpParameters())
#>`n
"@
    } else {
        $Help = ""
    }

    $Parts = @()
    if($CmdletBindingAttribute) {
        $Parts += $CmdletBindingAttribute
    }
    $Parts += $FnDsl.GetParamBlock()

    if($FnDsl.BeginBlock) {
        $Parts += $FnDsl.GetBegin()
    }
    if($FnDsl.ProcessBlock) {
        $Parts += $FnDsl.GetProcess()
    }
    if($FnDsl.EndBlock) {
        $Parts += $FnDsl.GetEnd()
    }

@"
${Help}function $Name {
$($Parts -join "`n")
}
"@
}

function _Parameter {
    param(
        [Parameter(Mandatory=$true)]
        $Name,
        $Type,
        [switch]$Mandatory,
        [switch]$ValueFromPipeline,
        [switch]$ValueFromPipelineByPropertyName,
        $DefaultValue,
        $ParameterSetName,
        $ValidateSet,
        [int]$Position,
        $HelpText = "ADD PARAMETER HELP TEXT"
    )
    $FnDsl = $Script:__FnDsl
    $FnDsl.IncreaseIndent()
    $MyIndent = $FnDsl.GetIndent()
    $ParameterAttributeValues = @()
    if($Mandatory) {
        $ParameterAttributeValues += 'Mandatory=$true'
    }
    if($ValueFromPipeline) {
        $ParameterAttributeValues += 'ValueFromPipeline=$true'
    }
    if($ValueFromPipelineByPropertyName) {
        $ParameterAttributeValues += 'ValueFromPipelineByPropertyName=$true'
    }
    if($PSBoundParameters.ContainsKey("Position")) {
        $ParameterAttributeValues += "Position=$Position"
    }
    if($ParameterSetName) {
        $ParameterAttributeValues += "ParameterSetName='$ParameterSetName'"
    }
    if($ParameterAttributeValues.Count -gt 0) {
        $ParameterAttribute = "$MyIndent[Parameter($($ParameterAttributeValues -join ','))]`n"
    } else {
        $ParameterAttribute = ""
    }
    if($HelpText) {
        $FnDsl.HelpParameters.Add( (New-Object HelpParameter -Property @{
            Name = $Name
            Description = $HelpText
        })) > $Null
    }
    if($DefaultValue) {
        $Default = " = $DefaultValue"
    }
    if($ValidateSet) {
        $ValidateSet = $ValidateSet | ForEach-Object {
            $Value = $_
            switch($Value.GetType().Fullname) {
                "System.String" {
                    "'$Value'"
                }
                default {
                    $Value
                }
            }
        }
        $Validate = "$MyIndent[ValidateSet($($ValidateSet -join ','))]`n"
    }
    If($Type) {
        $Type = "${MyIndent}[$Type]"
    } else {
        $Type = "$MyIndent"
    }
    $FnDsl.Parameters.Add(@"
${ParameterAttribute}${Validate}${Type}`$$Name$Default
"@) > $Null
    $FnDsl.DecreaseIndent()
}

function _Begin {
    param(
        $Body
    )
    BlockImplementation -Name Begin -Body $Body
}

function _Process {
    param(
        $Body
    )
    BlockImplementation -Name Process -Body $Body
}

function _End {
    param(
        $Body
    )
    BlockImplementation -Name End -Body $Body
}

function BlockImplementation {
    param(
        $Name,
        $Body
    )
    $Fn = $Script:__FnDsl
    $MyIndent = $Fn.Getindent()
    $Fn.IncreaseIndent()
    $BlockName = "${Name}Block"
    $Fn."$BlockName" = (&$Body) -Join "`r"
    $Fn.DecreaseIndent()
}

function _If {
    param(
        $Condition,
        $Statement,
        $Else,
        [Switch]$LB
    )
    $FnDsl = $Script:__FnDsl
    $MyIndent = $FnDsl.GetIndent()
    $FnDsl.IncreaseIndent()
    if($Else) {
        $ElsePart = @"
 else {
$MyIndent    $(&$Else)
$MyIndent}
"@
    }

@"
${MyIndent}if($(&$Condition)) {
$MyIndent    $(&$Statement)
$MyIndent}$ElsePart$(if($LB) { "`n"})
"@
    $FnDsl.DecreaseIndent()
}

function _$ {
    param(
        $Name,
        $Value
    )
    if($Value) {
        "`$$Name = $Value"
    } else {
        "`$$Name"
    }
}

function _ {
    param()
    $Args -Join " "
}

function _foreach {
    param(
        [Parameter(Mandatory=$true)]
        $Condition,

        [Parameter(Mandatory=$true)]
        $Statement,

        [Switch]$LB
    )
    $FnDsl = $Script:__FnDsl
    $MyIndent = $FnDsl.GetIndent()
    $FnDsl.IncreaseIndent()
    $StatementParts = (&$Statement) -Join "`n$MyIndent    "
@"
${MyIndent}foreach($(&$Condition)) {
$MyIndent    $StatementParts
$MyIndent}$(if($LB) { "`n"})
"@
    $FnDsl.DecreaseIndent()
}

function PSLB {
    "`r`n"
}