function prompt {
    # Obtener fecha y hora
    $date = Get-Date -Format "ddd MMM dd"
    $time = Get-Date -Format "HH:mm:ss"

    # Obtener usuario, host y ruta
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split('\')[-1]
    $node = $env:COMPUTERNAME.ToLower()
    $path = (Get-Location).Path

    # Determinar símbolo ($ o #)
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $symbol = if ($isAdmin) { "#" } else { "$" }

    # Construir el prompt con colores similares a Ubuntu
    Write-Host "$date $time " -ForegroundColor DarkCyan -NoNewline
    Write-Host "$user@$node" -ForegroundColor Green -NoNewline
    Write-Host " " -ForegroundColor White -NoNewline
    Write-Host "$path" -ForegroundColor Yellow -NoNewline
    return "$symbol "
}
