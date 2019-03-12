using module "../FnDSL.psm1"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module $here/../FnDSL.psm1 -force

Describe "_`$" {
    BeforeEach {
        $Fn = InModuleScope FnDSL -Script {
            $Script:__FnDsl = New-Object FnDSL
            $Script:__FnDSL
        }
    }

    It "Creates a variable" {
        _$ VarName | Should -Be '$VarName'
    }

    It "Assigns a variable" {
        _$ VarName '"boo"' | Should -Be '$VarName = "boo"'
    }
}