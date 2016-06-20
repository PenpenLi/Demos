-- FileName: PublicInfoCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-21
-- Purpose: function description of module
--[[TODO List]]
-- 显示商店，兑换中心中 各种物品信息面板 比如说装备信息面板，

module("PublicInfoCtrl", package.seeall)

require "script/module/public/UIHelper"
require "script/module/public/ItemUtil"

-- 模块局部变量 --
local m_tid 


local function init(...)
	m_tid = nil
end

function destroy(...)
	package.loaded["PublicInfoCtrl"] = nil
end

function moduleName()
    return "PublicInfoCtrl"
end

function create( )

end

function createItemInfoViewByTid( _tid, num)
	AudioHelper.playInfoEffect()
	m_tid = _tid
	local tbItemInfo = ItemUtil.getItemById(m_tid) -- 通过ID获取某个物品的属性所有信息 
	if (tbItemInfo ~= nil) then
		if (tbItemInfo.isDirect == true) then	 	-- 直接使用类
			LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isGift == true) then		-- 礼包类物品：
			LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isRandGift == true) then -- 随机礼包类：
			LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isShip == true) then 	-- 激活主船物品：
			LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isFeed == true) then 	-- 坐骑饲料类：50001~80000
			LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isNormal == true) then   -- 普通物品：
			LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isBook == true) then     -- 武将技能书：

		elseif (tbItemInfo.isStarGift == true) then 	-- 好感礼物类：100001~120000
			LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isHeroFragment == true) then -- 伙伴碎片
	        require "script/module/partner/PartnerInfoCtrl"
	        local tbherosInfo = {}
	        local heroInfo = {htid = tbItemInfo.id ,hid = 0,strengthenLevel = 0 ,transLevel = 0,showOnly = true }
	        local tArgs = {}
	        tArgs.heroInfo = heroInfo
	        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
	        LayerManager.addLayoutNoScale(layer)

		elseif (tbItemInfo.isTreasureFragment == true) then -- 饰品碎片
			require "script/module/treasure/NewTreaInfoCtrl"
			NewTreaInfoCtrl.createBtTid(tbItemInfo.treasureId)
		elseif (tbItemInfo.isTreasure == true) then -- 饰品类：
			logger:debug("FragmentDrop")
			require "script/module/treasure/NewTreaInfoCtrl"
			NewTreaInfoCtrl.createBtTid(_tid)
		elseif (tbItemInfo.isConch == true) then  -- 空岛贝
			require "script/module/conch/ConchStrength/SkyPieaInfoCtrl"
			LayerManager.addLayout(SkyPieaInfoCtrl.createForConchItemInfo(tbItemInfo))
		elseif (tbItemInfo.isDress == true) then 	-- 时装
			LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo))
		elseif (tbItemInfo.isFragment == true) then	-- 物品碎片类：
			require "script/module/equipment/EquipInfoCtrl"
			EquipInfoCtrl.createForShopFragEquip(tbItemInfo)
		elseif (tbItemInfo.isArm == true) then  	-- 装备类：
			require "script/module/equipment/EquipInfoCtrl"
			EquipInfoCtrl.createForShopEquip(tbItemInfo)
		elseif (tbItemInfo.isSpeTreasure == true) then  	-- 专属宝物
			require "script/module/specialTreasure/SpecTreaInfoCtrl"
			SpecTreaInfoCtrl.create(tbItemInfo.id)
		elseif (tbItemInfo.isSpeTreasureFragment == true) then  	-- 专属宝物碎片
			require "script/module/specialTreasure/SpecTreaInfoCtrl"
			SpecTreaInfoCtrl.create(tbItemInfo.id)
		elseif (tbItemInfo.isAwake) then 							-- 觉醒物品
			AwakeItemInfoCtrl.create(tbItemInfo.id, "bag")
		end
	end
end


--noPlayAudioEffect 不播放音效 因为在点击强化 进阶 等按钮时候会触发
function createItemDropInfoViewByTid( _tid ,dropReturnCallFn,noPlayAudioEffect)
	-- 是否播放音效
	if (not noPlayAudioEffect) then
		AudioHelper.playInfoEffect()
	end
	m_tid = _tid
	local tbItemInfo = ItemUtil.getItemById(m_tid) -- 通过ID获取某个物品的属性所有信息 
	if (tbItemInfo ~= nil) then
		if (tbItemInfo.isDirect == true) then	 	-- 直接使用类
			-- LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isGift == true) then		-- 礼包类物品：
			-- LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isRandGift == true) then -- 随机礼包类：
			-- LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isFeed == true) then 	-- 坐骑饲料类：50001~80000
			-- LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isNormal == true) then   -- 普通物品：
			require "script/module/public/PropertyDrop"
			local propertyDrop = PropertyDrop:new()
			local propertyDropLayer = propertyDrop:create(m_tid,dropReturnCallFn)
			LayerManager.addLayout(propertyDropLayer)                    
		elseif (tbItemInfo.isBook == true) then     -- 武将技能书：

		elseif (tbItemInfo.isStarGift == true) then 	-- 好感礼物类：100001~120000
			-- LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo,num))
		elseif (tbItemInfo.isHeroFragment == true) then -- 伙伴碎片
			require "script/module/public/FragmentDrop"
			local fragmentDrop = FragmentDrop:new()
			local fropertyDropLayer = fragmentDrop:create(m_tid,dropReturnCallFn)
			LayerManager.addLayout(fropertyDropLayer)  

		elseif (tbItemInfo.isTreasureFragment == true) then -- 宝物碎片
			require "script/module/public/FragmentDrop"
			local fragmentDrop = FragmentDrop:new()
			local fropertyDropLayer = fragmentDrop:create(m_tid,dropReturnCallFn)
			LayerManager.addLayout(fropertyDropLayer)                    
			
		elseif (tbItemInfo.isTreasure == true) then -- 宝物类：
			logger:debug("PropertyDrop")
			require "script/module/public/EntireDrop"
			local entireDrop = EntireDrop:new()
			local entireDropLayer = entireDrop:create(m_tid,dropReturnCallFn)
			LayerManager.addLayout(entireDropLayer)                    
			
		elseif (tbItemInfo.isConch == true) then  -- 空岛贝
			require "script/module/conch/ConchStrength/SkyPieaInfoCtrl"
			LayerManager.addLayout(SkyPieaInfoCtrl.createForConchItemInfo(tbItemInfo))
		elseif (tbItemInfo.isDress == true) then 	-- 时装
			LayerManager.addLayout(UIHelper.createItemInfoDlg(tbItemInfo))
		elseif (tbItemInfo.isFragment == true) then	-- 物品碎片类：
			require "script/module/public/FragmentDrop"
			local fragmentDrop = FragmentDrop:new()
			local fropertyDropLayer = fragmentDrop:create(m_tid,dropReturnCallFn)
			LayerManager.addLayout(fropertyDropLayer)  
		elseif (tbItemInfo.isArm == true) then  	-- 装备类：                   
			
		elseif (tbItemInfo.isSpeTreasure == true) then  	-- 专属宝物
			require "script/module/specialTreasure/SpecTreaDrop"
			local specTreaDrop = SpecTreaDrop:new()
			local dropLayout = specTreaDrop:create(tbItemInfo.id)
			LayerManager.addLayout(dropLayout)
			
		elseif (tbItemInfo.isSpeTreasureFragment == true) then  	-- 专属宝物碎片
			logger:debug({m_tid=m_tid})
			require "script/module/public/FragmentDrop"
			logger:debug({m_tid=m_tid})
			local fragmentDrop = FragmentDrop:new()
			local fragmentDropLayer = fragmentDrop:create(m_tid,dropReturnCallFn)
			LayerManager.addLayout(fragmentDropLayer)
		elseif (tbItemInfo.isShip) then
			require "script/module/public/PropertyDrop"
			local propertyDrop = PropertyDrop:new()
			local propertyDropLayer = propertyDrop:create(m_tid,dropReturnCallFn)
			LayerManager.addLayout(propertyDropLayer)
		end
	end



end

function createHeroInfoView(_htid)
	require "script/model/utils/HeroUtil"
	local heroInfo =HeroUtil.getHeroLocalInfoByHtid(_htid)
    require "script/module/partner/PartnerInfoCtrl"
    local pHeroValue = heroInfo --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
    logger:debug({pHeroValue=pHeroValue})
    local tbherosInfo = {}
    local heroInfo = {htid = pHeroValue.fragment ,hid = 0,strengthenLevel = 0 ,transLevel = 0}
    table.insert(tbherosInfo,heroInfo)
    local tArgs = {}
    tArgs.heroInfo = heroInfo
    tArgs.index = 1
    logger:debug({tArgs=tArgs})
    local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
    LayerManager.addLayoutNoScale(layer)
end


