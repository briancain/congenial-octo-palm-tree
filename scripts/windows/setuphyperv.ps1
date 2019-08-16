Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install vscode vagrant docker-for-windows -y

DISM /Online /Enable-Feature /All /NoRestart /FeatureName:Microsoft-Hyper-V
