using module "../FnDSL.psm1"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module $here/../FnDSL.psm1 -force

Describe "_foreach" {
    BeforeEach {
        $Fn = InModuleScope FnDSL -Script {
            $Script:__FnDsl = New-Object FnDSL
            $Script:__FnDSL
        }
    }

    It "Creates a foreach loop" {
        _foreach { "one"; "in"; "many"} { "do stuff" } | Should -Be "    foreach(one in many) {`n        do stuff`n    }"
    }

    It "Adds a line-break when -LB is specified" {
        _foreach { "one"; "in"; "many"} { "do stuff" } -LB | Should -Be "    foreach(one in many) {`n        do stuff`n    }`n"
    }

    It "Calculates values in the condition" {
        _foreach { (_$ One); "in"; (_$ Many) } { "do stuff" } | Should -Be "    foreach(`$One in `$Many) {`n        do stuff`n    }"
    }

    It "Calculates values in the statement" {
        _foreach { "one"; "in"; "many"} { _$ Var } | Should -Be "    foreach(one in many) {`n        `$Var`n    }"
    }
}