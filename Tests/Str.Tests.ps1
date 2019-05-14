using module "../FnDSL.psm1"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module $here/../FnDSL.psm1 -force

Describe "_Str" {
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

        It "Builds single quoted string" {
            _Str "boo" | Should -Be "'boo'"
        }

        It "Builds double quoted string" {
            _Str "boo" -Double | Should -Be '"boo"'
        }
    }
    Context "Indent Enabled" {
        BeforeEach {
            $Fn.IndentEnabled = $True
            $Fn.IndentLevel = 4
        }

        It "Builds an indented single quoted string" {
            _Str "boo" | Should -Be "    'boo'"
        }

        It "Builds an indented double quoted string" {
            _Str "boo" -Double | Should -Be '    "boo"'
        }
    }
}