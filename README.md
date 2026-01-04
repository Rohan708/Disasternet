# DisasterNet 🌐

A peer-to-peer emergency communication network that works without internet connectivity. Built with libp2p, React, and Node.js.

## 🎯 Features

- **No Internet Required** - Works on local network via P2P connections
- **Real-time Messaging** - Send and receive messages across connected nodes
- **Automatic Peer Discovery** - MDNS automatically finds peers on local network
- **Web Interface** - Beautiful React frontend for easy communication
- **REST API** - Full API for programmatic access

## ⚠️ Current Limitation

**P2P connections are currently blocked** due to a bug in libp2p v3. See [KNOWN_LIMITATIONS.md](./KNOWN_LIMITATIONS.md) for details.

**What Works:**
- ✅ Nodes start and run successfully
- ✅ HTTP APIs fully functional
- ✅ MDNS peer discovery
- ✅ Messages stored locally
- ✅ Frontend works locally

**What Doesn't Work:**
- ❌ Direct peer-to-peer connections
- ❌ Message sharing between nodes

## 🚀 Quick Start

### Prerequisites

- Node.js (v18 or higher)
- npm

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/DisasterNet.git
   cd DisasterNet
   ```

2. **Install backend dependencies:**
   ```bash
   cd backend
   npm install
   ```

3. **Install frontend dependencies:**
   ```bash
   cd ../frontend
   npm install
   ```

### Running

1. **Start Node 1:**
   ```bash
   cd backend
   node server.js --port 3001
   ```

2. **Start Node 2 (in another terminal):**
   ```bash
   cd backend
   node server.js --port 3002
   ```
   *Note: Bootstrap is optional - MDNS will auto-discover peers*

3. **Start Frontend:**
   ```bash
   cd frontend
   npm run dev
   ```

4. **Open in browser:**
   - Node 1: `http://localhost:5173` (or port shown by Vite)
   - Node 2: `http://localhost:5173?port=3002`

## 📡 API Endpoints

### Node 1 (Port 3001) / Node 2 (Port 3002)

- `GET /messages` - Get all messages
- `POST /send` - Send a message
  ```json
  {
    "message": "Your message here"
  }
  ```
- `GET /status` - Get connection status and peer info
- `POST /reconnect` - Manually retry bootstrap connection (Node 2 only)

## 🧪 Testing

See [TESTING_GUIDE.md](./TESTING_GUIDE.md) for detailed testing instructions.

Quick test:
```powershell
# Check status
Invoke-RestMethod -Uri http://localhost:3001/status

# Send message
$body = @{message='Hello!'} | ConvertTo-Json
Invoke-RestMethod -Uri http://localhost:3002/send -Method POST -ContentType 'application/json' -Body $body

# Check messages
Invoke-RestMethod -Uri http://localhost:3001/messages
```

## 🏗️ Architecture

- **Backend**: Node.js + Express + libp2p
- **Frontend**: React + TypeScript + Vite + Tailwind CSS
- **P2P**: libp2p with GossipSub, MDNS, WebSocket, TCP
- **Services**: Identify, Ping, Pubsub

## 📦 Dependencies

### Backend
- `libp2p` - P2P networking
- `@chainsafe/libp2p-gossipsub` - Pubsub messaging
- `@libp2p/mdns` - Peer discovery
- `@libp2p/websockets` - WebSocket transport
- `express` - HTTP API

### Frontend
- `react` - UI framework
- `vite` - Build tool
- `tailwindcss` - Styling

## 🔧 Configuration

### Backend Port
```bash
node server.js --port 3001
```

### Bootstrap Peer (Optional)
```bash
node server.js --port 3002 --bootstrap /ip4/127.0.0.1/tcp/PORT/p2p/PEER_ID
```

### Frontend Backend Port
Add `?port=3002` to URL or set environment variable.

## 📝 Documentation

- [KNOWN_LIMITATIONS.md](./KNOWN_LIMITATIONS.md) - Current issues and workarounds
- [TESTING_GUIDE.md](./TESTING_GUIDE.md) - How to test the system
- [TEST_DOWNGRADE.md](./backend/TEST_DOWNGRADE.md) - Testing libp2p version downgrade

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Built with [libp2p](https://libp2p.io/)
- UI components with [React](https://react.dev/)
- Icons from [Lucide](https://lucide.dev/)

---

**Status**: ⚠️ In Development - P2P connections pending libp2p bug fix

