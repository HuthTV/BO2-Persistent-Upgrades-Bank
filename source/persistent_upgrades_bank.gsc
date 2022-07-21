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
	while(true)
	{
		level waittill("connecting", player);
		if(sessionmodeisonlinegame() && isVictisMap() && level.scr_zm_ui_gametype_group == "zclassic")
		{
			player thread onplayerspawned();
		}
	}
	
		
}

onplayerspawned()
{
	self endon( "disconnect" );
	flag_wait("initial_blackscreen_passed");
	
	persistent_upgrades = array("pers_boarding",
								"pers_revivenoperk",
								"pers_multikill_headshots",
								"pers_cash_back_bought",
								"pers_cash_back_prone",
								"pers_insta_kill",
								"pers_jugg",
								"pers_carpenter",
								"pers_flopper_counter",
								"pers_perk_lose_counter",
								"pers_pistol_points_counter",
								"pers_double_points_counter",
								"pers_sniper_counter",
								"pers_box_weapon_counter",
								"pers_nube_counter"	);
	
	persistent_upgrade_values = [];
	persistent_upgrade_values["pers_boarding"] = 74;
	persistent_upgrade_values["pers_revivenoperk"] = 17;
	persistent_upgrade_values["pers_multikill_headshots"] = 5;
	persistent_upgrade_values["pers_cash_back_bought"] = 50;
	persistent_upgrade_values["pers_cash_back_prone"] = 15;
	persistent_upgrade_values["pers_insta_kill"] = 2;
	persistent_upgrade_values["pers_jugg"] = 3;
	persistent_upgrade_values["pers_carpenter"] = 1;
	persistent_upgrade_values["pers_flopper_counter"] = 1;
	persistent_upgrade_values["pers_perk_lose_counter"] = 3;
	persistent_upgrade_values["pers_pistol_points_counter"] = 1;
	persistent_upgrade_values["pers_double_points_counter"] = 1;
	persistent_upgrade_values["pers_sniper_counter"] = 1;
	persistent_upgrade_values["pers_box_weapon_counter"] = 5;
	persistent_upgrade_values["pers_nube_counter"] = 1;
	

	foreach(pers_perk in persistent_upgrades)
	{
 		if( getDvar( pers_perk ) == "" )
			setDvar( pers_perk, 1 );

		statVal = (getDvarInt(pers_perk) > 0) * persistent_upgrade_values[pers_perk];
		maps/mp/zombies/_zm_stats::set_client_stat(pers_perk, statVal );
	}	

	if( getDvar( "full_bank" ) == "" ) 
		setDvar( "full_bank", 1 );

	bank_points = (getDvarInt("full_bank") > 0) * 250;
	if(bank_points)
	{
		self maps/mp/zombies/_zm_stats::set_map_stat("depositBox", bank_points, level.banking_map);
		self.account_value = bank_points;
	}
	
	self iprintln("^4github.com/HuthTV ^7- Persistent Upgrades & Bank");
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
