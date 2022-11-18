extends Node

enum UpgradeType {
	BiggerServer,
	ActivityBreakpoint,
	BetterClicks,
    AutoSpawn
}

enum UpgradeId {
	BiggerServer1,
	BiggerServer2,
	LessActivityBreakpoint1,
	LessActivityBreakpoint2,
	BetterClicks1,
	BetterClicks2,
    AutoSpawn1,
    AutoSpawn2
}

var UPGRADE_DATA = {
	UpgradeId.BiggerServer1 : {
		"name" : "Bigger Server",
		"id" : UpgradeId.BiggerServer1,
		"type" : UpgradeType.BiggerServer,
		"data" : 50,
		"description" : "There has been a bit of activity, and the developer thinks he can afford a slightly bigger server.",
		"effect" : "+50 maximum gikos",
		"unlockedBy" : []
	},
	UpgradeId.BiggerServer2 : {
		"name" : "Bigger Server 2",
		"id" : UpgradeId.BiggerServer2,
		"type" : UpgradeType.BiggerServer,
		"data" : 100,
		"description" : "There's just so much activity these days, the people want a bigger server. The developer will just have to get a second job.",
		"effect" : "+100 maximum gikos",
		"unlockedBy" : [UpgradeId.BiggerServer1]
	},
	UpgradeId.LessActivityBreakpoint1 : {
		"name" : "Lower Activity Required",
		"id" : UpgradeId.LessActivityBreakpoint1,
		"type" : UpgradeType.ActivityBreakpoint,
		"data" : 0.25,
		"description" : "The developer is really into coding at the moment, and will require less activity to consider upgrades. Probably trying to escape from personal problems.",
		"effect" : "-25% Activity Required to Upgrade",
		"unlockedBy" : []
	},
	UpgradeId.LessActivityBreakpoint2 : {
		"name" : "Lower Activity Required 2",
		"id" : UpgradeId.LessActivityBreakpoint2,
		"type" : UpgradeType.ActivityBreakpoint,
		"data" : 0.25,
		"description" : "The developer must have quit their job, because they're now requiring even less activity to get started on upgrading the site.",
		"effect" : "-50% Activity Required to Upgrade",
		"unlockedBy" : [UpgradeId.LessActivityBreakpoint1]
	},
	UpgradeId.BetterClicks1 : {
		"name" : "Better Clicks",
		"id" : UpgradeId.BetterClicks1,
		"type" : UpgradeType.BetterClicks,
		"data" : 1,
		"description" : "You're clicking so much, you're bound to get better at it at some point, right?",
		"effect" : "+1 Spawned Giko On Click",
		"unlockedBy" : []
	},
	UpgradeId.BetterClicks2 : {
		"name" : "Better Clicks 2",
		"id" : UpgradeId.BetterClicks2,
		"type" : UpgradeType.BetterClicks,
		"data" : 1,
		"description" : "Click better. Get more gikos. Easy.",
		"effect" :  "+1 Spawned Giko On Click",
		"unlockedBy" : [UpgradeId.BetterClicks1]
	},
    UpgradeId.AutoSpawn1 : {
        "name" : "Activate Auto Spawn",
        "id" : UpgradeId.AutoSpawn1,
        "type" : UpgradeType.AutoSpawn,
        "data" : 1,
        "description" : "People are visiting the site, and that attracts more visitors curious to witness the weird chinese cat chatroom.",
        "effect" : "Activate Auto Spawn ( +1 Giko/s)",
        "unlockedBy" : []
    },
    UpgradeId.AutoSpawn2 : {
        "name" : "Better Auto Spawn",
        "id" : UpgradeId.AutoSpawn2,
        "type" : UpgradeType.AutoSpawn,
        "data" : 0.5,
        "description" : "The site is really gaining traction. More and more visitors are coming to admire the tiles.",
        "effect" : "Better Auto Spawn (+1 Giko/s)",
        "unlockedBy" : [UpgradeId.AutoSpawn1]
    }
}
