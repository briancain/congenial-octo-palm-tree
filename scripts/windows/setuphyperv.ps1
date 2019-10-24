Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install vscode docker-for-windows -y

choco install vagrant -y

DISM /Online /Enable-Feature /All /NoRestart /FeatureName:Microsoft-Hyper-V
