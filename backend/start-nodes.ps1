# DisasterNet - Start Both Nodes
# This script starts both Node 1 and Node 2 in separate PowerShell windows

Write-Host "Starting DisasterNet nodes..." -ForegroundColor Green
Write-Host ""

# Start Node 1 in a new window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; Write-Host '=== NODE 1 (Port 3001) ===' -ForegroundColor Cyan; node server.js --port 3001"

# Wait a moment
Start-Sleep -Seconds 2

# Start Node 2 in a new window  
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; Write-Host '=== NODE 2 (Port 3002) ===' -ForegroundColor Yellow; node server.js --port 3002"

Write-Host "✅ Both nodes are starting in separate windows!" -ForegroundColor Green
Write-Host ""
Write-Host "Watch for:" -ForegroundColor Cyan
Write-Host "  • 🔍 MDNS peer discovery enabled" -ForegroundColor White
Write-Host "  • 🌐 WebSocket transport enabled" -ForegroundColor White
Write-Host "  • 🔍 Discovered peer messages" -ForegroundColor White
Write-Host "  • ✅ Successfully connected messages" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit this window (nodes will keep running)..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

