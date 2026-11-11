# Starts the backend locally: config-service first, then the other services.
# Prereqs: `docker compose --env-file .env up -d` in this folder, and the jars built
# (see README-local.md). Logs go to .\logs\, PIDs to .\logs\*.pid
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here
New-Item -ItemType Directory -Force "$here\logs" | Out-Null

# Load .env into this process; child processes inherit it.
Get-Content "$here\.env" | Where-Object { $_ -match '^\s*[A-Za-z_][A-Za-z0-9_]*=' } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    Set-Item -Path "env:$($name.Trim())" -Value $value.Trim()
}

function Start-Svc($name, $healthUrl, [string[]]$extraArgs) {
    $jar = Get-ChildItem "$root\$name\target\$name-*.jar" | Where-Object { $_.Name -notlike "*plain*" } | Select-Object -First 1
    if (-not $jar) { throw "Jar for $name not found - build it first." }
    $javaArgs = @("-jar", "`"$($jar.FullName)`"", "--eureka.client.enabled=false") + $extraArgs
    $p = Start-Process java -ArgumentList $javaArgs -WorkingDirectory $here -WindowStyle Hidden -PassThru `
        -RedirectStandardOutput "$here\logs\$name.log" -RedirectStandardError "$here\logs\$name.err.log"
    Set-Content "$here\logs\$name.pid" $p.Id
    Write-Host "Started $name (pid $($p.Id)), waiting for $healthUrl ..."
    for ($i = 0; $i -lt 90; $i++) {
        if ($p.HasExited) { throw "$name exited early - see logs\$name.log" }
        try {
            $r = Invoke-WebRequest -UseBasicParsing -TimeoutSec 3 $healthUrl
            if ($r.StatusCode -eq 200) { Write-Host "  $name is UP"; return }
        } catch { }
        Start-Sleep -Seconds 2
    }
    throw "$name did not become healthy in 3 minutes - see logs\$name.log"
}

# Config server in "native" mode serves .\config\*.yaml instead of the original private git repo.
Start-Svc "config-service" "http://localhost:8888/actuator/health" @(
    "--spring.profiles.active=native",
    "--spring.cloud.config.server.native.search-locations=file:./config/"
)
Start-Svc "account-service"      "http://localhost:9010/account/actuator/health" @()
Start-Svc "workspace-service"    "http://localhost:9020/workspace/actuator/health" @()
Start-Svc "intelligence-service" "http://localhost:9030/intelligence/actuator/health" @()
Start-Svc "api-gateway"          "http://localhost:8080/actuator/health" @()

Write-Host "`nBackend is up. API gateway: http://localhost:8080"
