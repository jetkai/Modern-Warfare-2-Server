#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {	
	level thread onPlayerConnect();
}

onPlayerConnect() {
	for(;;) {
		level waittill( "connected", player);

		player thread thirdPersonToggle();
	}
}

thirdPersonToggle() {
	self endon ( "disconnect" );
	self notifyOnPlayerCommand( "thirdperson", "mp_quickmessage" );
	
	thirdPersonElem = self createFontString( "default", 1.25 );
	thirdPersonElem setPoint( "CENTER", "BOTTOM", 0, -20 );
	thirdPersonElem setText( "^:Press \"B\" to toggle Third-Person | Press \"5\" to toggle Cut-Killstreaks" );
	thirdPersonElem fadeovertime(1);

	self thread destroyEle( thirdPersonElem );
	
	for ( ;; )
	{
		self waittill( "thirdperson" );
		self.isThirdPerson = !self.isThirdPerson;
	//	self iprintlnbold(self.isThirdPerson + ".");
		//self setClientDvar( "camera_thirdPerson", self.isThirdPerson);
		//self setClientDvar( "camera_thirdPersonAdsTransSc", "2");
		//self setClientDvar( "camera_thirdPersonFovScale", "0.9");
		//self setClientDvar( "camera_thirdPersonOffset", "-120 0 14");
		//self setClientDvar( "camera_thirdPersonOffsetAds", "-60 -20 4");
		//self setClientDvar( "camera_thirdPersonOffsetTurr", "-80 0 14");
		//self setClientDvar( "scr_thirdperson", self.isThirdPerson);
		//self setClientDvar("cg_thirdPerson", self.isThirdPerson);
		//self setClientDvar("cg_thirdPersonMode", "Free"); 
		self setClientDvar( "cg_thirdPerson", self.isThirdPerson );
		self setThirdPersonDOF( self.isThirdPerson );
	}
}

destroyEle( hudElem ) {
	self endon ( "disconnect" );

	wait 8;

	hudElem fadeovertime(1);
	hudElem.alpha = 0;

	wait 3;
	
	hudElem destroy();
}