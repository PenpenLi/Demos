-- 贝里副本信息




local BattleEventInfoMediator = class("BattleEventInfoMediator")

 
	------------------ properties ----------------------
	 BattleEventInfoMediator.name 			= "BattleEventInfoMediator"


	 BattleEventInfoMediator.totalDamageUI 	= nil
	 BattleEventInfoMediator.getBellyUI 	= nil
	 BattleEventInfoMediator.roundInfo 		= nil

	 BattleEventInfoMediator.dpsLevel		= nil
	 BattleEventInfoMediator.bellyLevel		= nil 
	 BattleEventInfoMediator.radio 			= nil -- 伤害获得贝里系数
	------------------ functions -----------------------
	function BattleEventInfoMediator:getInterests( ... )

		return {	
					NotificationNames.EVT_BELLY_EVENT_INFO_ADD,  		 	-- 初始化贝里副本信息
					NotificationNames.EVT_BELLY_EVENT_INFO_REMOVE,  		-- 移除
					NotificationNames.EVT_BELLY_EVENT_INFO_REFRESH_DAMAGE, 	-- 刷新
					NotificationNames.EVT_UI_REFRESH_ROUND					-- 刷新回合信息
		 		} 

	end



 	function BattleEventInfoMediator:createAll( ... )

 		self.totalDamageUI  = require(BATTLE_CLASS_NAME.BattleBellyEventInfoLabel).new()
 		self.getBellyUI 	= require(BATTLE_CLASS_NAME.BattleBellyEventInfoLabel).new()
 		self.roundInfo 		= require(BATTLE_CLASS_NAME.BattleBellyEventInfoLabel).new()

 		BattleLayerManager.battleUILayer:addChild(self.totalDamageUI)
 		BattleLayerManager.battleUILayer:addChild(self.getBellyUI)
 		BattleLayerManager.battleUILayer:addChild(self.roundInfo)


 		self.totalDamageUI:setPosition(10,g_winSize.height - (63+23) * g_fScaleY)
 		self.getBellyUI:setPosition(10,g_winSize.height - (63+23) * g_fScaleY - 52)
 		self.roundInfo:setPosition(10,g_winSize.height - (63+23) * g_fScaleY - 104)


 		self.totalDamageUI:reset(gi18nString(1372,""))
 		-- self.totalDamageUI:reset("当前伤害:")
 		self.getBellyUI:reset(gi18nString(1373,""))
 		-- self.getBellyUI:reset("获得贝里:")
 		self.roundInfo:reset(gi18nString(1374,""))
 		-- self.roundInfo:reset("当前回合:")

		-- self.totalDamageUI:setValueColor(255,0,0)
 		self.totalDamageUI:setValueColor(0,255,0)
 		self.getBellyUI:setValueColor(0,255,0)
 		self.roundInfo:setValueColor(0,255,0)
 		-- self.roundInfo:setValueColor(0,0,255)
 		

 		self.totalDamageUI:setValue("0")
 		self.getBellyUI:setValue("0")
 		self.roundInfo:setValue("0/5")

  	end
 

 	function BattleEventInfoMediator:removeAll( ... )
 		if(self.totalDamageUI) then
 			self.totalDamageUI:dispose()
 			ObjectTool.removeObject(self.totalDamageUI)
 			self.totalDamageUI = nil
 		end

 		if(self.getBellyUI) then
 			self.getBellyUI:dispose()
 			ObjectTool.removeObject(self.getBellyUI)
 			self.getBellyUI = nil
 		end

 		if(self.roundInfo) then
 			self.roundInfo:dispose()
 			ObjectTool.removeObject(self.roundInfo)
 			self.roundInfo = nil
 		end


 	end


	function BattleEventInfoMediator:onRegest( ... )

	   
	end -- function end

	function BattleEventInfoMediator:onRemove( ... )
		self:removeAll()
	end


	function BattleEventInfoMediator:getHandler()
		return self.handleNotifications
	end
 -- 	-- 计算伤害可以获取的伤害额外贝里
	-- function BattleEventInfoMediator:caculateDamageGetExtraBelly( damage )
	-- 	if(damage == nil) then damage = 0 end
	-- 	if(damage < 0 ) then
	-- 		damage = damage * -1
	-- 	end
	-- 	local result = 0
	-- 	if(self.dpsLevel) then
	-- 		local len = #self.dpsLevel 
	-- 		local damageLevel
	-- 		for i=1,len do
	-- 			damageLevel = self.dpsLevel[i]
	-- 			if(damage <= damageLevel) then
	-- 				result = self.bellyLevel[i]
	-- 				break
	-- 			end
	-- 		end

	-- 		if(result == nil) then
	-- 			damageLevel = self.dpsLevel[#self.dpsLevel]
	-- 			if(damageLevel <= damage) then
	-- 				result = self.bellyLevel[#self.bellyLevel]
	-- 			end
	-- 		end

	-- 	end

	-- 	return result
	-- end


	-- function BattleEventInfoMediator:caculateDamgeGetTotalBelly( id,damage )
		
	-- 	local baseBelly 	= damage * self.radio
	-- 	local extraBelly 	= self:caculateDamageGetExtraBelly(damage)
	-- 	local total 		= math.floor(baseBelly + extraBelly)
		
	-- 	return total
		
	-- 	-- 获得贝里值=基础贝里+额外贝里
	-- 	-- 基础贝里=伤害值*系数，系数在表中有配置
	-- 	-- 额外贝里按照伤害档次划分，获得额外贝里总值和伤害总值档位在表中有配置，是一一对应的关系。

	-- end	





	function BattleEventInfoMediator:handleNotifications(eventName,data)

			if eventName ~= nil then
				
				-- 显示加速按钮
				if eventName == NotificationNames.EVT_BELLY_EVENT_INFO_ADD then
					 self:createAll()
					 -- local id = BattleMainData.copyId
					 -- self.dpsLevel,self.bellyLevel = db_activitycopy_util.getDamgeDesInfo(id)
					 -- assert(self.dpsLevel,"贝里副本未发现伤害和获得贝里描述数据")
					 -- assert(self.bellyLevel,"贝里副本未发现伤害和获得贝里描述数据")
					 -- self.radio = db_activitycopy_util.getBellyRatio(id)
					 -- assert(self.radio,"贝里副本未发现伤害和获得贝里倍率数据")
				-- 删除
				elseif eventName == NotificationNames.EVT_BELLY_EVENT_INFO_REMOVE then
					 self:removeAll()
				
				-- 刷新
				elseif eventName == NotificationNames.EVT_BELLY_EVENT_INFO_REFRESH_DAMAGE then

					local adt = BattleMainData.fightRecord
					if(adt and adt.team2Info) then
						local total = adt.team2Info:getHpLost()
						-- local belly = self:caculateDamgeGetTotalBelly(BattleMainData.copyId,total)
						local belly = BattleDataUtil.caculateDamgeGetTotalBelly(BattleMainData.copyId,total)
						if(self.totalDamageUI) then
							self.totalDamageUI:setValue(total)
						end
						if(self.getBellyUI) then
 							self.getBellyUI:setValue(belly)
						end
					end

					-- 获得贝里值=基础贝里+额外贝里
					-- 基础贝里=伤害值*系数，系数在表中有配置
					-- 额外贝里按照伤害档次划分，获得额外贝里总值和伤害总值档位在表中有配置，是一一对应的关系。

				elseif eventName == NotificationNames.EVT_UI_REFRESH_ROUND then
					if(self.roundInfo) then
						


						local round = data or 0
						self.roundInfo:setValue(tostring(round) .. "/5")
					end
				end -- if end
			
			end -- if end

	end-- function end

return BattleEventInfoMediator

