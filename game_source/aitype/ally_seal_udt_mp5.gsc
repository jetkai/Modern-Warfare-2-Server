// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_seal_udt_MP5 (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
defaultmdl="body_seal_udt_assault_a"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
FORCESPAWN -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for FORCESPAWN guys
PERFECTENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
DONTSHAREENEMYINFO -- do not get shared info about enemies at spawn time from teammates
*/
main()
{
	self.animTree = "";
	self.additionalAssets = "";
	self.team = "allies";
	self.type = "human";
	self.subclass = "regular";
	self.accuracy = 0.2;
	self.health = 150;
	self.secondaryweapon = "";
	self.sidearm = "beretta";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	if ( isAI( self ) )
	{
		self setEngagementMinDist( 256.000000, 0.000000 );
		self setEngagementMaxDist( 768.000000, 1024.000000 );
	}

	self.weapon = "mp5";

	switch( codescripts\character::get_random_character(2) )
	{
	case 0:
		character\character_seal_udt_assault_a::main();
		break;
	case 1:
		character\character_seal_udt_smg::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\character_seal_udt_assault_a::precache();
	character\character_seal_udt_smg::precache();

	precacheItem("mp5");
	precacheItem("beretta");
	precacheItem("fraggrenade");
}
