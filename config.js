var ConfigObject = function() {
	var self = this;
	
	this.Ranks = [
		{ // [0] will always be default, everyone has
			Title: "Regular",
			Perms: ["guid", "smhelp"]
		},
		{
			Title: "Trusted",
			Users: [],
			Perms: ["rmstart", "rmstop", "rmrestart"]
		},
		{
			Title: "Mod",
			Users: [],
			Perms: ["kick"]
		},
		{
			Title: "Admin",
			Users: [], // "license:ssdfgskjdbkljgdlfjdl;sffl;dsjfl;ksdjflk" 
			Perms: ["i:Mod", "i:Trusted", "ban"] // i:<Title> includes perms from them.
		},
	];
	
	this.help = false;
	this.source = 0;
	this.Commands = {
		smhelp: () => {
			if (self.help)
				return;
			
			var props = Object.getOwnPropertyNames(self.Commands);
			
			emitNet('chatMessage', self.source, "Help", [0, 255, 0], "== Help ==");
			self.help = true; // All commands will output help text.
			for(var i = 0; i < props.length; i++) {
				self.Commands[props[i]]();
			}
			self.help = false;
			emitNet('chatMessage', self.source, "Help", [0, 255, 0], "== Help ==");
		},
		guid: () => {
			if (self.help) {
				emitNet('chatMessage', self.source, "Help", [0, 255, 0], "/guid [Get your GUID (Steam id)]"); return;
			}
			emitNet('chatMessage', self.source, 'GUID', [0, 255, 0], 'Use in Users Array: ' + GetPlayerIdentifier(self.source));
			emitNet('chatMessage', self.source, 'GUID', [0, 255, 0], 'Perms: ' + Rank.getPermsByID(GetPlayerIdentifier(self.source)));
		},
		kick: (id, reason) => {
			if (self.help) {
				emitNet('chatMessage', self.source, "Help", [0, 255, 0], '/kick <id> "<reason>" [Kick ID]'); return;
			}
			
			if (id != null && reason != null) {
				DropPlayer(id, reason);
			} else if (id != null && reason == null) {
				DropPlayer(id, "Droped by ServerManagement");
			} else {
				emitNet('chatMessage', self.source, "Kick", [0, 255, 0], 'Invaild args');
			}
		},
		ban: (id, reason) => {
			if (self.help) {
				emitNet('chatMessage', self.source, "Help", [0, 255, 0], '/ban <id> "<reason>" [Ban ID]'); return;
			}
			
			if (id != null && reason != null) {
				TempBanPlayer(id, reason);
			} else if (id != null && reason == null) {
				TempBanPlayer(id, "Banned by ServerManagement");
			} else {
				emitNet('chatMessage', self.source, "Band", [0, 255, 0], 'Invaild args');
			}
		},
		rmstart: (resource) => {
			if (self.help) {
				emitNet('chatMessage', self.source, "Help", [0, 255, 0], '/rmstart <resourcename> [Start resource]'); return;
			}
			
			if (resource != null) {
				StartResource(resource);
			} else {
				emitNet('chatMessage', self.source, "ResourceManager", [0, 255, 0], 'Invaild args');
			}
			console.log(resource);
		},
		rmstop: (resource) => {
			if (self.help) {
				emitNet('chatMessage', self.source, "Help", [0, 255, 0], '/rmstop <resourcename> [Stop resource]'); return;
			}
			
			if (resource != null) {
				console.log(StopResource(resource));
			} else {
				emitNet('chatMessage', self.source, "ResourceManager", [0, 255, 0], 'Invaild args');
			}
		},
		rmrestart: (resource) => {
			if (self.help) {
				emitNet('chatMessage', self.source, "Help", [0, 255, 0], '/rmrestart <resourcename> [Restart resource]'); return;
			}
			
			if (resource != null) {
				StopResource(resource);
				StartResource(resource);
			} else {
				emitNet('chatMessage', self.source, "ResourceManager", [0, 255, 0], 'Invaild args');
			}
		}
	}
}

var Config = new ConfigObject();

function addCommand(name, func) { // Should work? Didn't test. Everything else is dynamic. To change command can use .addCommand(oldfunc, (param, parm) => { do something here });
	Config.Commands[name] = func;
} // exports.TrainSportation.addCommand(name, func);