using module "../FnDSL.psm1"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module $here/../FnDSL.psm1 -force

Describe "_If" {
    BeforeEach {
        $Fn = InModuleScope FnDsl -Script {
            $Script:__FnDsl = New-Object FnDSL
            $Script:__FnDsl
        }
    }
    It "Makes an if statement" {
        _If { '$True' } {
            8
        } | Should -Be "    if(`$True) {`n        8`n    }"
    }

    It "Makes an If..Else Statement" {
        _If { '$True' } {
            8
        } -Else {
            9
        }| Should -Be "    if(`$True) {`n        8`n    } else {`n        9`n    }"
    }

    It "Adds a line-break when -LB is specified" {
        _If { '$True' } {
            8
        } -LB | Should -Be "    if(`$True) {`n        8`n    }`n"
    }
}