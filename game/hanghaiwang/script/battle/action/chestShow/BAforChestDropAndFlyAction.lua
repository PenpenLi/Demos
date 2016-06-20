
-- 用于 BSTree(行为选择树) 内部结束回调的节点
-- blackBoard.treeComplete 为回调函数
require (BATTLE_CLASS_NAME.class)
local BAforChestDropAndFlyAction = class("BAforChestDropAndFlyAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAforChestDropAndFlyAction.target 				= nil
	BAforChestDropAndFlyAction.chestDataes 			= nil
	-- BAforChestDropAndFlyAction.chestNum				= nil
	BAforChestDropAndFlyAction.icons				= nil
	BAforChestDropAndFlyAction.unloadData 			= nil
	BAforChestDropAndFlyAction.count 				= nil
	-- BAforChestDropAndFlyAction.			= nil
	------------------ functions -----------------------
 	-- function BAforChestDropAndFlyAction:get( ... )
 	-- end
 	function BAforChestDropAndFlyAction:start()
 		
 		if(not self:isOK() or self.target == nil or self.target.container == nil) then 
 			self:complete()
 			self:release()
 			return 
 		end

 		self.icons = {}
 		self.unloadData = false
 		self.count = 0
 		if(#self.chestDataes > 0 and self.target) then
	 		local itemNum = #self.chestDataes
	 		local itemCounter  = 0
	 		local space = 20
	 		local xStart = -itemNum * space/2
	 		local rowXStart = 0
	 		local rowYStart = 0
	 		local cardSpace = 17
	 		for k,itemData in pairs(self.chestDataes or {}) do
	 			 
	 			-- Logger.debug("=== chest progress:%d",itemCounter)
		 		-- 生成掉落物品图标
		 		local icon = itemData:getSprite() --CCSprite:create(itemData.iconURL)
		 		-- 起始位置
		 		local startPosition = self.target:globalCenterPoint()
	 			icon:setPosition(startPosition)
	 			BattleLayerManager.battleUILayer:addChild(icon)

				-- 物品掉落动画
					
				
				-- 物品飞动画
					-- 计算飞行前延迟
					local delayTime = 0.8 + 10 * itemCounter * BATTLE_CONST.FRAME_TIME
				local lineIndex = itemCounter%3
				local rowIndex = math.floor(itemCounter/3)
				local px = 0

				 -- = (rowIndex + 1) * BATTLE_CONST.DROP_ITEM_SIZE/3
				if(lineIndex == 0) then

					if(rowIndex == 0) then
						rowYStart = startPosition.y - BATTLE_CONST.DROP_ITEM_SIZE
					else
						rowYStart = rowYStart - 16--BATTLE_CONST.DROP_ITEM_SIZE/2
					end


					if(rowIndex%2 == 1) then
						rowXStart = startPosition.x - cardSpace - BATTLE_CONST.DROP_ITEM_SIZE
						-- dxdy.x = startPosition.x - 20	
					else
						rowXStart = startPosition.x - cardSpace  * 2 - BATTLE_CONST.DROP_ITEM_SIZE  
						-- dxdy.x = startPosition.x - 40
					end
					-- rowYStart = rowXStart
				elseif(lineIndex == 1) then
					rowXStart = startPosition.x
				elseif(lineIndex == 2) then
					rowXStart = rowXStart + cardSpace + BATTLE_CONST.DROP_ITEM_SIZE
				end

				-- local dxdy = ccp(rowXStart + lineIndex * space,0)

				-- 计算最终位置
				local toPostion = ccp(rowXStart,rowYStart)

				local bezier    	  =ccBezierConfig:new()
				-- math.randomseed(os.time())
			    bezier.controlPoint_1 = ccp(startPosition.x + (rowXStart - startPosition.x)/3, toPostion.y + 200)
			    bezier.controlPoint_2 = ccp(startPosition.x + (rowXStart - startPosition.x)/3 * 2, toPostion.y - 25)
			    bezier.endPosition    = toPostion
			    local bezierTo 		  = CCBezierTo:create(0.3 ,bezier)


				-- 掉落 + 飞行
				local actionArray = CCArray:create()
	            actionArray:addObject(bezierTo)
	            -- actionArray:addObject(CCMoveBy:create(5 * BATTLE_CONST.FRAME_TIME,toPostion))
	            if(delayTime > 0) then
	            	-- actionArray:addObject(CCMoveTo:create(5 * BATTLE_CONST.FRAME_TIME,toPostion))
	            	-- actionArray:addObject(CCDelayTime:create(60 * BATTLE_CONST.FRAME_TIME))

	            	local ani 

					actionArray:addObject(CCCallFuncN:create(function ( ... )
	            		ani = ObjectTool.getAnimation("flash_item")
						ani:getAnimation():playWithIndex(0,0,-1,1)
						BattleLayerManager.addNode("flash_item",ani)
						ani:setPosition(toPostion)





	            	end))

	            	actionArray:addObject(CCDelayTime:create(delayTime))
	            	actionArray:addObject(CCCallFuncN:create(function ( ... )
	            		ObjectTool.removeObject(ani)
	            	end))
	            
	            end

				local particle 

	            	
	            local inOneTime = CCArray:create()
	            -- inOneTime:addObject(CCMoveTo:create(20 * BATTLE_CONST.FRAME_TIME,itemData:getToPosition()))
	            inOneTime:addObject(CCScaleTo:create(20 * BATTLE_CONST.FRAME_TIME,0.5))
	            inOneTime:addObject(CCMoveTo:create(20 * BATTLE_CONST.FRAME_TIME,itemData:getToPosition()))
	            inOneTime:addObject(CCCallFuncN:create(function( ... )
	            	particle= ObjectTool.getParticle(BATTLE_CONST.BATTLE_DROP_ITEM_PARTICLE)
		       	
			       	if(particle) then
						particle:setAnchorPoint(ccp(0.5, 0.5))
						BattleLayerManager.battleUILayer:addChild(particle)
						particle:setPosition(toPostion.x - 30,toPostion.y + 50)
						local particleAction = CCArray:create()
						particleAction:addObject(CCMoveTo:create(20 * BATTLE_CONST.FRAME_TIME,itemData:getToPosition()))
						particleAction:addObject(CCCallFuncN:create(function( ... )
							ObjectTool.removeObject(particle)
						 end
						))
						particle:runAction(CCSequence:create(particleAction))
					else
						ObjectTool.removeObject(particle)
					end
	            end))
	            actionArray:addObject(
                                    -- CCSpawn:createWithTwoActions( ,)
                                    CCSpawn:create(inOneTime)
                              )

            	-- actionArray:addObject()

            	-- if(itemCounter == itemNum) then
            	-- 结束发送更新事件
				local sendUPdateEvt = function ( ... )
					-- 如果没有被释放 则发送更新ui数据
					if(self:isOK() and self.unloadData ~= true) then
						Logger.debug("=== chest send event")
						EventBus.sendNotification(NotificationNames.EVT_UI_REFRESH_CHEST_DATA,itemData)
					end
					-- 删除
					ObjectTool.removeObject(icon)
					-- 增加
					self.count = self.count + 1
					Logger.debug("=== chest total:%d , current:%d",itemNum,self.count)
					if(self.count >= itemNum) then
						self:complete()
						self:release()
						BattleSoundMananger.removeSound(BATTLE_CONST.BATTLE_DROP_SOUND)
					end
				end
					

	            actionArray:addObject(CCCallFuncN:create(sendUPdateEvt))
            	-- end
            	-- 插入到icons
				table.insert(self.icons,icon)

 				-- 开始执行移动
            	icon:runAction(CCSequence:create(actionArray))

            	
            	
				itemCounter = itemCounter + 1
				
			end -- for end
			BattleSoundMananger.playDropItemEffect()
		-- AudioHelper.playTansuo02()
		else
			self:complete()
			self:release()
		end
	end

	function BAforChestDropAndFlyAction:release()
		for k,icon in pairs(self.icons or {}) do
			ObjectTool.removeObject(icon)
		end
		self.icons 			= {}
		self.chestDataes 	= {}
		self.target 		= nil
	end


return BAforChestDropAndFlyAction