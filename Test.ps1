ipmo .\FnDSL.psm1 -force

PSFunction "Get-Things" {
    PSParam "One" "Type"
    PSParam "Two" "Type" -Mandatory
    PSParam "Three" "Type" -Order 1
    PSParam "Four" "Type" -ValueFromPipeline
    PSParam "Five" -ValueFromPipelineByPropertyName
    PSParam "Six" -Mandatory -Order 2 -ValueFromPipeline -ValueFromPipelineByPropertyName
    PSParam "Seven" -ValidateSet 1,"two",3
}


PSFunction "New-Process" {
    $ParamMap = @{}
    [System.Diagnostics.Process].GetProperties() | %{
        PSParam $_.Name -Mandatory
        $ParamMap[$_.name] = Get-Random
    }

    $BooValue = "BOO"

    PSBegin {
        "echo boo"
    }

    PSProcess {
@"
`$Map = @{
$($ParamMap.Keys | ForEach-Object {"            $_ = $($ParamMap[$_])`r`n"})        }
"@
    }

    PSEnd {
        $BooValue
    }
}

