-- 显示ship主船信息
require (BATTLE_CLASS_NAME.class)
local BAForShowShipInfo = class("BAForShowShipInfo",require(BATTLE_CLASS_NAME.BaseAction))
		
		BAForShowShipInfo.teamid  		= nil
		BAForShowShipInfo.shiInfoUI 		= nil
		BAForShowShipInfo.shipInfoAni 		= nil
 		BAForShowShipInfo.pos 				= nil
 		BAForShowShipInfo.icon 				= nil
 		BAForShowShipInfo.soundName 		= nil
 		BAForShowShipInfo.userColor 		= nil
 		function BAForShowShipInfo:start()
 			-- print("BAForShowShipInfo:start",self.teamid)
 			local shipData
 			-- local userColor 
 			if(self.teamid == BATTLE_CONST.TEAM1) then
 				if(BattleMainData.fightRecord and BattleMainData.fightRecord.team1Info and BattleMainData.fightRecord.team1Info.shipData) then
		 			shipData = BattleMainData.fightRecord.team1Info.shipData
		 			self.userColor = BattleMainData.fightRecord.team1Info.userColor
		 		end

 			else
 				if(BattleMainData.fightRecord and BattleMainData.fightRecord.team2Info and BattleMainData.fightRecord.team2Info.shipData) then
		 			shipData = BattleMainData.fightRecord.team2Info.shipData
		 			self.userColor = BattleMainData.fightRecord.team2Info.userColor
		 		end
 			end

 			if(shipData) then
 				self.icon = shipData.infoIcon
 				-- print("BAForShowShipInfo:start",2)	 
	 			if(self.teamid == BATTLE_CONST.TEAM1) then
					self.pos = BattleGridPostion.getPlayerPointByIndex(1)
				else
					self.pos = BattleGridPostion.getEnemyPointByIndex(1)
				end

	 			self.shipInfoAni = ObjectTool.getAnimation(BATTLE_CONST.SHIP_INFO_ANI,false)
	 			BattleLayerManager.shipLayer:addChild(self.shipInfoAni)

	 			local fnMovementCall = function ( sender, MovementEventType , frameEventName)
					if(MovementEventType == EVT_COMPLETE) then
						if(self:isOK()) then
							ObjectTool.removeObject(self.shipInfoAni)
							self.shipInfoAni = nil
							self:onShowAnimationComplete()
							
							if(self.soundName ~= nil and self.soundName ~= "") then
								BattleSoundMananger.removeSound(self.soundName)
							end
						end
					end
				end
				-- print("-- BAForShowShipInfo:playAnimation:",animationName)
				self.shipInfoAni:getAnimation():setMovementEventCallFunc(fnMovementCall)
				self.shipInfoAni:setPosition(self.pos)
				if(self.soundName ~= nil and self.soundName ~= "") then
                    BattleSoundMananger.removeSound(self.soundName)
                    BattleSoundMananger.playEffectSound(self.soundName,false)
                end

			else
				self:complete()
			end

			

 		end

 	function BAForShowShipInfo:release( ... )
		self.super.release(self)
		ObjectTool.removeObject(self.shipInfoAni)
		ObjectTool.removeObject(self.shiInfoUI)
		self.userColor = nil
		self.shipInfoAni = nil
		self.shiInfoUI = nil
	end

 		function BAForShowShipInfo:onShowAnimationComplete()
 			-- print("BAForShowShipInfo:start",3)
 			if(self:isOK()) then
 					-- print("BAForShowShipInfo:start",4)
		 			-- 加载ui
					self.shiInfoUI = g_fnLoadUI(BATTLE_CONST.SHIP_INFO_UI)
					BattleLayerManager.layout:addChild(self.shiInfoUI)
					local baseContainer = g_fnGetWidgetByName(self.shiInfoUI,"IMG_BG")
					if(baseContainer) then
						baseContainer:setPosition(self.pos)
						local ww = baseContainer:getContentSize().width
						local scale = g_winSize.width/ww
						-- print(" -= BAForShowShipInfo: ",ww,scale)
						baseContainer:setScale(scale)
					end
					local imgShip = g_fnGetWidgetByName(self.shiInfoUI,"IMG_SHIP")
					if(self.icon ~= nil) then
						-- print("== BAForShowShipInfo:start:",self.icon)
						imgShip:loadTexture(self.icon)
					end

		 			local imgXianshou = g_fnGetWidgetByName(self.shiInfoUI,"IMG_XIANSHOU")	
		 			local imgHoushou = g_fnGetWidgetByName(self.shiInfoUI,"IMG_HOUSHOU")	
		 			
		 			local labelPlayerName = g_fnGetWidgetByName(self.shiInfoUI,"TFD_PLAYER_NAME")	

		 			local labelHp 	  = g_fnGetWidgetByName(self.shiInfoUI,"TFD_HP_NUM")	
		 			local labelMogong = g_fnGetWidgetByName(self.shiInfoUI,"TFD_MAGIC_ATK_NUM")	
		 			local labelMofang = g_fnGetWidgetByName(self.shiInfoUI,"TFD_MAGIC_DEF_NUM")	
		 			local labelWugong = g_fnGetWidgetByName(self.shiInfoUI,"TFD_PHY_ATK_NUM")	
		 			local labelWufang = g_fnGetWidgetByName(self.shiInfoUI,"TFD_PHYSIC_DEF_NUM")

		 			local labelHpName 	  = g_fnGetWidgetByName(self.shiInfoUI,"TFD_HP")	
		 			local labelMogongName = g_fnGetWidgetByName(self.shiInfoUI,"TFD_MAGIC_ATK")	
		 			local labelMofangName = g_fnGetWidgetByName(self.shiInfoUI,"TFD_MAGIC_DEF")	
		 			local labelWugongName = g_fnGetWidgetByName(self.shiInfoUI,"TFD_PHYSIC_ATK")	
		 			local labelWufangName = g_fnGetWidgetByName(self.shiInfoUI,"TFD_PHYSIC_DEF")

		 			local color = ccc3(0,18,63)
		 			local size  = 2
		 			UIHelper.labelNewStroke(labelHp,color,size)
		 			UIHelper.labelNewStroke(labelMogong,color,size)
		 			UIHelper.labelNewStroke(labelMofang,color,size)
		 			UIHelper.labelNewStroke(labelWugong,color,size)
		 			UIHelper.labelNewStroke(labelWufang,color,size)
		 			UIHelper.labelNewStroke(labelPlayerName,color,size)
		 			
					UIHelper.labelNewStroke(labelHpName,color,size)
		 			UIHelper.labelNewStroke(labelMogongName,color,size)
		 			UIHelper.labelNewStroke(labelMofangName,color,size)
		 			UIHelper.labelNewStroke(labelWugongName,color,size)
		 			UIHelper.labelNewStroke(labelWufangName,color,size)

		 			labelPlayerName:setColor(self.userColor or ccc3(255,255,255))

		 			-- UIHelper.labelNewStroke(labelHp,ccc3(0,0,0),2)
		 			-- UIHelper.labelNewStroke(labelMogong,ccc3(0,0x12,0x3f),2)
		 			-- UIHelper.labelNewStroke(labelMofang,ccc3(0,0,0),2)
		 			-- UIHelper.labelNewStroke(labelWugong,ccc3(0,0,0),2)
		 			-- UIHelper.labelNewStroke(labelWufang,ccc3(0,0,0),2)

		 			assert(baseContainer,BATTLE_CONST.SHIP_INFO_UI .. "IMG_BG 不存在")
		 			assert(imgShip,BATTLE_CONST.SHIP_INFO_UI .. "IMG_SHIP 不存在")
		 			assert(imgXianshou,BATTLE_CONST.SHIP_INFO_UI .. "IMG_XIANSHOU 不存在")
		 			assert(imgHoushou,BATTLE_CONST.SHIP_INFO_UI .. "IMG_HOUSHOU 不存在")
		 			assert(labelPlayerName,BATTLE_CONST.SHIP_INFO_UI .. "TFD_PLAYER_NAME 不存在")

		 			assert(labelHp,BATTLE_CONST.SHIP_INFO_UI .. "TFD_HP_NUM 不存在")
		 			assert(labelMogong,BATTLE_CONST.SHIP_INFO_UI .. "TFD_MAGIC_ATK_NUM 不存在")
		 			assert(labelMofang,BATTLE_CONST.SHIP_INFO_UI .. "TFD_MAGIC_DEF_NUM 不存在")
		 			assert(labelWugong,BATTLE_CONST.SHIP_INFO_UI .. "TFD_PHY_ATK_NUM 不存在")
		 			assert(labelWufang,BATTLE_CONST.SHIP_INFO_UI .. "TFD_PHYSIC_DEF_NUM 不存在")
		 			local shipData
		 			-- 设置队伍名称,先手
		 			if(self.teamid == BATTLE_CONST.TEAM1) then
		 				imgHoushou:setVisible(false)
		 				imgXianshou:setVisible(true)
		 				local teamName = ""
		 				if(BattleMainData.fightRecord and BattleMainData.fightRecord.team1Info and BattleMainData.fightRecord.team1Info.teamName) then
		 					teamName = BattleMainData.fightRecord.team1Info.teamName
		 				end

		 				if(BattleMainData.fightRecord and BattleMainData.fightRecord.team1Info and BattleMainData.fightRecord.team1Info.shipData) then
		 					shipData = BattleMainData.fightRecord.team1Info.shipData
		 				end
		 				
		 				labelPlayerName:setText(teamName)
		 			else
		 				imgHoushou:setVisible(true)
		 				imgXianshou:setVisible(false)

		 				local teamName = ""
		 				if(BattleMainData.fightRecord and BattleMainData.fightRecord.team2Info and BattleMainData.fightRecord.team2Info.teamName) then
		 					teamName = BattleMainData.fightRecord.team2Info.teamName
		 				end
		 				if(BattleMainData.fightRecord and BattleMainData.fightRecord.team2Info and BattleMainData.fightRecord.team2Info.shipData) then
		 					shipData = BattleMainData.fightRecord.team2Info.shipData
		 				end
		 				labelPlayerName:setText(teamName)
		 			end
		 			-- print("=== shipData:",shipData)
		 			-- 设置具体属性
		 			if(shipData and shipData.shipProperty) then
		 				labelHp:setText(shipData.shipProperty.HP)
		 				labelMogong:setText(shipData.shipProperty.MAGIC_ATK)
		 				labelMofang:setText(shipData.shipProperty.MAGIC_DEF)
		 				labelWugong:setText(shipData.shipProperty.PHY_ATK)
		 				labelWufang:setText(shipData.shipProperty.PHY_DEF)
		 			else
		 				labelHp:setText("")
		 				labelMogong:setText("")
		 				labelMofang:setText("")
		 				labelWugong:setText("")
		 				labelWufang:setText("")
		 			end



		 			local onUIShowComplete = function ( ... )
		 				-- print("BAForShowShipInfo:start",5)
		 				self:complete()
		 			end

					local damageActionArray = CCArray:create()
		         	 damageActionArray:addObject(CCDelayTime:create(2))
		         	 damageActionArray:addObject(CCCallFuncN:create(onUIShowComplete))

		         	 self.shiInfoUI:runAction(CCSequence:create(damageActionArray))
		    -- else
		    end

 		end


 return BAForShowShipInfo