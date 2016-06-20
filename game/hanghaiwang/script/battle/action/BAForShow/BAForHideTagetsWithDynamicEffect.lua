



 -- 特效+英雄隐藏
local BAForHideTagetsWithDynamicEffect = class("BAForHideTagetsWithDynamicEffect",require(BATTLE_CLASS_NAME.BaseAction))

BAForHideTagetsWithDynamicEffect.showEffectName = nil -- 出现特效
BAForHideTagetsWithDynamicEffect.data 		   	 = nil -- 目标索引
BAForHideTagetsWithDynamicEffect.actions 		 = nil
BAForHideTagetsWithDynamicEffect.total			 = nil
BAForHideTagetsWithDynamicEffect.count 		 = nil
function BAForHideTagetsWithDynamicEffect:start( ... )
	if(self.data and #self.data > 1 and type(self.data[#self.data]) == "string") then
		
		self.actions 		= {}
		self.showEffectName = self.data[#self.data]
		table.remove(self.data,#self.data)

		local playersDataList = BattleTeamDisplayModule.getPlayerDisplayByPositionList(self.data,true)
		if(playersDataList and #playersDataList > 0) then
			-- self.runner = require(BATTLE_CLASS_NAME.)
			local showEffect = nil 
			self.count = 0
			self.total = #playersDataList
			for k,displayData in pairs(playersDataList) do
				displayData:setVisible(true)
				local animation =  require("script/battle/action/BAForPlayEffectAtHero").new()
					  animation.heroUI = displayData
					  -- animation.atPostion = BATTLE_CONST.POS_MIDDLE
					  animation.animationName = self.showEffectName
				-- self.animation.downTarget = true
				 	  animation:addCallBacker(self,self.onAllComplete)
				 	  animation:start()
				 	  table.insert(self.actions,animation)



			end
 			
		else
			self:complete()	
		end
	else
		self:complete()	
	end
	
end




function BAForHideTagetsWithDynamicEffect:onAllComplete( ... )
	self.count = self.count + 1
	if(self.count >= self.total) then


	 	local playersDataList = BattleTeamDisplayModule.getPlayerDisplayByPositionList(self.data,true)
		if(playersDataList and #playersDataList > 0) then


			local hideTargets = function ( ... )
				for k,displayData1 in pairs(playersDataList) do
					displayData1:setVisible(false)
				end
				self:complete()
			end
			local count = 0
			for k,displayData in pairs(playersDataList) do
				  count = count + 1
			 	  displayData:setVisible(true)
				  displayData:setOpacity(1)
				  local actionArray = CCArray:create()
	         	  actionArray:addObject(CCFadeOut:create(0.1))

	         	  if(count == #playersDataList) then
	 			  	actionArray:addObject(CCCallFunc:create(hideTargets))
	 			  end
	         	  
	         	  displayData.boneBinder:runAction(CCSequence:create(actionArray))
	        end


		end
	end
end

function BAForHideTagetsWithDynamicEffect:release( ... )
	 self.data = {}
	 if(self.actions and #self.actions > 0) then
	 	for k,v in pairs(self.actions) do
	 		v:release()
	 	end
	 	self.actions = nil
	 end
end



return BAForHideTagetsWithDynamicEffect


