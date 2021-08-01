#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;

init()
{
	thread onplayerconnect();
}

onplayerconnect()
{
	level waittill("connecting", player);
	if(sessionmodeisonlinegame() && isVictisMap() && level.scr_zm_ui_gametype_group == "zclassic")
	{
		player thread onplayerspawned();
	}
		
}

onplayerspawned()
{
	self endon( "disconnect" );
	flag_wait("initial_blackscreen_passed");
	
	persistent_upgrades = array("pers_boarding", "pers_revivenoperk", "pers_multikill_headshots", "pers_cash_back_bought", "pers_cash_back_prone", "pers_insta_kill", "pers_jugg", "pers_carpenter", "pers_perk_lose_counter", "pers_pistol_points_counter", "pers_double_points_counter", "pers_sniper_counter", "pers_box_weapon_counter");
	
	if(level.script == zm_buried)
		persistent_upgrades = combinearrays(persistent_upgrades, array("pers_flopper_counter"));
	
	have_all_upgrades = 1;

	foreach(pers_perk in persistent_upgrades)
	{
		upgrade_value = self getdstat("playerstatslist", pers_perk, "StatValue");
		if(upgrade_value == 0)
		{
			maps/mp/zombies/_zm_stats::increment_client_stat(pers_perk, 0);
			have_all_upgrades = 0;
		}	
	}
		 
	if(have_all_upgrades == 0)
	{
		self iprintln("^4github.com/HuthTV ^7- Persistent Upgrades Awarded");
		wait 2;
		self iprintln("^1Restarting Game!");
		wait 5;
		map_restart(0);
	}

	
	if(have_all_upgrades && self.account_value < 250)
	{
		self maps/mp/zombies/_zm_stats::set_map_stat("depositBox", 250, level.banking_map);
		self.account_value = 250;
		self iprintln("^4github.com/HuthTV ^7- Bank Filled");
	}
}

isVictisMap()
{
	switch(level.script)
	{
		case "zm_transit":
		case "zm_highrise":
		case "zm_buried":
			return true;
		default:
			return false;
	}	
}
