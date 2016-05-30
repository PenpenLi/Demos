ResourceConfig = {
	plist={
		-- "flash/bear.plist", 	
		-- "flash/fox.plist", 		
		-- "flash/horse.plist", 	
		-- "flash/frog.plist", 	
		-- "flash/cat.plist", 		
		-- "flash/chicken.plist", 	
		-- "flash/bird.plist", 	
		-- "flash/bird_ext.plist",
		-- "flash/game_props.plist",
		-- "flash/TileEffect.plist",
		-- "flash/mapTiles.plist",
		-- "flash/explode.plist",
		-- "flash/mapBaseItem.plist",
		-- "flash/destroy_effect.plist",		
		-- "flash/tile_select.plist",

		-- "materials/game_bg.plist",
		-- "materials/game_bg_activity.plist",

		"materials/head_images.plist",
		"materials/intermediate.plist",
		"materials/trunk.plist",
		"materials/trunkRoot.plist",
		"materials/trunkRootBackCloud.plist",
		"materials/anniversary_two_years.plist",

		-- "materials/home_color.plist",
		-- "materials/fruitTree.plist",
		
		"flash/scenes/homeScene/lockedCloud.plist",
		"flash/scenes/flowers/home_effects.plist",
		"flash/scenes/flowers/title_text.plist",
		"flash/scenes/flowers/branch_mask.plist",
		"flash/scenes/flowers/branch.plist",
		"flash/scenes/flowers/flower_effects.plist",
		"flash/scenes/flowers/target_icon.plist",

		"flash/gameguide/guidespanImage.plist",
		"flash/ladybug.plist",
	},

	asyncPlist={
		-- GamePlayScene
		"flash/bear.plist", 	
		"flash/fox.plist", 		
		"flash/horse.plist", 	
		"flash/frog.plist", 	
		"flash/cat.plist", 		
		"flash/chicken.plist", 	
		"flash/bird.plist", 	
		"flash/bird_ext.plist",
		"flash/game_props.plist",
		"flash/TileEffect.plist",
		"flash/mapTiles.plist",
		"flash/explode.plist",
		"flash/mapBaseItem.plist",
		"flash/destroy_effect.plist",		
		"flash/tile_select.plist",

		"materials/game_bg.plist",
		"materials/game_bg_activity.plist",
		"materials/game_bg_AnniversaryTwoYears.plist",
		-- "materials/game_bg_weekly.plist",
		
		-- FruitScene
		"materials/fruitTree.plist",
	},
	
	json={
		"flash/scenes/homeScene/home.json",		
		"flash/gameguide/guideelem.json",
		"flash/scenes/flowers/ladybug.json",
		"flash/scenes/flowers/target_helper.json",
		"ui/common_ui.json",
		"ui/panel_game_start.json",
		"flash/common/properties.json",
		"flash/scenes/homeScene/homeScene.json",
		"flash/scenes/homeScene/home_icon.json",

		"flash/scenes/gamePlaySceneUI/gamePlaySceneUI.json",
	},
	skeleton={
		"skeleton/energy_animation",
		"skeleton/energy_animation_spring2016",
	},
	image={

	},
	sfx={
		"music/sound.DeadlineStep.mp3",
		"music/sound.Drop.mp3",
		"music/sound.create.color.mp3",
		"music/sound.create.strip.mp3",
		"music/sound.create.wrap.mp3",
		"music/sound.eliminate.color.mp3",
		"music/sound.eliminate.strip.mp3",
		"music/sound.eliminate.wrap.mp3",
		"music/sound.EliminateTip.mp3",
		"music/sound.frosint.break.mp3",
		"music/sound.ice.break.mp3",
		"music/sound.Keyboard.mp3",
		"music/sound.PopupClose.mp3",
		"music/sound.PopupOpen.mp3",
		"music/sound.clipStar.mp3",
		"music/sound.star.light.mp3",
		"music/sound.Swap.mp3",
		"music/sound.SwapFun.mp3",
		"music/sound.bonus.time.mp3",
		"music/sound.swap.colorcolor.swap.mp3",
		"music/sound.swap.colorcolor.cleanAll.mp3",
		"music/sound.swap.colorline.mp3",
		"music/sound.swap.lineline.mp3",
		"music/sound.swap.wrapline.mp3",
		"music/sound.swap.wrapwrap.mp3",

		"music/sound.contnuousMatch.3.mp3",
		"music/sound.contnuousMatch.5.mp3",
		"music/sound.contnuousMatch.7.mp3",
		"music/sound.contnuousMatch.9.mp3",
		"music/sound.contnuousMatch.11.mp3",

		"music/sound.Eliminate1.mp3",
		"music/sound.Eliminate2.mp3",
		"music/sound.Eliminate3.mp3",
		"music/sound.Eliminate4.mp3",
		"music/sound.Eliminate5.mp3",
		"music/sound.Eliminate6.mp3",
		"music/sound.Eliminate7.mp3",
		"music/sound.Eliminate8.mp3",
		"music/sound.roost0.mp3",
		"music/sound.roost1.mp3",
		"music/sound.roost2.mp3",
		"music/sound.roost3.mp3",
		"music/sound.balloon.break.mp3",
		"music/sound.balloon.runaway.mp3",
		"music/sound.tileBlocker.turn.mp3",
		"music/sound.fireworks.mp3",
		"music/sound.blessing.mp3",
		"music/sound.weekly.boss.hit.mp3",
		"music/sound.hedgehogbox.open.mp3",
		"music/sound.hedgehog.crazy.mp3",
		"music/sound.hedgehog.crazymove.mp3",

		--春节相关音效 用于1.30版本 之后版本可删
		"music/sound.spring_firework1.mp3",
		"music/sound.spring_firework2.mp3",
		"music/sound.spring_firework3.mp3",
		"music/sound.spring_firework4.mp3",
		"music/sound.spring_firework5.mp3",
		"music/sound.wukong.casting.mp3",
		-- "music/sound.spring_firework_triple.mp3",

	},
	mp3={
		"music/sound.WorldSceneBGM.mp3",
		
		--春节相关音效 用于1.30版本 之后版本可删
		"music/sound.spring_bg_music.mp3",
	}
}

ResourceConfigPixelFormat = {}
ResourceConfigPixelFormat["materials/game_bg.plist"] = kCCTexture2DPixelFormat_RGB565
ResourceConfigPixelFormat["materials/game_bg_qixi.plist"] = kCCTexture2DPixelFormat_RGBA8888
ResourceConfigPixelFormat["materials/trunkRoot.plist"] = kCCTexture2DPixelFormat_RGB565
ResourceConfigPixelFormat["materials/logo.plist"] = kCCTexture2DPixelFormat_RGB565
ResourceConfigPixelFormat["materials/trunkRootBackCloud.plist"] = kCCTexture2DPixelFormat_RGBA4444
ResourceConfigPixelFormat["materials/fruitTree.plist"] = kCCTexture2DPixelFormat_RGB565
ResourceConfigPixelFormat["flash/scenes/flowers/branch_mask.plist"] = kCCTexture2DPixelFormat_A8
ResourceConfigPixelFormat["flash/tile_select.plist"] = kCCTexture2DPixelFormat_RGBA4444
ResourceConfigPixelFormat["flash/link_item.plist"] = kCCTexture2DPixelFormat_RGBA4444
ResourceConfigPixelFormat["flash/coin.plist"] = kCCTexture2DPixelFormat_RGBA4444
ResourceConfigPixelFormat["flash/mapSnow.plist"] = kCCTexture2DPixelFormat_RGBA4444
ResourceConfigPixelFormat["flash/mapLock.plist"] = kCCTexture2DPixelFormat_RGBA4444
ResourceConfigPixelFormat["flash/gameguide/guidespanImage.plist"] = kCCTexture2DPixelFormat_RGBA8888 
ResourceConfigPixelFormat["flash/scenes/homeScene/home.plist"] = kCCTexture2DPixelFormat_RGBA4444
ResourceConfigPixelFormat["flash/sand_move.plist"] = kCCTexture2DPixelFormat_RGBA4444
ResourceConfigPixelFormat["flash/destroy_effect.plist"] = kCCTexture2DPixelFormat_RGBA4444

ResourceFntPixelFormat = {}
ResourceFntPixelFormat["fnt/tutorial.fnt"] = kCCTexture2DPixelFormat_RGBA4444
ResourceFntPixelFormat["fnt/tutorial_white.fnt"] = kCCTexture2DPixelFormat_RGBA4444
ResourceFntPixelFormat["fnt/green_button.fnt"] = kCCTexture2DPixelFormat_RGBA4444
ResourceFntPixelFormat["fnt/zh_tw/green_button.fnt"] = kCCTexture2DPixelFormat_RGBA4444
ResourceFntPixelFormat["fnt/titles.fnt"] = kCCTexture2DPixelFormat_RGBA4444
ResourceFntPixelFormat["fnt/level_seq_upon_entering.fnt"] = kCCTexture2DPixelFormat_RGBA4444

ResourceArmaturePixelFormat = {}
ResourceArmaturePixelFormat["skeleton/timeback_animation"] = kCCTexture2DPixelFormat_RGBA4444

ResourceConfigTextureParam = {}
-- ResourceConfigTextureParam["materials/home_color.plist"] = true

PanelConfigFiles = {}
PanelConfigFiles.common_ui = "ui/common_ui.json"
PanelConfigFiles.panel_game_setting = "ui/panel_game_setting.json"
PanelConfigFiles.panel_with_keypad = "ui/panel_with_keypad.json"
PanelConfigFiles.BeginnerPanel = "ui/BeginnerPanel.json"
PanelConfigFiles.AskForEnergyPanel = "ui/AskForEnergyPanel.json"
PanelConfigFiles.bag_panel_ui = "ui/bag_panel_ui.json"
PanelConfigFiles.friend_ranking_panel = "ui/friend_ranking_panel.json"
PanelConfigFiles.choose_payment_panel = "ui/choose_payment_panel.json"
PanelConfigFiles.star_reward_panel = "ui/star_reward_panel.json"
PanelConfigFiles.lady_bug_panel = "ui/lady_bug_panel.json"
PanelConfigFiles.unlock_cloud_panel_new = "ui/unlock_cloud_panel_new.json"
PanelConfigFiles.invite_friend_reward_panel = "ui/invite_friend_reward_panel.json"
PanelConfigFiles.request_message_panel = "ui/request_message_panel.json"
PanelConfigFiles.panel_buy_prop = "ui/panel_buy_prop.json"
PanelConfigFiles.panel_buy_gold = "ui/panel_buy_gold.json"
PanelConfigFiles.buy_gold_items = "ui/BuyGoldItem.json"
PanelConfigFiles.panel_mark = "ui/panel_mark.json"
PanelConfigFiles.panel_energy_bubble = "ui/panel_energy_bubble.json"
PanelConfigFiles.panel_add_step = "ui/panel_add_step.json"
PanelConfigFiles.wdj_invite_reward_panel = "ui/wdj_invite_reward_panel.json"
PanelConfigFiles.panel_preprop_remind = "ui/panel_preprop_remind.json"
PanelConfigFiles.market_panel = "ui/market_panel.json"
PanelConfigFiles.properties = "flash/common/properties.json"
PanelConfigFiles.unlock_hidden_area_panel = "ui/unlock_hidden_area_panel.json"
PanelConfigFiles.update_new_version_panel = "ui/update_new_version_panel.json"
PanelConfigFiles.fruitTreeScene = "flash/scenes/fruitTreeScene/FruitTreeScene.json"
PanelConfigFiles.panel_fruit_tree = "ui/panel_fruit_tree.json"
PanelConfigFiles.panel_give_back = "ui/panel_give_back.json"
PanelConfigFiles.free_fcash_panel = "ui/free_fcash_panel.json"
PanelConfigFiles.panel_mark_prise = "ui/panel_mark_prise.json"
PanelConfigFiles.panel_game_start = "ui/panel_game_start.json"
PanelConfigFiles.more_star_panel = "ui/more_star_panel.json"
PanelConfigFiles.panel_nick_name = "ui/panel_nick_name.json"
PanelConfigFiles.panel_push_activity = "ui/panel_push_activity.json"
PanelConfigFiles.panel_mark_energy_notionce = "ui/panel_mark_energy_notionce.json"
PanelConfigFiles.panel_turntable = "ui/panel_turntable.json"
PanelConfigFiles.panel_rabbit_weekly_v2 = "ui/panel_rabbit_week_match.json" -- not use anymore since 1.25
PanelConfigFiles.recall_ui = "ui/RecallUI.json"
PanelConfigFiles.panel_ad_video = "ui/AdVideoPanel.json"
PanelConfigFiles.panel_buy_confirm = "ui/panel_buy_confirm.json"
PanelConfigFiles.panel_register = "ui/phone_register_panel.json"
PanelConfigFiles.qr_code_panel = "ui/qr_code_panel.json"
PanelConfigFiles.third_pay_guide_panel = "ui/third_pay_guide_panel.json"
PanelConfigFiles.ios_pay_cartoon_panel = "ui/ios_pay_guide_help.json"
PanelConfigFiles.two_choice_panel = "ui/TwoChoicePanel.json"
PanelConfigFiles.four_star_guid = "ui/four_star_guid.json"
PanelConfigFiles.star_achevement = "ui/star_achievement.json"
PanelConfigFiles.third_pay_show_priority_panel = "ui/third_pay_show_priority_panel.json"
PanelConfigFiles.mark_energy_remind_panel = "ui/MarkEnergyRemindPanel.json"
PanelConfigFiles.coin_info_panel = "ui/coin_info_panel.json"
PanelConfigFiles.unlock_guide_panel = "ui/unlock_guide_panel.json"
PanelConfigFiles.mission = "ui/mission_panel.json"
PanelConfigFiles.mission_1 = "ui/mission_panel_1.json"
PanelConfigFiles.mission_2 = "ui/mission_panel_2.json"
PanelConfigFiles.mission_manga = "ui/mission_manga.json"
PanelConfigFiles.mission_bugtips = "ui/mission_bugtips.json"
PanelConfigFiles.mission_rules = "ui/mission_rules.json"
PanelConfigFiles.panel_season_weekly_share = "ui/panel_season_weekly_share.json"
PanelConfigFiles.cd_key_exchange_panel = "ui/cd_key_exchange_panel.json"
PanelConfigFiles.jump_level_panel = "ui/jump_level_panel.json"
PanelConfigFiles.more_ingredient_panel = 'ui/more_ingredient_panel.json'
PanelConfigFiles.personal_center_panel = 'ui/personal_center_panel.json'
PanelConfigFiles.panel_game_start_activity = "ui/panel_game_start_spring2016.json"
PanelConfigFiles.panel_apple_paycode = "ui/panel_apple_paycode.json"
PanelConfigFiles.panel_confirm_buy_full_energy = "ui/panel_confirm_buy_full_energy.json"
PanelConfigFiles.two_years_gift_enegy = "ui/TwoYearsGiftEnegy.json"
PanelConfigFiles.weekly_race_promotion_panel = "ui/weekly_race_promotion_panel.json"