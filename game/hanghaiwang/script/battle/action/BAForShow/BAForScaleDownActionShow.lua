
 -- 落下动作出现
local BAForScaleDownActionShow = class("BAForScaleDownActionShow",require(BATTLE_CLASS_NAME.BaseAction))

BAForScaleDownActionShow.count = 0
BAForScaleDownActionShow.total = 0

function BAForScaleDownActionShow:start( ... )
	Logger.debug("BAForScaleDownActionShow:complete0")
	if(self.data) then


		local playersDataList = BattleTeamDisplayModule.getPlayerDisplayByPositionList(self.data)
		if(playersDataList and #playersDataList > 0) then
			
			self.total = #playersDataList
			local onXMLComplete = function( ... )
			Logger.debug("BAForScaleDownActionShow:complete1")
				self.count = self.count + 1
				if(self.count >= self.total and not self.disposed) then
					self:complete()
					Logger.debug("BAForScaleDownActionShow:complete2")
				end
			end

			for k,displayData in pairs(playersDataList) do
				displayData:setVisible(true)
				displayData:playXMLAnimationWithCallBack( "xialuo",self,onXMLComplete,false)
			end

		 	local shakeScreen = require("script/battle/action/BAForShakeScreen").new()
		 	shakeScreen.total = 0.4
		 	shakeScreen:start()
		else
			self:complete()	
		end
	else
		self:complete()	
	end
	
end





return BAForScaleDownActionShow