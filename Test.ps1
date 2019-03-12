ipmo .\FnDSL.psm1 -force

_Function "Get-Things" {
    _Parameter "One" "Type"
    _Parameter "Two" "Type" -Mandatory
    _Parameter "Three" "Type" -Position 1
    _Parameter "Four" "Type" -ValueFromPipeline
    _Parameter "Five" -ValueFromPipelineByPropertyName
    _Parameter "Six" -Mandatory -Position 2 -ValueFromPipeline -ValueFromPipelineByPropertyName
    _Parameter "Seven" -ValidateSet 1,"two",3
}


_Function "New-Process" {
    $ParamMap = @{}
    [System.Diagnostics.Process].GetProperties() | %{
        _Parameter $_.Name -Mandatory
        $ParamMap[$_.name] = Get-Random
    }

    $BooValue = "BOO"

    _Begin {
        "echo boo"
    }

    _Process {
@"
`$Map = @{
$($ParamMap.Keys | ForEach-Object {"            $_ = $($ParamMap[$_])`r`n"})        }
"@
    }

    _End {
        $BooValue
    }
}

