using module "../FnDSL.psm1"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module $here/../FnDSL.psm1 -force

Describe "_Parameter" {
    Context "a context" {
        BeforeEach {
            $Fn = InModuleScope FnDSL -Script {
                $Script:__FnDsl = New-Object FnDSL
                $Script:__FnDsl
            }
        }

        It "Adds a parameter" {
            _Parameter "ParamName"
            
            $Fn.Parameters.Count | Should -Be 1
            $Fn.Parameters[0] | Should -Be '        $Paramname'
        }

        It "Sets Mandatory" {
            _Parameter "ParamName" -Mandatory
            $Fn.Parameters[0] | Should -Be "        [Parameter(Mandatory=`$True)]`n        `$ParamName"
        }

        It "Sets Type" {
            _Parameter "ParamName" -Type "String"
            $Fn.Parameters[0] | Should -Be "        [String]`$ParamName"
        }

        It "Sets ValueFromPipeline" {
            _Parameter "ParamName" -ValueFromPipeline
            $Fn.Parameters[0] | Should -Be "        [Parameter(ValueFromPipeline=`$True)]`n        `$ParamName"
        }

        It "Sets ValueFromPipelineByPropertyName" {
            _Parameter "ParamName" -ValueFromPipelineByPropertyName
            $Fn.Parameters[0] | Should -Be "        [Parameter(ValueFromPipelineByPropertyName=`$True)]`n        `$ParamName"
        }

        It "Sets default value" {
            _Parameter "ParamName" -DefaultValue "'default'"
            $Fn.Parameters[0] | Should -Be "        `$ParamName = 'default'"
        }

        It "Sets parameter set name" {
            _Parameter "ParamName" -ParameterSetName "psn"
            $Fn.Parameters[0] | Should -Be "        [Parameter(ParameterSetName='psn')]`n        `$ParamName"
        }

        It "Sets validate set" {
            _Parameter "ParamName" -ValidateSet 1,"two",3
            $Fn.Parameters[0] | Should -Be "        [ValidateSet(1,'two',3)]`n        `$ParamName"
        }

        It "Sets position" {
            _Parameter "ParamName" -Position 3
            $Fn.Parameters[0] | Should -Be "        [Parameter(Position=3)]`n        `$ParamName"
        }

        It "Sets them all at once" {
            _Parameter "Paramname" -Mandatory -Type "String" -ValueFromPipeline -ValueFromPipelineByPropertyName -DefaultValue "'default'" -ParameterSetName "psn" -ValidateSet 1,2,3 -Position 4
            $Fn.Parameters[0] | Should -Match "\[String\]"
            $Fn.Parameters[0] | Should -Match 'ValueFromPipeline=\$True'
            $Fn.Parameters[0] | Should -Match 'ValueFromPipelineByPropertyName=\$True'
            $Fn.Parameters[0] | Should -Match 'Mandatory=\$True'
            $Fn.Parameters[0] | Should -Match " = 'default'"
            $Fn.Parameters[0] | Should -Match "ParameterSetName='psn'"
            $Fn.Parameters[0] | Should -Match "\[ValidateSet\(1,2,3\)\]"
            $Fn.Parameters[0] | Should -Match "Position=4"
        }
    }
}