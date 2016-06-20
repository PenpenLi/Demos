
-- 宝箱飞管理器
local BattleChestMediator = class("BattleChestMediator")

 
	------------------ properties ----------------------
	 BattleChestMediator.name 			= "BattleChestMediator"


	 BattleChestMediator.flyingItems 	= nil

	------------------ functions -----------------------
	function BattleChestMediator:getInterests( ... )

		return {	
					NotificationNames.EVT_CHEST_ADD,  		 		-- 添加一个箱子飞得动作
					NotificationNames.EVT_CHEST_UNUSE_ALL,  		 			-- 废弃当前正在执行的数据(动画仍然继续)
					NotificationNames.EVT_CHEST_DISPOSE  		 		-- 删除所有
					-- NotificationNames.EVT_UI_INI,			 		-- 初始
		 		} 
	end


	function BattleChestMediator:releaseAll( ... )
		for k,action in pairs(self.flyingItems or {}) do
			if(action) then
				action:release()
			end
		end
		self.flyingItems = {}
	end

	function BattleChestMediator:onRegest( ... )

		self.flyingItems = {}
	   
	end -- function end

	function BattleChestMediator:onRemove( ... )
		self:releaseAll()
	end


	function BattleChestMediator:getHandler()
		return self.handleNotifications
	end

	function BattleChestMediator:handleActionComplete(target,data)
		if(target) then
			self.flyingItems[target:instanceName()] = nil
		end
	end

	function BattleChestMediator:handleNotifications(eventName,data)

			if eventName ~= nil then
			
				-- 显示加速按钮
				if eventName == NotificationNames.EVT_CHEST_ADD then
					-- print("== EVT_CHEST_ADD")
					local target = data
					if(target ~= nil and target.willDropItem == true) then
						 
						local chest = target:popAll()
						-- for k,v in pairs(chest or {}) do
							
							local action = require(BATTLE_CLASS_NAME.BAforChestDropAndFlyAction).new()
							action.target = target.displayData
							action.chestDataes = chest
							-- action.uiPosition = 
							-- local complete = function (  )
							-- 	self.flyingItems[action:instanceName()] = nil
							-- end
							self.flyingItems[action:instanceName()] = action
							-- table.insert(self.flyingItems,action)
							action:addCallBacker(self,self.handleActionComplete)
							action:start()
						-- end
						
					end -- if end
				-- 废弃数据
				elseif eventName == NotificationNames.EVT_CHEST_UNUSE_ALL then

					for k,targetAction in pairs(self.flyingItems) do
						targetAction.unloadData = true
					end

				-- 删除
				elseif eventName == NotificationNames.EVT_CHEST_DISPOSE then
					self:releaseAll()
				end -- if end
			
			end -- if end

	end-- function end

return BattleChestMediator
