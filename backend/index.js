const express = require('express');
const socketIO = require('socket.io');

const app = express();
const port = 3900

const server = app.listen(port,()=>{
  console.log('Server Running on ${port}');

})
const io = socketIO(server)
io.on('connection',(socket)=>{
  console.log('New connection: ${socket.id}');

    socket.on('disconnect',()=>{
      console.log('Client Disconnected: ${socket.id}')
    })
    socket.on('chat',(data)=>{
      console.log(data);
      socket.broadcast.emit('chat',data)
    })
})
