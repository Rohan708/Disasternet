# DisasterNet - Known Limitations

## Current Status: ⚠️ P2P Connections Not Working

### Issue
Peer-to-peer connections between nodes are currently blocked due to a bug in libp2p v3.1.0.

**Error Message:**
```
EncryptionFailedError: At least one protocol must be specified
```

### What Works ✅
- ✅ Both nodes start and run successfully
- ✅ HTTP APIs are fully functional (ports 3001, 3002, etc.)
- ✅ MDNS peer discovery works (nodes find each other automatically)
- ✅ Messages are stored locally on each node
- ✅ Frontend can connect and send/receive messages locally
- ✅ All services initialize correctly (Identify, Ping, Pubsub)

### What Doesn't Work ❌
- ❌ Direct peer-to-peer connections fail
- ❌ Messages are NOT shared between nodes
- ❌ Bootstrap connections fail
- ❌ WebSocket transport also fails (same underlying bug)

### Technical Details

**libp2p Version:** ~~3.1.0~~ → **Testing 3.0.7** (downgraded to test if bug exists in earlier version)  
**Error Location:** `Upgrader._encryptOutbound`  
**Root Cause:** Protocol negotiation fails during connection encryption phase

**Attempted Solutions:**
1. ✅ Added ping service for basic protocol support
2. ✅ Added identify service for peer identification
3. ✅ Enabled MDNS for automatic peer discovery
4. ✅ Added WebSocket transport as alternative
5. ✅ Enabled autoDial for automatic connection retries
6. ❌ All connection attempts still fail with same error

### Workaround

**Current Workaround:**
- Messages are stored locally on each node
- Each node works independently
- Frontend can connect to any node and see local messages
- Messages will be shared automatically once the libp2p bug is fixed

**To Use:**
1. Start multiple nodes (they will discover each other via MDNS)
2. Send messages - they'll be stored locally
3. Check messages on each node separately
4. Once libp2p is fixed/upgraded, messages will automatically sync

### Future Fix

This is a known issue with libp2p v3.1.0. Potential solutions:
- Wait for libp2p team to fix the bug
- Downgrade to libp2p v2.x (if compatible)
- Use alternative P2P library
- Work around the encryption layer

### Testing

To test if connections are working:
```powershell
# Check status
Invoke-RestMethod -Uri http://localhost:3001/status
Invoke-RestMethod -Uri http://localhost:3002/status

# Send message
$body = @{message='Test'} | ConvertTo-Json
Invoke-RestMethod -Uri http://localhost:3002/send -Method POST -ContentType 'application/json' -Body $body

# Check if received
Invoke-RestMethod -Uri http://localhost:3001/messages
```

**Success Indicators:**
- `connectedPeers > 0` in status
- Messages appear on both nodes
- `🤝 Peer Connected:` in terminal logs
- `📨 Received P2P message:` in terminal logs

---

**Last Updated:** Current session  
**Status:** Issue persists, workaround in place

