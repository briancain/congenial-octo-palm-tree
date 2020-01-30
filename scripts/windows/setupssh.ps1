# Check if it's installed
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Start-Service sshd
# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Disable firewall :shrug:
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Confirm the Firewall rule is configured. It should be created automatically by setup
#Get-NetFirewallRule -Name *ssh*
# There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled
# If the firewall does not exist, create one
#New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
