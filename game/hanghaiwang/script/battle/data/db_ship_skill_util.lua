module("db_ship_skill_util",package.seeall)

require "db/DB_Ship_skill"
require "db/DB_Shell"

shellMap = {}


function iniSkillShell()
	shellMap = {}
	for k,info in pairs(DB_Shell.Shell or {}) do
		-- 技能id->主船id
		shellMap[info[2]] = info[1]
	end
end

iniSkillShell()

-- skill id -> shipSkill id
function getShipSkillIDFromSkill(id)
	return shellMap[id]
end



function getItemByid( id )
	return DB_Ship_skill.getDataById(tonumber(id))
end

-- 获取炮弹特效名称
function getShipBulletName(id)
	local item = getItemByid(id)
	if(item) then
		return item.bulletName
	end
end

-- -- 是否发射炮弹
-- function isFireBullet(id)
-- 	local bname = getShipBulletName(id)
-- 	print(" isFireBullet:",id,bname,bname == nil or bname == "")
-- 	if(bname == nil or bname == "") then
-- 		return false
-- 	end
-- 	return true 
-- end


-- 获取技能释放动画名称
function getShipFireSkillActionName(id)
	local item = getItemByid(id)
	if(item) then
		return item.actionName
	end
end


-- 获取技能释放时挂接在炮口的特效
function getEffectAtMuzzle(id)
	local item = getItemByid(id)
	if(item) then
		return item.muzzleEffect
	end
end

-- 获取技能释放时瞄准镜特效
function getAimEffectName(id)
	local item = getItemByid(id)
	if(item) then
		return item.aimEffectName
	end
end

-- 获取技能释放时瞄准镜特效
function getAimEffectName(id)
	local item = getItemByid(id)
	if(item) then
		return item.aimEffectName
	end
end


-- 入场方式
-- 1:目前只有一种入场方式
function getEnterSceneType(id)
	local item = getItemByid(id)
	if(item) then
		if(item.enterSceneType == nil or item.enterSceneType <= 0) then
			return 1
		end
		return item.enterSceneType
	end
end

-- 退场方式
-- 1:目前只有一种入场方式
function getQuitSceneType(id)
	local item = getItemByid(id)
	if(item) then
		if(item.quitSceneType == nil or item.quitSceneType <= 0) then
			return 1
		end
		return item.quitSceneType
	end
end

-- aimMode
-- 炮管瞄准模式:1,2  
-- 1:默认值,瞄准方式为旋转
-- 2:不瞄准
function getAimMode(id)
	local item = getItemByid(id)
	if(item) then
		if(item.aimMode == nil or item.aimMode <= 0) then
			return 1
		end
		return item.aimMode
	end
end


-- 是否需要瞄准和旋转方式的瞄准
function isRotationAimStyle( id )
	local m = getAimMode(id)
	return m == 1
end


-- aimEffectMode 瞄准特效出现方式
-- 1:每个伤害对象都有瞄准特效 默认值
-- 2:阵型中央
-- 3:没有瞄准特效
function getAimEffectMode( id )
	local item = getItemByid(id)
	if(item) then
		if(item.aimEffectMode == nil or item.aimEffectMode <= 0) then
			return 1
		end
		return item.aimEffectMode
	end
end


function isAimEffShowAtEveryOne( id )
	local m = getAimEffectMode(id)
	return m == 1
end
function isAimEffShowAtCenter( id )
	local m = getAimEffectMode(id)
	return m == 2
end

-- 获取弹道类型:1,2,3
-- 默认值为1:每个攻击对象都有弹道
-- 2:只有一个炮弹特效在中心
-- 3:没有弹道
function getBulletMode( id )
	local item = getItemByid(id)
	if(item) then
		if(item.bulletMode == nil or item.bulletMode <= 0 or tonumber(item.bulletMode) == 0) then
			return 1
		end
		return tonumber(item.bulletMode)
	end
end

-- 是否发射弹道
function isFireBullet( id )
	return getBulletMode(id) ~= 3
end
function isBulletAtEveryOne( id )
	local m = getBulletMode(id)
	return m == 1
end
function isBulletAtCenter( id )
	local m = getBulletMode(id)
	return m == 2
end

-- 技能名称图片名
function getShipSkillNameImg( id )
	local item = getItemByid(id)
	
	if(item) then
		local imgName = item.skillNameImg
		if(imgName ~= nil and imgName ~= "") then
			return BattleURLManager.getShipSkillNameImg(imgName)
		end
		return 
	end
end
-- 获取主船技能特效
function getShipSkillEffect( id )
	local item = getItemByid(id)
	if(item) then
		return item.skillEffect
	end
end
-- 获取主船技能特效模式:1,2
-- 1:默认值(不填也是1) 每个受击者有一个特效 
-- 2:受击者队伍中央播放一个特效
function getShipSkillEffectMode( id )
	local item = getItemByid(id)
	if(item) then
		if(item.skillEffectMode == nil or item.skillEffectMode <= 0) then
			return 1
		end
		return item.skillEffectMode
	end
end

function isSkillEffectAtEveryOne( id )
	local m = getShipSkillEffectMode(id)
	return m == 1
end
function isSkillEffectAtCenter( id )
	local m = getShipSkillEffectMode(id)
	return m == 2
end

function getAaccumulateEff( ... )
	local item = getItemByid(id)
	if(item) then
		return item.aaccumulateEff
	end
end
function isAaccumulateSkill( id )
	local item = getItemByid(id)
	if(item) then
		if(item.aaccumulateEff ~= nil and item.itemaaccumulateEff ~= "") then
			return true
		end
	end
	return false
end

--------------  声音 
-- 获取炮口挂接特效的音效名称 done
function getMuzzleEffectSound( id )
	local item = getItemByid(id)
	if(item) then
		if(item.muzzleEffectSound == nil or item.muzzleEffectSound == "") then
			return nil
		else
			return item.muzzleEffectSound
		end
	end
	return nil
end

-- 获取主船技能特效的音效
function getShipSkillEffectSound( id )
	local item = getItemByid(id)
	if(item) then
		if(item.skillEffectSound == nil or item.skillEffectSound == "") then
			return nil
		else
			return item.skillEffectSound
		end
	end
	return nil
end


-- 获取瞄准镜音效
function getAimSound( id )
	local item = getItemByid(id)
	if(item) then
		return item.aimSound
	end
end

-- 获取开炮动画对应的声音
function getFireActionSound( id )
	local item = getItemByid(id)
	if(item) then
		return item.actionSound
	end
end

-- 获取炮口旋转音效
function getRotationSound( id )
	local item = getItemByid(id)
	if(item) then
		return item.rotationSound
	end
end
