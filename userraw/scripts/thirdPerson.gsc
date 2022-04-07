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
		setDvar( "camera_thirdPerson", !getDvarInt( "camera_thirdPerson" ) );
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