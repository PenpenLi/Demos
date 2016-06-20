module("BattleNodeFactory",package.seeall)
-- todo 给每个节点增加节点id,再加上blackboard 这样就方便调试啦 ^^
local NODE_CONDITION 						= 1
local NODE_ACTION	 						= 2
local NODE_OR 								= 3
local NODE_AND	 							= 4
local NODE_MOVETO	 						= 5
local NODE_ATTACK_ANI	 					= 6
local NODE_DECORATOR_CF 					= 8 -- 装饰节点,子节点返会complete时返回false
local NODE_PARALLEL_OR						= 9 -- 同时执行,结果用or逻辑

local ACTION_MOVETO 						= 1
local ACTION_PLAY_ATTACK_ACTION 			= 2	-- 攻击者技能动作
local ACTION_PLAY_RAGE_FIRE_EFFECT 			= 3 -- 怒气曝气特效
local ACTION_RUN_ACTION_IN_SAME_TIME 		= 4 -- 怒气曝气特效
local ACTION_ATTACKER_TRIGGER		 		= 5 -- 攻击关键帧触发
local ACTION_RAGE_FIRE 						= 6	-- 播放怒气释放特效
local ACTION_RAGE_SKILL_BAR 				= 7	-- 怒气动画条

local ACTION_SKILL_SPELL_ATTACK 			= 8	-- 一般技能打击

local ACTION_SKILL_RANGE_ATTACK 			= 9 -- 技能范围打击(无伤害,只有特效)

local ACTION_REMOTE_ATTACK 					= 10 -- 远程技能打击
local ACTION_SHOW_ADD_BUFF_EFF				= 11
local ACTION_ADD_BUFF_ICON					= 12
local ACTION_NODE_END 						= 13
local armatures 							= {}
local textures 								= {}
local framelist 							= {}
local reflectMap  							= nil
function regeistTextureURL(url)
	textures[url] = true
end

function releaseTextures()
	for k,v in pairs(textures) do
		CCTextureCache:sharedTextureCache():removeTextureForKey(k)
	end
end

function registArmature( json ,image,plist)
	assert(json,"registArmature url is nil")
	-- armatures[url] = true

	local imgIns = CCTextureCache:sharedTextureCache():textureForKey(image)
	if(armatures[json] == nil or imgIns == nil) then
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(image, plist ,json)
	 	armatures[json] = {plist,image}
	 	regeistTextureURL(image)
	 	print("---- BattleNodeFactory registArmature:",image, plist ,json)
	end


end



function addAnimation( json,plist,image )
	
	

end


function releaseArmatures()
	for url,v in pairs(armatures) do
		 CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(url)
	end
	armatures = {}
end

function registFrameList(url)
	framelist[url] = true
end

function releaseFrameList( ... )
	for url,v in pairs(framelist) do
		  CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(url)
	end
	framelist = {}
end

function release( ... )
	releaseArmatures()
	releaseFrameList()
	releaseTextures()
	reflectMap = nil
end


-- 获取属性选择器
function getPropertySelector(typeValue)
	local ps
	if typeValue == BATTLE_CONST.PS_AttackerUIToHeroUI then
		ps = require(BATTLE_CLASS_NAME.PSAttackerUIToHeroUI).new()
	
	elseif  typeValue == BATTLE_CONST.PS_DamageEffectNameToAnimationName then
		ps = require(BATTLE_CLASS_NAME.PSDamageEffectNameToAnimationName).new()
	
	elseif typeValue == BATTLE_CONST.PS_DamageActionNameToAnimationName then 
		ps = require(BATTLE_CLASS_NAME.PSDamageActionNameToAnimationName).new()
	
	elseif typeValue == BATTLE_CONST.PS_HpDamageToValue then
		ps = require(BATTLE_CLASS_NAME.PSHpDamageToValue).new()
	
	elseif typeValue == BATTLE_CONST.PS_HpNumberColorToColor then
		ps = require(BATTLE_CLASS_NAME.PSHpNumberColorToColor).new()
	
	elseif typeValue == BATTLE_CONST.PS_BuffChangeEffectToAnimationName then
		ps = require(BATTLE_CLASS_NAME.PSBuffChangeEffectToAnimationName).new()
	
	elseif typeValue == BATTLE_CONST.PS_RageDamgeToValue then
		ps = require(BATTLE_CLASS_NAME.PSRageDamgeToValue).new()
	elseif typeValue == BATTLE_CONST.PS_BuffDamageTitleToTitle then
		ps = require(BATTLE_CLASS_NAME.PSBuffDamageTitleToTitle).new()
	end

	return ps 
end
 





function iniReflect( ... )
	reflectMap = {}
	reflectMap[BATTLE_CONST.ACTION_MOVETO] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BaseActionForMoveTo).new()
		node.name = "moveToAction"
		return node
	end
 	

 	reflectMap[BATTLE_CONST.ACTION_RUN_ACTION_IN_SAME_TIME] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BattleActionForRunActionInSameTime).new()
		node.name = "同时播放"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_ATTACKER_TRIGGER] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForAttackAnimationTrigger).new()
		node.name = "攻击关键帧触发"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_RAGE_FIRE] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowRageSkillFireEffect).new()
		node.name = "爆豆特效"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SKILL_SPELL_ATTACK] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForSpellAttack).new()
		node.name = "技能攻击动作"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SKILL_RANGE_ATTACK] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForSpellRangeAttack).new()
		node.name = "技能攻击范围特效"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_REMOTE_ATTACK] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForRemoteSpellAttack).new()
		node.name = "远程"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_ADD_BUFF_EFF] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowAddBuffEffect).new()
		node.name = "添加buff特效"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_ADD_BUFF_ICON] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForAddBuffIcon).new()
		node.name = " 添加buff图标"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_REMOVE_BUFF_ICON] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForRemoveBuffIcon).new()
		node.name = " 删除buff图标"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_NODE_END] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForNodeComplete).new()
		node.name = " 结束"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_EFFECT_AT_HERO] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero).new()
		node.name = " 指定人物播放动画"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_XML_ANI_AT_HERO] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForObjectPlayXMLAnimation).new()
		node.name = " 指定人物播放xml动画"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_RAGE_BAR_CHANGE] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForHeroRageBarChange).new()
		node.name = " rageBar"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_HP_BAR_CHANGE] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForHeroHpBarChange).new()
		node.name = " hpBar"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_DELETE_BUFF] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSBuffDeleteAction).new()
		node.name = " bs删除buff"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_ADD_BUFF] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSBuffAddAction).new()
		node.name = " bs添加buff"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_IM_BUFF ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSBuffImAction ).new()
		node.name = " bs免疫buff "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_DAMAGE_BUFF ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSBuffDamageAction ).new()
		node.name = "  bs伤害buff"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_CHANGE_HP ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForChangeTargetHpData ).new()
		node.name = "  hp数据改变"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_CHANGE_RAGE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForChangeTargetRageData ).new()
		node.name = "  怒气数据改变"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_CHANGE_RAGE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSSkillRageAction).new()
		node.name = "  怒气改变BS"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_RUN_ALL_BUFF_BY_TIME ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForRunAllBuffByTimeAction ).new()
		node.name = "  运行指定时间所有buff"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_ATTACK ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSAttackAction ).new()
		node.name = "  攻击技能BS"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_HANDLE_SKILL ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSHandleSkillAction ).new()
		node.name = "  分发技能BS"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_CHECK_UA_COMPLETE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBeAttackedCompleteAction ).new()
		node.name = "  检测被攻击者是否完成"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_SUBSKILL ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForSubSkillsAction ).new()
		node.name = "  子技能"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_ROUND_SKILL ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSBattleRoundLogicAction ).new()
		node.name = "  战斗回合技能"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_RAGE_CHANGE_ANI ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForRageChangeAnimationAction ).new()
		node.name = " 怒气改变动画 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_REACTION_ANI ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForReactionAnimationAction ).new()
		node.name = " 反击动画 "
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_CALL_DIE_FUNCTION ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForHeroCallDieFunction ).new()
		node.name = "  死亡function"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_ADD_EFFECT_TO_HERO ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForAddEffectAtHero ):new()
		node.name = "  添加特效"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_DIE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSDieAction ).new()
		node.name = "  bs死亡"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_HIDE_TARGETS ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForHideTargetsAction ).new()
		node.name = "  隐藏指定目标"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_VISIBLE_TARGETS ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForVisibleTargetsAction ).new()
		node.name = "  显示指定目标"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_MOVE_BACKGROUND ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBackGroundImgScrollAction ).new()
		node.name = " 移动背景 "
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_TRAGETS_PLAY_MOVE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForTargetsPlayMoveInTimeAction ).new()
		node.name = "  指定目标播放移动动画"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_TRAGETS_FADE_IN ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForTargetsFadeInOrOutAction ).new()
		node.name = "  指定目标淡入或者淡出"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_BATTLE_NUM_INFO ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowBattleNumberStateAction ).new()
		node.name = " 显示战斗场次 "
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_MOVE_ARMY_FROM_FAR ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForMoveArmyFromFarAction ).new()
		node.name = "  让敌军从远处移动过来"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_MOVE_TARGETS_TO ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForMoveTargetsTo ).new()
		node.name = "移动多个目标  "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_TARGES_PLAY_EFFECT ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForTargetsPlayEffectAction ).new()
		node.name = "  指定目标播放特效"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_DELAY ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForDelayAction ).new()
		node.name = " 延迟 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_FLY_ATTACK ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForFlyAttack ).new()
		node.name = " 撞击 "
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_REMOTE_FROM_BACK ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPierceAttackFromBack ).new()
		node.name = " 后方穿刺弹道 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_REMOTE_PIERCE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPierceAttack ).new()
		node.name = " 穿刺弹道 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_SKILL_NAME ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowSkillNameAction ).new()
		node.name = " 显示技能名字 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_MOVE_BACK ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForMoveBackAction ).new()
		node.name = " 移动回去 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SEND_NOTIFICATION ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForSendNotification ).new()
		node.name = "  发送通知"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_PUSH_BUFF ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPushBuffInfoTo ).new()
		node.name = "push buff"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_RAGE_SKILL_BAR ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPlayRageSkilBar ).new()
		node.name = "怒气头像  "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SET_Z_ORDER ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForSetZOrder ).new()
		node.name = " 设置z "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_TOTAL_HURT ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowTotalHurtAnimation ).new()
		node.name = " 显示总伤害动画 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SET_TARGET_VISABLE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForChangeTargetVisable ).new()
		node.name = " 显示目标 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SET_TARGET_UNVISABLE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForChangeTargetUnVisable ).new()
		node.name = " 隐藏目标 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_ARMY_MOVE_IN ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForArmyTeamMoveIn ).new()
		node.name = " 出场_敌军入场 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_SELF_MOVE_IN ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForSelfTeamMoveIn ).new()
		node.name = " 出场_自己队伍入场 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_SELF_MOVEING ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForSelfTeamMoveAndScrollImg ).new()
		node.name = " 自己踏步,地图滚动 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_LIGHTING_EFFECT ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForLightingEffectShow ).new()
		node.name = " 闪电出场 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_LIGHTING_MAGIC ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForMagicEffectShow ).new()
		node.name = " 魔法特效出场 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_HIDE_TARGET ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForHideTargets ).new()
		node.name = "隐藏目标  "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_TALK ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPlayTalk ).new()
		node.name = " 对话 "
		return node
	end
		reflectMap[BATTLE_CONST.ACTION_SHOW_SCALE_DOWN ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForScaleDownActionShow ).new()
		node.name = " 落下入场"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_MOVE_TARGET_DOWN ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForMoveTargetsDown ).new()
		node.name = " 指定目标向下"
		return node
	end
		reflectMap[BATTLE_CONST.ACTION_MOVE_TARGET_UP ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForMoveTargetsUp ).new()
		node.name = " 指定目标向上移动 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_TARGET_WITH_EFFECT ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowTargetsWithDynamicEffect ).new()
		node.name = "指定特效出现"
		return node
	end
		reflectMap[BATTLE_CONST.ACTION_CHANGE_MUSIC ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForChangeMusic ).new()
		node.name = " 更换音乐 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_CHANGE_BACKGROUND ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForChangeBackGround ).new()
		node.name = " 更换背景 "
		return node
	end
		reflectMap[BATTLE_CONST.ACTION_PLAY_EFFECT_AT_SCENE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPlayEffectAtScene ).new()
		node.name = "  场景指定位置播放"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_UP_TARGET_ZODER ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForUpTargetsZOder ).new()
		node.name = " 提升指定目标zOder "
		return node
	end
		reflectMap[BATTLE_CONST.ACTION_RESUME_TARGET_ZODER ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForResumeTargetsZOder ).new()
		node.name = " 恢复指定目标zoder "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_ADD_IMG_RAGE_MASK ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForAddImageRageMask ).new()
		node.name = " 添加怒气遮罩 "
		return node
	end
		reflectMap[BATTLE_CONST.ACTION_REMOVE_IMG_RAGE_MASK ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForRemoveImageRageMask ).new()
		node.name = " 删除怒气遮罩 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SET_TARGETS_VISABLE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForSetTargetsVisible ).new()
		node.name = "设置目标位置(人物)可视  "
		return node
	end
		reflectMap[BATTLE_CONST.ACTION_TEAM1_OUT] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForMoveTeam1Out ).new()
		node.name = "  队伍1移出队伍"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_TEAM2_OUT ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForMoveTeam2Out ).new()
		node.name = " 队伍2移出 "
		return node
	end
		reflectMap[BATTLE_CONST.ACTION_HIDE_TARGETS_WITH_EFFECT ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForHideTagetsWithDynamicEffect ).new()
		node.name = "  特效 + 隐藏目标"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_DELAY_FROM_ANIMATION ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForAnimationFrameDelay ).new()
		node.name = " 特效一半时间延迟 "
		return node
	end
		reflectMap[BATTLE_CONST.ACTION_SHOW_BUFF_ADD_TIP ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowAddBuffTip ).new()
		node.name = " buff添加时提示buff作用图片 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_TIP_ON_CENTER ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowTipInCenter ).new()
		node.name = " 场景中播放指定数据 "
		return node
	end
		reflectMap[BATTLE_CONST.ACTION_ACTIVE_BENCH_DATA ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBenchDataActiveAction ).new()
		node.name = " 激活替补数据 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_ACTIVE_BENCH_DISPLAY_DATA ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBenchDisplayActiveAction ).new()
		node.name = "  激活替补显示数据 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_PLAY_EFFECT_BY_ID ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPlayEffectAtHeroByID ):new()
		node.name = "  指定id人物播放指定特效"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_BS_BENCH_SHOW ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BSForBenchShow ).new()
		node.name = " 替补BSAction "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_PLAY_EFFECT_AT_POSITION ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion ).new()
		node.name = "  指定位置播放特效"
		return node
	end
	reflectMap[BATTLE_CONST.TARGET_FADE_IN_WITH_ID ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForTargetFadeInWithIDs ).new()
		node.name = " 指定id目标fade in "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_ADD_ANI_RAGE_MASK ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForAddAnimationRageMask ).new()
		node.name = "  动画类型怒气遮罩"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_KICK_OUT ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForKickOutScreenAction ).new()
		node.name = " 踢飞"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_HANDLE_NEAR_DEATH ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForNearDeathSkillHandler ).new()
		node.name = "  濒死处理"
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_TO_RAW_POSTION ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPlayerToRawPosition ).new()
		node.name = " 还原玩家显示位置 "
		return node
	end
	reflectMap[BATTLE_CONST.ACTION_SHOW_TITLE_AND_BLACK_BG ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowTitleWithBlackBG ).new()
		node.name = "  显示指定文字并黑背景"
		return node
	end
	
	reflectMap[BATTLE_CONST.ACTION_SHOW_NUMBER ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowNumberAnimation ).new()
		node.name = "  数字飘动画"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_SEND_PRESTART_EVT ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPreStartEvt ).new()
		node.name = "  发送提前触发事件"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_SHOW_BOSS_INFO ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowBossInfo ).new()
		node.name = "  boss简介"
		return node
	end

	
	reflectMap[BATTLE_CONST.SHIP_ACTION_ENTER_SCENCE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShipEnterScene ).new()
		node.name = "  船入场"
		return node
	end


	reflectMap[BATTLE_CONST.SHIP_ACTION_QUIT_SCENCE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShipQuitScene ).new()
		node.name = "  船退场"
		return node
	end


	reflectMap[BATTLE_CONST.SHIP_ACTION_ROTATION_GUN ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShipRoatationGunForAimAction ).new()
		node.name = "  旋转炮口"
		return node
	end


	reflectMap[BATTLE_CONST.SHIP_ACTION_PLAY_EFFECT_AT_TARGETS ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowEffectAtTargets ).new()
		node.name = "  指定目标多个人物播放特效"
		return node
	end

	reflectMap[BATTLE_CONST.SHIP_ACTION_PLAY_GUN_ANIMATION ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPlayAnimationOfGun).new()
		node.name = "  播放炮管指定动画"
		return node
	end
	

	reflectMap[BATTLE_CONST.ACTION_BS_SHIP_ATTACK ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSShipAttackAction).new()
		node.name = "  船攻击bsTree"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_BS_SHIP_HANDLE_SKILL ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSHandleShipSkillAction).new()
		node.name = "  船技能处理 bsTree"
		return node
	end

	reflectMap[BATTLE_CONST.ACTION_BS_SHIP_SUBSKILL ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForBSShipSubSkillsAction).new()
		node.name = "  船子技能bsTree"
		return node
	end

	reflectMap[BATTLE_CONST.SHIP_ACTION_PLAY_ANIMATION_AT_SHIP ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForPlayAnimationAtShipGunAction).new()
		node.name = "  在指定主船上播放指定特效"
		return node
	end

	reflectMap[BATTLE_CONST.SHIP_ACTION_SHOW_SKILL_NAME ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowShipSkillName).new()
		node.name = "  显示主船技能名"
		return node
	end

	reflectMap[BATTLE_CONST.SHIP_ACTION_REMOTE_FIRE ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShipRemoteSpellAttack).new()
		node.name = "  主船弹道"
		return node
	end

	reflectMap[BATTLE_CONST.SHIP_ACTION_ANIMATION_DAMAGE_TRIGER ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForAnimationTrigerAction).new()
		node.name = "  伤害触发(动画)"
		return node
	end
 
	reflectMap[BATTLE_CONST.SHIP_ACTION_SHOW_TEAM_FIGHT_UP ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowTeamFightUpAnimation).new()
		node.name = " 显示队伍战斗力上升动画"
		return node
	end


	reflectMap[BATTLE_CONST.SHIP_ACTION_SHOW_SHIP_INFO ] = function ( ... )
		local node = require(BATTLE_CLASS_NAME.BAForShowShipInfo).new()
		node.name = " 显示主船信息"
		return node
	end
 



end

function getAction(data,blackBoardData)
	if(reflectMap == nil) then
		iniReflect()
	end

	local typeValue 					= tonumber(data.actionType)
	local needPS 						= false

	-- TimeUtil.timeStart("node action get")
	nodeFun = reflectMap[typeValue]
	local node = nil
	-- todo release时 没有node可以有个默认空节点生成,以防挂掉
	if(nodeFun ~= nil) then
		node = nodeFun()
		if node ~= nil then 
			node.blackBoard = blackBoardData
			node.des 		= data.des
			local selectors 					= data.selectors
			-- 初始化属性选择器,用于初始化node节点(数据从blackBoard读取,然后赋值给action)
			if(selectors ~= nil and selectors ~= {}) then
				local num = #selectors/2
				for i=1,num do
					local  index = (i - 1) * 2 + 1
					node[selectors[index + 1]] 		= blackBoardData[selectors[index]]
				end
				 
			end
			local dataes = data.data
			if(dataes ~= nil) then
				node.data = dataes
				-- Logger.debug("==data:" .. tostring(dataes))
			end
		else
				print("=============== factory not get action:",typeValue,"======================")
				print(debug.traceback())
				print("===========================================================")
				error("factory not get action:" .. tostring(typeValue))
			 	-- print("&&&&&&&&&&&  factory not get action:",typeValue)
		end
	else
		error("factory not get action:" .. tostring(typeValue))
	end

	-- TimeUtil.timeEnd("node action get")
	return node

	-- end
	-- -- --print("----------------------- getAction:",data.des)
	-- local node = nil
	-- if typeValue == BATTLE_CONST.ACTION_MOVETO then 

	-- 		node = require(BATTLE_CLASS_NAME.BaseActionForMoveTo).new()
	-- 		node.name = "moveToAction"
 
	-- elseif typeValue == BATTLE_CONST.ACTION_RUN_ACTION_IN_SAME_TIME then
	--  		node = require(BATTLE_CLASS_NAME.BattleActionForRunActionInSameTime).new()
	-- 		node.name = "同时播放"
	-- 		node:init(data,blackBoardData)
	-- elseif typeValue == BATTLE_CONST.ACTION_ATTACKER_TRIGGER then
	--  		node = require(BATTLE_CLASS_NAME.BAForAttackAnimationTrigger).new()
	-- 		node.name = "攻击关键帧触发"
	-- elseif typeValue == BATTLE_CONST.ACTION_RAGE_FIRE then
	-- 		node = require(BATTLE_CLASS_NAME.BAForShowRageSkillFireEffect).new()
	-- 		node.name = "爆豆特效"

	-- elseif typeValue == BATTLE_CONST.ACTION_SKILL_SPELL_ATTACK then
	-- 		node = require(BATTLE_CLASS_NAME.BAForSpellAttack).new()
	-- 		node.name = "技能攻击动作"
 
	-- elseif typeValue == BATTLE_CONST.ACTION_SKILL_RANGE_ATTACK then
	-- 		node = require(BATTLE_CLASS_NAME.BAForSpellRangeAttack).new()
	-- 		node.name = "技能攻击范围特效"
	-- elseif typeValue == BATTLE_CONST.ACTION_REMOTE_ATTACK then
	-- 		node = require(BATTLE_CLASS_NAME.BAForRemoteSpellAttack).new()
	-- 		node.name = "远程"

	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_ADD_BUFF_EFF then
	-- 		node = require(BATTLE_CLASS_NAME.BAForShowAddBuffEffect).new()
	-- 		node.name = "添加buff特效"

	-- elseif typeValue == BATTLE_CONST.ACTION_ADD_BUFF_ICON then
	-- 		node = require(BATTLE_CLASS_NAME.BAForAddBuffIcon).new()
	-- 		node.name = "添加buff图标"

	-- elseif typeValue == BATTLE_CONST.ACTION_REMOVE_BUFF_ICON then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForRemoveBuffIcon).new()
	-- 		node.name 	= "删除buff图标"

	-- elseif typeValue == BATTLE_CONST.ACTION_NODE_END then
	-- 		node = require(BATTLE_CLASS_NAME.BAForNodeComplete).new()
	-- 		node.name = "结束"

	-- elseif typeValue == BATTLE_CONST.ACTION_EFFECT_AT_HERO then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero).new()
	-- 		node.name 	= "指定人物播放动画"
	-- 		--needPS    	= true
	-- elseif typeValue == BATTLE_CONST.ACTION_XML_ANI_AT_HERO then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForObjectPlayXMLAnimation).new()
	-- 		node.name 	= "指定人物播放xml动画"

	-- elseif typeValue == BATTLE_CONST.ACTION_RAGE_BAR_CHANGE then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForHeroRageBarChange).new()
	-- 		node.name 	= "rageBar"

	-- elseif typeValue == BATTLE_CONST.ACTION_HP_BAR_CHANGE then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForHeroHpBarChange).new()
	-- 		node.name 	= "hpBar"


	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_NUMBER then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForShowNumberAnimation).new()
	-- 		node.name 	= "数字飘动画"
	
	
	-- elseif typeValue == BATTLE_CONST.ACTION_BS_DELETE_BUFF then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBSBuffDeleteAction).new()
	-- 		node.name 	= "bs删除buff"

	-- elseif typeValue == BATTLE_CONST.ACTION_BS_ADD_BUFF then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBSBuffAddAction).new()
	-- 		node.name 	= "bs添加buff"

	-- elseif typeValue == BATTLE_CONST.ACTION_BS_IM_BUFF then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBSBuffImAction).new()
	-- 		node.name 	= "bs免疫buff"
	-- elseif typeValue == BATTLE_CONST.ACTION_BS_DAMAGE_BUFF then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBSBuffDamageAction).new()
	-- 		node.name 	= "bs伤害buff"

 -- 	elseif typeValue == BATTLE_CONST.ACTION_CHANGE_HP then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForChangeTargetHpData).new()
	-- 		node.name 	= "hp数据改变"
	-- elseif typeValue == BATTLE_CONST.ACTION_CHANGE_RAGE then 
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForChangeTargetRageData).new()
	-- 		node.name 	= "怒气数据改变"
	-- elseif typeValue == BATTLE_CONST.ACTION_BS_CHANGE_RAGE then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBSSkillRageAction).new()
	-- 		node.name 	= "怒气改变BS"	
	-- elseif typeValue == BATTLE_CONST.ACTION_RUN_ALL_BUFF_BY_TIME then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForRunAllBuffByTimeAction).new()
	-- 		node.name 	= "运行指定时间所有buff"	

	-- elseif typeValue == BATTLE_CONST.ACTION_BS_ATTACK then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBSAttackAction).new()
	-- 		node.name 	= "攻击技能BS"

	-- elseif typeValue == BATTLE_CONST.ACTION_BS_HANDLE_SKILL then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBSHandleSkillAction).new()
	-- 		node.name 	= "分发技能BS"

	-- elseif typeValue == BATTLE_CONST.ACTION_BS_CHECK_UA_COMPLETE then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBeAttackedCompleteAction).new()
	-- 		node.name 	= "检测被攻击者是否完成"	
	-- elseif typeValue == BATTLE_CONST.ACTION_BS_SUBSKILL then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForSubSkillsAction).new()
	-- 		node.name 	= "子技能"	
	-- elseif typeValue == BATTLE_CONST.ACTION_BS_ROUND_SKILL then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBSBattleRoundLogicAction).new()
	-- 		node.name 	= "战斗回合技能"	
	-- elseif typeValue == BATTLE_CONST.ACTION_RAGE_CHANGE_ANI then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForRageChangeAnimationAction).new()
	-- 		node.name 	= "怒气改变动画"
	-- elseif typeValue == BATTLE_CONST.ACTION_REACTION_ANI then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForReactionAnimationAction).new()
	-- 		node.name 	= "反击动画"	
	-- elseif typeValue == BATTLE_CONST.ACTION_CALL_DIE_FUNCTION then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForHeroCallDieFunction).new()
	-- 		node.name 	= "死亡function"	
	-- elseif typeValue == BATTLE_CONST.ACTION_ADD_EFFECT_TO_HERO then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForAddEffectAtHero).new()
	-- 		node.name 	= "添加特效"		
	-- elseif typeValue == BATTLE_CONST.ACTION_BS_DIE then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBSDieAction).new()
	-- 		node.name 	= "bs死亡"	


	-- elseif typeValue == BATTLE_CONST.ACTION_HIDE_TARGETS then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForHideTargetsAction).new()
	-- 		node.name 	= "隐藏指定目标"	

	-- elseif typeValue == BATTLE_CONST.ACTION_VISIBLE_TARGETS then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForVisibleTargetsAction).new()
	-- 		node.name 	= "显示指定目标"


	-- elseif typeValue == BATTLE_CONST.ACTION_MOVE_BACKGROUND then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForBackGroundImgScrollAction).new()
	-- 		node.name 	= "移动背景"	

	-- elseif typeValue == BATTLE_CONST.ACTION_TRAGETS_PLAY_MOVE then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForTargetsPlayMoveInTimeAction).new()
	-- 		node.name 	= "指定目标播放移动动画"

	-- elseif typeValue == BATTLE_CONST.ACTION_TRAGETS_FADE_IN then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForTargetsFadeInOrOutAction).new()
	-- 		node.name 	= "指定目标淡入或者淡出"

	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_BATTLE_NUM_INFO then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForShowBattleNumberStateAction).new()
	-- 		node.name 	= "显示战斗场次"

 -- 	elseif typeValue == BATTLE_CONST.ACTION_MOVE_ARMY_FROM_FAR  then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForMoveArmyFromFarAction).new()
	-- 		node.name 	= "让敌军从远处移动过来"

 -- 	elseif typeValue == BATTLE_CONST.ACTION_MOVE_TARGETS_TO then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForMoveTargetsTo).new()
	-- 		node.name 	= "移动多个目标"

	-- elseif typeValue == BATTLE_CONST.ACTION_TARGES_PLAY_EFFECT then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForTargetsPlayEffectAction).new()
	-- 		node.name 	= "指定目标播放特效"
	-- elseif typeValue == BATTLE_CONST.ACTION_DELAY then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForDelayAction).new()
	-- 		node.name 	= "延迟"		
	-- elseif typeValue == BATTLE_CONST.ACTION_FLY_ATTACK then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForFlyAttack).new()
	-- 		node.name 	= "撞击"		
	-- elseif typeValue == BATTLE_CONST.ACTION_REMOTE_FROM_BACK then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForPierceAttackFromBack).new()
	-- 		node.name 	= "后方穿刺弹道"	
	-- elseif typeValue == BATTLE_CONST.ACTION_REMOTE_PIERCE then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForPierceAttack).new()
	-- 		node.name 	= "穿刺弹道"	

	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_SKILL_NAME then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForShowSkillNameAction).new()
	-- 		node.name 	= "显示技能名字"
	-- elseif typeValue == BATTLE_CONST.ACTION_MOVE_BACK then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForMoveBackAction).new()
	-- 		node.name 	= "移动回去"
 --    elseif typeValue == BATTLE_CONST.ACTION_SEND_NOTIFICATION then
 --    		node 		= require(BATTLE_CLASS_NAME.BAForSendNotification).new()
	-- 		node.name 	= "发送通知"
	-- elseif typeValue == BATTLE_CONST.ACTION_PUSH_BUFF then
 --    		node 		= require(BATTLE_CLASS_NAME.BAForPushBuffInfoTo).new()
	-- 		node.name 	= "push buff"
	-- elseif typeValue == BATTLE_CONST.ACTION_RAGE_SKILL_BAR then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForPlayRageSkilBar).new()
	-- 		node.name 	= "怒气头像"
	-- elseif typeValue == BATTLE_CONST.ACTION_SET_Z_ORDER then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForSetZOrder).new()
	-- 		node.name 	= "设置z"

	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_TOTAL_HURT then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForShowTotalHurtAnimation).new()
	-- 		node.name 	= "显示总伤害动画"

	-- elseif typeValue == BATTLE_CONST.ACTION_SET_TARGET_VISABLE then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForChangeTargetVisable).new()
	-- 		node.name 	= "显示目标"

	-- elseif typeValue == BATTLE_CONST.ACTION_SET_TARGET_UNVISABLE then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForChangeTargetUnVisable).new()
	-- 		node.name 	= "隐藏目标"



	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_ARMY_MOVE_IN then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForArmyTeamMoveIn).new()
	-- 		node.name 	= "出场_敌军入场"
	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_SELF_MOVE_IN then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForSelfTeamMoveIn).new()
	-- 		node.name 	= "出场_自己队伍入场"
	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_SELF_MOVEING then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForSelfTeamMoveAndScrollImg).new()
	-- 		node.name 	= "自己踏步,地图滚动"
	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_LIGHTING_EFFECT then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForLightingEffectShow).new()
	-- 		node.name 	= "闪电出场"
	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_LIGHTING_MAGIC then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForMagicEffectShow).new()
	-- 		node.name 	= "魔法特效出场"
	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_HIDE_TARGET then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForHideTargets).new()
	-- 		node.name 	= "隐藏目标"
	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_TALK then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForPlayTalk).new()
	-- 		node.name 	= "对话"
	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_SCALE_DOWN then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForScaleDownActionShow).new()
	-- 		node.name 	= "落下入场"
	
	-- elseif typeValue == BATTLE_CONST.ACTION_MOVE_TARGET_DOWN then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForMoveTargetsDown).new()
	-- 		node.name 	= "指定目标向下"
	
	-- elseif typeValue == BATTLE_CONST.ACTION_MOVE_TARGET_UP then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForMoveTargetsUp).new()
	-- 		node.name 	= "指定目标向上移动"
	 
	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_TARGET_WITH_EFFECT then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForShowTargetsWithDynamicEffect).new()
	-- 		node.name 	= "指定特效出现"
	 
	-- elseif typeValue == BATTLE_CONST.ACTION_CHANGE_MUSIC then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForChangeMusic).new()
	-- 		node.name 	= "更换音乐"
	 
	-- elseif typeValue == BATTLE_CONST.ACTION_CHANGE_BACKGROUND then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForChangeBackGround).new()
	-- 		node.name 	= "更换背景"	

	-- elseif typeValue == BATTLE_CONST.ACTION_PLAY_EFFECT_AT_SCENE then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForPlayEffectAtScene).new()
	-- 		node.name 	= "场景指定位置播放"
	
	-- elseif typeValue == BATTLE_CONST.ACTION_UP_TARGET_ZODER then
	-- 		node 		= require(BATTLE_CLASS_NAME.BAForUpTargetsZOder).new()
	-- 		node.name 	= "提升指定目标zOder"

	-- elseif typeValue == BATTLE_CONST.ACTION_RESUME_TARGET_ZODER then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForResumeTargetsZOder).new()
	-- 	node.name 	= "恢复指定目标zoder"

	-- elseif typeValue == BATTLE_CONST.ACTION_ADD_IMG_RAGE_MASK then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForAddImageRageMask).new()
	-- 	node.name 	= "添加怒气遮罩"

	-- elseif typeValue == BATTLE_CONST.ACTION_REMOVE_IMG_RAGE_MASK then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForRemoveImageRageMask).new()
	-- 	node.name 	= "删除怒气遮罩"	
	-- elseif typeValue == BATTLE_CONST.ACTION_SET_TARGETS_VISABLE then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForSetTargetsVisible).new()
	-- 	node.name 	= "设置目标位置(人物)可视"	
	
	-- elseif typeValue == BATTLE_CONST.ACTION_TEAM1_OUT then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForMoveTeam1Out).new()
	-- 	node.name 	= "队伍1移出队伍"

	-- elseif typeValue == BATTLE_CONST.ACTION_TEAM2_OUT then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForMoveTeam2Out).new()
	-- 	node.name 	= "队伍2移出"
	-- elseif typeValue == BATTLE_CONST.ACTION_HIDE_TARGETS_WITH_EFFECT then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForHideTagetsWithDynamicEffect).new()
	-- 	node.name 	= "特效 + 隐藏目标"

	-- elseif typeValue == BATTLE_CONST.ACTION_DELAY_FROM_ANIMATION then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForAnimationFrameDelay).new()
	-- 	node.name 	= "特效一半时间延迟"
		
	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_BUFF_ADD_TIP then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForShowAddBuffTip).new()
	-- 	node.name 	= "buff添加时提示buff作用图片"
	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_TIP_ON_CENTER then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForShowTipInCenter).new()
	-- 	node.name 	= "场景中播放指定数据"
	-- elseif typeValue == BATTLE_CONST.ACTION_ACTIVE_BENCH_DATA then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForBenchDataActiveAction).new()
	-- 	node.name 	= "激活替补数据"
	-- elseif typeValue == BATTLE_CONST.ACTION_ACTIVE_BENCH_DISPLAY_DATA then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForBenchDisplayActiveAction).new()
	-- 	node.name 	= "激活替补显示数据"
		
	-- elseif typeValue == BATTLE_CONST.ACTION_PLAY_EFFECT_BY_ID then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForPlayEffectAtHeroByID).new()
	-- 	node.name 	= "指定id人物播放指定特效"
	-- elseif typeValue == BATTLE_CONST.ACTION_BS_BENCH_SHOW then
	-- 	node 		= require(BATTLE_CLASS_NAME.BSForBenchShow).new()
	-- 	node.name 	= "替补BSAction"
	-- elseif typeValue == BATTLE_CONST.ACTION_PLAY_EFFECT_AT_POSITION then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
	-- 	node.name 	= "指定位置播放特效"
	-- elseif typeValue == BATTLE_CONST.TARGET_FADE_IN_WITH_ID then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForTargetFadeInWithIDs).new()
	-- 	node.name 	= "指定id目标fade in"
		
	-- elseif typeValue == BATTLE_CONST.ACTION_ADD_ANI_RAGE_MASK then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForAddAnimationRageMask).new()
	-- 	node.name   = "动画类型怒气遮罩"
	-- elseif typeValue == BATTLE_CONST.ACTION_KICK_OUT then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForKickOutScreenAction).new()
	-- 	node.name   = "踢飞"
	-- elseif typeValue == BATTLE_CONST.ACTION_HANDLE_NEAR_DEATH then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForNearDeathSkillHandler).new()
	-- 	node.name   = "濒死处理"
	-- elseif typeValue == BATTLE_CONST.ACTION_TO_RAW_POSTION then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForPlayerToRawPosition).new()
	-- 	node.name   = "还原玩家显示位置"

	-- elseif typeValue == BATTLE_CONST.ACTION_SHOW_TITLE_AND_BLACK_BG then
	-- 	node 		= require(BATTLE_CLASS_NAME.BAForShowTitleWithBlackBG).new()
	-- 	node.name   = "显示指定文字并黑背景"
	-- end

	-- if node ~= nil then 
	-- 	node.blackBoard = blackBoardData
	-- 	node.des 		= data.des
	-- 	local selectors 					= data.selectors
	-- 	-- 初始化属性选择器,用于初始化node节点(数据从blackBoard读取,然后赋值给action)
	-- 	if(selectors ~= nil and selectors ~= {}) then
	-- 		local num = #selectors/2
	-- 		for i=1,num do
	-- 			local  index = (i - 1) * 2 + 1
	-- 			node[selectors[index + 1]] 		= blackBoardData[selectors[index]]
	-- 		end
	-- 		-- local list = lua_string_split(selectors,",")
 -- 		-- 	for k,v in pairs(list) do
 -- 		-- 		local valueList 			= lua_string_split(v,":")
 -- 		-- 		if(#valueList == 2) then
 -- 		-- 			node[valueList[2]] 		= blackBoardData[valueList[1]]
 -- 		-- 		else
 -- 		-- 			error("getAction:selectors error")
 -- 		-- 		end
 
 -- 		-- 		-- local ps = getPropertySelector(tonumber(v))
 -- 		-- 		-- if(ps ~= nil) then 
 -- 		-- 		-- 	ps:selectProperty(blackBoardData,node)
 -- 		-- 		-- else
 -- 		-- 		-- 	error("getPropertySelector get nil:",v)
 -- 		-- 		-- end
 -- 		-- 	end

	-- 	end
	-- 	-- 插入action静态数据
 -- 		-- Logger.debug("==data:" .. tostring(data.data))
	-- 	local dataes = data.data
	-- 	if(dataes ~= nil) then
	-- 		node.data = dataes
	-- 		-- Logger.debug("==data:" .. tostring(dataes))
	-- 	end
	-- else
	-- 		print("=============== factory not get action:",typeValue,"======================")
	-- 		print(debug.traceback())
	-- 		print("===========================================================")
	-- 	 	-- print("&&&&&&&&&&&  factory not get action:",typeValue)
	-- end
	-- TimeUtil.timeEnd("node action get")
	-- return node
end

function getRootNode( data , blackBoardData)

	if blackBoardData == nil then 
        --print("&&&&&&&&&&&  blankBoard is nil")
      end
 	-- --print("BattleNodeFactory:getRootNode blackBoard is nil")
 	local rootNode 	= getNodeWithData(data,blackBoardData)
 	rootNode.isroot = true
	return rootNode
	 
end -- function

function getNodeWithData(data,blackBoardData)
	----print("$$$$$$$$$$ getNodeWithData:",data.des)
 	if(data == nil or type(data) ~= "table" ) then 
			--print("=============== 	data is nil or not table ================= ")
			--print("data is:",data)
			--print(debug.traceback())
			--print("===========================================================")
       
 	end
	if blackBoardData == nil then 

			--print("=============== blackBoardData is nil======================")
			--print(debug.traceback())
			--print("===========================================================")
       -- --print("&&&&&&&&&&&  battleLayer blankBoard is nil")
    end
	local typeValue 					= tonumber(data.type)
	local node 							= nil
	if typeValue == BATTLE_CONST.NODE_CONDITION then 

			node = require(BATTLE_CLASS_NAME.BSConditionNode).new()
			node.name = "BSConditionNode"
	elseif typeValue == BATTLE_CONST.NODE_ACTION then 
 			-- --print("BATTLE_CLASS_NAME.BSActionNode:",BATTLE_CLASS_NAME.BSActionNode)
 			node = require(BATTLE_CLASS_NAME.BSActionNode).new()
			node.name = "BSActionNode"
		
	elseif typeValue == BATTLE_CONST.NODE_OR then 
 			
 			node = require(BATTLE_CLASS_NAME.BSOrLogicNode).new()
 			node.name = "BSOrLogicNode"
	elseif typeValue == BATTLE_CONST.NODE_AND then 
 			
 			node = require(BATTLE_CLASS_NAME.BSAndLogicNode).new()
			node.name = "BSAndLogicNode"
 

	elseif typeValue == BATTLE_CONST.NODE_DECORATOR_CF then
			node = require(BATTLE_CLASS_NAME.BSDecoratorCompleteFalse).new()
			node.name = "NODE_DECORATOR_CF"
	elseif typeValue == BATTLE_CONST.NODE_PARALLEL_OR then 
			node = require(BATTLE_CLASS_NAME.BSParallelOr).new()
			node.name = "NODE_PARALLEL_OR"
    elseif typeValue == BATTLE_CONST.NODE_INSTANT_ACTION then
    		node = require(BATTLE_CLASS_NAME.BSInstantActionNode).new()
			node.name = "NODE_INSTANT_ACTION"
    elseif typeValue == BATTLE_CONST.NODE_CUSTOM_ACTION then
    		node = require(BATTLE_CLASS_NAME.BSCustomActionNode).new()
			node.name = "NODE_CUSTOM_ACTION"
	end

	if node~=nil then 

		-- print("$$$$$$$$$$ factory genraet:",data.des)
		if blackBoardData == nil then 
			--print("$$$$$$$$$$ blackBoard is nil ")
		end
		-- --print("BattleNodeFactory callFunction is :",callFunction)
		-- node.callBackFunc 	= callFunction

		node.blackBoard 	= blackBoardData
		node.treeName		= blackBoardData.treeName
		node:init(data)
		node.weight 		= tonumber(data.weight) or 0
		-- --print("node des:")
	-- else
	else
			print("=============== factory not get node action :",typeValue,"======================")
			print("===============  node des :",data.des,"======================")
			print(debug.traceback())
			print("===========================================================")
		 	print("&&&&&&&&&&&  factory not get node action:",typeValue)
	end

	 -- --print("node is : type:",typeValue," des:",data.des)
	
	return node

end -- function end
 
