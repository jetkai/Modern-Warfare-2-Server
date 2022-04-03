#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {	
	setDvarIfUninitialized( "scr_free_sentry", true );
	level.freeSentry = getDvarInt("scr_free_sentry");

	level thread onPlayerConnect();
}

onPlayerConnect() {
	for(;;) {
		level waittill( "connected", player);

		player thread onPlayerGiveloadout();
		player thread sentryTick();
	}
}

onPlayerGiveloadout() {
	self endon("disconnect");

	self.pers["freeSentry"] = false;
	_onetime = false;

	for(;;) {
		self waittill("giveLoadout");
		if(!_onetime && level.freeSentry) {
			self.pers["freeSentryTimer"] = 40 + (level.aliveCount["allies"] * 20);
			giveSentry();
			_onetime = true;

			self thread maps\mp\gametypes\_hud_message::hintMessage("^7Press ^2[{+actionslot 1}] ^7to receive a free ^2Sentry Gun!", 4000);
		}
		
		self thread FreeSentry();
	}
}

FreeSentry() {
	self endon("disconnect");
	self endon("giveLoadout");
	self endon("death");
	
	self notifyOnPlayerCommand("toggle_freeSentry", "+actionslot 1");
	self _SetActionSlot( 1, "" );

	for(;;) {
		self waittill("toggle_freeSentry");

		if(level.freeSentry) {
			giveLittleBird();
			if(self.pers["freeSentryTimer"] == 0) {
				giveSentry();
			} else {
				self iPrintlnBold("You must wait " + self.pers["freeSentryTimer"] + " seconds to spawn another free ^2Sentry Gun.");
			}
		}
	}
}

sentryTick() {
	self endon("disconnect");

	while(self.connected) {
		if(self.pers["freeSentryTimer"] > 0 ) {
			self.pers["freeSentryTimer"]--;
		}
		if(self.pers["freeSentryTimer"] == 1) {
			self thread maps\mp\gametypes\_hud_message::hintMessage("^8[Sentry Ready] - ^7Press ^2[{+actionslot 1}] ^7to receieve a free ^2Sentry Gun!", 8000);
		}

		wait 1;
	}
}

giveSentry() {
	self.pers["freeSentryTimer"] = 40 + (level.aliveCount["allies"] * 20);

	self maps\mp\killstreaks\_killstreaks::giveKillstreak("sentry");
	self maps\mp\gametypes\_hud_message::playerCardSplashNotify("giveaway_sentry", self);

	self thread maps\mp\gametypes\_rank::giveRankXP("killstreak_giveaway", maps\mp\killstreaks\_killstreaks::getStreakCost( "sentry" ) * 50);
}

giveLittleBird() {
	PrintConsole("My Name: " + self.owner.name);
	//self thread maps\mp\perks\_perkfunctions::setAC130();
	//self thread maps\mp\perks\_perkfunctions::setLittlebirdSupport();

	//self maps\mp\killstreaks\_killstreaks::giveKillstreak("littlebird_support");
	//self maps\mp\gametypes\_hud_message::playerCardSplashNotify("giveaway_sentry", self);

	//self thread maps\mp\gametypes\_rank::giveRankXP("killstreak_giveaway", maps\mp\killstreaks\_killstreaks::getStreakCost( "littlebird_support" ) * 50);
}