param(
    [int]$DurationSeconds = 900,
    [int]$Threads = 64
)

Write-Output "Starting P9a CPU stress test for $DurationSeconds seconds using $Threads threads..."
Write-Output "Started: $(Get-Date)"

$Jobs = @()

1..$Threads | ForEach-Object {
    $Jobs += Start-Job -ScriptBlock {
        while ($true) {
            $x = 0
            for ($i = 0; $i -lt 5000000; $i++) {
                $x += [Math]::Sqrt($i)
            }
        }
    }
}

$EndTime = (Get-Date).AddSeconds($DurationSeconds)

while ((Get-Date) -lt $EndTime) {
    $cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    Write-Output "CPU: $([math]::Round($cpu,2))% at $(Get-Date)"
    Start-Sleep -Seconds 10
}

$Jobs | Stop-Job -Force
$Jobs | Remove-Job -Force

Write-Output "Completed: $(Get-Date)"
Write-Output "P9a CPU stress test completed and jobs removed."
