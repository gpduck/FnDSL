using module "../FnDSL.psm1"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module $here/../FnDSL.psm1 -force

Describe "_Switch" {
    BeforeEach {
        $Fn = InModuleScope FnDsl -Script {
            $Script:__FnDsl = New-Object FnDSL
            $Script:__FnDsl
        }
    }
    Context "Indent Disabled" {
        BeforeEach {
            $Fn.IndentEnabled = $False
        }

        It "Builds a switch statement with a single case" {
            _switch { _$ true } {
                _case {_$ true} {
                  _str "true"
                }
            } | Should -Be "switch(`$true) {`n`$true {`n`'true'`n}`n}"
        }
    }
    Context "Indent Enabled" {
        BeforeEach {
            $Fn.IndentEnabled = $True
            $Fn.IndentLevel = 4
        }

        It "Builds a switch statement with a single case" {
            _switch { _$ true } {
                _case {_$ true} {
                  _str "true"
                }
            } | Should -Be "    switch(`$true) {`n        `$true {`n            'true'`n        }`n    }"
        }
    }
}