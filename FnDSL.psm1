function PSFunction {
    param(
        $Name,

        [System.Management.Automation.ScriptBlock]$Body,

        [switch]$CmdletBinding = $true,

        [switch]$SupportsShouldProcess,

        $ConfirmImpact,

        $Description = "AUTO GENERATED FUNCTION",

        $DefaultParameterSetName
    )
    $Parameters = New-object System.Collections.ArrayList
    $BeginBlock = New-object System.Collections.ArrayList
    $ProcessBlock = New-object System.Collections.ArrayList
    $EndBlock = New-Object System.Collections.ArrayList
    $HelpParameters = New-Object System.Collections.ArrayList

    $CmdletBindingValues = @()
    if($SupportsShouldProcess) {
        $CmdletBindingValues += 'SupportsShouldProcess=$true'
    }
    if($DefaultParameterSetName) {
        $CmdletBindingValues += "DefaultParameterSetname='$DefaultParameterSetName'"
    }
    if($CmdletBinding -or $CmdletBindingValues.Count -gt 0) {
        $CmdletBindingAttribute = "[CmdletBinding($($CmdletBindingValues -join ','))]"
    }

    &$Body

    if($BeginBlock.Count -gt 0) {
        $Begin = @"
    begin {
        $BeginBlock
    }
"@
    }

    if($ProcessBlock.Count -gt 0) {
        $Process = @"
    process {
        $ProcessBlock
    }
"@
    }

    if($EndBlock.Count -gt 0) {
        $End = @"
    end {
        $EndBlock
    }
"@
    }


@"
<#
.DESCRIPTION
  $Description

$($HelpParameters -join "`r`n`r`n")
#>
function $Name {
    $CmdletBindingAttribute
    param(
        $($Parameters -join ",`r`n`r`n        ")
    )
$Begin
$Process
$End
}
"@
}

function PSParam {
    param(
        [Parameter(Mandatory=$true)]
        $Name,
        $Type = "Object",
        [switch]$Mandatory,
        [switch]$ValueFromPipeline,
        [switch]$ValueFromPipelineByPropertyName,
        $DefaultValue,
        $ParameterSetName,
        $ValidateSet,
        [int]$Position,
        $HelpText = "ADD PARAMETER HELP TEXT"
    )
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
        $ParameterAttribute = "[Parameter($($ParameterAttributeValues -join ','))]`r`n        "
    } else {
        $ParameterAttribute = ""
    }
    if($HelpText) {
        $HelpParameters.Add(".PARAMETER $Name`r`n  $HelpText") > $null
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
        $Validate = "[ValidateSet($($ValidateSet -join ','))]`r`n        "
    }
    $Parameters.Add(@"
$ParameterAttribute$Validate[$Type]`$$Name$Default
"@) > $null
}

function PSBegin {
    param(
        $Body
    )
    $BeginBlock.Add( (&$Body) ) > $null
}

function PSProcess {
    param(
        $Body
    )
    $ProcessBlock.Add( (&$Body) ) > $null
}

function PSEnd {
    param(
        $Body
    )
    $EndBlock.Add( (&$Body) ) > $null
}