Function Get-LineGraph
{
    param([Parameter(Mandatory=$true)]
    $ChartName,
    [Parameter(Mandatory=$true)]
    $XaxisLabels,
    [Parameter(Mandatory=$true)]
    $ValueType,
    [Parameter(Mandatory=$true)]
    $OutputFilePath,
    [Parameter(Mandatory=$true)]
    $Dataset1,$Dataset2,$Dataset3,$Dataset4,$Dataset5,$Dataset6,$Dataset7,$Dataset8)

    $ChartID = $ChartName.Replace(' ','')
    Function Get-DataArray
    {
        param(
            [Parameter(Mandatory=$true)]
            [string]$DatasetName,
            [Parameter(Mandatory=$true)]
            [object[]]$Data

        )
        Return ("const $DatasetName = [$($Data -join ',')];")
    }

    Function Get-Dataset
    {
        param(
            $DatasetName
        )
        Return ('{label: "' + $Datasetname + '",data: ' + $Datasetname + ',tension: 0.4,borderWidth: 3,pointRadius: 4,pointHoverRadius: 7,fill: false}')   
    }

    $Dataset1Name = ($Dataset1 | Get-Member -MemberType Properties | Select-Object Name -Unique).Name
    $XaxisText = ($XaxisLabels | Get-Member -MemberType Properties | Select-Object Name -Unique).Name
    $Dataarray = "const labels = [" + ($XaxisLabels | Select-Object -ExpandProperty $XaxisText | ForEach-Object{'"' + $_ + '",'}) + "];"
    $DataArray += Get-DataArray -DatasetName $Dataset1Name -Data ($Dataset1 | Select-Object -ExpandProperty $Dataset1Name)
    $Dataset = Get-Dataset -DatasetName $Dataset1Name

    If($Dataset2){
        $Dataset2Name = ($Dataset2 | Get-Member -MemberType Properties | Select-Object Name -Unique).Name
        $DataArray += Get-DataArray -DatasetName $Dataset2Name -Data ($Dataset2 | Select-Object -ExpandProperty $Dataset2Name)
        $Dataset += "," + (Get-Dataset -DatasetName $Dataset2Name)
    }

    If($Dataset3){
        $Dataset3Name = ($Dataset3 | Get-Member -MemberType Properties | Select-Object Name -Unique).Name
        $DataArray += Get-DataArray -DatasetName $Dataset3Name -Data ($Dataset3 | Select-Object -ExpandProperty $Dataset3Name)
        $Dataset += "," + (Get-Dataset -DatasetName $Dataset3Name)
    }

    If($Dataset4){
        $Dataset4Name = ($Dataset4 | Get-Member -MemberType Properties | Select-Object Name -Unique).Name
        $DataArray += Get-DataArray -DatasetName $Dataset4Name -Data ($Dataset4 | Select-Object -ExpandProperty $Dataset4Name)
        $Dataset += "," + (Get-Dataset -DatasetName $Dataset4Name)
    }

    If($Dataset5){
        $Dataset5Name = ($Dataset5 | Get-Member -MemberType Properties | Select-Object Name -Unique).Name
        $DataArray += Get-DataArray -DatasetName $Dataset5Name -Data ($Dataset5 | Select-Object -ExpandProperty $Dataset5Name)
        $Dataset += "," + (Get-Dataset -DatasetName $Dataset5Name)
    }

    If($Dataset6){
        $Dataset6Name = ($Dataset6 | Get-Member -MemberType Properties | Select-Object Name -Unique).Name
        $DataArray += Get-DataArray -DatasetName $Dataset6Name -Data ($Dataset6 | Select-Object -ExpandProperty $Dataset6Name)
        $Dataset += "," + (Get-Dataset -DatasetName $Dataset6Name)
    }

    If($Dataset7){
        $Dataset7Name = ($Dataset7 | Get-Member -MemberType Properties | Select-Object Name -Unique).Name
        $DataArray += Get-DataArray -DatasetName $Dataset7Name -Data ($Dataset7 | Select-Object -ExpandProperty $Dataset7Name)
        $Dataset += "," + (Get-Dataset -DatasetName $Dataset7Name)
    }

    If($Dataset8){
        $Dataset8Name = ($Dataset8 | Get-Member -MemberType Properties | Select-Object Name -Unique).Name
        $DataArray += Get-DataArray -DatasetName $Dataset8Name -Data ($Dataset8 | Select-Object -ExpandProperty $Dataset8Name)
        $Dataset += "," + (Get-Dataset -DatasetName $Dataset8Name)
    }

    $header = '<meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" /><title>' + $ChartName + '</title><script src="https://cdn.jsdelivr.net/npm/chart.js"></script><style>body {font-family: Arial, sans-serif;margin: 40px;background: #f6f7f9;color: #222;}.chart-wrapper {max-width: 1100px;margin: 0 auto;padding: 24px;background: #fff;border-radius: 12px;box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);} h1 {text-align: center;margin-bottom: 24px;font-size: 1.5rem;}.chart-container {position: relative;height: 500px;width: 100%;}</style><div class="chart-wrapper"><h1>' + $ChartName + '</h1><div class="chart-container"><canvas id="' + $ChartID + '"></canvas></div></div><script>'
    $ChartPlot = 'const ctx = document.getElementById("' + $ChartID + '");new Chart(ctx, {type: "line",data: {labels: labels,datasets: [' + $Dataset.replace('(','_').Replace(')','') + ']}, options: {responsive: true,maintainAspectRatio: false,plugins: {tooltip: {callbacks: {label: function(context) {return "' + $ValueType + '" + context.raw.toLocaleString();}}}},scales: {x: {title: {display: true,text: "' + $XaxisText + '"},ticks: {maxRotation: 60,minRotation: 60}},y: {beginAtZero: true,title: {display: true,text: "' + $ValueType + '"},ticks: {callback: function(value) {return value.toLocaleString();}}}}}});</script>'

    $header | out-file $OutputFilePath
    $DataArray.replace('(','_').Replace(')','') | out-file $OutputFilePath -Append
    $ChartPlot | out-file $OutputFilePath -Append
}