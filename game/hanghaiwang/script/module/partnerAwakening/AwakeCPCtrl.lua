-- FileName: AwakeCPCtrl.lua
-- Author: 
-- Date: 2015-11-25
-- Purpose: 觉醒物品合成
--[[TODO List]]

module("AwakeCPCtrl", package.seeall)

-- UI控件引用变量 --
local _awakeCPView = nil

-- 模块局部变量 --
local _btnEvent = {}
local _onEquipCallback = nil
local _senderEquip = nil
local _awakeView = nil
local _awakePreviewView = nil

local function init(...)

end

function destroy(...)
	package.loaded["AwakeCPCtrl"] = nil
end

function moduleName()
    return "AwakeCPCtrl"
end


-- 点击子物品，进入到下一层的合成的逻辑
local onNextLayer = function ( pos )
	-- 设置当前的新状态
	AwakeCPData.setNextCompose(pos)
end

-- 点击顶部列表中的物品，回到第几层的合成层
local onLastLayer = function ( layer )
	-- 设置当前的新状态
	AwakeCPData.setUpLayer(layer)
end

_btnEvent.onNext = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()
		local tag = sender:getTag()
		if (tag ~= 1) then
			onNextLayer(tag-1)
			if (_awakeCPView) then
				_awakeCPView:refreshView()
			end
		end
	end
end

_btnEvent.onLast = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()
		local tag = sender:getTag()
		local nowComposeLine = AwakeCPData.getComposeLine()
		if (tag < #nowComposeLine) then
			onLastLayer(tag)
			if (_awakeCPView) then
				_awakeCPView:refreshView()
			end
		end
	end
end

_btnEvent.onClose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		if (_awakeView) then
			_awakeView:changePage()
		end
		if (_awakePreviewView) then
			_awakePreviewView:showListView()
		end
		LayerManager.removeLayout()
	end
end


_btnEvent.onCompose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local nowComposeInfo = AwakeCPData.getNowComposeInfo()
		if (nowComposeInfo.enough) then
			if (ItemUtil.isAwakeBagFull( true )) then
				return
			end

			local tbItemArg = AwakeCPData.getNowChildItems( nowComposeInfo )

			local array = CCArray:create()
			array:addObject(CCInteger:create(nowComposeInfo.itemId))
			local args_item = CCDictionary:create()
			for k,v in pairs (tbItemArg) do
				args_item:setObject(CCInteger:create(v), tostring(k))
			end
			array:addObject(args_item)


			local function composeCallback( ... )
				LayerManager.removeLayoutByName("layerBlockAwakeComposeAni")
				if (tonumber(nowComposeInfo.itemNeedNum) <= ItemUtil.getAwakeNumByTid(nowComposeInfo.itemId)) then
					if (nowComposeInfo.classNum == 0) then
						if (_onEquipCallback) then
							LayerManager.removeLayout() -- 删除合成窗
							LayerManager.removeLayout() -- 删除选择窗
							_awakeView:changePage()		-- 刷新觉醒界面
							_onEquipCallback(_senderEquip, TOUCH_EVENT_ENDED) -- 弹出装备窗
						else
							LayerManager.removeLayout() -- 删除合成窗
							LayerManager.removeLayout() -- 删除选择窗
							_awakeView:changePage()		-- 刷新觉醒界面
							GlobalNotify.postNotify("AWAKE_PRIVIEW_REFRESH")
						end
					else
						onLastLayer(nowComposeInfo.classNum)
						_awakeCPView:refreshView()
					end
				else
					_awakeCPView:refreshView()
				end
				UserModel.addSilverNumber(-tonumber( nowComposeInfo.itemDB.need_belly or 0 ))
			end

			GlobalNotify.addObserver(GlobalNotify.BAG_PUSH_CALL, function ( ... )
				if (_awakeCPView) then
					_awakeCPView:showComposeAni(composeCallback)
				end
			end, true, "AWAKE_COMPOSE" )

			local function composeAwakeEquipCallback( cbFlag, dictData, bRet )
				if(dictData.ret == "ok") then
					local layerBlock = Layout:create()
					layerBlock:setName("layerBlockAwakeComposeAni")
					LayerManager.addLayoutNoScale(layerBlock)
					-- MainAwakeModel.tempAddItem(nowComposeInfo.itemId, 1)
					-- for k,v in pairs(tbItemArg) do
					-- 	MainAwakeModel.decreaseItemNumByTid(k, v, "awake")
					-- end
				end
			end
			RequestCenter.forge_composeProp(composeAwakeEquipCallback, array)
		end
	end
end

_btnEvent.onGetWay = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()
		local nowComposeInfo = AwakeCPData.getNowComposeInfo()
		require "script/module/public/AwakeDrop"
		local awakeDrop = AwakeDrop:new()
		local awakeDropLayer = awakeDrop:create(nowComposeInfo.itemId, function ( ... )
			if (_awakeCPView) then
				_awakeCPView:refreshView()
			end
			if (_awakeView) then
				_awakeView:changePage()
			end
		end)
		LayerManager.addLayout(awakeDropLayer)
	end
end

function create( itemId, itemNum, onEquipCallback )

----------------

----------------
	if (onEquipCallback) then
		_onEquipCallback = onEquipCallback[2]
		_senderEquip = onEquipCallback[1]
		_awakeView = onEquipCallback[3]
		_awakePreviewView = onEquipCallback[4]
	end

	AwakeCPData.setComposeData(itemId, itemNum)

	_awakeCPView = AwakeCPView:new()
	local AwakeCPLayout = _awakeCPView:create(_btnEvent)
	
	LayerManager.addLayout(AwakeCPLayout)
end
