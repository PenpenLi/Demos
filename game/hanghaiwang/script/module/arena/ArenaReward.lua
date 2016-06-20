-- FileName: ArenaReward.lua
-- Author: huxiaozhou
-- Date: 2014-12-12
-- Purpose: 竞技场历史排名上升 获得的奖励
--[[TODO List]]
-- /


module("ArenaReward", package.seeall)

local arena_challenge_json = "ui/arena_rank_reward.json"

-- 页签 
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString

-- UI 控件
local m_mainWidget
local effectDuang
local effectRank
local layRank 
local btnClose
local bShowMin = false

local nShowState = 1

local function init(...)
	bShowMin = false
	nShowState = 1
end

function destroy(...)
	package.loaded["ArenaReward"] = nil
end

function moduleName()
    return "ArenaReward"
end

function create(tbReward, minPos, tbChangeInfo)
	init()
	-- 滑动的竞技场界面
	m_mainWidget = g_fnLoadUI(arena_challenge_json)
	m_mainWidget:setSize(g_winSize)
	logger:debug(tbChangeInfo)

	local lay_fit = m_fnGetWidget(m_mainWidget, "lay_fit")
	lay_fit:setEnabled(false)

	effectDuang = m_fnGetWidget(m_mainWidget, "IMG_EFFECT_DUANG")
	effectRank = m_fnGetWidget(m_mainWidget, "IMG_EFFECT_BOARD")
	layRank = m_fnGetWidget(m_mainWidget, "LAY_RANK")
	layRank:setEnabled(false)
	local LABN_RANK = m_fnGetWidget(layRank, "LABN_RANK")
	LABN_RANK:setStringValue(minPos)
	if ArenaData.getMinPosition() > tonumber(minPos) then
		bShowMin = true
	else
		bShowMin = false
	end

	logger:debug({tbReward = tbReward})
	function checkShowStaus(  )
		if bShowMin and tbReward and tbReward.gold and tonumber(tbReward.gold)~=0 then
			nShowState = 3 -- 历史排名上升切送金币
		elseif bShowMin then
			nShowState = 2 -- 历史排名上升不松金币
		else
			nShowState = 1 -- 只有排名变化
		end
	end
	checkShowStaus()
	logger:debug("nShowState = %s", nShowState)

	-- tbReward = {}
	-- tbReward.gold = 10
	-- nShowState = 1 
	-- tbChangeInfo = tbTemp
	-- minPos = 9
	rankChangeAnimation(tbReward,  minPos, tbChangeInfo)

	btnClose = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
	btnClose:addTouchEventListener(function ( sender, eventType )
			logger:debug("eventType == " .. eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				LayerManager.removeLayout()
			end	
		end)
	btnClose:setEnabled(false)

	LayerManager.addLayoutNoScale(m_mainWidget)
end

-- 排名变化动画
function rankChangeAnimation(tbReward, minPos, tbChangeInfo)
	local armature
	armature = UIHelper.createArmatureNode({
			filePath = "images/effect/arena/civil.ExportJson",
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				logger:debug("frameEventName = %s", frameEventName)
				if (frameEventName == "1") then
					if nShowState == 3 or nShowState == 2 then
						local duang = UIHelper.createArmatureNode({
							filePath = "images/effect/skypiea/bell_duang.ExportJson",
							animationName = "civil_text"
						})
						effectDuang:addNode(duang, 1)
					else

					end
				elseif (frameEventName == "2") then
					if nShowState == 3 or nShowState == 2 then
						local duang = UIHelper.createArmatureNode({
							filePath = "images/effect/forge/qh3/qh3.ExportJson",
							animationName = "qh3_2"
						})
						effectDuang:addNode(duang)

						if bShowMin then
							AudioHelper.playSpecialEffect("texiao_gongxininhuode.mp3")
							layRank:setEnabled(true)
						end
					else

					end
				elseif (frameEventName == "3") then
					if nShowState == 3 then
						goldAnimation(tbReward, minPos)
					else

					end
				elseif (frameEventName == "4") then
					if nShowState == 3 then
						
					else
						logger:debug("frameEventName = %s", frameEventName)
						logger:debug("testcases huxiaozhou")
						armature:getAnimation():stop()
						btnClose:setEnabled(true)
						-- if nShowState == 2 then
						-- 	layRank:setEnabled(true)
						-- end
					end
					
				end
			end,
			-- animationName = "civil"
		})
	
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	cache:addSpriteFramesWithFile("images/effect/arena/civil0.plist");
-- 换骨开始
	local spr5 = CCSprite:createWithSpriteFrameName("civil_5.png")
	local labName = CCLabelTTF:create(tbChangeInfo.atk.uname,g_FontCuYuan,28)
	labName:setColor(ccc3(0x7f,0x5f,0x20))
	labName:setAnchorPoint(ccp(0,0))
	spr5:addChild(labName)
	local size = spr5:getContentSize()
	labName:setPosition(ccp(-24+size.width*.5,18+size.height*.5))

	local labRank = CCLabelTTF:create(tbChangeInfo.def.position,g_FontCuYuan,50)
	labRank:setColor(ccc3(0xdf,0x01,0x0c))
	labRank:setAnchorPoint(ccp(0,0))
	spr5:addChild(labRank)
	labRank:setPosition(ccp(-24+size.width*.5,-45+size.height*.5))

	local labMing =  CCLabelTTF:create(m_i18n[5409],g_FontCuYuan,28)
	labMing:setColor(ccc3(0x7f,0x5f,0x20))
	labMing:setAnchorPoint(ccp(0,0))
	local x,y = labRank:getPosition()
	labMing:setPosition(ccp(x+labRank:getContentSize().width,y+10))
	spr5:addChild(labMing)

	local htid = tbChangeInfo.atk.figure
	local heroInfo = HeroUtil.getHeroLocalInfoByHtid(htid)
	local bgFile = "images/base/potential/officer_" .. heroInfo.potential .. ".png"
	local color_bg = "images/base/potential/color_" .. heroInfo.potential .. ".png"

	local bgIcon = CCSprite:create(bgFile)
	local bgColor = CCSprite:create(color_bg)
	bgColor:addChild(bgIcon)
	bgIcon:setPosition(ccp(bgColor:getContentSize().width*0.5,bgColor:getContentSize().height*0.5))

	local imgIcon = CCSprite:create(HeroUtil.getHeroIconImgByHTID(htid))
	bgIcon:addChild(imgIcon)
	imgIcon:setPosition(ccp(bgIcon:getContentSize().width*0.5,bgIcon:getContentSize().height*0.5))
	spr5:addChild(bgColor)
	bgColor:setPosition(ccp(-88+size.width*.5,size.height*.5))
	armature:getBone("civil_5"):addDisplay(spr5,0)

---------
	local uname 
	local quality_bg 
	local color_bg 
	local iconBg 
	if tonumber(tbChangeInfo.def.armyId) ~= 0 then
		require "db/DB_Monsters"
		local htidM = DB_Monsters.getDataById(tbChangeInfo.def.squad[1]).htid
		-- 根据htid查找DB_Monsters_tmpl表得到icon
		require "db/DB_Monsters_tmpl"
		local heroData = DB_Monsters_tmpl.getDataById(htidM)
		iconBg ="images/base/hero/head_icon/" .. heroData.head_icon_id
		quality_bg =  "images/base/potential/officer_" .. heroData.star_lv .. ".png"
		color_bg =  "images/base/potential/color_" .. heroData.star_lv .. ".png"
		local utid = tonumber(tbChangeInfo.def.utid)
   		uname = ArenaData.getNpcName(tonumber(tbChangeInfo.def.uid), utid)
	else
		local htid = tbChangeInfo.def.figure
		local heroInfo = HeroUtil.getHeroLocalInfoByHtid(htid)
		color_bg =  "images/base/potential/color_" .. heroInfo.potential .. ".png"
		quality_bg = "images/base/potential/officer_" .. heroInfo.potential .. ".png"
		iconBg = HeroUtil.getHeroIconImgByHTID(htid)
		uname = tbChangeInfo.def.uname
	end

	local spr4 = CCSprite:createWithSpriteFrameName("civil_4.png")
	local labName = CCLabelTTF:create(uname,g_FontCuYuan,28)
	labName:setColor(ccc3(0x7f,0x5f,0x20))
	labName:setAnchorPoint(ccp(0,0))
	spr4:addChild(labName)
	local size = spr4:getContentSize()
	labName:setPosition(ccp(-24+size.width*.5,18+size.height*.5))

	local labRank = CCLabelTTF:create(tbChangeInfo.atk.position,g_FontCuYuan,50)
	labRank:setColor(ccc3(0x00,0x8a,0x01))
	labRank:setAnchorPoint(ccp(0,0))
	spr4:addChild(labRank)
	labRank:setPosition(ccp(-24+size.width*.5,-45+size.height*.5))

	local labMing =  CCLabelTTF:create(m_i18n[5409],g_FontCuYuan,28)
	labMing:setColor(ccc3(0x7f,0x5f,0x20))
	labMing:setAnchorPoint(ccp(0,0))
	local x,y = labRank:getPosition()
	labMing:setPosition(ccp(x+labRank:getContentSize().width,y+10))
	spr4:addChild(labMing)

	
	local bgIcon = CCSprite:create(quality_bg)
	local bgColor = CCSprite:create(color_bg)
	bgColor:addChild(bgIcon)
	bgIcon:setPosition(ccp(bgColor:getContentSize().width*0.5,bgColor:getContentSize().height*0.5))
	local imgIcon = CCSprite:create(iconBg)
	bgIcon:addChild(imgIcon)
	imgIcon:setPosition(ccp(bgIcon:getContentSize().width*0.5,bgIcon:getContentSize().height*0.5))
	spr4:addChild(bgColor)
	bgColor:setPosition(ccp(-88+size.width*.5,size.height*.5))
	armature:getBone("civil_4"):addDisplay(spr4,0)
---------------------------------------
	local spr1 = CCSprite:createWithSpriteFrameName("civil_1.png")
	local labName = UIHelper.createStrokeTTF("-" .. (tbChangeInfo.atk.position - tbChangeInfo.def.position),
												ccc3(0xff,0xff,0xff),ccc3(0x1e,0x1e,0x1e),false, 28, g_FontCuYuan)
	-- labName:setAnchorPoint(ccp(0,0))
	spr1:addChild(labName)
	local size = spr1:getContentSize()
	labName:setPosition(ccp(size.width*.5,40+size.height*.5))
	armature:getBone("civil_1"):addDisplay(spr1,0)

-------------------------------------------
	local spr2 = CCSprite:createWithSpriteFrameName("civil_2.png")
	local labName = UIHelper.createStrokeTTF("+" .. (tbChangeInfo.atk.position - tbChangeInfo.def.position),ccc3(0xff,0xfe,0xb7),
											ccc3(0x68,0x22,0x00),false, 28, g_FontCuYuan)
	-- labName:setAnchorPoint(ccp(0,0))
	spr2:addChild(labName)
	local size = spr2:getContentSize()
	labName:setPosition(ccp(size.width*.5,-25+size.height*.5))
	armature:getBone("civil_2"):addDisplay(spr2,0)
-- 换骨结束

	-- performWithDelay(tolua.cast(LayerManager.getRootLayout(), "CCNode"),
								-- function ( ... )
								effectRank:addNode(armature)
								armature:getAnimation():play("civil", -1, -1, 0)
								-- end, 0.5)
	AudioHelper.playSpecialEffect("texiao_paimingshangsheng.mp3")
end

-- 送金币动画
function goldAnimation( tbReward, minPos)
	local lay_fit = m_fnGetWidget(m_mainWidget, "lay_fit")

	if tbReward and tbReward.gold ~= nil and tonumber(tbReward.gold)~=0 then
		lay_fit:setEnabled(true)
		local IMG_REWARD_FRAME = m_fnGetWidget(lay_fit, "IMG_REWARD_FRAME")
		local TFD_NUM = m_fnGetWidget(IMG_REWARD_FRAME, "TFD_NUM")
		TFD_NUM:setText("x" .. tbReward.gold or "")
		local img_gold = m_fnGetWidget(lay_fit, "IMG_ITEM")
		TFD_NUM:setEnabled(false)
		img_gold:setEnabled(false)
		UIHelper.labelNewStroke(TFD_NUM)

		local armature = UIHelper.createArmatureNode({
			filePath = "images/effect/battle_result/win_drop.ExportJson",
			fnMovementCall = function ( sender, MovementEventType )
								 			if (MovementEventType == EVT_COMPLETE) then 
												btnClose:setEnabled(true)
											end
				 						end,
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if (frameEventName == "1") then

					TFD_NUM:setEnabled(true)
					img_gold:setEnabled(true)

					local armatureLight = UIHelper.createArmatureNode({
						filePath = "images/effect/battle_result/win_drop.ExportJson",
						animationName = "win_drop_purple",
						
					})
					IMG_REWARD_FRAME:addNode(armatureLight, -1, -1)
				end
			end
		})
		IMG_REWARD_FRAME:addNode(armature)
		local imgIcon = ItemUtil.getGoldIconByNum()
		armature:getBone("win_drop_3"):addDisplay(imgIcon, 0)
		armature:getAnimation():play("win_drop", -1, -1, 0)
		AudioHelper.playBtnEffect("buttonbuy.mp3")
	else
		lay_fit:removeFromParent()
	end
end

