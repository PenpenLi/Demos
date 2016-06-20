

 -- 特效+英雄出现
local BAForHeroesEffectShow = class("BAForHeroesEffectShow",require(BATTLE_CLASS_NAME.BaseAction))

BAForHeroesEffectShow.showEffectName = nil -- 出现特效
BAForHeroesEffectShow.data 		   	 = nil -- 目标索引
BAForHeroesEffectShow.actions 		 = nil
BAForHeroesEffectShow.total			 = nil
BAForHeroesEffectShow.count 		 = nil
function BAForHeroesEffectShow:start( ... )
	if(self.data and self.showEffectName) then
		local playersDataList = BattleTeamDisplayModule.getPlayerDisplayByPositionList(self.data)
		if(playersDataList and #playersDataList > 0) then
			-- self.runner = require(BATTLE_CLASS_NAME.)
			local showEffect = nil 
			self.count = 0
			self.total = #playersDataList
			local delayFrame = 0
			for k,displayData in pairs(playersDataList) do

				displayData:setVisible(false)
				showEffect = require("script/battle/action/BAForSingleHeroShow").new()
			 	showEffect.targetUI = displayData
			 	showEffect.animationName = self.showEffectName
			 	showEffect:addCallBacker(self,self.onAllComplete)
			 	showEffect.delay = delayFrame
			 	showEffect:start()
			 	delayFrame = delayFrame + 2
			end
 			
		else
			self:complete()	
		end
	else
		self:complete()	
	end
	
end




function BAForHeroesEffectShow:onAllComplete( ... )
	 self.count = self.count + 1
	 if(self.count >= self.total) then
	 	 self:complete()
	 end
end

function BAForHeroesEffectShow:release( ... )
	 if(self.actions and #self.actions > 0) then
	 	for k,v in pairs(self.actions) do
	 		v:release()
	 	end
	 	self.actions = nil
	 end
end



return BAForHeroesEffectShow

