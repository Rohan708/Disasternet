# Testing libp2p Downgrade

## Current Test
- **Previous Version:** libp2p 3.1.0 (had connection bug)
- **Testing Version:** libp2p 3.0.7 (earlier v3 release)

## Steps to Test

1. **Stop all running nodes** (Ctrl+C in both terminal windows)

2. **Restart both nodes:**
   ```powershell
   # Terminal 1
   node server.js --port 3001
   
   # Terminal 2  
   node server.js --port 3002
   ```

3. **Watch for:**
   - ✅ `🔍 Discovered peer:` - MDNS discovery
   - ✅ `🤝 Peer Connected:` - **SUCCESS!**
   - ✅ `📨 Received P2P message:` - Messages sharing

4. **Test message sharing:**
   ```powershell
   # Send from Node 2
   $body = @{message='Test from Node 2'} | ConvertTo-Json
   Invoke-RestMethod -Uri http://localhost:3002/send -Method POST -ContentType 'application/json' -Body $body
   
   # Check Node 1
   Invoke-RestMethod -Uri http://localhost:3001/messages
   ```

5. **Check connection status:**
   ```powershell
   (Invoke-RestMethod -Uri http://localhost:3001/status).connectedPeers
   (Invoke-RestMethod -Uri http://localhost:3002/status).connectedPeers
   ```

## Expected Results

**If 3.0.7 works:**
- `connectedPeers > 0`
- Messages appear on both nodes
- `🤝 Peer Connected:` in logs

**If 3.0.7 still has bug:**
- `connectedPeers = 0`
- Messages only local
- Same error messages

## Next Steps if 3.0.7 Fails

Try:
- libp2p 3.0.6
- libp2p 3.0.5
- Or check if we need different noise package

