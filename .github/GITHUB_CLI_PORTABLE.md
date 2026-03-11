# GitHub CLI Portable Configuration

Tu GitHub CLI portátil está ubicado en: `C:/tools/bin/gh.exe`

## Uso Rápido

### Verificar instalación
```powershell
Test-Path C:/tools/bin/gh.exe
```

### Ver estado de autenticación
```powershell
C:/tools/bin/gh.exe auth status
```

### Crear y publicar repositorio
```powershell
cd tu-servicio-aqui
C:/tools/bin/gh.exe repo create alvarodiaz-dev/nombre-repo `
  --public `
  --source=. `
  --remote=origin `
  --push
```

## Alternativa: Crear un Alias (Opcional)

Para dejar de escribir la ruta completa cada vez, puedes crear un alias en PowerShell:

### 1. Abrir tu perfil de PowerShell
```powershell
notepad $PROFILE
```

### 2. Agregar esta línea
```powershell
Set-Alias -Name gh -Value "C:/tools/bin/gh.exe"
```

### 3. Guardar y recargar
```powershell
& $PROFILE
```

### 4. Ahora puedes usar simplemente `gh`
```powershell
gh auth status
gh repo create alvarodiaz-dev/service-name --public --source=. --remote=origin --push
```

## Configuración Global de Git

Asegúrate de que git esté configurado:

```powershell
git config --global user.name "Alvaro Diaz"
git config --global user.email "alvarodiaz.dev@example.com"
git config --global --list  # Verificar
```

## Troubleshooting

### ¿"gh not found"?
```powershell
# Verifica que existe
Test-Path C:/tools/bin/gh.exe

# Si no existe, descarga desde https://github.com/cli/cli/releases
```

### ¿No autenticado?
```powershell
C:/tools/bin/gh.exe auth login
# Sigue las instrucciones en pantalla
```

### ¿Repositorio ya existe?
```powershell
# Elimina primero
C:/tools/bin/gh.exe repo delete alvarodiaz-dev/nombre

# O usa otro nombre
C:/tools/bin/gh.exe repo create alvarodiaz-dev/nuevo-nombre --public --source=. --remote=origin --push
```

## Scripts de Ejemplo

### Script: Publicar un Servicio
```powershell
param(
    [string]$ServiceName,
    [string]$ServicePath
)

$gh = "C:/tools/bin/gh.exe"
$repoName = $ServiceName.ToLower() -replace "service", "-service"

Write-Host "📦 Publishing $ServiceName..."
cd $ServicePath

# Initialize git if needed
if (-not (Test-Path ".git")) {
    git init
    git add .
    git commit -m "Initial commit: $ServiceName"
}

# Create and push
& $gh repo create "alvarodiaz-dev/$repoName" `
  --public `
  --source=. `
  --remote=origin `
  --push

Write-Host "✅ Published to https://github.com/alvarodiaz-dev/$repoName"
```

Uso:
```powershell
./publish-service.ps1 -ServiceName "UserService" -ServicePath "./UserService"
```

### Script: Publicar Múltiples Servicios
```powershell
$gh = "C:/tools/bin/gh.exe"

$services = @(
    @{Name="UserManagementService"; Path="./generated/UserManagementService"},
    @{Name="OrderProcessingService"; Path="./generated/OrderProcessingService"},
    @{Name="InventoryService"; Path="./generated/InventoryService"}
)

foreach ($service in $services) {
    $repoName = $service.Name.ToLower() -replace "service", "-service"
    
    Write-Host "`n📦 Publishing $($service.Name)..."
    Push-Location $service.Path
    
    # Initialize and commit
    if (-not (Test-Path ".git")) {
        git init
        git config user.email "alvarodiaz.dev@example.com"
        git config user.name "Alvaro Diaz"
        git add .
        git commit -m "Initial commit: $($service.Name) microservice"
    }
    
    # Create and push
    & $gh repo create "alvarodiaz-dev/$repoName" `
      --public `
      --source=. `
      --remote=origin `
      --push
    
    Pop-Location
    Write-Host "✅ Published: https://github.com/alvarodiaz-dev/$repoName"
}

Write-Host "`n🎉 All services published!"
```

## Referencias

- [GitHub CLI Documentation](https://cli.github.com/manual)
- [GitHub CLI Releases](https://github.com/cli/cli/releases)
- Tu cuenta: https://github.com/alvarodiaz-dev
