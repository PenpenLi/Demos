JumpLevelIcon = class()
require "zoo.panel.jumpLevel.JumpLevelPanel"
function JumpLevelIcon:create( ui, levelId, levelType, parentPanel, isFakeIcon)
	-- body
	local s = JumpLevelIcon.new()
	s:init(ui, levelId, levelType, parentPanel, isFakeIcon)
	return s
end

function JumpLevelIcon:init( ui, levelId, levelType, parentPanel, isFakeIcon)
	-- body
	self.ui = ui
	self.levelId = levelId
	self.levelType = levelType
	self.parentPanel = parentPanel
	self.isFakeIcon = isFakeIcon
	local function onTapped(evt)
		self:onTapped()
	end

	ui:addEventListener(DisplayEvents.kTouchEnd, onTapped)
	ui:setTouchEnabled(true, 0, true)
end

function JumpLevelIcon:onTapped( ... )



	if self.isFakeIcon then
		CommonTip:showTip(localize('skipLevel.tips9', {replace1 = 40}), 'positive')
		return
	end
	-- body
	local function onSuccess( data )
		-- body
		local pawnNum = 0
		if data.data and data.data.pawnNum then
			pawnNum = data.data.pawnNum
		end
		local level_reward = MetaManager.getInstance():getLevelRewardByLevelId(self.levelId)
		if level_reward and level_reward.skipLevel ~= pawnNum then
			level_reward.skipLevel = pawnNum
		end
		if pawnNum > 0 then
			if self.parentPanel and not self.parentPanel.isDisposed then
				self.parentPanel:onCloseBtnTapped()
			end
			local isStartGamePanel = (self.parentPanel and self.parentPanel:is(LevelInfoPanel))
			local s = JumpLevelPanel:create(self.levelId, self.levelType, isStartGamePanel)
			s:popout()
		else
			CommonTip:showTip(Localization:getInstance():getText("skipLevel.tips11"), "negative")
			self.ui:removeFromParentAndCleanup(true)
		end
		
	end

	local function onFail( err )
		local err_code = tonumber(err.data or 0) 
		CommonTip:showTip(localize('error.tip.'..err_code), "negative",nil, 2)
	end

	local http = GetLevelPawnNumHttp.new(true)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load(self.levelId)
	
end
