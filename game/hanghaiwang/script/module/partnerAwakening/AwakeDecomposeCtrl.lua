-- FileName: AwakeDecomposeCtrl.lua
-- Author: LvNanchun
-- Date: 2015-11-19
-- Purpose: 觉醒物品分解界面提示框控制器
--[[TODO List]]

module("AwakeDecomposeCtrl", package.seeall)

-- UI variable --
local _viewInstance

-- module local variable --
local _nowDisplay = 1
local _nowMaxNum
-- 物品信息给分解按钮回调使用
local _itemInfo

local function init(...)

end

function destroy(...)
    package.loaded["AwakeDecomposeCtrl"] = nil
end

function moduleName()
    return "AwakeDecomposeCtrl"
end

-- 关闭按钮回调
local function fnBtnClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
	end
end

-- 分解网络回调
local function fnNetSureCallBack( cbFlag, dictData, bRet )
	if (bRet) then
		-- 删除分解窗口
		LayerManager.removeLayout()
		-- 构造奖励窗的信息
		local awakeCoinInfo = ItemUtil.getItemById(60032)
		local awakeCoinNum = AwakeDecomposeModel.getCoinNumByItemNum(_nowDisplay)
		local rewardInfo = {}
		local tbItems = {rewardInfo}
		rewardInfo.icon = ItemUtil.createBtnByTemplateIdAndNumber( 60032, awakeCoinNum )
		rewardInfo.name = awakeCoinInfo.name
		rewardInfo.quality = awakeCoinInfo.quality

		-- 奖励窗
		local rewardView = UIHelper.createRewardDlg( tbItems )
		LayerManager.addLayoutNoScale( rewardView )

		-- 修改觉醒结晶数目
		UserModel.addAwakeRimeNum( awakeCoinNum )

		-- 是否删除了cell
		AwakeDecomposeModel.setBuyNumAndMaxNum(_nowDisplay, _nowMaxNum)

		-- 刷新背包界面
		GlobalNotify.addObserver(GlobalNotify.BAG_PUSH_CALL, function ( ... )
			local awakeHandler = BagModel.getBagHandler(BAG_TYPE_STR.awake)
			if (awakeHandler) then
				awakeHandler._objBag:updateListWithData(awakeHandler:getListData(), 1, AwakeDecomposeModel.getDeleteNum() )
			end
		end, true)
	end
end

-- 确认按钮回调
local function fnBtnSureCallBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local subArgs = CCArray:create()
    	local args_item =  CCDictionary:create()
		args_item:setObject(CCInteger:create(_nowDisplay), tostring(_itemInfo.itemId))
		subArgs:addObject(args_item)

		RequestCenter.resolveAwakeItem( fnNetSureCallBack, subArgs )
	end
end

local function setNumInView( )
	_viewInstance:setDisplayNum( _nowDisplay )
	_viewInstance:setCoinNum( AwakeDecomposeModel.getCoinNumByItemNum(_nowDisplay) )
end

-- 减号按钮回调
local function fnBtnSub( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if (_nowDisplay - 1 >= 1) then
			_nowDisplay = _nowDisplay - 1
			setNumInView()
		end
	end
end

-- 减10按钮回调
local function fnBtnSubTen( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if (_nowDisplay - 10 >= 1) then
			_nowDisplay = _nowDisplay - 10
			setNumInView()
		else
			_nowDisplay = 1
			setNumInView()
		end
	end
end

-- 加号按钮回调
local function fnBtnAdd( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if (_nowDisplay + 1 <= _nowMaxNum) then
			_nowDisplay = _nowDisplay + 1
			setNumInView()
		end
	end
end

-- 加10按钮回调
local function fnBtnAddTen( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if (_nowDisplay + 10 <= _nowMaxNum) then
			_nowDisplay = _nowDisplay + 10
			setNumInView()
		else
			_nowDisplay = _nowMaxNum
			setNumInView()
		end
	end
end

-- 物品推送刷新背包的回调事件
local function refreshBagCallBack()
	
end

function create( tbItem )
	_viewInstance = AwakeDecomposeView:new()
	for k,v in pairs(tbItem) do
		logger:debug({tbItemKey = k})
	end

	-- 处理传来的数据
	AwakeDecomposeModel.dealInfo(tbItem)

	-- 初始化界面上的数字，刚进去是1
	_nowDisplay = 1
	-- 初始化界面上的数据
	setNumInView()

	-- 构建需要的按钮
	local tbBtn = {}
	tbBtn.close = fnBtnClose
	tbBtn.sure = fnBtnSureCallBack
	tbBtn.add = fnBtnAdd
	tbBtn.addTen = fnBtnAddTen
	tbBtn.sub = fnBtnSub
	tbBtn.subTen = fnBtnSubTen

	-- 构建需要的数据
	local tbInfo = AwakeDecomposeModel.getViewInfo()
	tbInfo.fnRefresh = refreshBagCallBack
	_nowMaxNum = tbInfo.num
	_itemInfo = {}
	_itemInfo.tid = tbItem.id
	_itemInfo.name = tbInfo.name
	_itemInfo.quality = tbItem.nQuality
	_itemInfo.itemId = tbItem.item_id
	logger:debug({_itemInfo = _itemInfo})

	local view = _viewInstance:create( tbBtn, tbInfo )

	LayerManager.addLayout(view)
end

