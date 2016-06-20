-- FileName: PartnerDescView.lua
-- Author: LvNanchun
-- Date: 2015-12-23
-- Purpose: function description of module
--[[TODO List]]

PartnerDescView = class("PartnerDescView")

-- UI variable --

-- module local variable --

function PartnerDescView:moduleName()
    return "PartnerDescView"
end

function PartnerDescView:ctor(...)
	self._layMain = g_fnLoadUI("ui/partner_desc.json")
end

function PartnerDescView:create( tid )
	local partnerInfo = HeroUtil.getHeroLocalInfoByHtid( tid )

	self._layMain.BTN_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)

	self._layMain.TFD_NAME:setText(partnerInfo.name)
	self._layMain.TFD_NAME:setColor(g_QulityColor[partnerInfo.quality])
	self._layMain.TFD_PLACE:setText(partnerInfo.place)
	
	local heroIcon = HeroUtil.createHeroIconBtnByHtid(tid)
	self._layMain.LAY_ICON:addChild(heroIcon)
	heroIcon:setPosition(ccp(self._layMain.LAY_ICON:getSize().width/2, self._layMain.LAY_ICON:getSize().height/2))

	self._layMain.TFD_DESC:setText(partnerInfo.place_desc)

	return self._layMain
end

