# DisasterNet Testing Guide

## Quick Start Testing

### Step 1: Start Both Backend Nodes

**Terminal 1 - Node 1 (Port 3001):**
```powershell
cd backend
node server.js --port 3001
```

**Terminal 2 - Node 2 (Port 3002):**
```powershell
cd backend
# Copy the bootstrap command from Node 1's output
node server.js --port 3002 --bootstrap /ip4/127.0.0.1/tcp/[PORT]/p2p/[PEER_ID]
```

### Step 2: Start Frontend

**Terminal 3:**
```powershell
cd frontend
npm run dev
```

### Step 3: Open Browser Windows

- **Window 1**: `http://localhost:5173` (or `http://localhost:5173?port=3001`)
- **Window 2**: `http://localhost:5173?port=3002`

### Step 4: Test Sending Messages

1. Type a message in Window 1 and send it
2. Type a message in Window 2 and send it
3. Watch both windows - messages should appear!

## Testing APIs Directly

### Check Connection Status

**Node 1:**
```powershell
Invoke-RestMethod -Uri http://localhost:3001/status
```

**Node 2:**
```powershell
Invoke-RestMethod -Uri http://localhost:3002/status
```

### Check Messages

**Node 1:**
```powershell
Invoke-RestMethod -Uri http://localhost:3001/messages
```

**Node 2:**
```powershell
Invoke-RestMethod -Uri http://localhost:3002/messages
```

### Send Messages

**To Node 1:**
```powershell
Invoke-RestMethod -Uri http://localhost:3001/send -Method POST -ContentType "application/json" -Body '{"message":"Hello from PowerShell!"}'
```

**To Node 2:**
```powershell
Invoke-RestMethod -Uri http://localhost:3002/send -Method POST -ContentType "application/json" -Body '{"message":"Hello from PowerShell!"}'
```

### Try Manual Reconnection (Node 2 only)

```powershell
Invoke-RestMethod -Uri http://localhost:3002/reconnect -Method POST
```

## What to Watch For

✅ **Success Indicators:**
- `🤝 Peer Connected:` in terminal
- `📨 Received P2P message:` in terminal
- Messages appearing in both frontend windows
- Connection count > 0 in `/status` endpoint

⚠️ **Expected Warnings:**
- `❌ Failed to dial bootstrap peer` - This is OK, nodes will discover each other
- `⚠️ No peers connected yet` - Messages are stored, waiting for connection

## Troubleshooting

If messages aren't sharing:
1. Check `/status` endpoint on both nodes
2. Look for `🤝 Peer Connected` messages in terminals
3. Wait a bit - pubsub mesh discovery can take time
4. Try sending more messages - sometimes triggers connection
5. Restart both nodes and try again

## API Endpoints

- `GET /messages` - Get all messages
- `POST /send` - Send a message (body: `{"message": "your text"}`)
- `GET /status` - Get connection status and peer info
- `POST /reconnect` - Manually retry bootstrap connection (Node 2 only)

