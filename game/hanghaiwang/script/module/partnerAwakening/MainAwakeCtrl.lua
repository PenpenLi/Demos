-- FileName: MainAwakeCtrl.lua
-- Author: Xufei
-- Date: 2015-11-16
-- Purpose: 伙伴觉醒主界面 控制模块
--[[TODO List]]

module("MainAwakeCtrl", package.seeall)

-- UI控件引用变量 --
local _instanceAwakeView = nil
local _previewInstance = nil
local _lastModuleName = nil

-- 模块局部变量 --
local tbEvent = {}

function goDrop( itemId )
	local awakeDrop = AwakeDrop:new()
	local awakeDropLayer = awakeDrop:create(itemId, function ( ... )
		if (_instanceAwakeView) then
			_instanceAwakeView:changePage()
		end
	end)
	LayerManager.addLayout(awakeDropLayer)
end

function goDropInPreview( itemId )
	local awakeDrop = AwakeDrop:new()
	local awakeDropLayer = awakeDrop:create(itemId, function ( ... )
		if (_instanceAwakeView) then
			_instanceAwakeView:changePage()
		end
		if (_previewInstance) then
			_previewInstance:showListView()
		end
	end)
	LayerManager.addLayout(awakeDropLayer)
end

function goDropWithInfoRefresh( itemId )
	local awakeDrop = AwakeDrop:new()
	local awakeDropLayer = awakeDrop:create(itemId, function ( ... )
		if (_instanceAwakeView) then
			_instanceAwakeView:changePage()
		end
		AwakeItemInfoCtrl.refreshHaveNum()
	end)
	LayerManager.addLayout(awakeDropLayer)
end

function goDropInPreviewWithInfoRefresh( itemId )
	local awakeDrop = AwakeDrop:new()
	local awakeDropLayer = awakeDrop:create(itemId, function ( ... )
		if (_instanceAwakeView) then
			_instanceAwakeView:changePage()
		end
		if (_previewInstance) then
			_previewInstance:showListView()
		end
		logger:debug("refresh_Callback_drop")
		AwakeItemInfoCtrl.refreshHaveNum()
	end)
	LayerManager.addLayout(awakeDropLayer)
end

-- 返回回调
tbEvent.onBtnBack = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		if (_lastModuleName == "MainFormation") then
			local PartnerInfo = MainAwakeModel.getNowPartnerInfo()
			local heroLocation = 0
			if (PartnerInfo.hid) then
				heroLocation = HeroModel.getHeroPosByHid(PartnerInfo.hid)
			end
			local layFormation = MainFormation.create(heroLocation or 0)
			if (layFormation) then
				LayerManager.changeModule(layFormation,  MainFormation.moduleName(), {1, 3}, true)
			end
		elseif (_lastModuleName == "MainPartner") then
			local layPartner = MainPartner.create()
			if (layPartner) then
				LayerManager.changeModule(layPartner,  MainPartner.moduleName(), {1, 3}, true)
				PlayerPanel.addForPartnerStrength()
			end
		else
			local layout = MainShip.create()
			if (layout) then
				LayerManager.changeModule(layout,  MainShip.moduleName(), {1, 3}, true)
				PlayerPanel.addForMainShip()
			end
		end
	end
end

-- pageView翻页回调
tbEvent.onPgvEvent = function(sender, eventType)
	if (eventType == PAGEVIEW_EVENT_TURNING) then
		if (_instanceAwakeView:getIsTurningPage()) then
			return
		end
		local partnerList = MainAwakeModel.getPartnerListWithNoEmpty() 

		local pageView = tolua.cast(sender, "PageView")
		local page = pageView:getCurPageIndex()
		local nowIndex = MainAwakeModel.getNowIndex()
		if (tonumber(page) ~= tonumber(nowIndex)) then
			MainAwakeModel.setNowIndex(page)
			if (_instanceAwakeView) then
				_instanceAwakeView:changePage()
			end
		end
		LayerManager.removeLayout()
	end
end

-- 预览的回调
tbEvent.onPreview = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		_previewInstance = AwakeItemPreview:new()
		_previewInstance:create()
	end
end

-- 装备上镶嵌物品的回调
tbEvent.onEquip = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		--AudioHelper.playInfoEffect()
		if (_instanceAwakeView:getIsTurningPage()) then
			return
		end
		local tag = sender:getTag()
		local itemInfo = MainAwakeModel.getNowEquipmentInfo(tag)
		local nowPartnerInfo = MainAwakeModel.getNowPartnerInfo()

		local tbCallback = {}
		tbCallback.equip = function ( ... )
			local tbItemArg = MainAwakeModel.getItemIdByTidAndNum( itemInfo.itemId, itemInfo.itemNum )

			local argItemId
			local argItemNum
			for k,v in pairs( tbItemArg ) do
				argItemId = k
				argItemNum = v
			end

			local array = CCArray:create()
			array:addObject(CCInteger:create(nowPartnerInfo.heroInfo.hid))
			array:addObject(CCInteger:create(tag))
			local args_item = CCDictionary:create()
			args_item:setObject(   CCInteger:create(argItemNum), tostring(argItemId) )
			array:addObject(args_item)		

			GlobalNotify.addObserver(GlobalNotify.BAG_PUSH_CALL, function ( ... )
				HeroModel.setHeroAwakeEquip(nowPartnerInfo.heroInfo.hid, itemInfo.itemId, tag, itemInfo.itemNum)
				MainAwakeModel.updateDataOfHero(nowPartnerInfo.heroInfo.hid)
				if (_instanceAwakeView) then
					local equipAttrs = MainAwakeModel.getAttrsByEquipItemInfo(itemInfo.itemId, itemInfo.itemNum)
								
					if (_instanceAwakeView) then
						_instanceAwakeView:showEquipAni(equipAttrs, tag, nowPartnerInfo.heroInfo.hid)
					end

					-- AwakeUtil.showFlyText(equipAttrs)
					-- UserModel.setInfoChanged(true)
					-- UserModel.updateFightValue({[nowPartnerInfo.heroInfo.hid] = {HeroFightUtil.FORCEVALUEPART.HEROAWAKE}})
					-- updateInfoBar()
					-- _instanceAwakeView:changePage()
				end
			end, true, "AWAKE_EQUIP" )

			local function equipAwakeItemCallback( cbFlag, dictData, bRet )
				if(dictData.ret == "ok") then
					local layerBlock = Layout:create() -- 添加屏蔽层
					layerBlock:setName("layerBlockAwakeEquipAnimation")
					LayerManager.addLayoutNoScale(layerBlock)
				end
			end			
			LayerManager.removeLayout() -- 删除安装框

			RequestCenter.hero_equipAwakeItem(equipAwakeItemCallback, array)

			-- GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )
			-- 	logger:debug("into_duanxian_awake")
			--     RequestCenter.bag_bagInfo(function (  cbFlag, dictData, bRet  )
   --              	PreRequest.preBagInfoCallback(cbFlag, dictData, bRet)
   --            	end)
   --            	RequestCenter.hero_getAllHeroes(function ( cbFlag, dictData, bRet )
			--         logger:debug({hero_getAllHeroes_dictData_awake = dictData})
			--         if (bRet and cbFlag == "hero.getAllHeroes") then
			--             require "script/model/hero/HeroModel"
			--             HeroModel.setAllHeroes(dictData.ret)
			--             UserModel.setInfoChanged(true)
			--             UserModel.updateFightValue() -- 然后更新战斗力数值
			--             updateInfoBar() -- zhangqi, 2015-12-24, 增加重连后刷新信息条的处理
			--         end
			--     end)

			--     --HeroModel.setHeroAwakeEquip(nowPartnerInfo.heroInfo.hid, itemInfo.itemId, tag, itemInfo.itemNum)
			-- 	MainAwakeModel.updateDataOfHero()
			-- 	if (_instanceAwakeView) then
			-- 		_instanceAwakeView:changePage()
			-- 	end

			-- end,true,"AwakeMainModel_onEquip")
		end
		AwakeItemInfoCtrl.create(itemInfo.itemId, "equip", tbCallback)
	end
end

-- 装备去合成的回调
tbEvent.onCompose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()
		if (_instanceAwakeView:getIsTurningPage()) then
			return
		end
		local tag = sender:getTag()
		local itemInfo = MainAwakeModel.getNowEquipmentInfo(tag)
		local tbCallback = {}
		tbCallback.compose = function ( ... )
			if (_instanceAwakeView) then
				local CallbackArgs = {sender, tbEvent.onEquip, _instanceAwakeView}
				AwakeCPCtrl.create(itemInfo.itemId, itemInfo.itemNum, CallbackArgs)
			end
		end
		tbCallback.gain = function ( ... )
			goDropWithInfoRefresh( itemInfo.itemId )
		end
		AwakeItemInfoCtrl.create(itemInfo.itemId, "compose", tbCallback)
	end
end

-- 装备去获取的回调,tag是位置
tbEvent.onGetWay = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()
		if (_instanceAwakeView:getIsTurningPage()) then
			return
		end
		local tag = sender:getTag()
		local itemInfo = MainAwakeModel.getNowEquipmentInfo(tag)
		goDrop( itemInfo.itemId )
	end
end

-- 装备去获取的回调，tag是物品id
tbEvent.onGetWayByid = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()
		if (_instanceAwakeView:getIsTurningPage()) then
			return
		end
		local index = sender:getTag()
		local _,itemList = MainAwakeModel.getItemPreviewData()
	logger:debug({isisisidafiodsiid = itemList,
		index = index,
		})
		local itemInfo = itemList[index]
		local isCanCompose = MainAwakeModel.getIfCanComposeOnlyByConfig(itemInfo.Id)
		if (isCanCompose) then
			local tbCallback = {}
			tbCallback.compose = function ( ... )
				if (_instanceAwakeView) then
					local CallbackArgs = {sender, nil, _instanceAwakeView, _previewInstance}
					AwakeCPCtrl.create(itemInfo.Id, itemInfo.num, CallbackArgs)
				end
			end
			tbCallback.gain = function ( ... )
				goDropInPreviewWithInfoRefresh( itemInfo.Id )
			end
			AwakeItemInfoCtrl.create(itemInfo.Id, "compose", tbCallback)
		else
			goDropInPreview( itemInfo.Id )
		end
	end
end

-- 觉醒按钮
tbEvent.onAwake = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local nowPartnerInfo = MainAwakeModel.getNowPartnerInfo().heroInfo
logger:debug({nowPartnerInfo=nowPartnerInfo})
		local function awakeActivateCallback( cbFlag, dictData, bRet ) 
			if(dictData.ret == "ok") then
				local layerBlock = Layout:create()
				layerBlock:setName("layerBlockAwakeAnimation")
				LayerManager.addLayoutNoScale(layerBlock)
			end
		end

		GlobalNotify.addObserver(GlobalNotify.BAG_PUSH_CALL, function ( ... )
			if (_instanceAwakeView) then
				-- 先读取一遍属性值
				MainAwakeModel.setHeroPreAttrs()
				local nextLvInfo = nowPartnerInfo.awakeConsume.lvInfo
				UserModel.addSilverNumber(-nowPartnerInfo.awakeConsume.belly)
				local newHeroInfo = HeroModel.setHeroAwakeLv( nowPartnerInfo.hid, nextLvInfo.nextStar, nextLvInfo.nextLv )
				MainAwakeModel.updateAwakeLv(newHeroInfo)
				local addAttrs = MainAwakeModel.getNowHeroAddAttrs()

				UserModel.setInfoChanged(true)
				UserModel.updateFightValue({[nowPartnerInfo.hid] = {HeroFightUtil.FORCEVALUEPART.HEROAWAKE}})
				
				if (_instanceAwakeView) then
					_instanceAwakeView:showAwakeAni(addAttrs)
				end
			end
		end, true, "AWAKE_UP" )


		RequestCenter.hero_activeAwakeAttr(awakeActivateCallback, Network.argsHandler(nowPartnerInfo.hid))
	end
end

local function init(...)

end

function destroy(...)
	package.loaded["MainAwakeCtrl"] = nil
end

function moduleName()
    return "MainAwakeCtrl"
end



--[[desc:功能简介
    arg1: canSlip=1表示可以左右滑动，需要取得上阵的阵容,canSlip=0表示只显示当前人物。
    return: 是否有返回值，返回值说明  
—]]
function create( canSlip, hid )
	require "script/module/partnerAwakening/MainAwakeModel"
	MainAwakeModel.setAwakeInfo(canSlip, hid) -- TODO 改成参数
	MainAwakeModel.setBtnEvent(tbEvent)
	require "script/module/partnerAwakening/MainAwakeView"
	_instanceAwakeView = MainAwakeView:new()
	local awakeView = _instanceAwakeView:create(tbEvent)
	_lastModuleName = LayerManager.curModuleName()
	if (awakeView) then
		LayerManager.changeModule( awakeView, moduleName(), {1,3}, true )
		PlayerPanel.addForPartnerStrength()
	end
end
