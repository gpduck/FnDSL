using module "../FnDSL.psm1"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module $here/../FnDSL.psm1 -force

Describe "_Function" {
    BeforeEach {
        $Fn = InModuleScope FnDSL -Script {
            $Script:__FnDsl = New-Object FnDSL
            $Script:__FnDSL
        }
    }
    Context "External Help" {
        It "Sets the name of the function" {
            _Function -name "New-Function" -CmdletBinding:$False -ExternalHelp | Should -Be "function New-Function {`n    param()`n}"
        }

        It "Creates CmdletBinding by default" {
            _Function -name "New-Function" -ExternalHelp | Should -Be "function New-Function {`n    [CmdletBinding()]`n    param()`n}"
        }

        It "Adds SupportsShouldProcess" {
            _Function -name "New-Function" -SupportsShouldProcess -ExternalHelp | Should -Be "function New-Function {`n    [CmdletBinding(SupportsShouldProcess=`$True)]`n    param()`n}"
        }

        It "Adds ConfirmImpact" {
            _Function -name "New-Function" -ConfirmImpact High -ExternalHelp | Should -Be "function New-Function {`n    [CmdletBinding(ConfirmImpact='High')]`n    param()`n}"
        }

        It "Adds DefaultParameterSetName" {
            _Function -name "New-Function" -DefaultParameterSetName "DPSN" -ExternalHelp | Should -Be "function New-Function {`n    [CmdletBinding(DefaultParameterSetName='DPSN')]`n    param()`n}"
        }
    }
    Context "With Body Blocks" {
        It "Adds the begin block" {
            _Function -name "New-Function" -CmdletBinding:$False -ExternalHelp -Body {
                _Begin {"''"}
            } | Should -Be "function New-Function {`n    param()`n    Begin {`n        ''`n    }`n}"
        }

        It "Adds the process block" {
            _Function -name "New-Function" -CmdletBinding:$False -ExternalHelp -Body {
                _Process {"''"}
            } | Should -Be "function New-Function {`n    param()`n    Process {`n        ''`n    }`n}"
        }

        It "Adds the end block" {
            _Function -name "New-Function" -CmdletBinding:$False -ExternalHelp -Body {
                _End {"''"}
            } | Should -Be "function New-Function {`n    param()`n    End {`n        ''`n    }`n}"
        }

        It "Adds all three blocks" {
            _Function -name "New-Function" -CmdletBinding:$False -ExternalHelp -Body {
                _Begin {"''"}
                _Process {"''"}
                _End {"''"}
            } | Should -Be "function New-Function {`n    param()`n    Begin {`n        ''`n    }`n    Process {`n        ''`n    }`n    End {`n        ''`n    }`n}"
        }
    }

    Context "With parameters" {
        It "Adds the parameters" {
            _Function -name "Parameter-Function" -ExternalHelp -CmdletBinding:$False {
                _Parameter "P1"
            } | Should -Be "function Parameter-Function {`n    param(`n        `$P1`n    )`n}"
        }

        It "Adds parameter attributes" {
            _Function -name "Parameter-Function" -ExternalHelp -CmdletBinding:$False {
                _Parameter "P1" -Mandatory
            } | Should -Be "function Parameter-Function {`n    param(`n        [Parameter(Mandatory=`$True)]`n        `$P1`n    )`n}"
        }

        It "Adds parameter help" {
            _Function -Name "Help-Function" -Description "Function Description" -CmdletBinding:$False {
                _Parameter "P1" -HelpText "P1 Help Text"
            } | Should -Be "<#`n.DESCRIPTION`nFunction Description`n`n.PARAMETER P1`nP1 Help Text`n#>`nfunction Help-Function {`n    param(`n        `$P1`n    )`n}"
        }
    }
}