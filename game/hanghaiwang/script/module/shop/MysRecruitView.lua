-- FileName: MysRecruitView.lua
-- Author: menghao
-- Date: 2015-05-09
-- Purpose: 神秘招募ctrl


module("MysRecruitView", package.seeall)



-- UI控件引用变量 --
local _UIMainRecruitView


-- 模块局部变量 --
local m_i18nString 					=  gi18nString
local m_strTreasName 				= ""
local effectId = nil
local  m_updateTimeScheduler = nil
local m_tbMysShopInfo = nil
local nProgressTag = 824
local function init(...)

end

function getTreasName(  )
	return m_strTreasName
end

function destroy(...)
	package.loaded["MysRecruitView"] = nil
end


function moduleName()
	return "MysRecruitView"
end

local function setRefreshTimeUI(  )
	local mysreftime = m_tbMysShopInfo.period_end
	local nLeftTime =  tonumber(mysreftime) -TimeUtil.getSvrTimeByOffset() 
	-- logger:debug(nLeftTime)
	nLeftTime = nLeftTime < 0 and 0 or nLeftTime
	-- _UIMainRecruitView.TFD_TIME_NUM:setText(TimeUtil.getTimeDesByInterval(nLeftTime) .. m_i18nString(1407))
	_UIMainRecruitView.TFD_TIME_NUM:setText(TimeUtil.getTimeString(nLeftTime))

end

-- 启动scheduler
function startScheduler()
	if(m_updateTimeScheduler == nil) then
		m_updateTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(setRefreshTimeUI, 1, false)
	end
end


-- 停止scheduler
function stopScheduler()
	if(m_updateTimeScheduler)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_updateTimeScheduler)
		m_updateTimeScheduler = nil
	end
end



local soundAction = nil
--播放武将音效
local function fnPlayHeroSound( htid)
    local soundPath = DB_Heroes.getDataById(htid).debut_word
    logger:debug(soundPath)
    if(soundPath) then
    	soundAction = performWithDelay(_UIMainRecruitView,function (  )
    		logger:debug("playsound")
    		effectId = AudioHelper.playEffect("audio/heroeffect/" .. soundPath ..".mp3")
    	end,0.5)
    	
    end
end


local function stopHeroSound(  )
	if(_UIMainRecruitView)then
		_UIMainRecruitView:stopAllActions()
	end
	AudioHelper.stopAllEffects()
end

local function setLayWeek( htid )
	 logger:debug(_UIMainRecruitView)
	local layHero = _UIMainRecruitView.lay_model
	local dbHero = DB_Heroes.getDataById(htid)
	local imgHero = ImageView:create()
	imgHero:loadTexture("images/base/hero/body_img/" .. dbHero.body_img_id)
	imgHero:setAnchorPoint(ccp(0.5, 0))
	imgHero:setPosition(ccp(layHero:getSize().width / 2, layHero:getSize().height / 2))
	layHero:addChild(imgHero)
	imgHero:setTouchEnabled(true)
	imgHero:addTouchEventListener(function( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playInfoEffect()
			local tArgs={selectedHeroes = dbHero}
			require "script/module/partner/PartnerInfoCtrl"
	        local pHeroValue = dbHero --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
	        logger:debug({pHeroValue=pHeroValue})
	        local tbherosInfo = {}
	        stopHeroSound()
	        local heroInfo = {htid = pHeroValue.id ,hid = 0 ,strengthenLevel = 0 ,transLevel = 0 }
	        table.insert(tbherosInfo,heroInfo)
	        local tArgs = {}
	        tArgs.heroInfo = heroInfo
	        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
	        LayerManager.addLayoutNoScale(layer)
		end
	end)
	 UIHelper.fnPlayHuxiAni(imgHero)
	-- local tb = {"灰色伙伴", "白色伙伴", "绿色伙伴", "蓝色伙伴", "紫色伙伴", "橙色伙伴"} 	-- TODO mh
	_UIMainRecruitView.TFD_HERO_NAME:setText(dbHero.name)
	_UIMainRecruitView.TFD_HERO_NAME:setColor(g_QulityColor2[dbHero.potential])
	UIHelper.labelNewStroke(_UIMainRecruitView.TFD_HERO_NAME, ccc3(0x28,0x00,0x00), 2 )

	_UIMainRecruitView.IMG_COLOR_2:setEnabled(dbHero.potential == 5)
	_UIMainRecruitView.IMG_COLOR_1:setEnabled(dbHero.potential == 6)

end


local function setLayDay( tbIDs )

	local lsv = _UIMainRecruitView.LSV_ICON
	UIHelper.initListView(lsv)
	local cellWidth = lsv:getSize().width / (#tbIDs - 1)
	for i=2,#tbIDs do
		lsv:pushBackDefaultItem()
		local item = lsv:getItem(i - 2)
		local id = tbIDs[i]
		require "db/DB_Day_hero_stock"
		local htid = DB_Day_hero_stock.getDataById(id).item_id
		local item_type = DB_Day_hero_stock.getDataById(id).item_type  --1为伙伴，2为宝物
		local dbHero = nil 
		local Qulity = 1
		local btnIcon = nil
		if(item_type == 1) then
			dbHero = DB_Heroes.getDataById(htid)
			Qulity = dbHero.potential
			btnIcon = HeroUtil.createHeroIconBtnByHtid(htid, nil, function( sender, eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playInfoEffect()
							local tArgs={selectedHeroes = dbHero}
							require "script/module/partner/PartnerInfoCtrl"
					        local pHeroValue = dbHero --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
					        logger:debug({pHeroValue=pHeroValue})
					        local tbherosInfo = {}
					        local heroInfo = {htid = pHeroValue.id ,hid = 0 ,strengthenLevel = 0,transLevel = 0}
					        table.insert(tbherosInfo,heroInfo)
					        local tArgs = {}
					        tArgs.heroInfo = heroInfo
					        stopHeroSound()
					        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
				        	LayerManager.addLayoutNoScale(layer)

				        	
						end
					end)
		elseif(item_type == 2) then
			dbHero = DB_Item_exclusive.getDataById(htid)
			Qulity = dbHero.quality
			m_strTreasName = dbHero.name
			btnIcon = ItemUtil.createBtnByTemplateId(htid, function( sender, eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playInfoEffect()
							require "script/module/specialTreasure/SpecTreaInfoCtrl"
							SpecTreaInfoCtrl.create(htid)
						end
					end)
		end
		btnIcon:setPosition(ccp(item.LAY_ICON:getSize().width / 2, item.LAY_ICON:getSize().height / 2))
		item.LAY_ICON:addChild(btnIcon)
		item.TFD_NAME:setText(dbHero.name)
		item.TFD_NAME:setColor(g_QulityColor2[Qulity])
		UIHelper.labelNewStroke(item.TFD_NAME, ccc3(0x28,0x00,0x00), 2 )
	end
end


local function getMysInfoCall( cbFlag, dictData, bRet )
	LayerManager:begainRemoveUILoading()
	if (bRet) then
		m_tbMysShopInfo = dictData.ret
		performWithDelayFrame(_UIMainRecruitView,function (  )
				setLayWeek(dictData.ret.va_mystery[1])
				setLayDay(dictData.ret.va_mystery)
		end,5)

	end
end


function resetView(  )
	logger:debug(_UIMainRecruitView)
	if(not _UIMainRecruitView)then
		return 
	else
		
		RequestCenter.shop_getRecruitInfo(function (cbFlag, dictData, bRet )
			getMysInfoCall( cbFlag, dictData, bRet)
		end
		)
	end
end

--获取本周热点伙伴的名字
function getWeekHotHeroName( ... )
	local dbHero = DB_Heroes.getDataById(m_tbMysShopInfo.va_mystery[1])
	return dbHero.name
end

--获取本周热点伙伴的个数
function getWeekHotHeroNum( ... )

	local heroData = DB_Heroes.getDataById(m_tbMysShopInfo.va_mystery[1]) 
	local heroFragTid = heroData.fragment
	local dbHero = ItemUtil.getItemById(heroFragTid)
	return dbHero.nOwn or 0
end

--获得当前周热点伙伴的幸运最大值
function getMaxLuckValue()
	local weekHeroHtid = tonumber(m_tbMysShopInfo.va_mystery[1])
	for k,v in pairs(DB_Tavern_mystery.Tavern_mystery) do
		if(tonumber(string.split(v[2],"|")[1]) == weekHeroHtid)then
			return v[4]
		end
	end
end

--获得当前周热点伙伴的基础幸运值
function getBasePoint()
	local weekHeroHtid = tonumber(m_tbMysShopInfo.va_mystery[1])
	for k,v in pairs(DB_Tavern_mystery.Tavern_mystery) do
		if(tonumber(string.split(v[2],"|")[1]) == weekHeroHtid)then
			return v[5]
		end
	end
end

function getCurLuckPercent(  )
	local nMaxValue = getMaxLuckValue()
	local tbShopInfo = DataCache.getShopCache()
	local nCurLuck = tonumber(tbShopInfo.mystery_recruit_point )
	local  percent  = nCurLuck / nMaxValue * 100
	percent = percent > 100 and 100 or percent
	return percent
end

--设置幸运值进度条
function setLuckProgress(  )
	local nMaxValue = getMaxLuckValue()
	local tbShopInfo = DataCache.getShopCache()
	local nCurLuck = tonumber(tbShopInfo.mystery_recruit_point )

	_UIMainRecruitView.TFD_LUCK:setText("幸运值:" .. nCurLuck .."/" ..  nMaxValue)
	local  percent  = getCurLuckPercent()

    local progressTimer = UIHelper.fnGetProgress("ui/mystical_pro_bg.png")
    _UIMainRecruitView.LOAD_LUCKY:addNode(progressTimer)
    progressTimer:setTag(nProgressTag)
    -- progressTimer:setVisible(false)
    logger:debug(percent)
	progressTimer:setPercentage(percent > 100 and 100 or percent)
	-- _UIMainRecruitView.LOAD_LUCKY:setPercent(percent > 100 and 100 or percent)
	_UIMainRecruitView.LOAD_LUCKY:setPercent(0)

	MysRecruitCtrl.addProAni(_UIMainRecruitView.LOAD_LUCKY,percent)


	_UIMainRecruitView.lay_mym_txt_1:setEnabled(false)
	_UIMainRecruitView.lay_mym_txt_2:setEnabled(false)

	_UIMainRecruitView.tfd_recruit_mym_next:setText(m_i18nString(1479))  --[1479] = "本次招募必得",
	_UIMainRecruitView.tfd_recruit_mym:setText(m_i18nString(1478))  		--[1478] = "招募必得幸运值，幸运值满后下次招募必得",

	local dbHero = DB_Heroes.getDataById(m_tbMysShopInfo.va_mystery[1])
	_UIMainRecruitView.tfd_hot_hero_name_next:setText(dbHero.name)  --艾斯
	_UIMainRecruitView.tfd_hot_hero_name:setText(dbHero.name)  --艾斯


	UIHelper.labelNewStroke(_UIMainRecruitView.tfd_hot_hero_name_next, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke(_UIMainRecruitView.tfd_recruit_mym_next, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke(_UIMainRecruitView.tfd_recruit_mym, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke(_UIMainRecruitView.tfd_hot_hero_name, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke(_UIMainRecruitView.TFD_LUCK, ccc3(0x28,0x00,0x00), 2 )

	if(percent == 100) then
		_UIMainRecruitView.lay_mym_txt_2:setEnabled(true)
	else
		_UIMainRecruitView.lay_mym_txt_1:setEnabled(true)
	end
end

function create(tbInfo, tbEvents)
	m_tbMysShopInfo = tbInfo
	logger:debug("asdfasdf")
	effectId = nil
	_UIMainRecruitView = g_fnLoadUI("ui/mystery_review.json")
		UIHelper.registExitAndEnterCall(_UIMainRecruitView,
		function()
			stopHeroSound()
			_UIMainRecruitView = nil 
			logger:debug(_UIMainRecruitView)
			AudioHelper.stopEffect(effectId)
			stopScheduler()
			-- if(effectId)then
			-- 	AudioHelper.stopEffect(effectId)
			-- end
			
			logger:debug("_UIMainRecruitView exit")
			  LayerManager.resetPaomadeng()
			  logger:debug(_UIMainRecruitView)
		end,
		function()
			logger:debug("_UIMainRecruitView enter")
		end
		)

	-- 背景图
	_UIMainRecruitView.img_bg_1:setSizeType(SIZE_ABSOLUTE)
	_UIMainRecruitView.img_bg_1:setSize(CCSizeMake( _UIMainRecruitView.img_bg_1:getSize().width * g_fScaleX,_UIMainRecruitView.img_bg_1:getSize().height * g_fScaleX))
	_UIMainRecruitView.img_bg_2:setSizeType(SIZE_ABSOLUTE)
	_UIMainRecruitView.img_bg_2:setSize(CCSizeMake( _UIMainRecruitView.img_bg_2:getSize().width * g_fScaleX,_UIMainRecruitView.img_bg_2:getSize().height * g_fScaleX))
	_UIMainRecruitView.img_bg_3:setSizeType(SIZE_ABSOLUTE)
	_UIMainRecruitView.img_bg_3:setSize(CCSizeMake( _UIMainRecruitView.img_bg_3:getSize().width * g_fScaleX,_UIMainRecruitView.img_bg_3:getSize().height * g_fScaleX))
	_UIMainRecruitView.lay_bg:updateSizeAndPosition()

	_UIMainRecruitView.img_title_bg:setScaleX(g_fScaleX)
	_UIMainRecruitView.BTN_CLOSE:addTouchEventListener(tbEvents.onBack)
	_UIMainRecruitView.BTN_CLOSE:setTitleText(m_i18nString(1019))
	UIHelper.titleShadow(_UIMainRecruitView.BTN_CLOSE)

	_UIMainRecruitView.tfd_desc:setText(m_i18nString(1473)) 
	-- UIHelper.labelNewStroke(_UIMainRecruitView.tfd_desc, ccc3(0x45,0x00,0x00), 2 )

	_UIMainRecruitView.tfd_recruit:setText(m_i18nString(1474)) 
	UIHelper.labelNewStroke(_UIMainRecruitView.tfd_recruit, ccc3(0x28,0x00,0x00), 2 )

	_UIMainRecruitView.tfd_or:setText(m_i18nString(1222)) 
	UIHelper.labelNewStroke(_UIMainRecruitView.tfd_or, ccc3(0x28,0x00,0x00), 2 )

	_UIMainRecruitView.tfd_hot_shadow:setText(m_i18nString(1476)) 
	UIHelper.labelNewStroke(_UIMainRecruitView.tfd_hot_shadow, ccc3(0x28,0x00,0x00), 2 )


	_UIMainRecruitView.BTN_RECRUIT:addTouchEventListener(tbEvents.onRecruit)
	UIHelper.titleShadow(_UIMainRecruitView.BTN_RECRUIT, m_i18nString(1448))
	UIHelper.titleShadow(_UIMainRecruitView.BTN_RECRUIT)

	_UIMainRecruitView.tfd_time:setText(m_i18nString(1477))
	UIHelper.labelNewStroke(_UIMainRecruitView.tfd_time, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke(_UIMainRecruitView.TFD_TIME_NUM, ccc3(0x28,0x00,0x00), 2)
	UIHelper.labelNewStroke(_UIMainRecruitView.tfd_hot_hero, ccc3(0x28,0x00,0x00), 2)

	-- local nextHeroHtid = DB_Day_hero_stock.getDataById(tonumber(m_tbMysShopInfo.next_hot)).item_id
	local nextBbHero = DB_Heroes.getDataById(tonumber(m_tbMysShopInfo.next_hot))
	_UIMainRecruitView.tfd_next:setText("下期热点:")
	_UIMainRecruitView.TFD_NEXT_NAME:setText(nextBbHero.name)

	UIHelper.labelNewStroke(_UIMainRecruitView.tfd_next, ccc3(0x28,0x00,0x00), 2)
	UIHelper.labelNewStroke(_UIMainRecruitView.TFD_NEXT_NAME, ccc3(0x28,0x00,0x00), 2)

	setRefreshTimeUI()
	startScheduler()
	require "db/DB_Tavern_mystery"
	local nCost = DB_Tavern_mystery.getDataById(1).cost
	_UIMainRecruitView.TFD_GOLD:setText(nCost)
	UIHelper.labelNewStroke(_UIMainRecruitView.TFD_GOLD, ccc3(0x00,0x00,0x00), 2 )

	_UIMainRecruitView.TFD_RECRUIT_FREE:setText(m_i18nString(1450)) --本次购买免费
	UIHelper.labelNewStroke(_UIMainRecruitView.TFD_RECRUIT_FREE, ccc3(0x00,0x00,0x00), 2 )
	
	local shopInfo = DataCache.getShopCache()
	if(tonumber(shopInfo.mySteryFreeNum)<=0) then
		_UIMainRecruitView.TFD_GOLD:setEnabled(true)
		_UIMainRecruitView.img_gold:setEnabled(true)
		_UIMainRecruitView.TFD_RECRUIT_FREE:setEnabled(false)
	else
		_UIMainRecruitView.TFD_GOLD:setEnabled(false)
		_UIMainRecruitView.img_gold:setEnabled(false)
		_UIMainRecruitView.TFD_RECRUIT_FREE:setEnabled(true)
	end



	setLayWeek(tbInfo.va_mystery[1])

	fnPlayHeroSound(tbInfo.va_mystery[1])

	setLayDay(tbInfo.va_mystery)

	setLuckProgress()

	return _UIMainRecruitView
end

