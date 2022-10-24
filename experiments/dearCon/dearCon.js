const dear = require('dear');
const Connect = require('connect-js');

var connect = new Connect({
    projectId: 'c1cdc858-3e40-4bbf-af3d-06b80e925e1f',
    apiKey: 'deaf27d6-befd-1ea4-8f1c-87de82664f67'
});

connect.get('register', function(){

	var token = req.params.access_token;
	var network = req.params.network;

	dear( network )
	.api('me', {
		access_token: token
	})
	.then(function(response){

		var email = response.email;

		// do something with the verified email address
	});

});
