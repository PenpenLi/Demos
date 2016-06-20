 


-- 替补ui 管理器
local BattleBenchInfoMediator = class("BattleBenchInfoMediator")

 
	------------------ properties ----------------------
	 BattleBenchInfoMediator.name 			= "BattleBenchInfoMediator"
	 BattleBenchInfoMediator.team1InfoUI		= nil -- 队伍1替补ui
	 BattleBenchInfoMediator.team2InfoUI		= nil -- 替补2替补ui
	 BattleBenchInfoMediator.team1DisplayData 	= nil
	 BattleBenchInfoMediator.team2DisplayData 	= nil
	 BattleBenchInfoMediator.team1HasBench		= nil
	 BattleBenchInfoMediator.team2HasBench		= nil
	------------------ functions -----------------------
	function BattleBenchInfoMediator:getInterests( ... )

		return {	
					NotificationNames.EVT_UI_BENCH_ADD,  		 		-- 初始化
					NotificationNames.EVT_UI_BENCH_REFRESH_ALIVE_NUM,  	-- 刷新
					NotificationNames.EVT_UI_BENCH_SHOW, 		 		-- 显示
					-- NotificationNames.EVT_UI_BENCH_REMOVE,  		 	-- 删除
					NotificationNames.EVT_UI_BENCH_HIDE,			 	-- 隐藏
					NotificationNames.EVT_UI_BENCH_SHOW_REVIVE,			-- 显示替补复活界面
					NotificationNames.EVT_UI_BENCH_REMOVE_REVIVE,		-- 删除替补复活界面
					NotificationNames.EVT_UI_BENCH_INI_FROM_BATTLE_STRING,		--
					NotificationNames.EVT_UI_BENCH_INI_FROM_DATACACHE,		-- 删除替补复活界面
					NotificationNames.EVT_UI_BENCH_ENABLE_REVIVE,		-- 开启复活
					NotificationNames.EVT_UI_BENCH_DISABLE_REVIVE,		-- 关闭复活
					NotificationNames.EVT_UI_BENCH_REVIVE_SUCCESS,		-- 替补复活成功
					NotificationNames.EVT_UI_BENCH_REQUEST_REVIVE		-- ui触发 请求复活替补
		 		} 
	end
	-- 添加替补复活ui
	function BattleBenchInfoMediator:showBenchRevive( ... )
		
		local bench = DataCache.getBench()
		local hero = HeroModel.getHeroByHid()
	end

	-- 关闭替补复活ui
	function BattleBenchInfoMediator:removeBenchRevive( ... )

	end

	function BattleBenchInfoMediator:onRegest( ... )
		self.team1HasBench = false
		self.team2HasBench = false
	end -- function end

	function BattleBenchInfoMediator:onRemove( ... )
		self.team1DisplayData = nil
		self.team2DisplayData = nil
		self:removeUI()
	end


	function BattleBenchInfoMediator:getHandler()
		return self.handleNotifications
	end
 	
	-- 刷新ui信息
	function BattleBenchInfoMediator:refreshBenchAliveNum()

		local adt = BattleMainData.fightRecord
		local aliveNum
		if(self.team1HasBench) then
			-- 设置剩余数量
			if(adt) then
				aliveNum = adt.team1Info:getBenchAliveNum()
				self.team1InfoUI:setLeftNum(aliveNum)
			else 
				if(self.team1DisplayData) then
					self.team1InfoUI:setLeftNum(#self.team1DisplayData)
				else
					self.team1InfoUI:setLeftNum(0)
				end
			end

		end
		
		if(self.team2HasBench) then
			if(adt) then
				aliveNum = adt.team2Info:getBenchAliveNum()
				self.team2InfoUI:setLeftNum(aliveNum)
			else
				if(self.team2DisplayData) then
					self.team2InfoUI:setLeftNum(#self.team2DisplayData)
				else
					self.team2InfoUI:setLeftNum(0)
				end
			end
		end
	end
	-- 创建替补ui 
 	function BattleBenchInfoMediator:createUI()
 		if(self.team1InfoUI == nil) then
 			self.team1InfoUI = require(BATTLE_CLASS_NAME.BattleBenchInfoComponent).new()
 		end
 		if(self.team1InfoUI:getParent() == nil) then
 			BattleLayerManager.battleUILayer:addChild(self.team1InfoUI)
 		end
 		self.team1InfoUI:setPosition(ccp(6,200 * g_fScaleY))

 		if(self.team2InfoUI == nil) then
 			self.team2InfoUI = require(BATTLE_CLASS_NAME.BattleBenchInfoComponent).new()
 		end

 		if(self.team2InfoUI:getParent() == nil) then
 			BattleLayerManager.battleUILayer:addChild(self.team2InfoUI)
 		end

 		self.team2InfoUI:setPosition(ccp(6,700 * g_fScaleY))

 	end

 	function BattleBenchInfoMediator:removeUI()
 		if(self.team1InfoUI and not tolua.isnull(self.team1InfoUI)) then
 			self.team1InfoUI:dispose()
 			ObjectTool.removeObject(self.team1InfoUI)
 		end
 		if(self.team2InfoUI and not tolua.isnull(self.team2InfoUI)) then
 			self.team2InfoUI:dispose()
 			ObjectTool.removeObject(self.team2InfoUI)
 		end

 	end

	function BattleBenchInfoMediator:handleNotifications(eventName,data)

			if eventName ~= nil then
			
				-- 初始化
				if eventName == NotificationNames.EVT_UI_BENCH_ADD then
					self:createUI()
				-- 刷新
				elseif eventName == NotificationNames.EVT_UI_BENCH_REFRESH_ALIVE_NUM then
					self:refreshBenchAliveNum()

				-- 显示
				elseif eventName == NotificationNames.EVT_UI_BENCH_SHOW then

				-- 删除
				elseif eventName == NotificationNames.EVT_UI_BENCH_REMOVE then

				-- 隐藏
				elseif eventName == NotificationNames.EVT_UI_BENCH_HIDE then
				-- 替补复活成功
				elseif eventName == NotificationNames.EVT_UI_BENCH_REVIVE_SUCCESS then
					local hid = data
					self:refreshBenchAliveNum()
					if(self.team1InfoUI) then
						self.team1InfoUI:refreshDeadState()
					end
				-- ui触发,请求复活替补
				elseif eventName == NotificationNames.EVT_UI_BENCH_REQUEST_REVIVE then

					-- print("EVT_UI_BENCH_REQUEST_REVIVE 1")
					local targetID = tonumber(data)
					local targetData = BattleMainData.fightRecord:getTargetData(targetID)
					-- 判断是否死亡
					if(targetData ~= nil and targetData:isDead() == true) then
						local cast = BattleMainData.preGetRevivedCost()
	             		Logger.debug("will cast:%d,have silver:%d",cast,UserModel.getSilverNumber())
	             		if(cast <= UserModel.getSilverNumber()) then
	             			function doReviveCard(sender, eventType ) -- 确认按钮事件
								if (eventType == TOUCH_EVENT_ENDED) then
								    -- 请求复活
								    BattleDataProxy.requestReviveBench(targetData.id)
								    LayerManager.removeLayout() -- 关闭提示框
								end
							end -- function end

							function cancleReviveCard()
							end
							-- Logger.debug("show revive window:%d,%d",cast,UserModel.getSilverNumber())
        					ObjectTool.showTipWindow( BattleMainData.getRevivedInfo(),doReviveCard,cancleReviveCard)
        					-- self:setRawPostion(dropCard)
        					return 
	             		else
	             			-- print("not dead")
	             			function removeWindow(sender, eventType ) -- 确认按钮事件
								if (eventType == TOUCH_EVENT_ENDED) then
									 LayerManager.removeLayout() -- 关闭提示框
									 self.onPopUpState = false
								end
							end
	             			ObjectTool.showTipWindow( BATTLE_CONST.LABEL_3 ,removeWindow)
	             			return
	             		end
					end

				-- 替补开启复活
				elseif eventName == NotificationNames.EVT_UI_BENCH_ENABLE_REVIVE then
					BattleTouchMananger.enableTouch()
				-- 替补关闭复活
				elseif eventName == NotificationNames.EVT_UI_BENCH_DISABLE_REVIVE then


				-- 从dataCache中初始化
				elseif eventName == NotificationNames.EVT_UI_BENCH_INI_FROM_DATACACHE then
					local benchesInfo = DataCache.getBench()
					local heros = {}
					if(benchesInfo ~= nil) then
						-- print("--- getBench")
						-- print_table("bench",benchesInfo)
						for position,hid in pairs(benchesInfo or {}) do
							print(position,hid)
							if(tonumber(hid) > 0) then
								local hero = HeroModel.getHeroByHid(hid)
								assert(hero,"未发现替补英雄 hid:" .. tostring(hid))
								local display = BattleDataUtil.getBenchDisplayDataFromHeroModel(hero,position)
								table.insert(heros,display)
								-- print("~~~~~ herodata")
								-- print_table("hero",hero)
								-- .level: "1"
 							-- 	.htid: "10094"
 							-- 	.soul: "0"
 							-- 	.evolve_level: "0"
 							-- 	.hid: "10067077"
							end
						end
					end

					if(#heros > 0) then
						table.sort(heros,function(a,b) 
														
														-- print_table("b",b)
														if(a and b) then
															return tonumber(a.pos) < tonumber(b.pos)
														end end) --从大到小排序

						-- print("--- heroes:")
						-- print_table("heros",heros)
						self.team1DisplayData = heros
						self.team1HasBench = true
						if(self.team1InfoUI) then
							self.team1InfoUI:setVisible(true)
							self.team1InfoUI:setListData(self.team1DisplayData)
						end
					end
					if(self.team1InfoUI) then
							self.team1InfoUI:setVisible(false)
					end

					if(self.team2InfoUI) then
							self.team2InfoUI:setVisible(false)
					end

					self:refreshBenchAliveNum()
				-- 设置替补列表数据
				elseif eventName == NotificationNames.EVT_UI_BENCH_INI_FROM_BATTLE_STRING then

					local adt = BattleMainData.fightRecord
					if( 
						adt and 
					  	adt.team1Info and 
					  	adt.team1Info:hasBench() == true
					  ) then
						self.team1DisplayData = adt.team1Info:getBenchsList()
						self.team1HasBench = true
						-- Logger.debug("team1 don't have bench1")
						if(self.team1InfoUI) then
							-- Logger.debug("team1 don't have bench2" .. tostring(#self.team1DisplayData))
							self.team1InfoUI:setVisible(true)
							self.team1InfoUI:setListData(self.team1DisplayData)
						end
					else
						-- Logger.debug("team1 don't have bench")
						self.team1HasBench = false
						if(self.team1InfoUI) then
							self.team1InfoUI:setVisible(false)
						end
					end

					if( 
						adt and 
					  	adt.team2Info and 
					  	adt.team2Info:hasBench() == true
					  ) then
						self.team2DisplayData = adt.team2Info:getBenchsList()

						self.team2HasBench = true
						if(self.team2InfoUI) then
							self.team2InfoUI:setVisible(true)
							self.team2InfoUI:setListData(self.team2DisplayData)
						end
					else
						self.team2HasBench = false
						if(self.team2InfoUI) then
							self.team2InfoUI:setVisible(false)
						end
					end
					self:refreshBenchAliveNum()
				end -- if end
			
			end -- if end

	end-- function end

return BattleBenchInfoMediator
