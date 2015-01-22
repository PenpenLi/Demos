

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê10ÔÂ26ÈÕ 17:32:10
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

local config = 
{
	--topPanelInitY	= 90,
	--topPanelInitY	= 70,
	topPanelInitY	= 115 - 30,
	--topPanelExpanY	= 270,
	topPanelExpanY	= 370
}

---------------------------------------------------
-------------- StartGamePanelConfig
---------------------------------------------------

StartGamePanelConfig = class()

-------------------------------------------------------
--------	Top Panel Position
--------------------------------------------------------

function StartGamePanelConfig:topPanelInitY(...)
	assert(#{...} == 0)

	assert(config.topPanelInitY)
	return config.topPanelInitY
end

function StartGamePanelConfig:topPanelInitX(...)
	assert(#{...} == 0)

	return self.panel.topPanel:getPositionX()
end


function StartGamePanelConfig:topPanelExpanX(...)
	assert(#{...} == 0)

	return self.panel.topPanel:getPositionX()
end

function StartGamePanelConfig:topPanelExpanY(...)
	assert(#{...} == 0)

	-- Ensure Bottom Of The Rank List Show Up When Expanded
	local topPanelHeight		= self.panel:getTopPanel():getGroupBounds().size.height
	he_log_warning("because rank list panel has use table view, so can't use the getGroupBounds() function ! hard coded the rankList height")
	local rankListPanelHeight	= 947

	local totalHeight = topPanelHeight + rankListPanelHeight - 150


	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local winSize		= CCDirector:sharedDirector():getWinSize()

	local expandY = -(winSize.height - (visibleOrigin.y + totalHeight))

	print("StartGamePanelConfig:topPanelExpanY Called !!!")
	print("expandY: " .. expandY)

	return expandY
	--return config.topPanelExpanY
end

--------------------------------------------------------
-----	Rank List Panel Position
------------------------------------------------------


function StartGamePanelConfig:rankListInitX(...)
	assert(#{...} == 0)

	local rankList 		= self.panel:getRankList()
	local rankListInitX	= rankList:getPositionX()
	return rankListInitX
end

function StartGamePanelConfig:rankListInitY(...)
	assert(#{...} == 0)

	local toppanelSize	= self.panel:getTopPanel():getGroupBounds().size
	local rankListInitY	= self.panel:getTopPanelInitPos().y - toppanelSize.height + 150 
	return rankListInitY
end

function StartGamePanelConfig:rankListExpanX(...)
	assert(#{...} == 0)

	return self.panel:getRankList():getPositionX()
end

function StartGamePanelConfig:rankListExpanY(...)
	assert(#{...} == 0)

	local toppanelSize	= self.panel:getTopPanel():getGroupBounds().size
	local rankListExpanY	= self.panel:getTopPanelExpanPos().y - toppanelSize.height + 150
	return rankListExpanY
end

function StartGamePanelConfig:init(startGamePanel, ...)
	--assert(startGamePanel:is(StartGamePanel))
	assert(startGamePanel)
	assert(#{...} == 0)

	self.panel = startGamePanel
end


function StartGamePanelConfig:create(startGamePanel, ...)
	--assert(startGamePanel:is(StartGamePanel))
	assert(startGamePanel)
	assert(#{...} == 0)

	local newStartGamePanelConfig = StartGamePanelConfig.new()
	newStartGamePanelConfig:init(startGamePanel)
	return newStartGamePanelConfig
end

