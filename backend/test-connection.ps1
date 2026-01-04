# DisasterNet Connection Test Script
Write-Host "=== DisasterNet Connection Test ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Check Node Status
Write-Host "1. Checking Node Status..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Node 1 (Port 3001):" -ForegroundColor Green
try {
    $status1 = Invoke-RestMethod -Uri http://localhost:3001/status
    Write-Host "   Peer ID: $($status1.peerId.Substring(0, 12))..." -ForegroundColor White
    Write-Host "   Connected Peers: $($status1.connectedPeers)" -ForegroundColor $(if ($status1.connectedPeers -gt 0) { "Green" } else { "Red" })
    Write-Host "   Status: $($status1.status)" -ForegroundColor White
    Write-Host "   Messages: $($status1.messages)" -ForegroundColor White
} catch {
    Write-Host "   ❌ Node 1 is not running!" -ForegroundColor Red
}

Write-Host ""
Write-Host "Node 2 (Port 3002):" -ForegroundColor Green
try {
    $status2 = Invoke-RestMethod -Uri http://localhost:3002/status
    Write-Host "   Peer ID: $($status2.peerId.Substring(0, 12))..." -ForegroundColor White
    Write-Host "   Connected Peers: $($status2.connectedPeers)" -ForegroundColor $(if ($status2.connectedPeers -gt 0) { "Green" } else { "Red" })
    Write-Host "   Status: $($status2.status)" -ForegroundColor White
    Write-Host "   Messages: $($status2.messages)" -ForegroundColor White
} catch {
    Write-Host "   ❌ Node 2 is not running!" -ForegroundColor Red
}

Write-Host ""
Write-Host "2. Testing Message Sending..." -ForegroundColor Yellow
Write-Host ""

# Test 2: Send message from Node 2
Write-Host "Sending test message from Node 2..." -ForegroundColor Cyan
try {
    $sendResult = Invoke-RestMethod -Uri http://localhost:3002/send -Method POST -ContentType "application/json" -Body '{"message":"Hello from Node 2! Testing connection..."}'
    Write-Host "   ✅ Message sent!" -ForegroundColor Green
    Write-Host "   Local Only: $($sendResult.localOnly)" -ForegroundColor $(if ($sendResult.localOnly) { "Yellow" } else { "Green" })
    if ($sendResult.warning) {
        Write-Host "   Warning: $($sendResult.warning)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Failed to send message: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Waiting 5 seconds for message propagation..." -ForegroundColor Gray
Start-Sleep -Seconds 5

# Test 3: Check if Node 1 received the message
Write-Host ""
Write-Host "3. Checking if Node 1 received the message..." -ForegroundColor Yellow
Write-Host ""

try {
    $messages1 = Invoke-RestMethod -Uri http://localhost:3001/messages
    Write-Host "   Messages on Node 1:" -ForegroundColor Cyan
    foreach ($msg in $messages1) {
        if ($msg -like "*Node 2*" -or $msg -like "*3002*") {
            Write-Host "   ✅ $msg" -ForegroundColor Green
        } else {
            Write-Host "   • $msg" -ForegroundColor White
        }
    }
    
    $hasNode2Message = $messages1 | Where-Object { $_ -like "*Node 2*" -or $_ -like "*3002*" }
    if ($hasNode2Message) {
        Write-Host ""
        Write-Host "   🎉 SUCCESS! Messages are being shared between nodes!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "   ⚠️  Node 1 did not receive the message from Node 2" -ForegroundColor Yellow
        Write-Host "   This means peers are not connected yet." -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Failed to get messages: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "4. Final Status Check..." -ForegroundColor Yellow
Write-Host ""

try {
    $status1 = Invoke-RestMethod -Uri http://localhost:3001/status
    $status2 = Invoke-RestMethod -Uri http://localhost:3002/status
    
    Write-Host "   Node 1 Connected Peers: $($status1.connectedPeers)" -ForegroundColor $(if ($status1.connectedPeers -gt 0) { "Green" } else { "Red" })
    Write-Host "   Node 2 Connected Peers: $($status2.connectedPeers)" -ForegroundColor $(if ($status2.connectedPeers -gt 0) { "Green" } else { "Red" })
    
    if ($status1.connectedPeers -gt 0 -or $status2.connectedPeers -gt 0) {
        Write-Host ""
        Write-Host "   ✅ Nodes are connected!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "   ⚠️  Nodes are not connected yet" -ForegroundColor Yellow
        Write-Host "   Check the node terminal windows for:" -ForegroundColor Gray
        Write-Host "     • 🔍 Discovered peer messages" -ForegroundColor Gray
        Write-Host "     • ✅ Successfully connected messages" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ❌ Could not check final status" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Test Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host 'Press any key to exit...' -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

