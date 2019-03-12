using module "../FnDSL.psm1"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module $here/../FnDSL.psm1 -force

Describe "_Begin" {
    BeforeEach {
        $Fn = InModuleScope FnDSL -Script {
            $Script:__FnDsl = New-Object FnDSL
            $Script:__FnDSL
        }
    }
    Context "Indent Disabled" {
        BeforeEach {
            $Fn.IndentEnabled = $False
        }

        It "Builds a block with a string" {
            _Begin {
                "`"boo`""
            }
            $Fn.GetBegin() | Should -Be "Begin {`n    `"boo`"`n}"
        }
    }
    Context "Indent Enabled" {
        BeforeEach {
            $Fn.IndentEnabled = $True
            $Fn.IndentLevel = 4
        }

        It "Builds a block with a string" {
            _Begin {
                "`"boo`""
            }
            $Fn.GetBegin() | Should -Be "    Begin {`n        `"boo`"`n    }"
        }

        It "Increments IndentLevel" {
            _Begin {
                $fn.IndentLevel
            }
            $Fn.GetBegin() | Should -Be "    Begin {`n        8`n    }"
        }

        It "Decrements IndentLevel" {
            _Begin {
                $fn.IndentLevel
            }
            $Fn.IndentLevel | Should -Be 4
        }
    }
}