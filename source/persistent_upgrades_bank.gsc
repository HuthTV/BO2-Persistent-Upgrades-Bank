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
	
	persistent_upgrades = array("pers_revivenoperk", "pers_multikill_headshots", "pers_insta_kill", "pers_jugg", "pers_perk_lose_counter", "pers_sniper_counter", "pers_box_weapon_counter");
	
	persistent_upgrade_values = [];
	persistent_upgrade_values["pers_revivenoperk"] = 17;
	persistent_upgrade_values["pers_multikill_headshots"] = 5;
	persistent_upgrade_values["pers_insta_kill"] = 2;
	persistent_upgrade_values["pers_jugg"] = 3;
	persistent_upgrade_values["pers_perk_lose_counter"] = 3;
	persistent_upgrade_values["pers_sniper_counter"] = 1;
	persistent_upgrade_values["pers_box_weapon_counter"] = 5;
	persistent_upgrade_values["pers_flopper_counter"] = 1;
	
	
	if(level.script == zm_buried)
		persistent_upgrades = combinearrays(persistent_upgrades, array("pers_flopper_counter"));
	
	have_all_upgrades = 1;

	foreach(pers_perk in persistent_upgrades)
	{
		upgrade_value = self getdstat("playerstatslist", pers_perk, "StatValue");
		if(upgrade_value != persistent_upgrade_values[pers_perk])
		{
			maps/mp/zombies/_zm_stats::set_client_stat(pers_perk, persistent_upgrade_values[pers_perk]);
			have_all_upgrades = 0;
		}	
	}
		 
	if(have_all_upgrades == 0)
	{
		self iprintln("^4github.com/HuthTV ^7- Persistent Upgrades Awarded");
	}
	
	if(self.account_value < 250)
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
