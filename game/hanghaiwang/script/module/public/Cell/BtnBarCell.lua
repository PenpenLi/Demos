-- FileName: BtnBarCell.lua
-- Author: zhangqi
-- Date: 2015-04-24
-- Purpose: 定义其他Cell中下拉按钮展开的按钮面板Cell
--[[TODO List]]

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

require "script/module/public/Cell/Cell"

BtnBarCell = class("BtnBarCell", Cell)

-- sUseType, 取值范围 CELL_USE_TYPE; objHostCell, 宿主Cell
function BtnBarCell:init(sUseType, objHostCell)
    self:initBase(CELLTYPE.BTN_BAR, sUseType)
    self.mCell:setEnabled(false)
    self.objHostCell = objHostCell

    -- 以下代码为了适配，需要将自动缩放的背景图片手工缩放，以及调整位置百分比
    self.mCell.img_bg:setScale(1/g_fScaleX)
    local ppBg = self.mCell.img_bg:getPositionPercent()
    self.mCell.img_bg:setPositionPercent(ccp(ppBg.x*1/g_fScaleX, ppBg.y*1/g_fScaleX))
end

function BtnBarCell:addCallbackToBtn( tbEvents, idx )
	for i, data in ipairs(tbEvents or {}) do
		local btnName = "BTN_" .. i
		logger:debug("addCallbackToBtn: " .. btnName)
		local labUnlock = m_fnGetWidget(self.mCell, "TFD_DESC_" .. i)
		local btn = m_fnGetWidget(self.mCell, btnName)
		btn.idx = idx
		assert(btn, "BtnBarCell:addCallbackToBtn can not found BTN_" .. i)

		if (data.event) then
			require "script/model/user/UserModel"
			if (UserModel.getHeroLevel() < data.unlock) then
				labUnlock:setText(m_i18nString(1141, tostring(data.unlock)))

				btn:setBright(false)
				btn:setTitleColor(g_btnTitleGray)
				UIHelper.titleShadow(btn, m_i18n[data.i18n])
			else
				labUnlock:setEnabled(false)
				UIHelper.titleShadow(btn, m_i18n[data.i18n])
				-- 进阶红点 2015 -11-18 sunyunpeng
				btn:setBright(true) -- 恢复上次禁用按的状态
				local btnRedPoint = m_fnGetWidget(btn, "IMG_RED")
				btnRedPoint:removeAllNodes()

				if (i == 2 and  data.canTrans ) then 
					btnRedPoint:removeAllNodes()
            		btnRedPoint:addNode(UIHelper.createRedTipAnimination())
				end

				if (i == 3 and data.canBreak == false) then
					btn:setBright(false) -- 如果是不可突破的伙伴禁用按钮
					btn:setTitleColor(g_btnTitleGray)
				end

				if (i == 4 and data.canAwake) then
					btnRedPoint:removeAllNodes()
            		btnRedPoint:addNode(UIHelper.createRedTipAnimination())
				end
        
				self.objHostCell:addMaskButton(btn, btnName, data.event)
			end
		else
			labUnlock:setEnabled(false)
			btn:setEnabled(false)
		end
	end
end

function BtnBarCell:refresh(tbData, idx)
    if (self.mCell) then
    	logger:debug({BtnBarCell_refresh = tbData.events})
    	self:addCallbackToBtn(tbData.events, idx)
    end
end
