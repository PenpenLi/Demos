module("BattleURLManager",package.seeall)



 
	------------------ properties ----------------------

local ACTION_URL												=	"images/base/hero/action_module/"
local ACTION_URL_BIG											=	"images/base/hero/action_module_b/"	
local ACTION_URL_DEMON											=	"images/base/hero/body_img/"	
local ACTION_URL_3X												=	"images/base/hero/action_module_super/"	

local BATTLE_IMG_PATH 											=	"images/battle/"							--	战斗图片主路径
BATTLE_IMG_BG_PATH 												=	BATTLE_IMG_PATH .. "bg/"							--	战斗图片主路径

local BATTLE_CARD												=	BATTLE_IMG_PATH.."card/"					--	小卡片位置 
local BATTLE_CARD_BIG											=	BATTLE_IMG_PATH.."bigcard/"					--	大卡片位置
local BATTLE_CARD_3X											=	BATTLE_IMG_PATH.."card3x/"					--	大卡片位置

local BATTLE_CARD_BLANK 										=	BATTLE_CARD.."blankcard.png"				--	空白的
local BATTLE_OUT_LINE_HERO										= 	"images/base/hero/body_img/"		
 BATTLE_EFFECT													= 	"images/battle/skillEffect/"						-- 特效目录
 BATTLE_EFFECT_OLD												= 	"images/battle/effect/"
local BATTLE_NUMBER 											= 	BATTLE_IMG_PATH.. "number/"
local BATTLE_ACTIONS_EFFECT										= 	"images/battle/xml/action/"			    	-- 动作目录

local BATTLE_BACKGROUND_MUSIC 									= "audio/bgm/"
local BATTLE_EFFECT_MUSIC 										= "audio/effect/"
local BUTTON_EFFECT												= "audio/btn/"

local BATTLE_RAGE_HEAD                                          = "images/battle/rage_head/"

BATTLE_PARTICLE 												= "images/battle/particles/"

BATTLE_HEAD 													= "images/base/hero/head_icon/"

BATTLE_BENCH_ICON_BG											= "images/base/potential/"
BATTLE_BLANK_ICON												= "images/battle/rage_head/blank.png"


BATTLE_ITEM_BACK												= "images/base/potential/"
BATTLE_SHIP_BODY												= "images/battle/ship/"
BATTLE_SHIP_SKILL_NAME_IMG										= "images/battle/shipSkillNameImages/"
BATTLE_SHIP_INFO_ICON											= "images/battle/shipInfoIcon/"
	------------------ functions -----------------------

function getHeroPartURL(name)
	return BATTLE_HEAD .. tostring(name)
end

function getRageHeadURL( name )
		assert(name)
		return BATTLE_RAGE_HEAD .. name
end
function getBGMusicURL( name )
	assert(name)
	local ext = ""
	local has = string.find(name,"%.mp3")
	if(has == nil or has < 0) then
		ext = ".mp3"
	end
	return BATTLE_BACKGROUND_MUSIC .. name .. ext
	
end
function getButtonEffectSoundURL( name )
	assert(name)
	local ext = ""
	local has = string.find(name,"%.mp3")
	if(has == nil or  has < 0) then
		ext = ".mp3"
	end
	return BUTTON_EFFECT .. name .. ext
end
function getBattleEffectMusicURL( name )
	assert(name)
	local ext = ""
	local has = string.find(name,"%.mp3")
	if(has == nil or  has < 0) then
		ext = ".mp3"
	end
	return BATTLE_EFFECT_MUSIC .. name .. ext
end
--获取英雄Action动作图片URL
function getActionImageURL(name,useBig,isoutLine,isSuperCard)
	-- print("---------- getActionImageURL name:",name," useBig:",useBig," isoutLine:",isoutLine," isSuperCard:",isSuperCard)

 	if isoutLine ~= true then


		if isSuperCard == true and file_exists(ACTION_URL_3X..name) == true then
			Logger.debug("=============== 3x:" .. (ACTION_URL_3X..name))
			return  (ACTION_URL_3X..name),name
		end
 		
 		if useBig == true and file_exists(ACTION_URL_BIG..name) == true then
 			Logger.debug("=============== 2x:" .. (ACTION_URL_BIG..name))
			return  (ACTION_URL_BIG..name),name
		end
			--print("===============",(ACTION_URL..name))
		if(file_exists(ACTION_URL..name)) then 
			-- print("=============== 1x:",(ACTION_URL..name))
			-- Logger.debug("----------getActionImageURL is not exists! name:" .. name .. " useBig:" .. tostring(useBig) ..  " isoutLine:" .. tostring(isoutLine))
			return (ACTION_URL..name),name
		else
			-- print("---------- 1x images is not exists! name:",name," useBig:",useBig," isoutLine:",isoutLine,"path:",ACTION_URL..name)
			return ACTION_URL .. "fight_elite_jingyan_feng.png","fight_elite_jingyan_feng.png"
		end
	

 	else
 		-- print("=============== outline :",(ACTION_URL_DEMON..name))
 		if(file_exists(ACTION_URL_DEMON..name) == true) then
			-- print("---------- outline is ok")
			return (ACTION_URL_DEMON..name),name
		else
			-- print("---------- outline images is not exists! name:",name," useBig:",useBig," isoutLine:",isoutLine,"path:",ACTION_URL_DEMON..name)
			return ACTION_URL_DEMON.."body_elite_jiaxishen.png","body_elite_jiaxishen.png"
		end
 	end


end

function getNumberURL( fileName )
	return BATTLE_NUMBER .. fileName
end
 
function getBattleHeroItemBackImg(quality)
	if(quality == nil) then quality = 1 end
	if(quality > 7) then quality = 7 end
	local img_name = "pro_" .. tostring(quality) .. ".png"
	return BATTLE_ITEM_BACK .. img_name
end
--获取不同等级的卡片
function getCardPathImageURL(grade,useBig,useBlank,isSuperCard)
	if(useBlank == true) then
		return BATTLE_CARD_BLANK
	end
	local cardName = "card_" .. grade .. ".png"
	if useBig == true  then
		return BATTLE_CARD_BIG..cardName
	elseif(isSuperCard == true) then
		return BATTLE_CARD_3X..cardName

	end

	return  BATTLE_CARD..cardName
end


function getSkillActionURLByid( id )
	local actionName = db_skill_util.getSkillActionName(id)
	local actionURL  = getSkillActionURL(actionName)
	return actionURL
end

function getSkillActionURLByid( id )
	local effectName = db_skill_util.getSkillAttackEffectName(id)
	
	local effectURL  = getAttackEffectURL(effectName)
	return effectURL
end



function getSkillActionURL( actionName )
	return  CCString:create(BATTLE_ACTIONS_EFFECT..actionName)
end

function getAttackEffectURL( effectName )
	-- --print(" getAttackEffectURL:",BATTLE_EFFECT..effectName)
	return  CCString:create(BATTLE_EFFECT_OLD..effectName)
end

function getAddBuffTipURL( tipName )
	return BATTLE_NUMBER .. tipName
end
-- 获取替补头像背景
function getBenchIconBG(name)
	return BATTLE_BENCH_ICON_BG .. tostring(name)
end

function getShipBody( name )
	return BATTLE_SHIP_BODY .. tostring(name)
end
-- 获取主船技能名图片路径
function getShipSkillNameImg(name)
	return BATTLE_SHIP_SKILL_NAME_IMG .. tostring(name)	
end
-- 获取主船信息中主船图片路径
function getShipInfoIcon( name )
	return BATTLE_SHIP_INFO_ICON .. tostring(name)	
end
