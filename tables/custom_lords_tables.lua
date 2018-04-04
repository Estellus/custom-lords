faction_lord_types = {
	SCHEMA = {"key", "faction_type", "lord_type", "lord_type_name"},
	KEY = {"key", "LIST"},
	DATA = {
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "dlc07_brt_prophetess_beasts", "Prophetess (Beasts)"},
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "dlc07_brt_prophetess_heavens", "Prophetess (Heavens)"},
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "dlc07_brt_prophetess_life", "Prophetess (Life)"},
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "brt_lord", "Lord"},

        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_lord", "Chaos Lord"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_sorcerer_lord_death", "Chaos Sorcerer Lord (Death)"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_sorcerer_lord_fire", "Chaos Sorcerer Lord (Fire)"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_sorcerer_lord_metal", "Chaos Sorcerer Lord (Metal)"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "dlc07_chs_sorcerer_lord_shadow", "Chaos Sorcerer Lord (Shadows)"},

        {"wh_dlc03_sc_bst_beastmen", "SUBCULTURE", "dlc03_bst_beastlord", "Beastlord"},

        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "dlc05_wef_ancient_treeman", "Ancient Treeman"},
        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "dlc05_wef_glade_lord", "Glade Lord"},
        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "dlc05_wef_glade_lord_fem", "Glade Lord"},

        {"wh_main_sc_dwf_dwarfs", "SUBCULTURE", "dwf_lord", "Lord"},
        {"wh_main_sc_dwf_dwarfs", "SUBCULTURE", "dlc06_dwf_runelord", "Runelord"},

        {"wh_main_sc_grn_greenskins", "SUBCULTURE", "dlc06_grn_night_goblin_warboss", "Night Goblin Warboss"},
        {"wh_main_sc_grn_greenskins", "SUBCULTURE", "grn_goblin_great_shaman", "Goblin Great Shaman"},
        {"wh_main_sc_grn_greenskins", "SUBCULTURE", "grn_orc_warboss", "Orc Warboss"},

        {"wh_main_sc_grn_savage_orcs", "SUBCULTURE", "dlc06_grn_night_goblin_warboss", "Night Goblin Warboss"},
        {"wh_main_sc_grn_savage_orcs", "SUBCULTURE", "grn_goblin_great_shaman", "Goblin Great Shaman"},
        {"wh_main_sc_grn_savage_orcs", "SUBCULTURE", "grn_orc_warboss", "Orc Warboss"},

        {"wh_main_sc_emp_empire", "SUBCULTURE", "emp_lord", "General of the Empire"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "dlc04_emp_arch_lector", "Arch Lector"},

        {"wh_main_sc_ksl_kislev", "SUBCULTURE", "ksl_lord", "Lord"},

        {"wh_main_sc_nor_norsca", "SUBCULTURE", "nor_marauder_chieftain", "Marauder Chieftain"},
        {"wh_main_sc_nor_norsca", "SUBCULTURE", "nor_sorcerer_lord_metal", "Chaos Sorcerer Lord (Metal)"},

        {"wh_main_sc_teb_teb", "SUBCULTURE", "teb_lord", "Lord"},

        {"wh_main_sc_vmp_vampire_counts", "SUBCULTURE", "vmp_lord", "Vampire Lord"},
        {"wh_main_sc_vmp_vampire_counts", "SUBCULTURE", "vmp_master_necromancer", "Master Necromancer"},

        {"wh2_dlc09_sc_tmb_tomb_kings", "SUBCULTURE", "wh2_dlc09_tmb_tomb_king", "Tomb King"},

        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_main_def_dreadlord", "Dreadlord (Sword & Crossbow)"},
        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_main_def_dreadlord_fem", "Dreadlord (Sword & Shield)"},

        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_prince", "Prince"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_princess", "Princess"},

        {"wh2_main_sc_lzd_lizardmen", "SUBCULTURE", "wh2_main_lzd_saurus_old_blood", "Saurus Oldblood"},
        {"wh2_main_sc_lzd_lizardmen", "SUBCULTURE", "wh2_main_lzd_slann_mage_priest", "Slann Mage-Priest"},

        {"wh2_main_sc_skv_skaven", "SUBCULTURE", "wh2_main_skv_grey_seer_plague", "Grey Seer (Plague)"},
        {"wh2_main_sc_skv_skaven", "SUBCULTURE", "wh2_main_skv_grey_seer_ruin", "Grey Seer (Ruin)"},
        {"wh2_main_sc_skv_skaven", "SUBCULTURE", "wh2_main_skv_warlord", "Warlord"}
    }
}

lord_types = {
	SCHEMA = {"key", "skill_set", "skill_set_name", "default_skill_set"},
	KEY = {"key", "LIST"},
	DATA = {
        {"wh2_main_hef_prince", "wh2_main_trait_hef_prince_melee", "Melee", "TRUE"},
        {"wh2_main_hef_prince", "wh2_main_trait_hef_prince_magic", "Magic", "FALSE"},
        {"wh2_main_hef_princess", "wh2_main_trait_hef_princess_ranged", "Ranged", "TRUE"},
        {"wh2_main_hef_princess", "wh2_main_trait_hef_princess_magic", "Magic", "FALSE"}
    }
}

skill_set_skills = {
	SCHEMA = {"key", "skill_set_skill"},
	KEY = {"key", "LIST"},
	DATA = {
        {"wh2_main_trait_hef_prince_melee", "wh2_main_skill_hef_combat_graceful_strikes"},
        {"wh2_main_trait_hef_prince_melee", "module_wh2_main_skill_hef_combat_graceful_strikes"},
        {"wh2_main_trait_hef_prince_melee", "wh_main_skill_all_all_self_foe-seeker"},
        {"wh2_main_trait_hef_prince_melee", "module_wh_main_skill_all_all_self_foe-seeker"},
        {"wh2_main_trait_hef_prince_melee", "wh_main_skill_all_all_self_deadly_onslaught"},
        {"wh2_main_trait_hef_prince_magic", "wh2_main_skill_all_magic_high_02_apotheosis"},
        {"wh2_main_trait_hef_prince_magic", "module_wh2_main_skill_all_magic_high_02_apotheosis"},
        {"wh2_main_trait_hef_prince_magic", "wh_main_skill_all_magic_all_06_evasion"},
        {"wh2_main_trait_hef_prince_magic", "module_wh_main_skill_all_magic_all_06_evasion"},
        {"wh2_main_trait_hef_prince_magic", "wh_main_skill_all_magic_all_11_arcane_conduit"}
    }
}

traits = {
	SCHEMA = {"key", "trait_cost"},
	KEY = {"key", "UNIQUE"},
	DATA = {
        {"wh2_main_trait_defeated_teclis", "-2"},
        {"wh2_main_trait_defeated_tyrion", "-2"},
        {"wh2_main_skill_innate_all_aggressive", "-1"},
        {"wh2_main_skill_innate_all_confident", "-1"},
        {"wh2_main_skill_innate_all_cunning", "-1"},
        {"wh2_main_skill_innate_all_determined", "-1"},
        {"wh2_main_skill_innate_all_disciplined", "-1"},
        {"wh2_main_skill_innate_all_fleet_footed", "-1"},
        {"wh2_main_skill_innate_all_intelligent", "-1"},
        {"wh2_main_skill_innate_all_knowledgeable", "-1"},
        {"wh2_main_skill_innate_all_perceptive", "-1"},
        {"wh2_main_skill_innate_all_strategist", "-1"},
        {"wh2_main_skill_innate_all_strong", "-1"},
        {"wh2_main_skill_innate_all_tactician", "-1"},
        {"wh2_main_skill_innate_all_tough", "-1"},
        {"wh2_main_skill_innate_all_weapon_master", "-1"},
        {"wh2_main_trait_increased_cost", "1"}
    }
}

trait_incidents = {
	SCHEMA = {"key", "incident_key"},
	KEY = {"key", "LIST"},
	DATA = {
        {"wh2_main_trait_increased_cost", "wh2_main_incident_treasury_down_one_k"}
    }
}