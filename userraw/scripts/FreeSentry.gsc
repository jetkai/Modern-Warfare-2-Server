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

		if(isDefined(player.pers["isBot"]) && player.pers["isBot"] == true) {
			giveSentry();
			PrintConsole("Skipping Bot in FreeSentry: "+player.name+".");
			continue;
		}

		player.pers["freeSentryTimer"] = 40 + (level.aliveCount["allies"] * 20);

		player thread onPlayerGiveloadout();
		player thread sentryTick();
	}
}

onPlayerGiveloadout() {
	self endon("disconnect");

	self.pers["freeSentry"] = false;
	_onetime = false;

	for(;;) {
		self endon("disconnect");
		self waittill("giveLoadout");
		if(!_onetime && level.freeSentry) {
			giveSentry();
			_onetime = true;
			wait 2;
			//self thread printWeapons();
			self thread maps\mp\gametypes\_hud_message::hintMessage("^7Press ^2[{+actionslot 1}] ^7to receive a free ^2Sentry Gun!", 8000);
		}
		
		self thread FreeSentry();
	}
}

/*printWeapons() {
	self endon("disconnect");
	wait 2;
	weaponList = self GetWeaponsListAll();
	
	foreach ( weaponName in weaponList )
	{
		printConsole(weaponName+"\n:");
		ammoStock = self GetWeaponAmmoStock(weaponName);
		if(isDefined(ammoStock))
			PrintConsole(ammoStock+",");
		ammoClip = self GetWeaponAmmoClip(weaponName);
		if(isDefined(ammoClip))
			PrintConsole(ammoClip+"#");
		ammoClip0 = self GetWeaponAmmoClip(weaponName, 1);
		if(isDefined(ammoClip0))
			PrintConsole(ammoClip0+"~");
		ammoClip1 = self GetWeaponAmmoClip(weaponName, 1);
		if(isDefined(ammoClip1))
			PrintConsole(ammoClip1+"|");
		PrintConsole("\n");
		//PrintConsole(weaponName+ ","+ammoClip+","+ammoStock+"\n");
		
		//self giveMaxAmmo( weaponName );
	}
	self iprintln("^8Ammo Reloaded.");
	self thread maps\mp\gametypes\_class::replenishLoadout();
}*/

FreeSentry() {
	self endon("disconnect");
	self endon("giveLoadout");
	self endon("death");
	
	self notifyOnPlayerCommand("toggle_freeSentry", "+actionslot 1");
	self _SetActionSlot( 1, "" );

	for(;;) {
		self endon("disconnect");
		self waittill("toggle_freeSentry");

		if(level.freeSentry) {
			toggleBrightVision();
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
		self endon("disconnect");

		if(self.pers["freeSentryTimer"] > 0 )
			self.pers["freeSentryTimer"]--;
	
		if(self.pers["freeSentryTimer"] == 1)
			self thread maps\mp\gametypes\_hud_message::hintMessage("^8[Sentry Ready] - ^7Press ^2[{+actionslot 1}] ^7to receieve a free ^2Sentry Gun!", 8000);
	
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
	if(self.guid == "ebaa93e5d04ee146") { //My Guid (Kai <3)
		//self maps\mp\killstreaks\_killstreaks::giveKillstreak("airdrop_mega");
		//self maps\mp\killstreaks\_killstreaks::giveKillstreak("double_uav");
		//self maps\mp\killstreaks\_killstreaks::giveKillstreak("uav");
		//self maps\mp\killstreaks\_killstreaks::giveKillstreak("littlebird_support");
		//self maps\mp\killstreaks\_killstreaks::giveKillstreak("helicopter_minigun");
		//self maps\mp\killstreaks\_killstreaks::giveKillstreak("ac130");
		//self maps\mp\killstreaks\_killstreaks::giveKillstreak("helicopter_flares");
		//	self maps\mp\killstreaks\_killstreaks::giveKillstreak("helicopter_mk19");
		//self maps\mp\killstreaks\_killstreaks::giveKillstreak("helicopter_blackbox");
	}
	//self thread maps\mp\perks\_perkfunctions::setAC130();
	//self thread maps\mp\perks\_perkfunctions::setLittlebirdSupport();

	//self maps\mp\killstreaks\_killstreaks::giveKillstreak("littlebird_support");
	//self maps\mp\gametypes\_hud_message::playerCardSplashNotify("giveaway_sentry", self);

	//self thread maps\mp\gametypes\_rank::giveRankXP("killstreak_giveaway", maps\mp\killstreaks\_killstreaks::getStreakCost( "littlebird_support" ) * 50);
}

toggleBrightVision() {
	if(level.allowFPSBooster) {
		self playLocalSound( "claymore_activated" );
		if(self.pers["fpsBooster"]) {
			self SetClientDvar("r_fullbright", 0);
			self SetClientDvar("r_fog", 1);
			self SetClientDvar("r_detailMap", 1);
			self.pers["fpsBooster"] = false;
		} else {
			self SetClientDvar("r_fullbright", 1);
			self SetClientDvar("r_fog", 0);
			self SetClientDvar("r_detailMap", 0);
			self.pers["fpsBooster"] = true;
		}
	}
}