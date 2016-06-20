
local BattleTouchScreenShowNameMediator = class("BattleTouchScreenShowNameMediator")
 BattleTouchScreenShowNameMediator.name 			= "BattleTouchScreenShowNameMediator"

 
	------------------ properties ----------------------
 	BattleTouchScreenShowNameMediator.isShowName 		= true
 	BattleTouchScreenShowNameMediator.onShowState 		= false
	------------------ functions -----------------------
	function BattleTouchScreenShowNameMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					NotificationNames.EVT_ENABLE_TOUCH_SHOW_NAME,
					NotificationNames.EVT_DISABLE_TOUCH_SHOW_NAME,
					 
				}
	end
	 
	function BattleTouchScreenShowNameMediator:getHandler()
		return self.handleNotifications
	end

	function BattleTouchScreenShowNameMediator:onRegest( ... )
		 Logger.debug("=== BattleTouchScreenShowNameMediator:onRegest")
		 self.onShowState = false
	end

	function BattleTouchScreenShowNameMediator:onRemove( ... )

		self:disableShowName()
	end
	function BattleTouchScreenShowNameMediator:handleNotifications(eventName,data)

		if eventName ~= nil then
			-- 初始化背景
			if eventName == NotificationNames.EVT_ENABLE_TOUCH_SHOW_NAME then
				Logger.debug("=== BattleTouchScreenShowNameMediator:EVT_ENABLE_TOUCH_SHOW_NAME")
				self:enableShowName()
			elseif eventName == NotificationNames.EVT_DISABLE_TOUCH_SHOW_NAME then
				Logger.debug("=== BattleTouchScreenShowNameMediator:disableShowName")
				self:disableShowName()
			end
		end
	end
	-- function BattleTouchScreenShowNameMediator:onCardMouseEvent(eventType, postions)
	-- 	Logger.debug("onCardMouseEvent:" .. eventType)
	-- 	return false
	-- end
 
	function BattleTouchScreenShowNameMediator:enableShowName( ... )
		
		if(self.onShowState == true) then return end
		
		self.onShowState = true
		local onMouseEvent = function (eventType, x,y)
				self.isShowName = not self.isShowName
				-- Logger.debug("=== onMouseEvent:".. eventType .. " " .. tostring(x) .. " " .. tostring(y))
				for k,cardDisplay in pairs(BattleTeamDisplayModule.selfDisplayListByPostion or {}) do
					if(self.isShowName) then

						cardDisplay:showName()
					else
						cardDisplay:hideName()
					end
				end

				for k,cardDisplay in pairs(BattleTeamDisplayModule.armyDisplayListByPostion or {}) do
					if(self.isShowName) then
						-- cardDisplay:setDisplayName()
						cardDisplay:showName()

					else
						cardDisplay:hideName()
					end
				end

				return false	
				
		end 

		BattleLayerManager.battleBaseLayer:setTouchEnabled(true)
		BattleLayerManager.battleBaseLayer:registerScriptTouchHandler(onMouseEvent,false,g_tbTouchPriority.battleLayer - 1,true)
		BattleLayerManager.battleBaseLayer:setTouchMode(kCCTouchesOneByOne)
		BattleLayerManager.battleBaseLayer:setTouchPriority(g_tbTouchPriority.battleLayer - 1)

	end

	function BattleTouchScreenShowNameMediator:disableShowName( ... )
		self.onShowState = false
		if(BattleLayerManager.battleBaseLayer) then
			BattleLayerManager.battleBaseLayer:setTouchEnabled(false)
	    	BattleLayerManager.battleBaseLayer:unregisterScriptHandler()
		end
	end
 return BattleTouchScreenShowNameMediator

