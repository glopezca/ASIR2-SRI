function prompt {
    $date = (Get-Date).ToString("yyyy-MM-dd HH:mm")
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $host = $env:COMPUTERNAME
    $path = (Get-Location)

    Write-Host "$date " -ForegroundColor Cyan -NoNewline
    Write-Host "$user@" -ForegroundColor Green -NoNewline
    Write-Host "$host:" -ForegroundColor Magenta -NoNewline
    Write-Host "$path" -ForegroundColor Yellow
    return "$ "
}