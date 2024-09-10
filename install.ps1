# Script d'installation de logiciels sur Windows
# Pré-requis : Lancer PowerShell en tant qu'Administrateur

# Désactiver les restrictions d'exécution de scripts PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force

# Vérifier si Chocolatey est déjà installé
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installation de Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey est déjà installé."
}

# Mettre à jour Chocolatey
choco upgrade chocolatey -y

# Installer Anaconda
Write-Host "Installation de Anaconda Distribution..."
choco install anaconda3 -y

# Ajouter Anaconda au PATH
$envPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
if (-not $envPath.Contains("C:\ProgramData\Anaconda3")) {
    Write-Host "Ajout de Anaconda au PATH..."
    [System.Environment]::SetEnvironmentVariable("PATH", "$envPath;C:\ProgramData\Anaconda3", [System.EnvironmentVariableTarget]::Machine)
}

# Installer Docker Desktop
Write-Host "Installation de Docker..."
choco install docker-desktop -y

# Lancer Docker après l'installation
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Vérification de Docker Compose (inclus avec Docker Desktop)
Write-Host "Vérification de Docker Compose..."
docker-compose --version

# Installer Tableau
Write-Host "Installation de Tableau..."
choco install tableau -y

# Installer Visual Studio Code (VSCode)
Write-Host "Installation de VSCode..."
choco install vscode -y

# Installer Discord
Write-Host "Installation de Discord..."
choco install discord -y

# Installer Minikube
Write-Host "Installation de Minikube..."
choco install minikube -y

# Installer Git
Write-Host "Installation de Git..."
choco install git -y

# Installer Google Chrome
Write-Host "Installation de Google Chrome..."
choco install googlechrome -y

# Installer Mozilla Firefox
Write-Host "Installation de Mozilla Firefox..."
choco install firefox -y

# Vérification de la configuration Python (Anaconda) et installation de Jupyter
Write-Host "Configuration de Python et Jupyter..."
$pythonPath = "C:\ProgramData\Anaconda3\python.exe"
$condaPath = "C:\ProgramData\Anaconda3\Scripts\conda.exe"

if (Test-Path $pythonPath) {
    Write-Host "Python est installé via Anaconda."
} else {
    Write-Host "Erreur : Python n'est pas installé."
    exit 1
}

if (Test-Path $condaPath) {
    Write-Host "Installation de Jupyter Notebook..."
    & $condaPath install jupyter -y
} else {
    Write-Host "Erreur : Conda n'est pas trouvé."
    exit 1
}

Write-Host "Installation terminée avec succès ! Redémarre ta machine pour finaliser les installations."

# Activer WSL (Windows Subsystem for Linux)
Write-Host "Activation de WSL..."
wsl --install -d Ubuntu

# Installer la fonctionnalité Windows Subsystem for Linux si non activée
if (-not (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Enabled") {
    Write-Host "Installation de la fonctionnalité WSL..."
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -All
}

# Installer la fonctionnalité Machine Virtuelle nécessaire pour WSL 2
if (-not (Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State -eq "Enabled") {
    Write-Host "Installation de la fonctionnalité VirtualMachinePlatform..."
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -All
}

# Redémarrer la machine pour activer les fonctionnalités WSL 2
Write-Host "Redémarrage nécessaire pour terminer l'installation de WSL 2..."
Restart-Computer -Force
