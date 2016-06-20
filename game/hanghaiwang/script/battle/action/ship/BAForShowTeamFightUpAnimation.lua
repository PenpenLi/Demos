
-- 显示战斗力上升动画
require (BATTLE_CLASS_NAME.class)
local BAForShowTeamFightUpAnimation = class("BAForShowTeamFightUpAnimation",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BAForShowTeamFightUpAnimation.teamid						= nil
	BAForShowTeamFightUpAnimation.tips 							= nil
	------------------ functions -----------------------
	function BAForShowTeamFightUpAnimation:start(data)

		print("BAForShowTeamFightUpAnimation start")
		if(self.teamid ~= nil) then
			local dis = nil
			self.tips = {}
			-- 如果是队伍1
			if(self.teamid == BATTLE_CONST.TEAM1) then
				dis = BattleTeamDisplayModule.selfDisplayListByPostion
			else
				dis = BattleTeamDisplayModule.armyDisplayListByPostion
			end
			local count = 0
			for pIndex,display in pairs(dis or {}) do
				if(display and display.isDead ~= true) then
					local position = display:globalHeadPoint()
					local sp = CCSprite:create(BATTLE_CONST.FIGHT_UP_ICON)
					local oneCompleteCall = function( ... )
						if(self:isOK()) then
							self:complete()
						end
					end
					table.insert(self.tips,sp)
					BattleLayerManager.battleAnimationLayer:addChild(sp)
					local action = WordsAnimationManager.getFightUpAnimation(oneCompleteCall)
					sp:setPosition(position.x,position.y)
					sp:runAction(action)
					count = count + 1
				end
			end
			-- 如果没有显示对象 直接结束
			if(count == 0 ) then
				self:complete()
			end


		else
			self:complete()
		end

	end
	
	function BAForShowTeamFightUpAnimation:onActionsComplete(data)
		-- --print("function BAForShowTeamFightUpAnimation:onActionsComplete")
		BattleMainData.skillHandle = nil
		if(skillAction) then
			skillAction:release()
			skillAction = nil
		end
		self:complete()
	end
		-- 释放函数
	function BAForShowTeamFightUpAnimation:release(data)
		if(self.tips ~= nil) then
			for k,item in pairs(self.tips or {}) do
				ObjectTool.removeObject(item)
			end
			self.tips = nil
		end
		self.super.release(self)
		self.roundData = nil
		if(self.skillAction) then
			self.skillAction:release()
			skillAction = nil
		end
	end
return BAForShowTeamFightUpAnimation