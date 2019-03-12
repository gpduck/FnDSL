using module "../FnDSL.psm1"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module $here/../FnDSL.psm1 -force

Describe "_Process" {
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
            _Process {
                "`"boo`""
            }
            $Fn.GetProcess() | Should -Be "Process {`n    `"boo`"`n}"
        }
    }
    Context "Indent Enabled" {
        BeforeEach {
            $Fn.IndentEnabled = $True
            $Fn.IndentLevel = 4
        }

        It "Builds a block with a string" {
            _Process {
                "`"boo`""
            }
            $Fn.GetProcess() | Should -Be "    Process {`n        `"boo`"`n    }"
        }

        It "Increments IndentLevel" {
            _Process {
                $fn.IndentLevel
            }
            $Fn.GetProcess() | Should -Be "    Process {`n        8`n    }"
        }

        It "Decrements IndentLevel" {
            _Process {
                $fn.IndentLevel
            }
            $Fn.IndentLevel | Should -Be 4
        }
    }
}