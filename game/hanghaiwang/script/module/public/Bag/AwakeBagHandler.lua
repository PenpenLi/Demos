-- FileName: AwakeBagHandler.lua
-- Author: LvNanchun
-- Date: 2015-11-11
-- Purpose: 觉醒物品背包数据处理类
--[[TODO List]]

AwakeBagHandler = class("AwakeBagHandler", BagHandler)

-- UI variable --

-- module local variable --

function AwakeBagHandler:moduleName()
    return "AwakeBagHandler"
end

function AwakeBagHandler:init( )
	self._bagType = BAG_TYPE_STR.awake
	self._nTabIdx = 1
end

-- must 初始化背包列表的一条数据，每种背包子类必须实现
function AwakeBagHandler:initOne( tbItemRef )
	local dbData = DB_Item_disillusion.getDataById(tbItemRef.item_template_id)

	local item = tbItemRef

	item.dbConf = dbData -- 物品对应的配置表信息

	item.id = tonumber(dbData.id) -- 排序用

	item.name = dbData.name -- 名称

	item.nQuality = dbData.quality -- 品质

	-- logger:debug({TreasBagHandler_initOne_item = item})
end

-- must 背包列表排序方法，每种背包子类需要实现
function AwakeBagHandler:listSorter( item1, item2 )
	-- 品质由低到高
	if (item1.nQuality ~= item2.nQuality) then
		return item1.nQuality < item2.nQuality
	end
	-- id由小到大
	return item1.id < item2.id 
end

-- must 每种背包子类必须实现
-- 1.在列表滑动回调中调用，填补初始化后剩余的其他字段 2.如果物品属性变化，需要重新给所有字段赋值
function AwakeBagHandler:fillOne( tbItemRef )
	logger:debug("BagHandler:fillOne")
	-- logger:debug({TreasBagHandler_fillOne_tbItemRef = tbItemRef})

	-- if (tbItemRef.icon) then
	-- 	-- logger:debug({fillOneWithData_has_item = tbItemRef})
	-- 	return -- 如果已经填充过直接返回
	-- end
	
	-- ********************************************************* --
	local item = tbItemRef
	
	local dbData, itemData = item.dbConf, item.va_item_text

	local nItemId = tonumber(item.item_id)

	item.icon = {id = dbData.id}
	item.icon.onTouch = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playInfoEffect()
			-- 点击icon打开信息面板
			AwakeItemInfoCtrl.create( dbData.id, "bag" )
		end
	end

	item.btnUse = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			-- 如果只有一个直接弹分解界面
			logger:debug({itemXXXXX = item})
			if (tonumber(item.item_num) == 1) then
				-- 分解网络回调
				local function fnNetSureCallBack( cbFlag, dictData, bRet )
					if (bRet) then
						-- 构造奖励窗的信息
						local awakeCoinInfo = ItemUtil.getItemById(60032)
						local awakeCoinNum = AwakeDecomposeModel.getCoinNumByItemNum(1)
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
						AwakeDecomposeModel.setBuyNumAndMaxNum(1, 1)
				
						-- 刷新背包界面
						GlobalNotify.addObserver(GlobalNotify.BAG_PUSH_CALL, function ( ... )
							local awakeHandler = BagModel.getBagHandler(BAG_TYPE_STR.awake)
							if (awakeHandler) then
								awakeHandler._objBag:updateListWithData(awakeHandler:getListData(), 1, AwakeDecomposeModel.getDeleteNum() )
							end
						end, true)
					end
				end

				AwakeDecomposeModel.dealInfo(item)

				local subArgs = CCArray:create()
				local args_item =  CCDictionary:create()
				args_item:setObject(CCInteger:create(1), tostring(item.item_id))
				subArgs:addObject(args_item)

				RequestCenter.resolveAwakeItem( fnNetSureCallBack, subArgs )
			else
				AwakeDecomposeCtrl.create( item )
			end
		end
	end
end

-- must 返回某种背包的当前最大可携带数, 每种背包子类必须实现
function AwakeBagHandler:getMaxNum( ... )
	logger:debug("BagHandler:getMaxNum")
	return tonumber(self._refBagInfo.gridMaxNum.awake)
end
