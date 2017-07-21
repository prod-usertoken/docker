'use strict';

var Gun = require('gun');
var http = require('http');
var port = process.env.PORT || 9000;
var fs = require('fs');

// Listens on /gun.js route.
var server = http.Server();

// Serves up /index.html
server.on('request', function (req, res) {
	if(Gun.serve(req, res)){ return }
	if (req.url === '/' || req.url === '/index.html') {
		fs.createReadStream('index.html').pipe(res);
	}
});

var gun = Gun({
	file: 'data.json', // Saves all data to `data.json`.
	web: server // Handles real-time requests and updates.
});

server.listen(port, function () {
	console.log('\nApp listening on port', port);
});
