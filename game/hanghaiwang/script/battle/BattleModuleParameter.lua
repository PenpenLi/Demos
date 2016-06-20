

local BattleModuleParameter = class("BattleModuleParameter")
 
	------------------ properties ----------------------
	BattleModuleParameter.type 						= nil

	------------------ const ----------------------
	BattleModuleParameter.TREASURE					= 1 -- 宝藏
	BattleModuleParameter.ACTIVE					= 2 -- 活动
	BattleModuleParameter.MINERAL					= 3 -- 资源矿
	BattleModuleParameter.ARENA						= 4 -- 竞技场
	BattleModuleParameter.ASTROLOGY					= 5 -- 占星
	BattleModuleParameter.BOSS						= 6 -- 世界boss
	BattleModuleParameter.TREEBOSS					= 7 -- 发财树
	BattleModuleParameter.RECORD 					= 8 -- 播放录像
	BattleModuleParameter.REVENGE					= 10 -- 复仇
	BattleModuleParameter.MATCH						= 11 -- 比武
	BattleModuleParameter.IMPEL                     = 12 -- 深海监狱
	------------------ functions -----------------------

return BattleModuleParameter