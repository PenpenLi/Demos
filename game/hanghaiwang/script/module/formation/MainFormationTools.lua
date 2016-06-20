-- FileName: MainFormationTools.lua
-- Author: wangming
-- Date: 14-12-30
-- Purpose: function description of module


module("MainFormationTools", package.seeall)

require "script/GlobalVars"
require "db/DB_Heroes"
require "db/DB_Normal_config"
require "script/model/hero/HeroModel"
require "db/DB_Union_profit"
require "db/DB_Suit"

--UI控件变量
local m_getWidget = g_fnGetWidgetByName
local m_UI = UIHelper
local mSplit = string.split
local mDB_formation = DB_Formation
local mDB_unicon = DB_Union_profit
local mDB_suit = DB_Suit
local mDB_hero = DB_Heroes
local mHeroModel = HeroModel
local mDB_nc = DB_Normal_config

local finalEquipAttr
local originEquipAttr
local labelNodesAttr

local labelNumLink
local originNumLink
local finalNumLink

local animationPath = "images/effect/"

local m_i18n = gi18n
-- local mFontSize = 32
local mFontSize = 28
local mFontName = g_FontCuYuan
-- local mHangPart = 36
local mHangPart = 10
local mTopPart = 17  --上下边距
local _autoGuruLayer = nil 	-- 全身强化json控件
local _autoGuruAtrribLayer = nil 	-- 全身强化飘属性文字层


function destroy( ... )
end

--根据phitd判断是否可以更换该伙伴
function fnCheckChangeID( pHid )
	if(not pHid) then
		return nil
	end
	local heroInfo = mHeroModel.getHeroByHid(pHid) or nil
	if(not heroInfo) then
		return nil
	end
	local heroData = mDB_hero.getDataById(heroInfo.htid) or nil
	if(not heroData) then
		return nil
	end
	local mHitd = tonumber(heroInfo.htid) or 0
	local pDB_data = mDB_nc.getDataById(1).lufei_limit_lv
	local card_ids = mSplit(pDB_data, ",") or {}
	for k,v in pairs(card_ids) do
		local pInfo = mSplit(v,"|")
		if(pInfo) then
			local pphtid = tonumber(pInfo[1]) or -1
			local pLv = tonumber(pInfo[2]) or 0
			local pHerolv = tonumber(UserModel.getHeroLevel()) or 0
			if(mHitd == pphtid and pHerolv < pLv) then
				local pName = heroData.name
				local pString = string.format(m_i18n[1253],pLv,pName)
				return pString
			end
		end
	end
	return nil
end

--[[desc:设置红点显示
    tipNode: tip的父node，小红圈
    return: 是否显示  
—]]
function fnSetTips( tipNode, isShow )
	if(not tipNode) then
		return false
	end
	if(not tipNode:getNodeByTag(10)) then
		local tipAni = m_UI.createRedTipAnimination()
		tipAni:setTag(10)
		tipNode:addNode(tipAni,10)
	end
	tipNode:setVisible(isShow)
	return isShow
end

--[[desc:初始化阵容、小伙伴、替补的数据
    arg1: 1-阵容 ， 2-小伙伴 ， 3-替补
    return: 是否有返回值，返回值说明  
—]]
function fnGetFormationDatas( tag , callFunc)
	local pData = nil
	local pTag = tag or 0
	local pFunc = nil
	local pFunc2 = nil
	-- 从服务器获取对应数据
	if(pTag == 1) then
		pData = DataCache.getSquad() or nil
		pFunc = RequestCenter.formation_getSquad or nil
		pFunc2 = DataCache.setSquad or nil
	elseif(pTag == 2) then
		pData = DataCache:getExtra() or nil
		pFunc = RequestCenter.formation_getExtraFriend or nil
		pFunc2 = DataCache.setExtra or nil
	elseif(pTag == 3) then
		pData = DataCache:getBench() or nil
		pFunc = RequestCenter.formation_getBench or nil
		pFunc2 = DataCache.setBench or nil
	end

	if(not pData and pFunc) then
		pFunc(function(cbFlag, dictData, bRet)
			if bRet then
				if(pFunc2) then
					pFunc2(dictData.ret)
				end
				if(callFunc) then
					callFunc()
				end
			end
		end , nil)
	else
		if(callFunc) then
			callFunc()
		end
	end
end

--[[desc:上阵时提示上阵伙伴名字
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function showUpName( strName )
	local ptxt = string.format(m_i18n[5305] , strName)
	ShowNotice.showShellInfo(ptxt)
end

--[[desc:处理返回数据数组
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function fnSortData( squadData )
	local sortTable = {}
	for key,value in pairs(squadData or {}) do
		sortTable[tonumber(key)] = value
	end
	return sortTable
end

function fnGetSquadNum( ... )
	return mDB_formation.getDataById(1).formation_display or 0
end

--[[desc:显示栏位替补显示个数
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function fnGetBenchNum( level )
	level = level or UserModel.getHeroLevel()
	local pNum = 0
	local pinfo = mDB_formation.getDataById(1).bench_display or ""
	local pM_level = tonumber(level) or 1
	local pArr = mSplit(pinfo, ",") or {}
	for k,v in pairs(pArr) do
		local ppArr = mSplit(v, "|") or {}
		local pL = tonumber(ppArr[1]) or 100
		if(pL <= pM_level) then
			pNum = pNum + 1
		end
	end
	return pNum
end

--[[desc:判断栏位是否开启
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function fnGetBenchOpenLevel( pos )
	local pinfo = mDB_formation.getDataById(1).openBenchByLv or ""
	local pPos = tonumber(pos) or 0
	local pArr = mSplit(pinfo, ",") or {}
	for k,v in pairs(pArr) do
		local ppArr = mSplit(v, "|") or {}
		local ppPos = tonumber(ppArr[2]) or -1
		if(ppPos == pPos) then
			local openLevel = tonumber(ppArr[1]) or 100
			return openLevel
		end
	end
	return 100
end

--[[desc:播放更换人物时的动画
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function runHeroImgAni( _btnImg)
	if(not _btnImg) then
		return
	end
	local pBtnImg = _btnImg
	local posX = pBtnImg:getPositionX()
	local posY = pBtnImg:getPositionY()


	local pTime1 = 1*3/30
	local pTime2 = 1*6/30
	local pTime3 = 1*4/30
	local pTime4 = 1*4/30
	local pLenght1 = 85
	local pLenght2 = -20


	pBtnImg:setPositionY(posY + 85)

	local function moveCallBack( armature,movementType,movementID  )
		if(movementType == EVT_COMPLETE) then
			armature:removeFromParentAndCleanup(true)
		end
	end


	local arr = CCArray:create()
	-- arr:addObject(CCFadeIn:create(pTime1))
	arr:addObject(CCMoveTo:create(pTime2,ccp(posX , posY)))
	arr:addObject(CCCallFuncN:create(function ( ... )
			local playname = "zhenrong_ct"
			local m_arAni1 = m_UI.createArmatureNode({
				filePath = animationPath .. playname .. "/" .. playname .. ".ExportJson",
				animationName = playname,
				loop = 0,
		        fnMovementCall = moveCallBack
			})
			m_arAni1:setPosition(ccp(posX , 180))
			pBtnImg:getParent():addNode(m_arAni1)
		end))
	local pMove1 = CCMoveTo:create(pTime3 , ccp(posX , posY + pLenght2))
	local pScale1 = CCScaleTo:create(pTime3 , 1.05, 0.9)
	local pSp1 = CCSpawn:createWithTwoActions(pMove1,pScale1)
	arr:addObject(pSp1)

	local pMove2 = CCMoveTo:create(pTime4 , ccp(posX , posY))
	local pScale2 = CCScaleTo:create(pTime4 , 1)
	local pSp2 = CCSpawn:createWithTwoActions(pMove2,pScale2)
	arr:addObject(pSp2)
	
	pBtnImg:runAction(CCSequence:create(arr))
end

local waitLayer
function fnAddComeInWait( ... )
	if(waitLayer) then
		return
	end
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if (runningScene==nil) then
		return
	end
	waitLayer = OneTouchGroup:create()
	waitLayer:setTouchPriority(g_tbTouchPriority.ShieldLayout)
	local t_layou = Layout:create()
	t_layou:setTouchEnabled(true)
	waitLayer:addWidget(t_layou)
	runningScene:addChild(waitLayer)
end

--[[desc:播放一进场时的动画
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function fnShowComeInAni( equipLayout , isInit)
	if(not equipLayout) then
		return
	end

	--播放某个对象的移动动画
	local function plAction(widget, i, offset)
		if(not widget) then
			return
		end

		local orignPosX = widget:getPositionX()
		local orignPosY = widget:getPositionY()

		if(isInit) then
			widget:setPositionType(0)
			widget:setPosition(ccp(orignPosX + offset * 181, orignPosY))
			return
		end

		orignPosX = widget:getPositionX() - offset * 181
		orignPosY = widget:getPositionY()

		local delay = 0
		if (i ~= 1 and i ~= 5) then
			if (i < 5) then
				delay = (i - 1) / 20
			else
				delay = (i - 4) / 20
			end
		end
		local actions = CCArray:create()
		actions:addObject(CCDelayTime:create(delay))
		-- 第1帧     位置 X=181
		actions:addObject(CCMoveTo:create(1/60, ccp(orignPosX + offset * 181, orignPosY)))
		-- 第12帧    位置 X=-35
		actions:addObject(CCMoveTo:create(11/60, ccp(orignPosX + -offset * 35, orignPosY)))
		-- 第18帧    位置 X=0
		actions:addObject(CCMoveTo:create(6/60, ccp(orignPosX, orignPosY)))
		if(i == 8) then
			actions:addObject(CCCallFuncN:create(function ( ... )
				if(waitLayer) then
					waitLayer:removeFromParentAndCleanup(true)
					waitLayer = nil
				end
			end))
		end
		widget:runAction(CCSequence:create(actions))
	end

	local pNames = {
		"img_headframe","img_necklaceframe","BTN_TREASURE_WIND","BTN_TREASURE_WATER",
		"img_weaponframe","img_armorframe","BTN_TREASURE_THUNDER","BTN_TREASURE_FIRE"
	}

	local pOb
	for i = 1, 8 do
		pOb = m_getWidget(equipLayout, pNames[i])
		plAction(pOb, i, i <= 4 and -1 or 1)
	end
		
end



--[[desc:计算阵容的战斗力
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function calcFightForce( allheroInfo , allextraInfo , externHeroInfo)
	local m_fightForce = 0
	for k,v in pairs(allheroInfo) do
		local fightForce = v.fight_force or 0
		m_fightForce = m_fightForce + tonumber(fightForce)
	end
	local arrHero   = externHeroInfo.arrHero

	for k,v in pairs(allextraInfo) do
		local heroInfo = arrHero[v]
		if heroInfo then
			local fightForce = heroInfo.fight_force or 0
			m_fightForce = m_fightForce + tonumber(fightForce)
		end
	end
	return m_fightForce
end


--[[desc:根据人物htid获取专属宝物id
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getExclusiveTreaureID( htid )
	local pDB = mDB_hero.getDataById(htid)
	if(not pDB) then
		return nil
	end
	local pArr = mSplit(pDB.treaureId, "|")
	if(not pArr) then
		return nil
	end
	return pArr[1]
end

--[[desc:根据人物htid获取专属宝物
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getExclusiveTreaureIDs( htid )
	local pDB = mDB_hero.getDataById(htid)
	if(not pDB) then
		return nil
	end
	local pArr = mSplit(pDB.treaureId, "|")
	if(not pArr) then
		return nil
	end
	return pArr
end

--[[desc:根据人物htid获取羁绊宝物id数组
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getFetterTreaureID( htid )
	local pDB = mDB_hero.getDataById(htid)
	if(not pDB) then
		return nil
	end
	local linkGroup = pDB.link_group1
 	if(not linkGroup)then
 		return nil
 	end
 	local pItem_template_ids = {}
    local linkGroupArr = lua_string_split(linkGroup, ",")
    
    for i,v in ipairs(linkGroupArr) do
        local heroUnionInfo = mDB_unicon.getDataById(v)
        local card_ids = mSplit(heroUnionInfo.union_card_ids, ",")
        for k,type_card in pairs(card_ids) do
        	local type_card_arr = mSplit(type_card, "|")
        	if(tonumber(type_card_arr[1]) == 2) then
        		local tmpV = mSplit(heroUnionInfo.union_arribute_ids, ",")
    			local tmpN = mSplit(heroUnionInfo.union_arribute_nums, ",")
    			local hQuality = pDB.heroQuality
    			local qualitys = mSplit(heroUnionInfo.quality, ",")	-- 6,10,12,13,14,15
    			local percent = {}
    			for k, quality in pairs(qualitys) do
    				if (tonumber(quality) == hQuality) then
    					local temp = tmpN[tonumber(k)]	-- 3000|3000
    					percent = mSplit(temp, "|")	
    					break
    				end
    			end
    			if (table.isEmpty(percent)) then
    				assert(false, "此人物的DB_Union_profit表quality字段中不包含 "..hQuality)
    			end

    			local strDesc = ""
        		for p = 1 , #tmpV do
        			local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(tmpV[p], percent[p])
        			strDesc = strDesc .. affixDesc.sigleName .. "+" .. displayNum .. " "
        		end
        		
        		local pInfo = { id = type_card_arr[2] , info = strDesc, name = heroUnionInfo.union_arribute_name}
        		table.insert(pItem_template_ids,pInfo)
        	end
        end
    end
    return pItem_template_ids
end

local partNames = {"WIND", "THUNDER" , "WATER" , "FIRE"}

--[[desc:初始化宝物专属和羁绊图标的显示
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function fnInitExclusiveAndFetterIcon( _lay , _i)
	if(not _lay or not _i) then
		return
	end
	if(tonumber(_i) < 1 or tonumber(_i) > 4) then
		return
	end
	_lay:removeChildByTag(_i,true)
	local icon1 = m_getWidget(_lay, "IMG_" .. partNames[tonumber(_i)] .. "_ZHUANSHU")
	local icon2 = m_getWidget(_lay, "IMG_" .. partNames[tonumber(_i)] .. "_JIBAN")
	if(icon1) then
		icon1:setVisible(false)
	end
	if(icon2) then
		icon2:setVisible(false)
	end
end

--[[desc:处理宝物专属和羁绊图标的显示
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getExclusiveAndFetterIcon( _lay , _i ,  _itid , _exclusiveID , _item_template_ids)
	if(not _lay or not _i) then
		return
	end
	if(tonumber(_i) < 1 or tonumber(_i) > 4) then
		return
	end
	
	local specialIcon = m_getWidget(_lay, "IMG_" .. partNames[tonumber(_i)] .. "_ZHUANSHU")
	local unionIcon = m_getWidget(_lay, "IMG_" .. partNames[tonumber(_i)] .. "_JIBAN")
	if(specialIcon) then
		specialIcon:setVisible(false)
	end
	if(unionIcon) then
		unionIcon:setVisible(false)
	end

	if(_item_template_ids and tonumber(_item_template_ids) ~= 0 and tonumber(_item_template_ids) ~= -1) then
		for i,v in pairs(_item_template_ids) do
			if(tonumber(_itid) == tonumber(v.id)) then
				if(specialIcon) then
					specialIcon:setVisible(false)
				end
				if(unionIcon) then
					unionIcon:setVisible(true)
					unionIcon:setZOrder(20)
				end
			end
		end
	end

	if(_itid and tonumber(_itid) == tonumber(_exclusiveID)) then
		if(specialIcon) then
			specialIcon:setVisible(true)
			specialIcon:setZOrder(20)
		end
		if(unionIcon) then
			unionIcon:setVisible(false)
		end
	end
end

 function getNumber( _num )
	local pN = math.abs(tonumber(_num))
	local pTb = {}
	-- math.modf(x/y)
	local sw = math.modf(pN/100000)
	local w = math.modf(pN/10000) - sw*10
	local q = math.modf(pN/1000) - w*10 - sw*100
	local b = math.modf(pN/100) - q*10 - w*100 - sw*1000
	local s = math.modf(pN/10) - b*10 - q*100 - w*1000 - sw*10000
	local g = pN - s*10 - b*100 - q*1000 - w*10000 - sw*100000

	if(pN > 0) then
		table.insert(pTb , g)
	end
	if(pN > 10) then
		table.insert(pTb , s)
	end
	if(pN > 100) then
		table.insert(pTb , b)
	end
	if(pN > 1000) then
		table.insert(pTb , q)
	end
	if(pN > 10000) then
		table.insert(pTb , w)
	end

	if(pN > 100000) then
		table.insert(pTb , sw)
	end

	return pTb
end

local function fnPlayOneNumChangeAni( pLabel , pSNum , pFNum)
	if(not pLabel or not pSNum or not pFNum) then
		return
	end
	if(tonumber(pSNum) == tonumber(pFNum)) then
		return
	end

	local totleCount = 20
	local pTime = 0.02
	local play_count = 0
	local ptb = getNumber(pFNum)
	local pRunAction = nil

	local function changeLabel()
		local pStr = ""
		for i=1,#ptb do
			local pY = math.random(0,tonumber(ptb[i]))
			if(i == #ptb and pY == 0) then
				pY = 1
			end 
			pStr =  pY .. pStr
		end

		play_count = play_count + 1
		if(play_count >= totleCount) then
			if(pLabel.setText) then
				pLabel:setText(tostring(pFNum))
			elseif(pLabel.setStringValue) then
				pLabel:setStringValue(tostring(pFNum))
			end
			return
		end
		if(pLabel.setText) then
			pLabel:setText(pStr)
		elseif(pLabel.setStringValue) then
			pLabel:setStringValue(pStr)
		end
	end

	local arrSQ = CCArray:create()
	for i=1,totleCount do
		arrSQ:addObject( CCDelayTime:create(pTime) )
		arrSQ:addObject( CCCallFunc:create(changeLabel))
	end
	local fnSq1 = CCSequence:create(arrSQ)
	

	local pTT = totleCount*pTime+0.01

	local arrSQ2 = CCArray:create()
	arrSQ2:addObject( CCScaleTo:create(pTT*0.5, 1.5) )
	arrSQ2:addObject( CCScaleTo:create(pTT*0.5, 1.0) )
	local fnSq2 = CCSequence:create(arrSQ2)

	pRunAction = CCSpawn:createWithTwoActions(fnSq1,fnSq2)
	pLabel:runAction(pRunAction)
end

function fnPlayLabelAni(_key)
	if(not _key) then
		return
	end
	local pLabel = labelNodesAttr[_key] or nil
	local pSNum = originEquipAttr[_key] or nil
	local pFNum = finalEquipAttr[_key] or nil

	fnPlayOneNumChangeAni(pLabel,pSNum,pFNum)
end

local tipNode = nil--飞属性动画的node ， 每次切换人物等要先移除


local function flyEndCallback( ttfNode )
	if(not ttfNode) then
		return
	end
	ttfNode:removeFromParentAndCleanup(true)
	ttfNode = nil
end

local function fnRemoveTipNode(  )
	if(not tipNode) then
		return
	end
	tipNode:removeFromParentAndCleanup(true)
	tipNode = nil
end

--[[desc:移除飞属性动画的node
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function removeFlyText()
	labelNumLink = nil
	originNumLink = nil
	finalNumLink = nil
	labelNodesAttr = {}
	finalEquipAttr = {}
	originEquipAttr = {}
	if(not tipNode) then
		return
	end
	tipNode:removeFromParentAndCleanup(true)
	tipNode = nil
end


--[[desc:播放飞属性的动画
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function showFlyText(tParam , callbackFunc )
	if (#tParam==0) then 
		if (callbackFunc) then 
			callbackFunc()
		end 
		return 
	end 

	local runningScene = CCDirector:sharedDirector():getRunningScene()
	tipNode = CCNode:create()
	runningScene:addChild(tipNode,999999999)
	local colorPlus = ccc3(0x00,0xff,0x0) -- { red = 0x76, green=0xfc , blue =0x06 }
	local colorMinus = ccc3(0xff,0x0,0x0)  -- red = 0x76, green=0xfc , blue =0x06
	local color

	local movetime_label = 0.33  --字体向下飘的时间
	local pSize = runningScene:getContentSize()

	local sp1 = CCSprite:create("images/common/showflytext_bg1.png")	
	local oriSize = sp1:getContentSize()
	local rect = CCRect(oriSize.width/2-80,oriSize.height/2-15,160,30)
	local bgSp = CCScale9Sprite:create(rect,"images/common/showflytext_bg1.png")	
	tipNode:addChild(bgSp)
	bgSp:setScale(0)
	bgSp:setOpacity(0)
	local w = oriSize.width
	local h = #tParam * mFontSize + (#tParam-1) * mHangPart + mTopPart*2
	local bgSize = CCSizeMake(w,h)
	bgSp:setContentSize(bgSize)
	bgSp:setPosition(ccp(pSize.width/2,pSize.height/2))
	local starty = bgSize.height - mTopPart-mFontSize/2   --label的坐标
	local startx = bgSize.width/2
	
	local labelSize
	for i=1,#tParam do
		tParam[i].txt= tParam[i].txt .. " "
		if(tonumber(tParam[i].num)>=0 ) then
			color = colorPlus
			tParam[i].txt= tParam[i].txt .. "+"
		else
			color = colorMinus
		end
		-- add by chengliang
		local displayNum = tParam[i].num or 0
		-- 文字 
		local descNode = m_UI.createStrokeTTF(tParam[i].txt .. displayNum,color,ccc3(0x00, 0x31,0x00),false,mFontSize,g_sFontCuYuan)
		bgSp:addChild(descNode)
		descNode:setTag(i)

		if (i==1) then 
			descNode:setAnchorPoint(ccp(0.5,0.5))
			labelSize = descNode:getContentSize()
			descNode:setPosition(ccp(startx,starty-(i-1)*(mHangPart+mFontSize)))
		else
 			descNode:setAnchorPoint(ccp(0,0.5))
			descNode:setPosition(ccp(startx-labelSize.width/2,starty-(i-1)*(mHangPart+mFontSize)))
		end 
	end


	--文字向下飘
	local function callback( ... )
		for i=1,#tParam do
			local node = bgSp:getChildByTag(i)
			local pos = ccp(node:getPositionX(),node:getPositionY())
			local wpos = node:getParent():convertToWorldSpace(pos)
			node:retain()
			node:removeFromParentAndCleanup(false)
			tipNode:addChild(node)
			node:setPosition(wpos)
			node:release()

			local array = CCArray:create()
			local pKey = tParam[i].key or ""
			local pNode = labelNodesAttr[pKey] or nil
			if(pNode) then
				local pPoint = ccp(pNode:getPositionX(),pNode:getPositionY())
				local finalMoveToP = pNode:getParent():convertToWorldSpace(pPoint)
				local move1 = CCMoveTo:create(movetime_label , finalMoveToP)
				array:addObject(move1)
			end

			local function playAni( ... )
				fnPlayLabelAni(tParam[i].key)
				if(i == 1) then
					AudioHelper.playEffect("audio/effect/texiao_shuzhibianhua.mp3")
				end
			end

			array:addObject(CCCallFuncN:create(playAni))
			array:addObject(CCCallFuncN:create(flyEndCallback))

			if(i==#tParam) then
				array:addObject(CCCallFuncN:create(fnRemoveTipNode))
				if(callbackFunc) then
					array:addObject(CCCallFuncN:create(function ( ... )
						callbackFunc()
					end))
				end
			end
			node:runAction(CCSequence:create(array))
		end
	end


	-- 背景的运动
	local function getAction( ... ) 
		local fadeto0 = CCFadeTo:create(FRAME_TIME,128)
		local scale0 = CCScaleTo:create(FRAME_TIME,0.09)
		local spawn0 = CCSpawn:createWithTwoActions(fadeto0,scale0)

		local fadeto1 = CCFadeTo:create(FRAME_TIME*4,170)

		local fadeto2 = CCFadeTo:create(FRAME_TIME*8,255)
		local scale = CCScaleTo:create(FRAME_TIME*8,1.0)
		local spawn = CCSpawn:createWithTwoActions(scale,fadeto2)

		local delay = CCDelayTime:create(1.4)
		local func = CCCallFunc:create(callback)
		local fadeto3 = CCFadeTo:create(0.18,0)
		local array = CCArray:create()
		
		array:addObject(spawn0)
		array:addObject(fadeto1)
		array:addObject(spawn)
		array:addObject(delay)
		array:addObject(func)
		array:addObject(fadeto3)
		local seq = CCSequence:create(array)
		return seq
	end

	bgSp:runAction(getAction())
	AudioHelper.playSpecialEffect("texiao_zhandouli_feichu.mp3")


end

function setNumerialInfo(t_numerial_last, t_numerial_cur , t_nodes)
	originEquipAttr = t_numerial_last
	finalEquipAttr = t_numerial_cur
	labelNodesAttr = t_nodes
end

-- 计算属性变化的值
function showAttrChangeInfo(callbackFunc)

	if(table.isEmpty(finalEquipAttr))then
		finalEquipAttr = {}
	end
	local numerial_result = {}
	if(table.isEmpty(originEquipAttr))then
		numerial_result = finalEquipAttr
	else
		for c_k = 1,#finalEquipAttr do
			local pNum = tonumber(originEquipAttr[c_k]) or 0
			if(pNum > 0 )then
				numerial_result[c_k] = tonumber(finalEquipAttr[c_k]) - tonumber(originEquipAttr[c_k])
				originEquipAttr[c_k] = 0
			else
				numerial_result[c_k] = tonumber(finalEquipAttr[c_k])
			end
		end
		for l_k = 1, #originEquipAttr do
			local pNum = tonumber(originEquipAttr[l_k]) or 0
			if(pNum > 0)then
				numerial_result[l_k] = -pNum
			end
		end
	end
	local t_text = {}
	for key = 1 , #numerial_result do
		if(numerial_result[key]~=0) then
			local strName = ""
			if (key == 1) then
				strName = m_i18n[1068]
			elseif(key == 2  )then
				strName = m_i18n[1069]
			elseif(key == 3)then
				strName = m_i18n[1071]
			elseif(key == 4  )then
				strName = m_i18n[1070]
			elseif(key == 5)then
				strName = m_i18n[1072]
			elseif(key == 6)then
				strName = m_i18n[5309]
			end
			local o_text = {}
			o_text.txt = strName
			o_text.key = key
			o_text.num = numerial_result[key]
			table.insert(t_text, o_text)
		end
	end
	showFlyText(t_text , callbackFunc)

end

local function fnCheckHaveEquip( c_id , tInfo )
	if(not c_id or not tInfo) then
		return
	end
	for k,v in pairs(tInfo) do
		if(tonumber(v) == tonumber(c_id)) then
			return true
		end
	end
	return false
end

local function mSort( item1, item2 )
	local isPre = false
	local pID1 = tonumber(item1.suit) or 0
	local pID2 = tonumber(item2.suit) or 0
	if pID1 >= pID2 then
		isPre = true
	else
		isPre = false
	end
	return isPre
end

--[[desc:根据文字数组和颜色数组生成一个node
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function createOneNode(pTxts, pColors, fontsize, fontname, strokeColors)
	local descNode = CCNode:create()
	descNode:setAnchorPoint(ccp(0.5,0.5))

	local pTTFs = {}
	local pW = 0
	local pH = 0
	local pCount = table.count(pTxts)
	for j = 1, pCount do
		local strokeColor = strokeColors and strokeColors[j] or nil
		local pTTF = m_UI.createStrokeTTF(pTxts[j],pColors[j], strokeColor,nil,fontsize,fontname)
		pTTF:setAnchorPoint(ccp(0,0.5))
		pTTF:setPosition(ccp(pW , 0))
		descNode:setTag(10)
		descNode:addChild(pTTF)
		pW = pW + pTTF:getContentSize().width
		pH = pTTF:getContentSize().height
		table.insert(pTTFs,pTTF)
	end

	for k,v in pairs(pTTFs) do
		local pX = v:getPositionX() - pW*0.5
		v:setPositionX(pX)
	end		
	
	return descNode,pH
end


--[[desc:套装变化显示
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
-- function showEquipChangeInfo( _equipInfos , callbackFunc, showStrings, realPos)
-- 	if(not _equipInfos and table.isEmpty(showStrings)) then
-- 		callbackFunc()
-- 		return
-- 	end

-- 	local runningScene = CCDirector:sharedDirector():getRunningScene()
-- 	tipNode = CCNode:create()
-- 	runningScene:addChild(tipNode,999999999)
-- 	local pSize = runningScene:getContentSize()


-- 	local pInfos = {}
-- 	local pInfos2 = {}
-- 	local totleHeight = 0

-- 	if(_equipInfos) then

-- 		local color = ccc3(0xff ,0xff ,0xff)
-- 		local color2 = ccc3(0x4d ,0xec ,0x15)

-- 		local pEquipInfos = {}
-- 		local pArmInfo = _equipInfos.arm
-- 		for k,v in pairs(_equipInfos) do
-- 			if(k ~= "arm") then
-- 				table.insert(pEquipInfos , v)
-- 			end
-- 		end
-- 		if(#pEquipInfos > 1) then
-- 			table.sort(pEquipInfos , mSort)
-- 		end
-- 		local tbCount = table.count(pEquipInfos)
-- 		for i = 1 , tbCount do
-- 			local suitID = pEquipInfos[i].suit
-- 			if((not suitID) == false) then
-- 				local pSuit = mDB_suit.getDataById(suitID) or nil
-- 				local suitName = pSuit.name or ""
-- 				local pNum = 0
-- 				local suit_items = pSuit.suit_items or ""
-- 				local pArr = mSplit(suit_items, ",")
-- 				for k,v in pairs(pArr) do
-- 					if(fnCheckHaveEquip(v , pArmInfo)) then
-- 						pNum = pNum + 1
-- 					end
-- 				end

-- 				--飘字
-- 				-- local pCount = 0
-- 				local ppquality
-- 				for j = 1 , #pEquipInfos[i].info do
-- 					-- local ppname = pEquipInfos[i].info[j].name or ""
-- 					ppquality = pEquipInfos[i].info[j].quality or 3
-- 					-- local pTxts = {m_i18n[1601],"[" .. ppname .. "]" , m_i18n[5306]}
-- 					-- local colors = {color, g_QulityColor2[ppquality] , color}
					
-- 					-- local descNode,pH = createOneNode(pTxts , colors , mFontSize,mFontName)
-- 					-- local ptb = {descNode,pH}
-- 					-- totleHeight = totleHeight + pH
-- 					-- table.insert(pInfos,ptb)
					
-- 					-- descNode:setPosition(ccp(pSize.width*0.5,pSize.height*0.7 - (j-1)*(mHangPart+mFontSize*0.5)))
-- 					-- pNode:addChild(descNode)
-- 					-- pCount = pCount + 1
-- 				end
				
-- 				local pTxts = {"[" .. suitName .. "]" , m_i18n[1096] , tostring(pNum) , m_i18n[5308]}
-- 				local colors = {g_QulityColor2[ppquality], color , color2 , color}

-- 				local descNode,pH = createOneNode(pTxts , colors , mFontSize,mFontName)
-- 				local ptb = {descNode,pH}
-- 				totleHeight = totleHeight + pH
-- 				table.insert(pInfos,ptb)
-- 				-- descNode:setPosition(ccp(pSize.width*0.5,pSize.height*0.7 - pCount*(mHangPart+mFontSize*0.5)))
-- 				-- pNode:addChild(descNode)
-- 			end
-- 		end
-- 	end

-- 	if(not table.isEmpty(showStrings)) then
-- 		local tbCount = table.count(showStrings)
-- 		for i = 1 , tbCount do
-- 			local pTxts = {showStrings[i],}
-- 			local colors = {g_QulityColor2[3],}

-- 			local descNode,pH = createOneNode(pTxts , colors , mFontSize,mFontName)
-- 			local ptb = {descNode,pH}
-- 			totleHeight = totleHeight + pH
-- 			table.insert(pInfos2,ptb)
-- 		end
-- 	end

-- 	local pNode = CCNode:create()
-- 	local pNode2 = CCNode:create()
-- 	local pCount1 = table.count(pInfos)
-- 	local pCount2 = table.count(pInfos2) 
-- 	local pCount = pCount1 + pCount2
-- 	totleHeight = pCount*mHangPart + totleHeight
-- 	local pStartY = pSize.height*0.5 + totleHeight*0.5
-- 	for i=1,pCount do
-- 		local descNode
-- 		local pH
-- 		if(i <= pCount1) then
-- 			descNode = pInfos[i][1]
-- 			pH = pInfos[i][2]
-- 			pNode:addChild(descNode)
-- 		else
-- 			descNode = pInfos2[i-pCount1][1]
-- 			pH = pInfos2[i-pCount1][2]
-- 			pNode2:addChild(descNode)
-- 		end
-- 		local pY = pStartY - (i-1)*(mHangPart+pH*0.5)
-- 		descNode:setPosition(ccp(pSize.width*0.5,pY))
-- 	end

-- 	if(pCount1 > 0) then
-- 		local pCall
-- 		local pCall2
-- 		if(pCount2 == 0) then
-- 			pCall = fnRemoveTipNode
-- 			pCall2 = callbackFunc
-- 		end
-- 		local function moveincall( ... )
-- 			if(pCall) then
-- 				pCall()
-- 			end
-- 			if(pCall2) then
-- 				pCall2()
-- 			end
-- 		end
-- 		m_UI.fnPlayLR_FlyEff(pNode,moveincall)
-- 		tipNode:addChild(pNode)
-- 	end

-- 	if(pCount2 > 0) then
-- 		local pRealPos = realPos or ccp(0,0)
-- 		local moveTime = 0.5
-- 		local pCall = callbackFunc

-- 		local function flyToRealPos( ... )
-- 			for i=1,pCount2 do
-- 				local descNode = pInfos2[i][1]
-- 				if(descNode) then
-- 					descNode:runAction(CCMoveTo:create(moveTime, pRealPos))
-- 				end
-- 			end
-- 			if(pNode2) then
-- 				local actionArr = CCArray:create()
-- 				actionArr:addObject(CCDelayTime:create(moveTime))
-- 				actionArr:addObject(CCCallFuncN:create(function ( ... )
-- 			        if(pNode2) then
-- 			            pNode2:removeFromParentAndCleanup(true)
-- 			            pNode2 = nil
-- 			        end
-- 			    end))
-- 		    	actionArr:addObject(CCCallFuncN:create(fnRemoveTipNode))
-- 			    if(pCall) then
-- 			        actionArr:addObject(CCCallFuncN:create(function ( ... )
-- 			            pCall()
-- 			        end))
-- 			    end
-- 			    pNode2:runAction(CCSequence:create(actionArr))
-- 			end
-- 		end

-- 		m_UI.fnPlayLR_FlyEff(pNode2,flyToRealPos,true)
-- 		tipNode:addChild(pNode2)
-- 	end
-- end

-- 播放一键强化相关特效、属性变化
-- tbMasterChangeData = {
 --	   orignData 原始属性
 --    armData 装备强化属性变化的数值
 --    masterData 强化大师属性变化的数值
 --    finalData 最终属性
 --    masterChangeString 强化大师当前的描述
 --    orignFightForce 原始战斗力
 --    finalFightForce 现在战斗力
-- }
function playAutoStrenEffect( tbMasterChangeData, tbWidgets, callBack )
	logger:debug({tbMasterChangeData = tbMasterChangeData})
	if (not tbMasterChangeData or table.isEmpty(tbMasterChangeData)) then
		return
	end
	local scene = CCDirector:sharedDirector():getRunningScene()
	local textFlyTime = 0.33
	local particlePoses = {}
	local attribDes = {"life", "physicalAttack", "physicalDefend", "magicAttack", "magicDefend", "speed"}
	-- 分类移动不同位置的控件
	local lifeWidgets = {}
	local wugongWidgets = {}
	local wufangWidgets = {}
	local fagongWidgets = {}
	local fafangWidgets = {}
	local LAY_STR = nil
	local function insertTable( layout, data )
		-- 宝物五个位置
		local fivePos = {
			{ccp(layout.TFD_WUGONG:getPositionX(), layout.TFD_WUGONG:getPositionY()), ccp(layout.TFD_WUGONG_NUM:getPositionX(), layout.TFD_WUGONG_NUM:getPositionY())},
			{ccp(layout.TFD_MOGONG:getPositionX(), layout.TFD_MOGONG:getPositionY()), ccp(layout.TFD_MOGONG_NUM:getPositionX(), layout.TFD_MOGONG_NUM:getPositionY())},
			{ccp(layout.TFD_WUFANG:getPositionX(), layout.TFD_WUFANG:getPositionY()), ccp(layout.TFD_WUFANG_NUM:getPositionX(), layout.TFD_WUFANG_NUM:getPositionY())},
			{ccp(layout.TFD_MOFANG:getPositionX(), layout.TFD_MOFANG:getPositionY()), ccp(layout.TFD_MOFANG_NUM:getPositionX(), layout.TFD_MOFANG_NUM:getPositionY())},
		}
		local index = 1
		if (data.physicalAttack ~= 0) then
			table.insert(wugongWidgets, layout.TFD_WUGONG)
			table.insert(wugongWidgets, layout.TFD_WUGONG_NUM)
			table.insert(particlePoses, ccp(layout.TFD_WUGONG_NUM:getWorldPosition().x, layout.TFD_WUGONG_NUM:getWorldPosition().y))
			index = index + 1
		else
			layout.TFD_WUGONG:setVisible(false)
			layout.TFD_WUGONG_NUM:setVisible(false)
		end
		if (data.magicAttack ~= 0) then
			table.insert(fagongWidgets, layout.TFD_MOGONG)
			table.insert(fagongWidgets, layout.TFD_MOGONG_NUM)
			layout.TFD_MOGONG:setPositionType(0)
			layout.TFD_MOGONG_NUM:setPositionType(0)
			layout.TFD_MOGONG:setPosition(fivePos[index][1])
			layout.TFD_MOGONG_NUM:setPosition(fivePos[index][2])
			table.insert(particlePoses, ccp(layout.TFD_MOGONG_NUM:getWorldPosition().x, layout.TFD_MOGONG_NUM:getWorldPosition().y))
			index = index + 1
		else
			layout.TFD_MOGONG:setVisible(false)
			layout.TFD_MOGONG_NUM:setVisible(false)
		end
		if (data.physicalDefend ~= 0) then
			table.insert(wufangWidgets, layout.TFD_WUFANG)
			table.insert(wufangWidgets, layout.TFD_WUFANG_NUM)
			layout.TFD_WUFANG:setPositionType(0)
			layout.TFD_WUFANG_NUM:setPositionType(0)
			layout.TFD_WUFANG:setPosition(fivePos[index][1])
			layout.TFD_WUFANG_NUM:setPosition(fivePos[index][2])
			table.insert(particlePoses, ccp(layout.TFD_WUFANG_NUM:getWorldPosition().x, layout.TFD_WUFANG_NUM:getWorldPosition().y))
			index = index + 1
		else
			layout.TFD_WUFANG:setVisible(false)
			layout.TFD_WUFANG_NUM:setVisible(false)
		end
		if (data.magicDefend ~= 0) then
			table.insert(fafangWidgets, layout.TFD_MOFANG)
			table.insert(fafangWidgets, layout.TFD_MOFANG_NUM)
			layout.TFD_MOFANG:setPositionType(0)
			layout.TFD_MOFANG_NUM:setPositionType(0)
			layout.TFD_MOFANG:setPosition(fivePos[index][1])
			layout.TFD_MOFANG_NUM:setPosition(fivePos[index][2])
			table.insert(particlePoses, ccp(layout.TFD_MOFANG_NUM:getWorldPosition().x, layout.TFD_MOFANG_NUM:getWorldPosition().y))
			index = index + 1
		else
			layout.TFD_MOFANG:setVisible(false)
			layout.TFD_MOFANG_NUM:setVisible(false)
		end
		if (data.life ~= 0 and layout.TFD_SHENGMING) then
			table.insert(lifeWidgets, layout.TFD_SHENGMING)
			table.insert(lifeWidgets, layout.TFD_SHENGMING_NUM)
			if (index < 5) then
				layout.TFD_SHENGMING:setPositionType(0)
				layout.TFD_SHENGMING_NUM:setPositionType(0)
				layout.TFD_SHENGMING:setPosition(fivePos[index][1])
				layout.TFD_SHENGMING_NUM:setPosition(fivePos[index][2])
			end
			table.insert(particlePoses, ccp(layout.TFD_SHENGMING_NUM:getWorldPosition().x, layout.TFD_SHENGMING_NUM:getWorldPosition().y))
			index = index + 1
		elseif (layout.TFD_SHENGMING) then
			layout.TFD_SHENGMING:setVisible(false)
			layout.TFD_SHENGMING_NUM:setVisible(false)
		end
	end
	if (tbMasterChangeData.masterChangeString) then
		_autoGuruLayer = g_fnLoadUI("ui/formation_onekey_guru.json")
		-- 强化大师
		local masterChangeData = tbMasterChangeData.masterChangeString[1]
		-- 当前强化大师加成的属性
		local masterTotalData = MainEquipMasterCtrl.fnGetAttrInfo(1, masterChangeData.level)
		-- 格式化成指定字段的属性
		local newMasterTotalData = {}
		for k, info in pairs(masterTotalData) do
			newMasterTotalData[attribDes[tonumber(info[1])]] = tonumber(info[2])
		end
		--logger:debug({newMasterTotalData = newMasterTotalData})

		local masterData = newMasterTotalData--tbMasterChangeData.masterData
		insertTable(_autoGuruLayer.LAY_GURU, masterData)
		_autoGuruLayer.LAY_GURU.TFD_WUGONG_NUM:setText("+"..masterData.physicalAttack)
		_autoGuruLayer.LAY_GURU.TFD_MOGONG_NUM:setText("+"..masterData.magicAttack)
		_autoGuruLayer.LAY_GURU.TFD_WUFANG_NUM:setText("+"..masterData.physicalDefend)
		_autoGuruLayer.LAY_GURU.TFD_MOFANG_NUM:setText("+"..masterData.magicDefend)
		_autoGuruLayer.LAY_GURU.TFD_WUGONG:setText(m_i18n[1069])
		_autoGuruLayer.LAY_GURU.TFD_MOGONG:setText(m_i18n[1070])
		_autoGuruLayer.LAY_GURU.TFD_WUFANG:setText(m_i18n[1071])
		_autoGuruLayer.LAY_GURU.TFD_MOFANG:setText(m_i18n[1072])

		
		_autoGuruLayer.TFD_GURU:setText(masterChangeData.des..":")
		_autoGuruLayer.TFD_GURU_LEVEL:setText(masterChangeData.level..m_i18n[3643])
		-- 各种描边
		UIHelper.labelNewStroke(_autoGuruLayer.TFD_STR, ccc3(0x28, 0x00, 0x00))
		UIHelper.labelNewStroke(_autoGuruLayer.TFD_GURU, ccc3(0x28, 0x00, 0x00))
		UIHelper.labelNewStroke(_autoGuruLayer.TFD_GURU_LEVEL, ccc3(0x28, 0x00, 0x00))

		LAY_STR = _autoGuruLayer.LAY_STR
	else
		_autoGuruLayer = g_fnLoadUI("ui/formation_onekey_without_guru.json")

		LAY_STR = _autoGuruLayer
	end
	-- 装备属性
	local armData = tbMasterChangeData.armData
	insertTable(LAY_STR, armData)
	LAY_STR.TFD_WUGONG_NUM:setText("+"..armData.physicalAttack)
	LAY_STR.TFD_MOGONG_NUM:setText("+"..armData.magicAttack)
	LAY_STR.TFD_WUFANG_NUM:setText("+"..armData.physicalDefend)
	LAY_STR.TFD_MOFANG_NUM:setText("+"..armData.magicDefend)
	LAY_STR.TFD_SHENGMING_NUM:setText("+"..armData.life)
	LAY_STR.TFD_WUGONG:setText(m_i18n[1069])
	LAY_STR.TFD_MOGONG:setText(m_i18n[1070])
	LAY_STR.TFD_WUFANG:setText(m_i18n[1071])
	LAY_STR.TFD_MOFANG:setText(m_i18n[1072])
	_autoGuruLayer.TFD_SHENGMING:setText(m_i18n[1068])

	-- 初始状态看不见
	_autoGuruLayer.IMG_BG:setScale(0)
	
	-- 各种描边
	UIHelper.labelNewStroke(_autoGuruLayer.TFD_STR, ccc3(0x28, 0x00, 0x00))
	local flyWidgets = {lifeWidgets, wugongWidgets, wufangWidgets, fagongWidgets, fafangWidgets}
	for k, widgets in pairs(flyWidgets) do
		for k1, widget in pairs(widgets) do
			UIHelper.labelNewStroke(widget, ccc3(0x00, 0x31, 0x00))
		end
	end
	local isPlayedMusic = false

	function playFightForce( ... )
		fnShowFightForceChangeAni(nil, nil, {tbMasterChangeData.finalFightForce, tbMasterChangeData.orignFightForce})
	end
	local endFunc = playFightForce
	--真正执行文字向下飘
	function fly2Target( widgets, targetPos, type, func )
		local isPlayed = false
		for k, widget in pairs(widgets) do
			local worldPos = widget:getWorldPosition()
			widget:retain()
			widget:removeFromParentAndCleanup(false)
			_autoGuruAtrribLayer:addChild(widget)
			widget:setPosition(worldPos)
			widget:release()
			local actions = CCArray:create()
			actions:addObject(CCMoveTo:create(textFlyTime, targetPos))
			actions:addObject(CCCallFunc:create(function ( ... )
				-- 移除飞控件
				widget:removeFromParentAndCleanup(true)
				if (k == 1) then
					if (not isPlayedMusic) then
						isPlayedMusic = true
						AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
					end
					fnPlayOneNumChangeAni(tbWidgets[type], tbMasterChangeData.orignData[attribDes[type]], tbMasterChangeData.finalData[attribDes[type]])
				end
				if (endFunc) then
					endFunc()
					endFunc = nil
				end
			end))
			widget:runAction(CCSequence:create(actions))
		end
	end
	-- 向下飘文字的准备
	function doFly( ... )
		removeAutoFlyText()
		_autoGuruAtrribLayer = CCNode:create()
		scene:addChild(_autoGuruAtrribLayer, 999)
		for type, widgets in pairs(flyWidgets) do
			-- 取label
			local targetWidget = tbWidgets[type]
			-- label位置
			local targetPos = targetWidget:getWorldPosition()
			
			fly2Target(widgets, targetPos, type, nil)
		end
	end
	-- 背景的运动 
	local function getBgAction( ... ) 
		local fadeto0 = CCFadeTo:create(FRAME_TIME, 128)
		local scale0 = CCScaleTo:create(FRAME_TIME, 0.09)
		local spawn0 = CCSpawn:createWithTwoActions(fadeto0, scale0)
		local fadeto1 = CCFadeTo:create(FRAME_TIME*4, 170)
		local fadeto2 = CCFadeTo:create(FRAME_TIME*8, 255)
		local scale = CCScaleTo:create(FRAME_TIME*8, 1.0)
		local spawn = CCSpawn:createWithTwoActions(scale, fadeto2)
		local delay = CCDelayTime:create(1.5)
		local fadeto3 = CCFadeTo:create(0.18, 0)

		local func2 = CCCallFunc:create(doFly)
		local array = CCArray:create()
		-- array:addObject(spawn0)
		-- array:addObject(fadeto1)
		-- array:addObject(spawn)
		-- 第0 帧    比例 30      透明度 50
		array:addObject(CCSpawn:createWithTwoActions(CCFadeTo:create(0, 0.5), CCScaleTo:create(0, 0.3)))
		-- 第4 帧    比例 75      透明度100
		array:addObject(CCSpawn:createWithTwoActions(CCFadeTo:create(2/60, 1), CCScaleTo:create(2/60, 0.75)))
		-- 第8 帧    比例 120     透明度100	
		array:addObject(CCSpawn:createWithTwoActions(CCFadeTo:create(2/60, 1), CCScaleTo:create(2/60, 1.3)))
		array:addObject(CCSpawn:createWithTwoActions(CCFadeTo:create(1/60, 1), CCScaleTo:create(1/60, 1.3)))
		-- 第12帧    比例 95      透明度100
		array:addObject(CCSpawn:createWithTwoActions(CCFadeTo:create(3/60, 1), CCScaleTo:create(3/60, 0.9)))
		-- 第20帧    比例 100     透明度100
		array:addObject(CCSpawn:createWithTwoActions(CCFadeTo:create(6/60, 1), CCScaleTo:create(6/60, 1)))

		array:addObject(delay)
		array:addObject(func2)
		array:addObject(CCSpawn:createWithTwoActions(fadeto3, CCCallFunc:create(function ( ... )
			UIHelper.widgetFadeTo(_autoGuruLayer.IMG_BG, 0.18, 0, function ( ... )
				removeAutoStrenEffect()
			end)
		end)))
		
		return CCSequence:create(array)
	end
	--_autoGuruLayer.IMG_BG.getBgAction = getBgAction
	_autoGuruLayer.IMG_BG:runAction(getBgAction())
	scene:addChild(_autoGuruLayer, 999)

	AudioHelper.playEffect("audio/effect/mianban_qianghua_chenggong.mp3")
	-- 返回需要添加粒子特效的控件
	return particlePoses, _autoGuruLayer.IMG_BG
end

function removeAutoStrenEffect( ... )
	if (_autoGuruLayer) then
		_autoGuruLayer:removeFromParentAndCleanup(true)
		_autoGuruLayer = nil
	end
end

function removeAutoFlyText( ... )
	if (_autoGuruAtrribLayer) then
		_autoGuruAtrribLayer:removeFromParentAndCleanup(true)
		_autoGuruAtrribLayer = nil
	end
end

function removeAllAuto( ... )
	removeAutoStrenEffect()
	removeAutoFlyText()
end

--[[desc:套装变化显示
    _equipInfos: 套装变动信息
    showStrings: 强化大师信息
    unionId: 属性加成变动
    return: 是否有返回值，返回值说明  
—]]
function showEquipChangeInfo( _equipInfos , callbackFunc, showStrings, realPos, unionId)

	local runningScene = CCDirector:sharedDirector():getRunningScene()
	tipNode = CCNode:create()
	runningScene:addChild(tipNode,999999999)
	local pSize = runningScene:getContentSize()

	local sp1 = CCSprite:create("images/common/showflytext_bg1.png")	
	local oriSize = sp1:getContentSize()
	local rect = CCRect(oriSize.width/2-80,oriSize.height/2-15,160,30)
	local bgSp = CCScale9Sprite:create(rect,"images/common/showflytext_bg1.png")	
	tipNode:addChild(bgSp)
	bgSp:setPosition(ccp(pSize.width/2,pSize.height/2))
	bgSp:setScale(0)
	bgSp:setCascadeOpacityEnabled(true)
	bgSp:setOpacity(0)

	local bgSpW = oriSize.width
	local bgSpH

	local pUnion = {}	-- 属性加成信息
	local pInfos = {}	-- 套装信息
	local pInfos2 = {}	-- 强化大师信息
	local pInfos3 = {}	-- 基本属性信息
	local totleHeight = 0

	------------------ 属性加成 ------------------
	if (unionId) then
		local pTxts = {m_i18n[6106],}
		local colors = {ccc3(0xff, 0xf6, 0x00)}
		local strokes = {ccc3(0x31, 0x00, 0x00)}

		local descNode,pH = createOneNode(pTxts, colors, mFontSize, mFontName, strokes)
		local ptb = {descNode,pH}
		totleHeight = totleHeight + pH
		table.insert(pUnion,ptb)
	end
	------------------ 套装信息 ------------------
	if(_equipInfos) then

		local color = ccc3(0xff ,0xff ,0xff)
		local color2 = ccc3(0x4d ,0xec ,0x15)

		local pEquipInfos = {}
		local pArmInfo = _equipInfos.arm
		for k,v in pairs(_equipInfos) do
			if(k ~= "arm") then
				table.insert(pEquipInfos , v)
			end
		end
		if(#pEquipInfos > 1) then
			table.sort(pEquipInfos , mSort)
		end
		local tbCount = table.count(pEquipInfos)
		for i = 1 , tbCount do
			local suitID = pEquipInfos[i].suit
			if((not suitID) == false) then
				local pSuit = mDB_suit.getDataById(suitID) or nil
				local suitName = pSuit.name or ""
				local pNum = 0
				local suit_items = pSuit.suit_items or ""
				local pArr = mSplit(suit_items, ",")
				for k,v in pairs(pArr) do
					if(fnCheckHaveEquip(v , pArmInfo)) then
						pNum = pNum + 1
					end
				end

				--飘字
				local ppquality
				for j = 1 , #pEquipInfos[i].info do
					ppquality = pEquipInfos[i].info[j].quality or 3
				end
				
				local pTxts = {"[" .. suitName .. "]" , m_i18n[1096] , tostring(pNum) , m_i18n[5308]}
				local colors = {g_QulityColor2[ppquality], color , color2 , color}

				local descNode,pH = createOneNode(pTxts , colors , mFontSize,mFontName)
				local ptb = {descNode,pH}
				totleHeight = totleHeight + pH
				table.insert(pInfos,ptb)
			end
		end
	end

	------------------ 强化大师信息 ------------------
	if(showStrings and not table.isEmpty(showStrings)) then
		local tbCount = table.count(showStrings)
		for i = 1 , tbCount do
			local pTxts = {showStrings[i].des..":", showStrings[i].level..m_i18n[3643], }
			local colors = {ccc3(0xff, 0xff, 0xff), ccc3(0xff, 0xf6, 0x00)}
			local strokes = {ccc3(0x31, 0x00, 0x00), ccc3(0x31, 0x00, 0x00)}

			local descNode,pH = createOneNode(pTxts, colors, mFontSize,mFontName, strokes)
			local ptb = {descNode,pH}
			totleHeight = totleHeight + pH
			table.insert(pInfos2,ptb)
		end
	end

	------------------ 基础属性 ------------------
	local colorPlus = ccc3(0x4d,0xec,0x15) -- { red = 0x76, green=0xfc , blue =0x06 }
	local colorMinus = ccc3(0xff,0x00,0x00)  -- red = 0x76, green=0xfc , blue =0x06
	local color
	local strokeColor

	local movetime_label = 0.33  --字体向下飘的时间

	if(table.isEmpty(finalEquipAttr))then
		finalEquipAttr = {}
	end
	local numerial_result = {}
	if(table.isEmpty(originEquipAttr))then
		numerial_result = finalEquipAttr
	else
		for c_k = 1,#finalEquipAttr do
			local pNum = tonumber(originEquipAttr[c_k]) or 0
			if(pNum > 0 )then
				numerial_result[c_k] = tonumber(finalEquipAttr[c_k]) - tonumber(originEquipAttr[c_k])
				originEquipAttr[c_k] = 0
			else
				numerial_result[c_k] = tonumber(finalEquipAttr[c_k])
			end
		end
		for l_k = 1, #originEquipAttr do
			local pNum = tonumber(originEquipAttr[l_k]) or 0
			if(pNum > 0)then
				numerial_result[l_k] = -pNum
			end
		end
	end
	local t_text = {}
	for key = 1 , #numerial_result do
		if(numerial_result[key]~=0) then
			local strName = ""
			if (key == 1) then
				strName = m_i18n[1068]
			elseif(key == 2  )then
				strName = m_i18n[1069]
			elseif(key == 3)then
				strName = m_i18n[1071]
			elseif(key == 4  )then
				strName = m_i18n[1070]
			elseif(key == 5)then
				strName = m_i18n[1072]
			elseif(key == 6)then
				strName = m_i18n[5309]
			end
			local o_text = {}
			o_text.txt = strName
			o_text.key = key
			o_text.num = numerial_result[key]
			table.insert(t_text, o_text)
		end
	end
	
	local labelSize
	for i=1,#t_text do
		t_text[i].txt= t_text[i].txt .. " "
		if(tonumber(t_text[i].num)>=0 ) then
			color = colorPlus
			t_text[i].txt= t_text[i].txt .. "+"
			strokeColor = ccc3(0x00, 0x31, 0x00)
		else
			color = colorMinus
			strokeColor = ccc3(0x31, 0x00, 0x00)
		end
		-- add by chengliang
		local displayNum = t_text[i].num or 0
		-- 文字 
		local descNode = m_UI.createStrokeTTF(t_text[i].txt .. displayNum,color,ccc3(0x31, 0x00,0x00),false,mFontSize,g_sFontCuYuan)
		local pH = 38
		local ptb = {descNode,pH}
		totleHeight = totleHeight + pH
		table.insert(pInfos3,ptb)
	end


	--文字向下飘
	local function doGoTarget( ... )
		for i=1,#t_text do
			local node = bgSp:getChildByTag(i)
			local pos = ccp(node:getPositionX(),node:getPositionY())
			local wpos = node:getParent():convertToWorldSpace(pos)
			node:retain()
			node:removeFromParentAndCleanup(false)
			tipNode:addChild(node)
			node:setPosition(wpos)
			node:release()

			local array = CCArray:create()
			local pKey = t_text[i].key or ""
			local pNode = labelNodesAttr[pKey] or nil
			if(pNode) then
				local pPoint = ccp(pNode:getPositionX(),pNode:getPositionY())
				local finalMoveToP = pNode:getParent():convertToWorldSpace(pPoint)
				local move1 = CCMoveTo:create(movetime_label , finalMoveToP)
				array:addObject(move1)
			end

			local function playAni( ... )
				fnPlayLabelAni(t_text[i].key)
				if(i == 1) then
					AudioHelper.playEffect("audio/effect/texiao_shuzhibianhua.mp3")
				end
			end

			array:addObject(CCCallFuncN:create(playAni))
			array:addObject(CCCallFuncN:create(flyEndCallback))

			if(i==#t_text) then
				array:addObject(CCCallFuncN:create(fnRemoveTipNode))
				if(callbackFunc) then
					array:addObject(CCCallFuncN:create(function ( ... )
						callbackFunc()
					end))
				end
			end
			node:runAction(CCSequence:create(array))
		end
	end

	------------------ 添加各个文字节点在背景上 ------------------
	local pCount0 = table.count(pUnion)
	local pCount1 = table.count(pInfos)
	local pCount2 = table.count(pInfos2) 
	local pCount3 = table.count(pInfos3)
	local pCount = pCount1 + pCount2 + pCount3 + pCount0
	totleHeight = pCount*mHangPart + totleHeight

	bgSpH = pCount * mFontSize + (pCount-1) * mHangPart + mTopPart * 2
	bgSp:setContentSize(CCSizeMake(bgSpW,bgSpH))
	local pStartY = bgSpH - mTopPart-mFontSize/2   --label的起始y坐标

	-- 添加文字节点
	local count = 0
	local isAddLine = false
	local tAll = {pUnion, pInfos, pInfos2, pInfos3}
	local tCount = {pCount0, pCount1, pCount2, pCount3}
	local attribLabelWidth = 0
	for k, tbInfo in pairs(tAll) do
		-- 添加一根割割割割割线
		if (isAddLine and k == 4) then
			local pLine = CCSprite:create("images/common/showflytext_bg2.png")
			bgSp:addChild(pLine)
			local pY = pStartY - (count)*(mHangPart+mFontSize) + (mHangPart+mFontSize)/2
			pLine:setAnchorPoint(ccp(0.5,0.5))
			pLine:setPosition(ccp(bgSpW/2, pY))
		end
		for i = 1, tCount[k] do
			isAddLine = true
			count = count + 1
			local descNode
			local pH
			descNode = tbInfo[i][1]
			pH = tbInfo[i][2]
			bgSp:addChild(descNode)
			local pY = pStartY - (count-1)*(mHangPart+mFontSize)
			descNode:setAnchorPoint(ccp(0.5,0.5))
			descNode:setPosition(ccp(bgSpW/2,pY))
			if (k == 4) then
				descNode:setTag(i)
				if (i == 1) then 
					attribLabelWidth = descNode:getContentSize().width
				else
		 			descNode:setAnchorPoint(ccp(0,0.5))
					descNode:setPosition(ccp(bgSpW/2 - attribLabelWidth/2, pY))
				end
			end
		end
	end

	-- 返回的所有子节点
	function getChildren( node )
		local tbChildren = {}
		tolua.cast(node, "CCScale9Sprite")
		local arrChildren = node:getChildren()
		for i = 1, node:getChildrenCount() do
			local widgetChild = arrChildren:objectAtIndex(i - 1)
			table.insert(tbChildren, widgetChild)
			for k, v in pairs(getChildren(widgetChild)) do
				table.insert(tbChildren, v)
			end
		end

		return tbChildren
	end

	-- 背景的运动 
	local function getAction( ... ) 
		local fadeto0 = CCFadeTo:create(FRAME_TIME,128)
		local scale0 = CCScaleTo:create(FRAME_TIME,0.09)
		local spawn0 = CCSpawn:createWithTwoActions(fadeto0,scale0)
		local fadeto1 = CCFadeTo:create(FRAME_TIME*4,170)
		local fadeto2 = CCFadeTo:create(FRAME_TIME*8,255)
		local scale = CCScaleTo:create(FRAME_TIME*8,1.0)
		local spawn = CCSpawn:createWithTwoActions(scale,fadeto2)
		local delay = CCDelayTime:create(1.5)
		local fadeto3 = CCFadeTo:create(0.18,0)

		--local func1 = CCCallFunc:create(fnRemoveTipNode)   --tipNode移除
		local func2 = CCCallFunc:create(doGoTarget)
		local array = CCArray:create()
		
		array:addObject(spawn0)
		array:addObject(fadeto1)
		array:addObject(spawn)
		array:addObject(delay)
		array:addObject(func2)
		--array:addObject(fadeto3)
		array:addObject(CCSpawn:createWithTwoActions(fadeto3, CCCallFunc:create(function ( ... )
			-- 所有子节点执行fadeout动作
			local children = getChildren(bgSp)
			for k,v in pairs(children) do
				v:runAction(CCFadeTo:create(0.18,0))
			end
		end)))
		--array:addObject(func1)
		
		local seq = CCSequence:create(array)
		return seq
	end

	bgSp:runAction(getAction())
	AudioHelper.playSpecialEffect("texiao_zhandouli_feichu.mp3")
end


local function fnCheckHaveLink( l_id , befInfo)
	if(not l_id or not befInfo) then
		return
	end
	for k,v in pairs(befInfo) do
		local pID = v.dbInfo.id
		if(tonumber(pID) == tonumber(l_id)) then
			return true
		end
	end
	return false
end

--[[desc:检测小伙伴羁绊变化，获取变化数组
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function fnGetLinkChanged( heroInfo )
	if(not heroInfo) then
		return nil
	end
	local befActiveUnion,curActiveUnion = FormLitFriScrollView.getBefCurLinkInfo()

	local mHeroHtid = heroInfo.htid

	local pTb = {}
	for k,v in pairs(curActiveUnion) do
		if(v and v.dbInfo) then
			local dbUnion = v.dbInfo
			local pID = dbUnion.id
			if(not fnCheckHaveLink(pID , befActiveUnion)) then
				local pLink = dbUnion.union_arribute_name or ""
				local card_ids = mSplit(dbUnion.union_card_ids, ",")
		        for key,type_card in pairs(card_ids) do
		        	local type_card_arr = mSplit(type_card, "|")
		        	if(tonumber(type_card_arr[1]) == 1) then
		        		local pHtid = type_card_arr[2]
		        		if(
		        			(pHtid ~= mHeroHtid) and
		        		  	(HeroPublicUtil.isBusyWithHtid(pHtid) or HeroPublicUtil.isOnBenchByHtid(pHtid))
		        		  ) then
		        			local t_heroInfo = mDB_hero.getDataById(pHtid)
		        			local pName = t_heroInfo.name or ""
        					local pQuality = t_heroInfo.potential or 3
		        			table.insert(pTb , {heronName = pName , heroQuality = pQuality , linkName = pLink})
		        		end
		        	end
		        end
			end
		end
	end

	return pTb
end

--[[desc:检测换人时羁绊变化，获取变化数组
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function fnGetFormationLinkChanged( mNewChangeHero )
	if(not mNewChangeHero) then
		return nil
	end

	local pDB = mNewChangeHero.localInfo or nil
	if(not pDB) then
		local pHtid = mNewChangeHero.htid
		pDB = mDB_hero.getDataById(pHtid)
	end
	if(not pDB) then
		return nil
	end
	local linkGroup = pDB.link_group1
	if(not linkGroup) then
		return nil
	end
	local linkGroupArr = lua_string_split(linkGroup, ",")

	local pTb = {}
    require "script/module/formation/FormationUtil"
    for i,v in ipairs(linkGroupArr) do
        local heroUnionInfo = mDB_unicon.getDataById(v)
        openUnion = FormationUtil.isUnionActive(v, mNewChangeHero.hid)
        if(openUnion) then
        	local pLink = heroUnionInfo.union_arribute_name or ""
        	local pName = pDB.name or ""
        	local pQuality = pDB.potential or 3
        	local pkey = i
        	table.insert(pTb , {heronName = pName , heroQuality = pQuality , linkName = pLink , key = pkey})
        end
    end
	return pTb
end

function fnSetLinkNumberInfo(oldNumber , newNumber , numberLabel)
	labelNumLink = numberLabel
	originNumLink = oldNumber
	finalNumLink = newNumber
end

function fnSetLinkNumberTrue( ... )
	if(not labelNumLink == false) then
		labelNumLink:stopAllActions()
		local pFinal = tonumber(finalNumLink) or 0
		labelNumLink:setStringValue(pFinal)
	end
	
	if(not tipNode) then
		return
	end
	tipNode:removeFromParentAndCleanup(true)
	tipNode = nil
end

function showSellInfo( ... )
	if(not labelNumLink) then
		return
	end

	local pTime = 0.3
	local pTime2 = 0.3
	local pScale = 1.3
	local pNow = tonumber(originNumLink) or 0
	local pFinal = tonumber(finalNumLink) or 0

	local pAction

	local function changeLabel()
		pNow = pNow + 1
		labelNumLink:setStringValue(pNow)
		if(pNow >= pFinal and pAction) then
			labelNumLink:stopAction(pAction)
			local arrAcc = CCArray:create()
			arrAcc:addObject( CCCallFuncN:create(function( ... )
				labelNumLink = nil
				fnShowFightForceChangeAni()
			end))
			labelNumLink:runAction(CCSequence:create(arrAcc))
		end
	end

	local arrSQ = CCArray:create()
	arrSQ:addObject( CCDelayTime:create(pTime))
	arrSQ:addObject( CCCallFunc:create(changeLabel))
	arrSQ:addObject( CCScaleTo:create(pTime2, pScale) )
	arrSQ:addObject( CCScaleTo:create(pTime2, 1.0) )
	pAction = CCRepeatForever:create(CCSequence:create(arrSQ))
	
	labelNumLink:runAction(pAction)
end

--[[desc:显示羁绊的变化
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function showLinkChangeInfo( _linkInfo , _finNode , _labelNodes , callbackFunc)
	if(not _linkInfo or #_linkInfo <= 0) then
		callbackFunc()
		return
	end

	local runningScene = CCDirector:sharedDirector():getRunningScene()
	tipNode = CCNode:create()
	runningScene:addChild(tipNode,999999999)
	local colorPlus 		= ccc3(0x76,0xfc,0x06) -- { red = 0x76, green=0xfc , blue =0x06 }
	local colorMinus 		= ccc3(0xff,0x0,0x0)  -- red = 0x76, green=0xfc , blue =0x06
	local color = colorPlus
	local delayTime1 = 0.3
	local delayTime2 = 1.5
	local moveTime1 = 0.5
	local moveTime2 = 0.6
	local pSize = runningScene:getContentSize()
	local openUnionColor    = ccc3(179 ,29  ,0  )         --开放的羁绊
	local normUnionColor    = ccc3(83  ,52  ,32 )         --未开放的羁绊
	local scaleTime = 0.5
	local color1 = g_QulityColor2[3]
	local color2 = ccc3(0xff,0xff,0xff)


	local mfinPoint
	if(_finNode) then
		local pPoint = ccp(_finNode:getPositionX(),_finNode:getPositionY())
		mfinPoint = _finNode:getParent():convertToWorldSpace(pPoint)
	else
		mfinPoint = ccp(0,0)
	end
	
	for i = 0 , #_linkInfo do
		local pTxt
		local descNode
		local plable = nil
		local pheight = 0
		
		if(i == 0) then
			pTxt = m_i18n[5301]
			descNode = m_UI.createStrokeTTF(pTxt,color1,nil,nil,mFontSize,mFontName)
			descNode:setAnchorPoint(ccp(0.5,0.5))
			descNode:setPosition(ccp(pSize.width*0.5,pSize.height*0.7))
			tipNode:addChild(descNode)
		else
			local pTxts = {m_i18n[5302] , "[" .. _linkInfo[i].heronName .. "]" , m_i18n[5303] , "[" .. _linkInfo[i].linkName .. "]"}
			local ppColor = g_QulityColor2[_linkInfo[i].heroQuality] or color1
			local pColors = {color2 , ppColor , color2 , color1}
			descNode = createOneNode(pTxts , pColors , mFontSize,mFontName)
			descNode:setPosition(ccp(pSize.width*0.5,pSize.height*0.7 - i*(mHangPart+mFontSize*0.5)))
			tipNode:addChild(descNode)
			
			if(_labelNodes) then
				plable = _labelNodes[_linkInfo[i].key] or nil
			end
			if(plable) then
				plable:setColor(normUnionColor)
			end
		end

		descNode:setVisible(false)
		descNode:setPositionX(descNode:getPositionX() - pSize.width*0.2)
		local actionArr = CCArray:create()
		actionArr:addObject(CCDelayTime:create(delayTime1))
		actionArr:addObject(CCCallFuncN:create(function ( ... )
			descNode:setVisible(true)
		end))
		local nextPoint = ccp(descNode:getPositionX() + pSize.width*0.2 , descNode:getPositionY())
		actionArr:addObject(CCEaseOut:create(CCMoveTo:create(moveTime1, nextPoint),2))
		actionArr:addObject(CCDelayTime:create(delayTime2))
		if(_finNode) then
			actionArr:addObject(CCMoveTo:create(moveTime2, mfinPoint))
		end
		actionArr:addObject(CCCallFuncN:create(function ( ... )
			tipNode:setVisible(false)
		end))

		if(plable) then
			actionArr:addObject(CCCallFuncN:create(function ( ... )
				plable:setColor(openUnionColor)
				local acArr = CCArray:create()
				acArr:addObject(CCScaleTo:create(scaleTime*0.5 , 1.3))
				acArr:addObject(CCScaleTo:create(scaleTime*0.5 , 1))
				plable:runAction(CCSequence:create(acArr))
			end))
		end

		if(i == #_linkInfo) then
			actionArr:addObject(CCCallFuncN:create(fnRemoveTipNode))
			if(callbackFunc ) then
				actionArr:addObject(CCCallFuncN:create(function ( ... )
					callbackFunc()
				end))
			end
		end
		descNode:runAction(CCSequence:create(actionArr))
	end
end

--战斗力数字改变
local function changeNumber( _label , _old , _final , callBack )
	local pLabel = _label or nil
	if(not _label) then
		if(not callBack == false) then
			callBack()
		end
		return
	end
	local old = tonumber(_old) or 0
	local final = tonumber(_final) or 0
	if(old == final) then
		if(not callBack == false) then
			callBack()
		end
	end
	local pRes = final-old
	local pRRes = math.abs(pRes)
	local pTotleTime = pRRes < 10 and pRRes or 10
	local pChange = pRRes < 10 and pRes or math.modf(pRes/10)
	local pTime = 0
	local pPart = 0.05

	local function fnChangeNum( ... )
		pTime = pTime + 1
		if(pTime < pTotleTime) then
			local pNum = old + pTime*pChange
			pLabel:setString(pNum.."")
		else
			pLabel:setString(final.."")
		end
	end

	local pArray = CCArray:create()
	for i=1,pTotleTime do
		local pDelay = CCDelayTime:create(pPart)
		pArray:addObject(pDelay)
		local pChange = CCCallFuncN:create(fnChangeNum)
		pArray:addObject(pChange)
	end
	if(not callBack == false) then
		local pCall = CCCallFuncN:create(callBack)
		pArray:addObject(pCall)
	end
	pLabel:runAction(CCSequence:create(pArray))
end

--战斗里动画结束后有回调
local function fnRemoveTipNodeWithCallBack(callBack )
	if(not tipNode)then 
		return 
	end 
	tipNode:removeFromParentAndCleanup(true)
	tipNode = nil

	if(callBack)then 
		callBack()
	end
end

-- --战斗力滑出屏幕，node移除
-- local function pMoveOut( callBack )
-- 	if(not tipNode) then
-- 		return
-- 	end
-- 	local pX = tipNode:getPositionX()
-- 	local pY = tipNode:getPositionY()
-- 	local accArr = CCArray:create()
-- 	local ppMove = CCMoveTo:create(14/60 , ccp(pX - 556 , pY))
-- 	local ppFadeOut = CCFadeOut:create(14/60)
-- 	local ppSpawn = CCSpawn:createWithTwoActions(ppMove , ppFadeOut)
-- 	accArr:addObject(ppSpawn)
-- 	local ppCall = CCCallFuncN:create( function ( ... )
-- 		-- fnRemoveTipNode(callBack)
-- 		 fnRemoveTipNodeWithCallBack(callBack)
-- 	end )
-- 	accArr:addObject(ppCall)
-- 	tipNode:runAction(CCSequence:create(accArr))
-- end

--战斗力滑出屏幕，node移除
local function pMoveOut( callBack )
	if(not tipNode) then
		return
	end
	local accArr = CCArray:create()
	local ppFadeOut = CCFadeOut:create(14/60)
	accArr:addObject(ppFadeOut)
	local ppCall = CCCallFuncN:create( function ( ... )
		-- fnRemoveTipNode(callBack)
		 fnRemoveTipNodeWithCallBack(callBack)
	end )
	accArr:addObject(ppCall)
	tipNode:runAction(CCSequence:create(accArr))
end

--[[desc:播放战斗力变化特效
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
-- function fnShowFightForceChangeAni( ph,fnCallBack)
-- 	local pNumFinal , pNumNow = UserModel.getFightForceValueNewAndOld()
-- 	if(tonumber(pNumFinal) == tonumber(pNumNow)) then
-- 		return
-- 	end

-- 	local runningScene = CCDirector:sharedDirector():getRunningScene()
-- 	local pWSize = runningScene:getContentSize()

-- 	local m_height = tonumber(ph) or (280/1136)*pWSize.height

-- 	local pfilePath = "images/formation/fightForce/"
-- 	tipNode = CCNode:create()
-- 	runningScene:addChild(tipNode,999999999)

-- 	local middlePos = ccp(pWSize.width*0.5 , m_height)
-- 	local pDelayWaitTime = 0.8

-- 	--红底
-- 	local pRed = CCSprite:create(pfilePath .. "red.png")
-- 	if(pRed) then
-- 		pRed:setAnchorPoint(0.5,0.5)
-- 		pRed:setPosition(ccp(middlePos.x + 518, middlePos.y))
-- 		tipNode:addChild(pRed)
-- 		pRed:setVisible(false)
-- 		pRed:setScaleY(0.2)

-- 		local actionArr = CCArray:create()
-- 		actionArr:addObject(CCDelayTime:create(pDelayWaitTime))--0
-- 		actionArr:addObject(CCCallFuncN:create(function( ... )
-- 			pRed:setVisible(true)
-- 		end))
-- 		local pfadein = CCFadeIn:create(12/60)
-- 		local pMove1 = CCMoveTo:create(12/60 , ccp(middlePos.x + 462 , middlePos.y))
-- 		local pSpawn1 = CCSpawn:createWithTwoActions(pfadein , pMove1)
-- 		actionArr:addObject(pSpawn1)--1
-- 		local pScale1 = CCScaleTo:create(4/60,1,1)
-- 		actionArr:addObject(pScale1)--2
-- 		actionArr:addObject(CCCallFuncN:create(function( ... )
-- 			AudioHelper.playEffect("audio/effect/texiao_zhandouli_feichu.mp3")
-- 		end))
-- 		local pMove2 = CCMoveTo:create(10/60 , ccp(middlePos.x , middlePos.y))
-- 		actionArr:addObject(pMove2)--3
-- 		pRed:runAction(CCSequence:create(actionArr))
-- 	end
-- 	--战斗力
-- 	local pZhandou = CCSprite:create(pfilePath .. "fightnumber.png")
-- 	if(pZhandou) then
-- 		local pStartx

-- 		pZhandou:setAnchorPoint(0.5,0.5)
-- 		local pWidth = pZhandou:getContentSize().width
-- 		tipNode:addChild(pZhandou)
-- 		pZhandou:setVisible(false)
-- 		pZhandou:setScaleY(0.2)
		
-- 		local labelAtlas = CCLabelAtlas:create(pNumNow, pfilePath .. "number.png", 28, 39, 48)
-- 		labelAtlas:setAnchorPoint(0,0)
-- 		local pLabelX = pZhandou:getContentSize().width + 5
-- 		labelAtlas:setPosition(ccp(pLabelX, 0))
-- 		pZhandou:addChild(labelAtlas)

-- 		pWidth = pWidth + 5 + labelAtlas:getContentSize().width
-- 		pStartx = middlePos.x - pWidth*0.5 + pZhandou:getContentSize().width*0.5
-- 		pZhandou:setPosition(ccp(pStartx + 498, middlePos.y))

-- 		local actionArr = CCArray:create()
-- 		actionArr:addObject(CCDelayTime:create(pDelayWaitTime))--0
-- 		local pseq = CCSequence:createWithTwoActions(CCDelayTime:create(12/60) 
-- 			, CCCallFuncN:create(function ( ... )
-- 			pZhandou:setVisible(true)
-- 		end))
-- 		actionArr:addObject(pseq)--1
-- 		local pArr = CCArray:create()
-- 		local pfadein = CCFadeIn:create(12/60)
-- 		pArr:addObject(pfadein)
-- 		local pScale1 = CCScaleTo:create(12/60 , 1,2)
-- 		pArr:addObject(pScale1)
-- 		local pMove1 = CCMoveTo:create(12/60 , ccp(pStartx - 20 , middlePos.y))
-- 		pArr:addObject(pMove1)
-- 		local pSpawn1 = CCSpawn:create(pArr)
-- 		actionArr:addObject(pSpawn1)--2
-- 		local pMove2 = CCMoveTo:create(6/60 , ccp(pStartx - 49 , middlePos.y))
-- 		actionArr:addObject(pMove2)--3
-- 		local pScale2 = CCScaleTo:create(12/60 ,1)
-- 		local pMove3 = CCMoveTo:create(12/60 , ccp(pStartx , middlePos.y))
-- 		local pSpawn2 = CCSpawn:createWithTwoActions(pScale2,pMove3)
-- 		actionArr:addObject(pSpawn2)--4
-- 		local pCallback = CCCallFuncN:create(function ( ... )
-- 				local pChange = tonumber(pNumFinal) - tonumber(pNumNow)
-- 				local pName = pChange > 0 and "up.png" or "down.png"
-- 				local pStateImgX = pLabelX + labelAtlas:getContentSize().width + 5
-- 				local pStateImg = CCSprite:create(pfilePath .. pName)
-- 				pStateImg:setAnchorPoint(0,0)
-- 				local pStartY = pChange > 0 and 0 or 27
-- 				pStateImg:setPosition(ccp(pStateImgX, pStartY))
-- 				pZhandou:addChild(pStateImg)

-- 				local function stateImgUpAni( ... )
-- 					local height1 = 16
-- 					local height2 = 27
-- 					if(pChange < 0) then
-- 						height1 = 11
-- 						height2 = 0
-- 						AudioHelper.playEffect("audio/effect/texiao_zhandouli_down.mp3")	
-- 					else
-- 						AudioHelper.playEffect("audio/effect/texiao_zhandouli_jiantou.mp3")
-- 					end
-- 					local pAccArr = CCArray:create()
-- 					local ppMove1 = CCMoveTo:create(14/60 , ccp(pStateImgX , height1))
-- 					pAccArr:addObject(ppMove1)--1
-- 					local ppMove2 = CCMoveTo:create(42/60 , ccp(pStateImgX , height2))
-- 					pAccArr:addObject(ppMove2)--2
-- 					local ppFadeOut = CCFadeOut:create(32/60)
-- 					pAccArr:addObject(ppFadeOut)--3
-- 					-- local ppCall = CCCallFuncN:create(pMoveOut)

-- 					local ppCall = CCCallFuncN:create(function ( ... )
-- 						pMoveOut(fnCallBack)
-- 					end)
-- 					pAccArr:addObject(ppCall)--4
-- 					pStateImg:runAction(CCSequence:create(pAccArr))
-- 				end

-- 				AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
-- 				changeNumber(labelAtlas, pNumNow , pNumFinal , stateImgUpAni)
-- 			end)
-- 		actionArr:addObject(pCallback)--5
-- 		pZhandou:runAction(CCSequence:create(actionArr))
-- 	end
-- end

--[[desc:播放战斗力变化特效
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function fnShowFightForceChangeAni( ph,fnCallBack,tbFight)
	removeFlyText()
	local pNumFinal , pNumNow = UserModel.getFightForceValueNewAndOld()
	logger:debug("pNumFinal:"..pNumFinal.." pNumNow:"..pNumNow)

	if(tbFight)then 
		pNumFinal = tbFight[1]
		pNumNow = tbFight[2]
	end 

	if(tonumber(pNumFinal) == tonumber(pNumNow)) then
		return
	end

	local deltaNum = tonumber(pNumFinal) - tonumber(pNumNow)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local pWSize = runningScene:getContentSize()

	local m_height = tonumber(ph) or (280/1136)*pWSize.height

	local pfilePath = "images/formation/fightForce/"
	tipNode = CCNode:create()
	runningScene:addChild(tipNode,999999999)

	local middlePos = ccp(pWSize.width*0.5 , m_height)
	local pDelayWaitTime = 8/60

	--红底
	local pRed = CCSprite:create(pfilePath .. "red.png")
	if(pRed) then
		pRed:setAnchorPoint(0.5,0.5)
		pRed:setPosition(ccp(middlePos.x, middlePos.y))
		tipNode:addChild(pRed)

		pRed:runAction(CCFadeIn:create(pDelayWaitTime))
	end

	--战斗力
	local pZhandou = CCSprite:create(pfilePath .. "fightnumber.png")
	if(pZhandou) then

		pZhandou:setAnchorPoint(0.5,0.5)
		local pWidth = pZhandou:getContentSize().width
		tipNode:addChild(pZhandou)
		pZhandou:setVisible(false)
		pZhandou:setScaleY(0.2)
		
		local labelAtlas = CCLabelAtlas:create(pNumNow, pfilePath .. "number.png", 20, 27, 48)
		labelAtlas:setAnchorPoint(0,0)
		local pLabelX = pZhandou:getContentSize().width + 5
		labelAtlas:setPosition(ccp(pLabelX, 0))
		pZhandou:addChild(labelAtlas)

		pWidth = pWidth + 5 + labelAtlas:getContentSize().width
		local pStartx = middlePos.x - pWidth*0.5 + pZhandou:getContentSize().width*0.5
		pZhandou:setPosition(ccp(pStartx , middlePos.y))

		local actionArr = CCArray:create()
		actionArr:addObject(CCDelayTime:create(pDelayWaitTime)) -- 0
		actionArr:addObject(CCCallFuncN:create(function( ... )
			pZhandou:setVisible(true)
		end))
		
			local actArr1 = CCArray:create()
			actArr1:addObject(CCFadeIn:create(6/60))
			actArr1:addObject(CCScaleTo:create(6/60,1,1.5))
			actArr1:addObject(CCMoveTo:create(6/60,ccp(pStartx,middlePos.y+29)))
			local pSpawn1 = CCSpawn:create(actArr1)
		actionArr:addObject(pSpawn1) -- 1

			local actArr2 = CCArray:create()
			actArr2:addObject(CCScaleTo:create(4/60,1,0.9))
			actArr2:addObject(CCMoveTo:create(4/60,ccp(pStartx,middlePos.y-3)))
			local pSpawn2 = CCSpawn:create(actArr2)
		actionArr:addObject(pSpawn2) -- 2

			local actArr3 = CCArray:create()
			actArr3:addObject(CCScaleTo:create(4/60,1,1))
			actArr3:addObject(CCMoveTo:create(4/60,ccp(pStartx,middlePos.y)))
			local pSpawn3 = CCSpawn:create(actArr3)
		actionArr:addObject(pSpawn3) -- 3

		local deltaY = deltaNum > 0 and 1 or -1
		function getAction( ... )
			local pAccArr = CCArray:create()
			-- 第 0 帧     位移 0；0      透明度0
			--pAccArr:addObject(CCSpawn:createWithTwoActions(CCMoveTo:create(0, ccp(pStateImgX, positionY)), CCFadeTo:create(0, 0)))
			-- 第 10 帧    位移 0；3      透明度100
			pAccArr:addObject(CCSpawn:createWithTwoActions(CCMoveBy:create(15/60, ccp(0, 3 * deltaY)), CCFadeTo:create(15/60, 255)))
			-- 第 30 帧    位移 0；9      透明度100
			pAccArr:addObject(CCSpawn:createWithTwoActions(CCMoveBy:create(35/60, ccp(0, 6 * deltaY)), CCFadeTo:create(35/60, 255)))
			-- 第 40 帧    位移 0；12     透明度0
			pAccArr:addObject(CCSpawn:createWithTwoActions(CCMoveBy:create(25/60, ccp(0, 3 * deltaY)), CCFadeTo:create(25/60, 0)))
			return CCSequence:create(pAccArr)
		end

		local pCallback = CCCallFuncN:create(function ( ... )
			local anchorPoint = deltaNum > 0 and ccp(1, 0) or ccp(1, 1)
			local positionY = deltaNum > 0 and (pZhandou:getContentSize().height/2 + pZhandou:convertToWorldSpace(ccp(0, 0)).y) or (pZhandou:convertToWorldSpace(ccp(0, 0)).y - pZhandou:getContentSize().height/2 + 4)
			local deltaColor = deltaNum > 0 and ccc3(0x4d, 0xec, 0x15) or ccc3(0xff, 0x32, 0x01)
			local strokeColor = deltaNum > 0 and ccc3(0x00, 0x31, 0x00) or ccc3(0x28, 0x00, 0x00)
			local deltaDes = deltaNum > 0 and "+"..tostring(deltaNum) or tostring(deltaNum)
			local pStateImgX = pZhandou:convertToWorldSpace(ccp(0, 0)).x + pLabelX + labelAtlas:getContentSize().width + 1
			local deltaLabel = CCLabelTTF:create(deltaDes, g_FontInfo.name, 28)
			deltaLabel:setAnchorPoint(anchorPoint)
			deltaLabel:setPosition(ccp(pStateImgX, positionY))
			deltaLabel:setColor(deltaColor)
			tipNode:addChild(deltaLabel)
			deltaLabel:enableStroke(strokeColor, 2)
			deltaLabel:runAction(getAction())

			local pChange = tonumber(pNumFinal) - tonumber(pNumNow)
			local pName = pChange > 0 and "up.png" or "down.png"
			local pStateImg = CCSprite:create(pfilePath .. pName)
			local pStartY = pChange > 0 and -20 or 7
			pStateImg:setAnchorPoint(ccp(0, anchorPoint.y))
			pStateImg:setPosition(ccp(pStateImgX, positionY))
			pStateImg:setOpacity(0)
			pStateImg:setScale(0.79)
			tipNode:addChild(pStateImg)
			
			--local function stateImgUpAni( ... )
				if(pChange < 0) then
					AudioHelper.playEffect("audio/effect/texiao_zhandouli_down.mp3")	
				else
					AudioHelper.playEffect("audio/effect/texiao_zhandouli_jiantou.mp3")
				end
				pStateImg:runAction(getAction())
			--end
		end)
			--end)
		--actionArr:addObject(pCallback)--4
		actionArr:addObject(CCDelayTime:create(1))
		actionArr:addObject(CCCallFuncN:create(function ( ... )
			pMoveOut(fnCallBack)
		end))
		pZhandou:runAction(CCSequence:create(actionArr))

		local actions2 = CCArray:create()
		actions2:addObject(CCDelayTime:create(23/60))
		actions2:addObject(pCallback)
		local action2Node = CCNode:create()
		tipNode:addChild(action2Node)
		action2Node:runAction(CCSequence:create(actions2))

		AudioHelper.playEffect("audio/effect/texiao_zhandouli.mp3")
		changeNumber(labelAtlas, pNumNow , pNumFinal , nil)
	end
end
