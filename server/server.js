onNet('chatMessage', (source, color, message) => {
	if (message.startsWith("/")) {
		message = message.substring(1);
		var args = message.match(/(".*?"|[^",\s]+)(?=\s* |\s*$)/g);
		var command = args.shift();
		var props = Object.getOwnPropertyNames(Config.Commands);
		
		if (props.includes(command)) {
			if (Rank.getPermsByID(GetPlayerIdentifier(source)).includes(command)) {
				Config.source = source;
				Config.Commands[command].apply(this, args);
				Config.source = 0;
			} else {
				emitNet('chatMessage', source, 'SM', [0, 255, 0], 'You don\'t have the permission to do this, or it doesn\'t exist');
			}
			CancelEvent();
		}
	}
});