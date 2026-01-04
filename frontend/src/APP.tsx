import { AlertTriangle, Send } from 'lucide-react'
import React, { useEffect, useState } from 'react'

function App() {
  const [messages, setMessages] = useState([])
  const [message, setMessage] = useState('')
  
  // Get backend port from URL parameter, default to 3001
  // Usage: http://localhost:5173?port=3002
  const getBackendPort = () => {
    const urlParams = new URLSearchParams(window.location.search)
    return urlParams.get('port') || '3001'
  }
  
  const backendPort = getBackendPort()
  const backendUrl = `http://localhost:${backendPort}`

  useEffect(()=>{
    const interval = setInterval(()=>{
      fetch(`${backendUrl}/messages`)
      .then(res=>res.json())
      .then(data => {
        console.log(data)
        setMessages(data)
      })
      .catch(err => console.error('Failed to fetch messages:', err))
    }, 2000)
    return ()=> clearInterval(interval)
  },[backendUrl])

  const sendMessage = async () => {
    if (message.trim() === '') return

    try {
      await fetch(`${backendUrl}/send`,{
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body: JSON.stringify({message:message}),
      })
      setMessage('')
    } catch (error) {
      console.error('Failed to send message:', error)
      alert('Failed to send message. Make sure the backend is running.')
    }
  }

  return (
    <div className='min-h-screen w-full flex flex-col justify-center items-center bg-gradient-to-tr from-violet-950 to-violet-500'>
      <div className='flex flex-col h-[80vh] sm:w-[80vw] lg:w-[60vw] border-4 border-black rounded-3xl overflow-hidden my-8'>
        <div className='flex h-[10%] bg-red-700'>
          <div className='my-auto ml-4'>
            <AlertTriangle className="text-yellow-400 w-12 h-12" />
          </div>
          <div className='text-white ml-4 my-2'>
            <p className='text-3xl font-bold'>DisasterNet (No Internet Required)</p>
            <p className='text-md'>Emergency Communication Network - Backend: {backendPort}</p>
          </div>
        </div>

        {/* MESSAGES SECTION */}
        <div className='h-[80%] bg-slate-700 px-6 py-4 overflow-y-auto space-y-2'>
          {Array.isArray(messages) ? (
            messages.map((msg, idx) => (
              <div key={idx} className='text-white bg-slate-800 px-4 py-2 rounded-md'>
                {msg}
              </div>
            ))
          ) : (
            <div className="text-red-400">No messages available</div>
          )}
        </div>

        {/* INPUT SECTION */}
        <div className='h-[10%] bg-slate-800 flex items-center px-6'>
          <input
            type='text'
            placeholder='Type your message here...'
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            className='w-full p-2 rounded-lg bg-slate-600 text-white'
          />
          <button onClick={sendMessage} className='ml-4'>
            <Send className='text-gray-300 w-8 h-8' />
          </button>
        </div>
      </div>
    </div>
  )
}

export default App