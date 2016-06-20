-- FileName: SpecTreaChange.lua
-- Author: sunyunpeng
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("SpecTreaChange", package.seeall)

-- UI控件引用变量 --
local _mainLayout
local m_i18n = gi18n
local _tfdPowerOwnNum  -- 万能宝物个数
local _tfdTreaOwnNum   -- 专属宝物个数
local _progressNum -- 进度条显示文字部分
local _progress     --  进度条部分


-- 模块局部变量 --
local _treaTid
local _powerFragTid = 720001
local _haveTreaNum
local _needTreaNum
local _powerFragNum
local _stockeColor = ccc3(0x8e,0x46,0x00)
local _treaAddNum = 0
-- local _addTreaTb = {}



local function init(...)

end

function destroy(...)
	_treaAddNum = 0
	-- _addTreaTb = {}
	package.loaded["SpecTreaChange"] = nil
end

function moduleName()
    return "SpecTreaChange"
end

function create( treaTid,haveNum,needNum)
	-- _addTreaTb = {}
	_treaAddNum =  0
	_treaTid = treaTid
	_haveTreaNum = haveNum
	_needTreaNum = needNum
	_,_powerFragNum  =  SpecTreaModel.getSpecTreaNumByTid(nil,_powerFragTid)

	initBg()
	initItemBg()
	initItemNumBg()
	intiBtn()
	return _mainLayout
end

function refreshUI( )
	_haveTreaNum = _haveTreaNum + 1
	_tfdTreaOwnNum:setText(_haveTreaNum)
	_powerFragNum = _powerFragNum - 1 
	_tfdPowerOwnNum:setText(_powerFragNum)

	_progressNum:setText(_haveTreaNum ..  "/" .. _needTreaNum)
	local nPercent = _haveTreaNum / _needTreaNum * 100
  	_progress:setPercent((nPercent > 100) and 100 or nPercent)
end

function lableStroke( widgt )
	UIHelper.labelNewStroke(widgt,_stockeColor)
end

-- 初始化背景
function initBg( ... )
	_mainLayout = g_fnLoadUI("ui/special_change.json")

	local tfdTip = _mainLayout.TFD_TIP
	tfdTip:setText(m_i18n[6916])
	-- 返回按键
	local btnBack = _mainLayout.BTN_CLOSE
	btnBack:addTouchEventListener(function (  sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
	 		LayerManager.removeLayout(mainLayout)
   			GlobalNotify.postNotify("SPECTREA_CHARGELAYOUTCLOSE",_addTreaTb)	-- 刷新底册界面UI
	 	end
	end)
end


function getAddNum( ... )
	logger:debug({_treaAddNum=_treaAddNum})
	return _treaAddNum
end

-- 初始化转化部分
function initItemBg( ... )
	local imgItemBg = _mainLayout.img_item_bg

	for i=1,2 do
		local layItem = imgItemBg["LAY_ITEM" .. i]

		local btnlay 
		local itemInfo
		local ownNum = 0

		if (i == 1) then
			btnlay	 = ItemUtil.createBtnByTemplateId(_powerFragTid)
			itemInfo = ItemUtil.getItemById(_powerFragTid)
			ownNum  =  _powerFragNum
		elseif (i ==2 ) then
			btnlay	 = ItemUtil.createBtnByTemplateId(_treaTid)
			itemInfo = ItemUtil.getItemById(_treaTid)
			ownNum  =  _haveTreaNum
		end

		local layItem = imgItemBg["LAY_ITEM" .. i]
		local btnlaySize = btnlay:getSize()
		btnlay:setPosition(ccp(btnlaySize.width * 0.5,btnlaySize.height * 0.5))
		layItem:addChild(btnlay)
		--  材料名字
		local tfdName = layItem.TFD_NAME1
		tfdName:setText(itemInfo.name)
		tfdName:setColor(g_QulityColor[itemInfo.quality])
		--  材料数量
		local tfdOwn = layItem.tfd_own1
		if (i == 1) then
			_tfdPowerOwnNum = layItem.TFD_OWN_NUM1
			_tfdPowerOwnNum:setText(ownNum)
		elseif (i == 2) then
			_tfdTreaOwnNum = layItem.TFD_OWN_NUM1
			_tfdTreaOwnNum:setText(ownNum)
		end

	end
end


-- 初始化消耗进度部分
function initItemNumBg( ... )
	local imgItemNumBg = _mainLayout.img_item_num_bg

	--  材料模型部分
	local btnlay = ItemUtil.createBtnByTemplateId(_treaTid)
	local itemInfo = ItemUtil.getItemById(_treaTid)
	
	local layItem = _mainLayout.LAY_ITEM3
	local btnlaySize = btnlay:getSize()
	btnlay:setPosition(ccp(btnlaySize.width * 0.5,btnlaySize.height * 0.5))
	layItem:addChild(btnlay)

	local tfdName = layItem.TFD_NAME3
	tfdName:setText(itemInfo.name)
	tfdName:setColor(g_QulityColor[itemInfo.quality])

	-- 进度条部分
	_progress  =  _mainLayout.LOAD_PROGRESS
	_progressNum  = _mainLayout.TFD_PROGRESS_NUM
	lableStroke(_progressNum)
	_progressNum:setText(_haveTreaNum ..  "/" .. _needTreaNum)

	local nPercent = _haveTreaNum / _needTreaNum * 100
  	_progress:setPercent((nPercent > 100) and 100 or nPercent)

end


-- 兑换
function onChange( ... )
	-- 检查背包是否已满
	if (ItemUtil.isSpecialTreasBagFull(true)) then
		return
	end

	local function afterBagRefresh( ... )
	end 
	PreRequest.setBagDataChangedDelete(afterBagRefresh) -- 注册后端推送背包信息时的回调

	local function requestFunc( cbFlag, dictData, bRet )  -- 做一些立刻要变的东西
		if( bRet )then
			-- table.insert(_addTreaTb,dictData.ret)
			local data = {}
        	data.tid = tonumber(_treaTid)
        	data.num = 1 -- 数量为 1
        	data.iType = 4 -- 5 代表类型为：装备
        	require "script/module/shop/HeroDisplay"
		 	HeroDisplay.create(data, 4)
			refreshUI()
			_treaAddNum = _treaAddNum + 1
   			GlobalNotify.postNotify("SPECTREA_CHARGEOK")	-- 刷新底册界面UI
		end
	end			
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(_treaTid))
	RequestCenter.bag_useUniversal(requestFunc,args)
end



-- 初始化兑换按钮
function intiBtn( ... )
	-- 兑换一次
	local btn1 = _mainLayout.BTN_1
	btn1:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (tonumber(_powerFragNum) <= 0) then
           		ShowNotice.showShellInfo("万能材料不够")
				return
			else
				onChange()
			end
		end
	end)

end



















