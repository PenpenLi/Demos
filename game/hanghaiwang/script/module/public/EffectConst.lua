-- FileName: EffectConst.lua
-- Author: yucong
-- Date: 2015-11-18
-- Purpose: 特效常量
--[[TODO List]]
module("EffectConst", package.seeall)

PATH_FORGE					= "images/effect/forge/"
PATH_WORLDBOSS				= "images/effect/worldboss/"
PATH_FORMATION				= "images/effect/formation/"

E_HAMMER					= "E_HAMMER"		-- 锤子
E_SPARK						= "E_SPARK"			-- 火花
E_STREN_OK					= "E_STREN_OK"		-- 强化成功
E_FIX_OK					= "E_FIX_OK"		-- 附魔成功
E_CRIT						= "E_CRIT"			-- 暴击
E_ADD_LEVEL					= "E_ADD_LEVEL"		-- 提升几级
E_MASTER_EQUIP_LIGHT		= "E_MASTER_EQUIP_LIGHT" 	-- 强化大师 装备升级特效
E_MASTER_BOARD_LIGHT		= "E_MASTER_BOARD_LIGHT" 	-- 强化大师 属性板子出现特效
E_JINJIE_SHUZI				= "E_JINJIE_SHUZI"
E_JINJIE_SHUZI2				= "E_JINJIE_SHUZI2"
E_AWAKE_OK					= "E_AWAKE_OK"		-- 觉醒成功

E_MASTER_EQUIP_STR			= "E_MASTER_EQUIP_STR"		-- 装备强化大师
E_MASTER_EQUIP_FIX			= "E_MASTER_EQUIP_FIX"		-- 装备附魔大师
E_MASTER_TREA_STR			= "E_MASTER_TREA_STR"		-- 饰品强化大师
E_MASTER_TREA_REFINE		= "E_MASTER_TREA_REFINE"	-- 饰品精炼大师

E_GUANGZHEN_DA				= "E_GUANGZHEN_DA"			-- 光阵
E_GUANGZHEN_XIAO			= "E_GUANGZHEN_XIAO"		-- 光阵
E_GUANGZHEN_XIAO_WU			= "E_GUANGZHEN_XIAO_WU"		-- 光阵
E_GUANGZHEN_XIAO_WU2		= "E_GUANGZHEN_XIAO_WU2"	-- 光阵
E_GUANGZHEN_XIAO_RENWU		= "E_GUANGZHEN_XIAO_RENWU"	-- 光阵

E_BATTLE_LIGHT				= "E_BATTLE_LIGHT"			-- 战斗背景光特效
E_TOUCH_CONTINUE			= "E_TOUCH_CONTINUE"		-- 触摸继续
E_TOUCH_CLOSE				= "E_TOUCH_CLOSE"			-- 触摸关闭

-- 默认8个帧事件
E_FRAME_1				= 1
E_FRAME_2				= 2
E_FRAME_3				= 3
E_FRAME_4				= 4
E_FRAME_5				= 5
E_FRAME_6				= 6
E_FRAME_7				= 7
E_FRAME_8				= 8

-- 特效数据
-- @param PATH 特效路径
-- @param NAME 特效名
-- @param FRAMES 关键帧集合 例["3"] = 1;关键帧事件为3，执行回调列表第1个回调 
-- @param ADAPT 是否适配，默认false
-- @param MUSIC 音效方法
T_EFFECT_DATA 	= {
	-- 锤子
	E_HAMMER	= {	
		PATH				= PATH_FORGE.."UI_20_hammer/qh4.ExportJson",
		NAME				= "qh4_1",
		FRAMES 		 		= {
			["1"] 			= 1,
			["2"] 			= 2,
		},
	},
	-- 火花
	E_SPARK		= {
		PATH				= PATH_FORGE.."UI_15/qh.ExportJson",
		NAME				= "qh",
		FRAMES 		 		= {
			["1"] 			= 1,
		},
	},
	-- 强化成功
	E_STREN_OK	= {
		PATH				= PATH_FORGE.."str_succeed/str_succeed.ExportJson",
		NAME				= "str_succeed",
		FRAMES 		 		= {
			["1"] 			= 1,
		},
		ADAPT				= true,
		MUSIC				= function () AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3") end,
	},
	-- 附魔成功
	E_FIX_OK	= {
		PATH				= PATH_FORGE.."enhance_succeed/enhance_succeed.ExportJson",
		NAME				= "enhance_succeed",
		FRAMES 		 		= {
			["1"] 			= 1,
		},
		ADAPT				= true,
	},
	-- 觉醒成功
	E_AWAKE_OK = {
		PATH				= "images/effect/awake_upgrade/awake_upgrade.ExportJson",
		NAME				= "awake_upgrade",
		FRAMES 		 		= {
			["1"]			= 1,
		},
		ADAPT 				= true,
		MUSIC				= function () AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3") end,
	},
	-- 暴击
	E_CRIT		= {
		PATH				= PATH_FORGE.."baoji/baoji.ExportJson",
		NAME				= "biaoji",
		FRAMES 		 		= {
			["baoji_13"] 	= 1,
		},
	},
	-- 提升几级 TODO
	E_ADD_LEVEL	= {
		PATH				= PATH_FORGE.."qh3_3/qh3_3.ExportJson",
		NAME				= "qh3_3",
		FRAMES 		 		= {
			["3"] 			= 1,
		},		
		ADAPT				= true,
	},
	-- 一键强化属性板出现特效
	E_MASTER_BOARD_LIGHT = {
		PATH				= PATH_FORMATION.."guru_board_light/guru_board_light.ExportJson",
		NAME				= "guru_board_light",
		FRAMES 		 		= {
			["1"] 			= 1,
			["2"] 			= 2,
		},		
		ADAPT				= true,	
	},
	-- 装备强化大师
	E_MASTER_EQUIP_STR	= {
		PATH				= PATH_FORGE.."equip_str_guru/equip_str_guru.ExportJson",
		NAME				= "equip_str_guru",
		FRAMES 		 		= {
			["2"] 			= 1,
		},
		ADAPT				= true,
		MUSIC				= function () AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3") end,
	},
	-- 装备附魔大师
	E_MASTER_EQUIP_FIX	= {
		PATH				= PATH_FORGE.."equip_enhance_guru/equip_enhance_guru.ExportJson",
		NAME				= "equip_enhance_guru",
		FRAMES 		 		= {
			["2"] 			= 1,
		},
		ADAPT				= true,
		MUSIC				= function () AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3") end,
	},
	-- 饰品强化大师
	E_MASTER_TREA_STR	= {
		PATH				= PATH_FORGE.."jewel_str_guru/jewel_str_guru.ExportJson",
		NAME				= "jewel_str_guru",
		FRAMES 		 		= {
			["2"] 			= 1,
		},		
		ADAPT				= true,
		MUSIC				= function () AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3") end,
	},
	-- 饰品精炼大师
	E_MASTER_TREA_REFINE	= {
		PATH				= PATH_FORGE.."jewel_refine_guru/jewel_refine_guru.ExportJson",
		NAME				= "jewel_refine_guru",
		FRAMES 		 		= {
			["2"] 			= 1,
		},
		ADAPT				= true,
		MUSIC				= function () AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3") end,
	},
	-- 光阵
	E_GUANGZHEN_DA = {
		PATH				= "images/effect/hero_transfer/qh2_guangzheng/qh2_guangzheng.ExportJson",
		NAME				= "guangzheng_da",
		FRAMES 		 		= {
		},
	},
	-- 光阵
	E_GUANGZHEN_XIAO = {
		PATH				= "images/effect/hero_transfer/qh2_guangzheng/qh2_guangzheng.ExportJson",
		NAME				= "guangzheng_xiao",
		FRAMES 		 		= {
		},
	},
	-- 光阵
	E_GUANGZHEN_XIAO_WU = {
		PATH				= "images/effect/hero_transfer/qh2_guangzheng/qh2_guangzheng.ExportJson",
		NAME				= "guangzheng_xiao_wu",
		FRAMES 		 		= {
		},
	},
	-- 光阵
	E_GUANGZHEN_XIAO_WU2 = {
		PATH				= "images/effect/hero_transfer/qh2_guangzheng/qh2_guangzheng.ExportJson",
		NAME				= "guangzheng_xiao_wu2",
		FRAMES 		 		= {
		},
	},
	-- 光阵
	E_GUANGZHEN_XIAO_RENWU = {
		PATH				= "images/effect/hero_transfer/qh2_guangzheng/qh2_guangzheng.ExportJson",
		NAME				= "guangzheng_xiao_renwu",
		FRAMES 		 		= {
		},
	},
	-- 战斗结束背景光
	E_BATTLE_LIGHT = {
		PATH				= PATH_WORLDBOSS.."new_rainbow.ExportJson",
		NAME				= "new_rainbow",
		FRAMES 		 		= {
		},
	},
	-- 触摸继续
	E_TOUCH_CONTINUE = {
		PATH				= PATH_WORLDBOSS.."fadein_continue.ExportJson",
		NAME				= "fadein_continue",
		FRAMES 		 		= {
		},
	},
	-- 触摸结束
	E_TOUCH_CLOSE = {
		PATH				= PATH_WORLDBOSS.."fadein_close.ExportJson",
		NAME				= "fadein_close",
		FRAMES 		 		= {
		},
	},
	-- 黄色闪烁粒子
	E_JINJIE_SHUZI = {
		PATH				= "images/effect/jinjie_shuzi/jinjie_shuzi.ExportJson",
		NAME				= "jinjie_shuzi",
		FRAMES 		 		= {
		},
	},
	-- 黄色闪烁粒子2
	E_JINJIE_SHUZI2 = {
		PATH				= "images/effect/jinjie_shuzi/jinjie_shuzi.ExportJson",
		NAME				= "jinjie_shuzi_2",
		FRAMES 		 		= {
		},
	},
}