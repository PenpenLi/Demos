module("BattleModuleRequire",package.seeall)
local BATTLE 						= "script/battle/"
local BATTLE_DATA 					= BATTLE.."data/"

-- require 
function requireAllModules( ... )
	-------------------------------preload module --------------------------------
	local startTime =  os.clock()
	require "script/module/main/MainScene"
	
	require "script/utils/extern"
	require "script/utils/LuaUtil"
	-- require "script/battle/lib/tween"
	require "db/DB_Item_hero_fragment"

	require "db/DB_Heroes"
	require "db/DB_Monsters"
	require "db/DB_Monsters_tmpl"
	require "db/DB_Stronghold"
 	require "db/DB_KeyFramesInfo"
 	require "db/battleShow"
 	require "db/battleEndShow"
 	require "db/battlingShow"
 	-- require "db/TexturesMergerMap"

	
 	require "script/module/talk/TalkCtrl"
    require "script/model/DataCache"
    require "script/model/user/FormationModel" 
    require "db/DB_Team"
    require "script/utils/LuaUtil"
    require "script/module/public/class"
	require "script/module/config/AudioHelper"
	require "script/libs/LuaCC"
	require "script/battle/BattleState"
	require "script/battle/touch/BattleTouchMananger"
	

	require (BATTLE_DATA.."BattleLinkList")
 --    local endTime =  os.clock()
	-- print("*************** db cost:",endTime - startTime)

	-- data = battleShow.indexLogicByArmyID(1)
	-- 	local startTime =  os.clock()
 --    local endTime =  os.clock()
	-- print("*************** db cost:",endTime - startTime)
	-------------------------------battle module --------------------------------

	-- startTime =  os.clock()
	require (BATTLE.."BATTLE_CONST")										--	战斗常量
	-- endTime =  os.clock()
	-- print("*************** BATTLE_CONST cost:",endTime - startTime)
	
	-- startTime =  os.clock()
	require (BATTLE.."BattleLayerManager")									--	战斗层级
	require (BATTLE.."BattleURLManager")									--	战斗相关URL
	require (BATTLE.."dataproxy/BattleDataProxy")							--	战斗相关URL

	require (BATTLE_DATA.."BattleMainData")
	require "script/battle/BATTLE_CLASS_NAME"
	require "script/battle/BattleFactory"
	require "script/battle/BattleTeamDisplayModule"							--  队伍显示
	require "script/battle/BattleShipDisplayModule"							--  队伍显示
	
	require "script/battle/ObjectTool"
	require "script/battle/mediator/BattleLoadSourceMediator"
 										--	战斗日志
 	require "script/battle/data/SpriteFramesManager"
	-- require "script/battle/BattleSkillModule"								--  技能module
	require "script/battle/action/BattleActionRender"
	-- require (BATTLE_DATA .. "battleRecordData/BattleRecordSourcAnalyser")

	-- require "script/battle/team/BATTLE_STATES"

    require "script/battle/mediator/BattleBackGroundMediator"
    require "script/battle/mediator/BattleLoadSourceMediator"
    require "script/battle/mediator/BattleChestMediator"			-- 宝箱飞
  
    require "script/battle/BSTree/BattleNodeFactory"
    require "script/battle/sound/BattleSoundMananger"

	require ("script/battle/notification/EventBus")		
	require ("script/battle/notification/NotificationNames")	

	require (BATTLE_DATA.."BattleGridPostion")						-- 战斗各自位置

	require (BATTLE_DATA.."BattleDataUtil")							-- 战斗数据Util主要是英雄相关的操作

	 -- endTime =  os.clock()
	-- Logger.debug("*************** other1 cost:" .. endTime - startTime)

	-- startTime =  os.clock()
	require (BATTLE_DATA.."db_heroes_util")
	require (BATTLE_DATA.."db_army_util")
	require (BATTLE_DATA.."db_monsters_util")
	require (BATTLE_DATA.."db_monsters_tmpl_util")
	require (BATTLE_DATA.."db_stronghold_util")
	require (BATTLE_DATA.."db_hero_offset_util")
	require (BATTLE_DATA.."db_battlingShow_util")
	require (BATTLE_DATA.."db_activitycopy_util")
	require (BATTLE_DATA.."db_shareTextureList_util")
	require (BATTLE_DATA.."db_normal_config_util")
	require (BATTLE_DATA.."db_battleConfig_util")
	require (BATTLE_DATA.."db_cardSize_util")
	require (BATTLE_DATA.."db_ship_skill_util")
	require (BATTLE_DATA.."db_ship_util")
	require (BATTLE_DATA.."ObjectSharePool")

	db_hero_offset_util.ini()
	db_shareTextureList_util.ini()
	-- endTime =  os.clock()
	-- Logger.debug("*************** other2 cost:" .. endTime - startTime)


	-- startTime =  os.clock()
	require (BATTLE_DATA.."db_team_util")
	-- endTime =  os.clock()
	-- Logger.debug("*************** other3 cost:" .. endTime - startTime)
	
	-- startTime =  os.clock()
	require (BATTLE_DATA.."db_skill_util")
	-- endTime =  os.clock()
	-- Logger.debug("*************** other4 cost:" .. endTime - startTime)

	-- startTime =  os.clock()
	require (BATTLE_DATA.."db_buff_util")
	-- Logger.debug("*************** other5 cost:" .. endTime - startTime)

	-- startTime =  os.clock()
 	require (BATTLE_DATA.."db_BattleEffectAnimation_util")
	-- Logger.debug("*************** other6 cost:" .. endTime - startTime)
	
	require (BATTLE_DATA.."db_vip_util")



	local logicPath 		= "script/battle/BSTree/logicData/"
	require (logicPath .. "BuffAddLogicData")
	require (logicPath .. "BuffDeleteLogicData")
	-- require (logicPath .. "BuffHurtLogicData")
	require (logicPath .. "BuffDamageLogicData")
	 
	require (logicPath .. "BuffImLogicData")
	require (logicPath .. "BuffLogicData")
	require (logicPath .. "AttackLogicData")
	require (logicPath .. "SkillLogicData")

	require (logicPath .. "SkillHpDamageActionLogicData")
	require (logicPath .. "SkillRageDamageActionLogicData")
	require (logicPath .. "BattleRoundLogicData")
	require (logicPath .. "BattleRoundSubskillLogic")
	require (logicPath .. "DieLogicData")
	require (logicPath .. "BenchShowLogic")
	require (logicPath .. "shipLogic/ShipAttackLogic")
	require (logicPath .. "shipLogic/ShipHanleLogic")
	require (logicPath .. "shipLogic/ShipRoundLogic")
	require (logicPath .. "shipLogic/ShipSubSkillLogic")


	require "script/battle/action/WordsAnimationManager"
	WordsAnimationManager.reloadSource()
	-- require (logicPath .. "ShowStylePlayerMoveFadeOutAllLogicData")
	-- require (logicPath .. "ShowStyleNoMoveLogicData")
	-- require (logicPath .. "ShowStyleFirstShowArmyThenMoveSelfLogicData")
	

end