#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {	
	level thread onPlayerConnect();
}

onPlayerConnect() {
	for(;;) {
		level waittill( "connected", player);
		if(isDefined(player.pers["isBot"]) && player.pers["isBot"] == true)
			continue;

		player thread thirdPersonToggle();
	}
}

thirdPersonToggle() {
	self endon ( "disconnect" );
	self notifyOnPlayerCommand( "thirdperson", "mp_quickmessage" );

	self createBottomCenterMessageElem();
	self createTopLeftMessageElem();
	
	for ( ;; )	{
		self waittill( "thirdperson" );
		self.isThirdPerson = !self.isThirdPerson;
		//self setClientDvar( "camera_thirdPerson", self.isThirdPerson); 	//CHEAT PROTECED (Only Global SetDvar() available)
		//self setClientDvar( "camera_thirdPersonAdsTransSc", "2"); 		//CHEAT PROTECED
		//self setClientDvar( "camera_thirdPersonFovScale", "0.9");			//CHEAT PROTECED
		//self setClientDvar( "camera_thirdPersonOffset", "-120 0 14");		//CHEAT PROTECED
		//self setClientDvar( "camera_thirdPersonOffsetAds", "-60 -20 4");	//CHEAT PROTECED
		//self setClientDvar( "camera_thirdPersonOffsetTurr", "-80 0 14");	//CHEAT PROTECED
		self setClientDvar( "cg_thirdPerson", self.isThirdPerson );
		self setThirdPersonDOF( self.isThirdPerson );
	}
}

createBottomCenterMessageElem() {
	messageElem = self createFontString( "default", 1.25 );
	messageElem setPoint( "CENTER", "BOTTOM", 0, -20 );
	messageElem setText( "^:Press \"B\" to toggle Third-Person | Press \"5\" to toggle Cut-Killstreaks" );
	messageElem fadeovertime(1);
	self thread destroyEle( messageElem );
}

createTopLeftMessageElem() {
	messageElem = self createFontString( "default", 1.25 );
	messageElem setPoint( "TOPLEFT", "TOPLEFT", 0, 200 );
	
	messageElem setText( 
		
		"^9 Recent Updates (April 10th, 2022)\n\n" +
		"  * Riot shield classes receive 2 Cut-Perks:\n" + 
		"    > Deadmans Hand (C4 Death)\n" + 
		"    > Armour Vest (Jugg)\n" + 
		"  * Cut-Killstreaks are included within Care Packages\n" + 
		"  * AA12 Extended Mags have increased ammo capacity\n"
	
	);

	//messageElem fadeovertime(1);
	messageElem thread pulse_fx();
	self thread destroyEle( messageElem );
}

pulse_fx()
{
	self endon( "death" );
	self endon( "disconnect" );
	credits_speed = 40.5;
	//self.alpha = 0;
	//wait credits_speed * .08;
	
//	self FadeOverTime( 0.2 );
	//self.alpha = 1;
	self SetPulseFX( 50, int( credits_speed * .6 * 1000 ), 500 );	
}


destroyEle( hudElem ) {
	self endon ( "disconnect" );

	wait 14;

	hudElem fadeovertime(1);
	hudElem.alpha = 0;

	wait 3;
	
	hudElem destroy();
}