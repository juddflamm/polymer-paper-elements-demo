var processUniqueUuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
	var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
	return v.toString(16);
});

var Hapi = require('hapi');
var server = new Hapi.Server(80);

server.route([
	{
		method: 'GET',
		path: '/puid',
		handler: function (request, reply) {
			reply(processUniqueUuid);
		}
	},
	{
		method: 'GET',
		path: '/{path*}',
		handler: {
			directory: { path: '.', listing: false, index: true }
		}
	}
]);

server.start(function () {
	console.log('Hapi server running at:', server.info.uri);
});
