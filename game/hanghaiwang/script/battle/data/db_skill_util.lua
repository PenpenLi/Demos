

module("db_skill_util",package.seeall)

require "db/skill"


function getItemByid( id )
	local skillitem = skill.getDataById(tonumber(id))
	return skillitem or skill.getDataById(1)
end
function getSkillName( id )
	local item = getItemByid(id)
	if item ~= nil then
		return item.name
	end
end


function getDieActionType( id )
	local item = getItemByid(id)
	if item ~= nil then
		return item.dieActionType
	end
end



-- 获取遮罩动画名字(图片或者动画)
function getSkillRageMaskName( id )
	local item = getItemByid(id)
	if item ~= nil then
		local maskName = item.rageMask
		if(maskName == nil or maskName == "") then
			maskName = BATTLE_CONST.RAGE_MASK_URL
			-- maskName = BATTLE_CONST.RAGE_MASK_ALL_BLACK_URL
			return maskName
		else
			local startIndex = string.find(maskName,".png")
			-- 如果是png图片
			if(startIndex ~= nil and startIndex ) then
				return BATTLE_CONST.RAGE_MASK_DIR .. maskName

			else -- 如果是动画直接返回动画名字
				return maskName
			end
		end
		return maskName
	end

end

-- 怒气遮罩是否是动画
function isAnimationRageMask(id)
	local rageMaskName = getSkillRageMaskName(id)
 	if(rageMaskName ~= nil) then
		local startIndex = string.find(rageMaskName,".png")
		if(startIndex ~= nil and startIndex > 0) then
			return false
		else
			return true
		end
	end
	return false
end
-- 是否是1个特效,且在攻击者身上
function isOneAttackOnAttacker(id)

	 if(getSkillTargetType(id) == 1) then
	 	return true
	 end
	 return false
end
-- 是否是1个特效
function isOneAttackEffect(id)
	local effectType 		= getAttackEffectType(id)
 	return effectType == 2
end
-- 是否每个被攻击者都有特效
function isEveryUnderAttackerHasEffect( id )
	return getAttackEffectType(id) == 1
end
-- 获取远程弹道
function getDistancePathName(id)
	local item = getItemByid(id)
	if item ~= nil then
		return item.distancePath
	end
end
-- 获取怒气技能音乐
function getRageBarMusic( id )
	local item = getItemByid(id)
	if item ~= nil and item.rageBarMusic ~= nil and item.rageBarMusic ~= "" then 
		return item.rageBarMusic
	else
		-- --print("error: skill:",id, " hitEffct 为空") 
		return nil
	end
end
 
-- 攻击特效挂点
function geAttackEffectPostion(id)
	local item = getItemByid(id)
	if item ~= nil then 
		local position = tonumber(item.attackEffctPosition)
		-- 默认值是2
		if (position == 0 or position == nil ) then 
			 position = BATTLE_CONST.POS_MIDDLE end
		return position
	end
end

function getHitEffectName( id )
	local item = getItemByid(id)
	if item ~= nil and item.hitEffct ~= nil and item.hitEffct ~= "" then 
		return item.hitEffct
	else
		-- --print("error: skill:",id, " hitEffct 为空") 
		return nil
	end
end
-- 获取粒子特效名称
function getParticleName( id )
	local item = getItemByid(id)
	if item ~= nil and item.particleName ~= nil and item.particleName ~= "" then 
		return item.particleName
	else
		-- --print("error: skill:",id, " hitEffct 为空") 
		return nil
	end


end

 

function getSkillIcon( id )
	local item = getItemByid(id)
	if item ~= nil then 
		if(item.icon == "") then
		 return nil
		end
		return item.icon
	end
end

-- 技能是否怒气技能
function isSkillRageSkill( id )
	assert(id)
	local item = getItemByid(id)
	if item ~= nil then 
		local functionWay = tonumber(item.functionWay)
 
		return functionWay == 2
	end
end
	--获取技能释放者 动作名称
function getSkillActionName( id )
	local item = getItemByid(id)
	if item ~= nil then 
		local actionName = item.actionid
		if actionName == nil or actionName == "" then
			actionName = "A001"
			--print("error: skill:",id, " actionid 不能为空") 
		end
		if(actionName == "T001") then actionName = "A001" end
		if(actionName == "T002") then actionName = "A002" end
		if(actionName == "T003") then actionName = "A004" end

		-- print("--- actionid:",actionName,id)
		return actionName
	end
end
-- 如果是挂在自己身上的技能特效,是否是要自动翻转(队伍2的时候需要垂直翻转,也就是180度)
-- 是否自动翻转 attackEffect
-- 默认值是1
function isAutoFlipWhenOnSelf( id )
	local item = getItemByid(id)
	-- 检测是否是挂在释放者身上的特效
	local isOnself = isOneAttackOnAttacker(id)
	if(isOnself == true and item ~= nil) then
			-- 检测是否需要翻转
			local isFlip = item.isAutoFlipAttEffect
			if(isFlip == "" or isFlip == nil or tonumber(isFlip) == 1) then
				return true
			end 

			return false
	end
	return true

end
-- 技能特效
function getSkillAttackEffectName( id )
 
	local item = getItemByid(id)
	if item ~= nil then 
		 
		local attackEffct = item.attackEffct
		if attackEffct == nil or attackEffct ~= "" then
			-- --print("error: skill:",id, " attackEffct 不能为空") 
		end
		-- attackEffct ="meffect_36"
		return attackEffct
 
		
	end
end
-- 获取技能表现类型:1普通释放/2弹道/3冲撞/4特效穿透/5敌方身后释放
function getSkillType( id )
		local item = getItemByid(id)
 	if item ~= nil then 
 		-- local effectType = 
 		return tonumber(item.skillType)
 	end
end
-- 释放技能移动方式
function getMoveType( id )
 	local item = getItemByid(id)
 	if item ~= nil then 
 		-- local effectType = 
 		return tonumber(item.mpostionType)
 	end
end

-- 魔法关键帧是否震屏
function isShake( id )
	local item = getItemByid(id)
 	if item ~= nil then 
 		-- local effectType = 
 		return tonumber(item.isShake) == 1 or item.isShake == true
 	end
 	return false
end

-- --撞击
-- function isImpactSill( id )
-- 	local moveType = getMoveType(id)
--  	 return moveType == 7
-- end


-- 获取技能表现类型:1普通释放/2弹道/3冲撞/4特效穿透/5敌方身后释放
--撞击
function isImpactSill( id )
	local skillType = getSkillType(id)
	return skillType == 3
end

-- -- 是否是背部穿刺技能 暂时不用
-- function isBackRemoteSkill( id )
-- 	-- return false
-- 	local moveType = getMoveType(id)
--  	 return moveType == 9
-- end

-- 获取技能表现类型:1普通释放/2弹道/3冲撞/4特效穿透/5敌方身后释放
-- 是否是背部穿刺技能 暂时不用
function isBackRemoteSkill( id )
	local skillType = getSkillType(id)
 	 return skillType == 5
end



-- -- 前方穿刺
-- function isPierceSkill( id )
-- 	local moveType = getMoveType(id)
--  	 return moveType == 8
-- end

-- 获取技能表现类型:1普通释放/2弹道/3冲撞/4特效穿透/5敌方身后释放
-- 前方穿刺
function isPierceSkill( id )
	local skillType = getSkillType(id)
	return skillType == 4
end
 
-- -- 是否是弹道技能
-- function isRemoteSkill(id)
-- 	local moveType = getMoveType(id)
-- 	if(moveType == 4 or moveType == 5 ) then 
-- 		return true
-- 	end
-- 	return false
-- end

-- 获取技能表现类型:1普通释放/2弹道/3冲撞/4特效穿透/5敌方身后释放
-- 是否是弹道技能 new
function isRemoteSkill(id)
	local skillType = getSkillType(id)
	if(skillType == 2) then 
		return true
	end
	return false
end


-- 技能特效攻击方式 技能效果类型  1.每个伤害都有魔法效果/2.只有一个魔法效果（多个人受伤）
function getAttackEffectType( id )
 	local item = getItemByid(id)
 	if item ~= nil then 
 	 local effectType = tonumber(item.meffectType)
 	 if effectType == 0 or effectType == nil then effectType = 1 end
 		return effectType
 	end
end

-- 远程弹道是否需要旋转
function isRemoteNeedRotate( id )
	local item = getItemByid(id)
 	if item ~= nil then 
 	 local need = tonumber(item.isRemoteRotate)
 	 if need == 1  then
 	   return true
 	 end
 		 
 	end

 	return false


end


-- 当攻击特效播放时,是否隐藏攻击者卡牌
function isHideWhenAttackEffect( id )
	local level = getAttackerHideLevel(id)
 	 if(level == 0) then return false end
 	 return true

end

-- 获取攻击者隐藏等级(0全部显示,1不显示卡牌,2都不显示)
function getAttackerHideLevel( id )
	local item = getItemByid(id)
 	if item ~= nil then 
 	 local level = tonumber(item.attackerHideLevel)
 	 if level == 0 or level == nil then
 	   return 0
 	 end
 	 
 	 return level	 
 	end
 	return 0
end

-- 远程弹道是否穿透
function isRemoteOverTarget( id )
	local item = getItemByid(id)
 	if item ~= nil then 
 	 local level = tonumber(item.isRemoteOver)
 	 if level == 0 or level == nil then
 	   return false
 	 end
 	 return true	 
 	end
 	return false
end

-- 获取技能受击动作
function getUnderAttackAction( id )
	
	local item = getItemByid(id)
	local actionName
 	if item ~= nil then 
 		actionName = item.UAAction
 	-- else
 	-- 	actionName = BATTLE_CONST.REACTION_ANIMATION_HURT
 	end

 	if(actionName == nil or actionName == "") then
 		actionName = BATTLE_CONST.REACTION_ANIMATION_HURT 
 	else
 		print("--- actionid UAAction:",actionName)
 	end

 	return actionName
	
end

-- 获取技能魔法音效
function getSpellSound(id)
	local item = getItemByid(id)
 	if item ~= nil then 
 		return item.spellSound
 	end
 	return nil
end

-- 获取技能击中音效
function getHitSound( id )
	local item = getItemByid(id)
 	if item ~= nil then 
 		return item.hitSound
 	end
 	return nil
end

--(1,2,3,4,5, 6,7,8)
-- 空格处不播放( 5 x 3 的描述文件 其中中点为被攻击的人) 
function getSkipType( id )
 	local item = getItemByid(id)
 	if item ~= nil then 
 		local info = tostring(item.skipAble)
 		-- --print("getSkipType:",info)
 		-- info = "1,1,1,1,1,1,1,1,1,1,0,0,0,0,0"
 		-- info = "0,0,0,0,0,1,1,1,1,1,0,0,0,0,0"
 		-- 空格处不需要播放
 		if info == nil or info == "" or info == "0" then
 			return nil
 		-- 空格处需要播放
 		else 
 			local list = lua_string_split(info,",")
 		
 			-- local posArray = lua_string_split(skill.skipAble,",")
	   --      local defenderPos = m_currentDefender:getTag()%1000
	   --      ----print("defenderPos",defenderPos)
	   --      for pi=1,#posArray do
    --         local posStr = posArray[pi]
    --         --local realPos = defenderPos-8+pi
    --         local relevantPos = defenderPos%3+(pi-1)%5-2
    --         local realPos = defenderPos+(math.floor((pi-1)/5)-1)*3+(pi-1)%5-2
    --         ----print("realPos:",realPos,relevantPos,pi,defenderPos)
    --         if(posStr=="1" and realPos>=0 and realPos<=5 and (relevantPos>=0 and relevantPos <=2))then
    --         end
 			for k,v in pairs(list) do
 				list[k] = tonumber(v)
 			end

 			return list

 		end -- if end
 	end -- if end
end -- function end


-- showRageSkillName   
-- 参数说明:是否显示怒气技能名(怒气头像的)
-- 参考值: 0(不显示),1(显示)
-- 默认值: 1
function getIsShowRageSkillName( id )
	local item = getItemByid(id)
 	if item ~= nil and item.showRageSkillName ~= nil and item.showRageSkillName ~= "" then
 		if(item.showRageSkillName == "0" or item.showRageSkillName == 0) then
 			return false
 		end
 		return true
 	end
 	return true
end


-- showSkillNameLabel 
-- 参数说明:是否显示无怒气头像技能名文本(怒气技能,无怒气头像)
-- 参考值: 0(不显示),1(显示)
-- 默认值: 0
function getIsShowSkillNameLabel( id )
	local item = getItemByid(id)
 	if item ~= nil and item.showSkillNameLabel ~= nil and item.showSkillNameLabel ~= "" then
 		if(item.showSkillNameLabel == "0" or item.showSkillNameLabel == 0) then
 			return false
 		end
 		return true
 	end
 	return false
end


-- 获取蓄力特效
function getRageFireEffect( id )

	local item = getItemByid(id)
 	if item ~= nil and item.rageFireEffect ~= nil and item.rageFireEffect ~= "" then
 		return tostring(item.rageFireEffect) 
 	end
 	return nil
		
end


-- 获取蓄力特效挂点
function getRageFirePosition(id)
	local item = getItemByid(id)
 	if item ~= nil and item.rageFireEffectPosition ~= nil then
 		return tonumber(item.rageFireEffectPosition) 
 	end
 	return nil
end



-- 获取技能目标类型(0:敌人身上,1:自己身上 2:屏幕中央,默认:0)
function getSkillTargetType( id )
	local item = getItemByid(id)
 	if item ~= nil and item.skillTargetType ~= nil then
 		return tonumber(item.skillTargetType) 
 	end
 	return 0
	
end

function getShipSkill( id )
	local item = getItemByid(id)
 	if item ~= nil and item.refShipSkill ~= nil then
 		return tonumber(item.refShipSkill)
 	end
 	return 0
end

-- 输入被攻击人,获取到范围table,玩家index为value,从0开始
function getSkipByDefender(skillid,defenderPos)
	--print("getSkipByDefender defenderPos:",defenderPos)
	local range 	= getSkipType(skillid)
	local startPos 	= defenderPos  - 7
	local result 	= {}

	if(range ~= nil ) then 

		local defenderxIndex = defenderPos%3
		local defenderyIndex =  math.floor(defenderPos/3)

		for k,v in ipairs(range) do
			 
	
			local xindex = (k - 1)%5
			local yindex = math.floor((k - 1)/5)

			local realX = xindex - defenderxIndex
			-- if(defenderyIndex < xindex) then
			-- 	realX = xindex - ( xindex - defenderyIndex)
			-- elseif(defenderyIndex >xindex) then 
			-- 	realX = xindex + ( xindex - defenderyIndex)
			-- else
			-- 	realX = xindex
			-- end


		
			local yindex = math.floor((k - 1)/5)
			local realY = yindex - defenderyIndex
			-- if(defenderyIndex < yindex) then
			-- 	realY = yindex - ( yindex - defenderyIndex)
			-- elseif(defenderyIndex >yindex) then 
			-- 	realY = yindex + ( yindex - defenderyIndex)
			-- else
			-- 	realY = yindex
			-- end
		

 		
			
			 if(v == 1) then 
			 	if(realX >=0 and realX <= 2 and realY >= 0 and realY <= 2 and defenderyIndex + yindex <= 2) then
				 	 	-- --print("getSkipByDefender arrIndex:",k," position:",realX + realY * 3," realX:",realX ," realY:",realY)
				 	table.insert(result,realX + realY * 3)
			 	end
			 end

			 startPos = startPos + 1
		end
		return result
	end -- if end
	return nil
end

 