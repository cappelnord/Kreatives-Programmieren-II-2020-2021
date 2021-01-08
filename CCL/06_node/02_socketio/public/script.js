var socket = io();

var box = document.getElementById("box");

box.addEventListener('mousemove', function(e) {
	socket.emit('message', {x: e.clientX, y: e.clientY});
});