const io = require('socket.io')(3000, {
    cors: {
        origin: '*',  // Allow connections from any origin
        methods: ['GET', 'POST']
    }
});

io.on('connect', (socket) => {
    console.log(`Client connected: ${socket.id}`);

    // Function to send notifications to connected clients
    socket.on('sendNotification', (data) => {
        // Emit the notification to all connected clients
       io.emit('receiveNotification', data);
        console.log(`receiveNotification: ${JSON.stringify(data)}`);
    });

    socket.on('disconnect', () => {
        console.log(`Client disconnected: ${socket.id}`);
    });
});
