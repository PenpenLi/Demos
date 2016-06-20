-- FileName: EquipFragCell.lua
-- Author: huxiaozhou 
-- Date: 2014-05-23
-- Purpose: 装备碎片cell
--[[TODO List
[1332] = "数量：",
[1604] = "合成",
]]

require "script/module/public/Cell/Cell"

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

------------------------------ 定义装备-Cell------------------------------------------
EquipFragCell = class("EquipFragCell",Cell)

-- EquipFragCell.tbTypes = {["LAY_FRAGMENT_SALE"]=false, ["LAY_EQUIP_BAG"]=false,}


--[[
--tbData 格式
tbData = {	
 			name = "小刀海贼-" .. idx, 
 			sign = "item_type_shadow.png", 
 			icon = btnIcon

 			bSelect = true or false 

 			onCompond =  合成装备方法 func
 	
 			price = "  " 出售价格 单件的价格 
 			curNum -- 当前拥有数量
 			maxNum -- 可以合成的数量
            nScore -- 对应装备的品级
 			
--]]

function EquipFragCell:refreshEquipFragCommon( tbData )
	if (self.mCell) then
		local cell = self.mCell

        local labSign = m_fnGetWidget(self.mCell, "TFD_SIGN")
        UIHelper.setLabel(labSign, {text = tbData.sign, color = self.qualityColor[tbData.nQuality]})
        
		local tfd_progress_i18n = m_fnGetWidget(cell, "tfd_progress_i18n") -- 进度  需要本地化的文字 改成 数量
        tfd_progress_i18n:setText(m_i18n[1332])

		local labMemberNum = m_fnGetWidget(cell,"TFD_MEMBER_NUM")  -- 当前有的数量
        labMemberNum:setText(tbData.curNum)

		local labDomitNum = m_fnGetWidget(cell,"TFD_DOMIT_NUM")  -- 合成需要的数量
        labDomitNum:setText(tbData.maxNum)
	end
end

-- 在出售界面
function EquipFragCell:refreshSale( tbData )
	if (self.layMod) then
        local sale = self.layMod

        local labPrice =  m_fnGetWidget(sale, "TFD_SELL_PRICE") --出售价格
        labPrice:setText(tbData.price)
        
        -- cell 内部保存 check box 状态
        self.cbxSelect = m_fnGetWidget(sale, "CBX_SELL_SELECT")
        self.cbxSelect:setSelectedState(tbData.bSelect)
    end
end

-- 在背包
function EquipFragCell:refreshBag( tbData )
	if (self.layMod) then
        
        self:removeMaskButton("BTN_COMPOND")
        self:removeMaskButton("BTN_DROP")

        local bag = self.layMod
       	local btnCompond = m_fnGetWidget(bag, "BTN_COMPOND") --合成按钮
        local tfdDesc = m_fnGetWidget(bag, "TFD_DESC") --碎片不足

        btnCompond.tbNeed = {gid = tbData.gid, item_id = tbData.item_id, item_num = tbData.item_num, name = tbData.compondName}

        local btnDrop = m_fnGetWidget(bag,"BTN_DROP")-- 碎片掉落查看按钮
        btnDrop.idx = tbData.gid
        -- 清除点击事件的方法 sunyunpeng  sunyunpeng 2016-01-29
        btnCompond.FnRemoveCompondMaskButton = function ( ... )
            self:removeMaskButton("BTN_COMPOND")
        end
        btnCompond.FnRemoveDropMaskButton = function ( ... )
            self:removeMaskButton("BTN_DROP")
        end

        -- self:removeMaskButton("BTN_COMPOND")
       	if(tbData.curNum == tbData.maxNum) then
       		btnCompond:setEnabled(true)
            UIHelper.titleShadow(btnCompond, m_i18n[1604])
        	self:addMaskButton(btnCompond, "BTN_COMPOND", tbData.onCompond)
            tfdDesc:setEnabled(false)
            btnDrop:setEnabled(false)
        else
        	btnCompond:setEnabled(false)
            tfdDesc:setEnabled(true)
            btnDrop:setEnabled(true)
            self:addMaskButton(btnDrop, "BTN_DROP", tbData.onFindDrop)
    	end
    end
end

-- 刷新方法
function EquipFragCell:refreshEquipFrag(tbData)
	if (self.mCell) then
		local keyType = "LAY_FRAGMENT_" .. self.subType
		self.UseNames[keyType] = true

		for k, v in pairs(self.UseNames) do
			local layUse = m_fnGetWidget(self.mCell, k)
			if ((not v) and layUse) then
				layUse:removeFromParentAndCleanup(true)
			end
		end
		self.layMod = m_fnGetWidget(self.mCell, keyType) -- 当前用到类型的layout引用
       	self:refreshByType(tbData) 
	end

end

-------------------- 对外接口 begin---------------
--[[
	初始化方法 
	args string 类型
	sType  = BAG , -- 背包列表
	   		SALE , -- 出售列表
    		
--]]
 			
function EquipFragCell:init(sType)
    self.UseNames = {["LAY_FRAGMENT_SALE"]=false, ["LAY_FRAGMENT_BAG"]=false,}
    self:initBase(CELLTYPE.FRAGMENT, sType)
end

-- 刷新
-- tbData 数据 见顶部
function EquipFragCell:refresh( tbData)
	if (self.mCell) then
    	self:refreshBase(tbData)
		self:refreshEquipFragCommon(tbData)
		self:refreshEquipFrag(tbData)
	end
end

-- 重用时需要先清理, 然后调用refresh
function EquipFragCell:clearAndRefresh(tbData)
    self:clear(tbData)
    self:refresh(tbData)
end

------------------ 对外接口 end ------------------------
