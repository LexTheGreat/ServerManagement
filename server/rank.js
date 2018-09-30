var RankObject = function() {
	var self = this;
	
	this.getRankByTitle = function(_t) {
		for(var i = 0; i < Config.Ranks.length; i++)
			if (Config.Ranks[i].Title == _t)
				return Config.Ranks[i]
	}
	
	this.isRank = function(title, id) {
		return self.getRankByTitle(title).Users.includes(id);
	}
	
	this.getPermsByID = function(id) {
		var permList = [];
		var addList = [];
		var simpLoopCheck = [];
		
		if (self.cache.myPerms.length > 0) // Don't need to do the below more than once. If we do, we can just reset myPerms and it will do the stuff again.
			return self.cache.myPerms;
		
		permList = Config.Ranks[0].Perms;
		
		for(var i = 1; i < Config.Ranks.length; i++)
			if (Config.Ranks[i].Users.includes(id))
				permList = Config.Ranks[i].Perms.concat(permList);
		
		var refInst = true; // Used to redo the loop when a new perm set is concated into the permlist
		while (refInst) {
			refInst = false
			for(i = permList.length-1; i >= 0; i--) {
				if (permList[i].includes("i:")) {
					if (!simpLoopCheck.includes(permList[i])) {
						var rankTitle = permList[i].substring(2);
						var rankObject = self.getRankByTitle(rankTitle);
						if (rankObject != null) {
							addList = addList.concat(rankObject.Perms); // Add It's perms to the list.
							permList.splice(i, 1); // Remove the i:<Title>
						}
						
						simpLoopCheck.push(permList[i]) // mem this so we don't loop
					} else {
						console.log("ServerManagement Perm Error! Already refrences this rank! ", rankTitle)
						permList.splice(i, 1);
					}
				}
			}
			
			if (addList.length > 0) {
				refInst = true;
				permList = permList.concat(addList);
				addList = [];
			}
		}
		
		self.cache.myPerms = permList;		
		return self.cache.myPerms;
	}
	
	this.hasPerm = function(perm, id) {
		return self.getPermsByID(id).includes(perm);
	}
	
	
	this.cache = {
		myPerms: [] // Store so we don't do math all the time.
	}
}

var Rank = new RankObject();