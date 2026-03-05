param (
    [string]$templatefile,
    [string]$outputfile, 
    [string]$env 
)

# Read the content of the input file
$template = Get-Content -Path lib/$templatefile -Raw
$envFile = "clusters/$env/.env"
$outputPath = Join-Path -Path "clusters/$env" -ChildPath $outputfile
$outputDirectory = Split-Path -Path $outputPath -Parent

if (-not (Test-Path -Path $outputDirectory -PathType Container)) {
    New-Item -Path $outputDirectory -ItemType Directory -Force | Out-Null
}

# Read the .env file line by line
Get-Content -Path $envFile | ForEach-Object {
    # Skip empty lines and comments
    if ($_ -match "^\s*#|^\s*$") { return }

    # Split the line into key and value
    $parts = $_ -split "=", 2
    $key = $parts[0].Trim()
    $value = $parts[1].Trim()

    # Set the environment variable
    #[System.Environment]::SetEnvironmentVariable($key, $value, [System.EnvironmentVariableTarget]::Process)
    $template = $template -replace "\$\{$key\}", $value

}

Set-Content -Path $outputPath -Value $template
