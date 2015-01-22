
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ28ÈÕ 19:52:19
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- EnergyBuyAndContinueBtn
---------------------------------------------------

assert(not EnergyBuyAndContinueBtn)
assert(BaseUI)
EnergyBuyAndContinueBtn = class(BaseUI)

function EnergyBuyAndContinueBtn:init(xxx, ...)
	assert(#{...} == 0)

	
end

function EnergyBuyAndContinueBtn:create(xxx, ...)
	assert(#{...} == 0)

	local newEnergyBuyAndContinueBtn = EnergyBuyAndContinueBtn.new()
	newEnergyBuyAndContinueBtn:init()
	return newEnergyBuyAndContinueBtn
end

