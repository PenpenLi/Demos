-- 播放技能名称

 local BAForShowSkillNameAction = class("BAForShowSkillNameAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForShowSkillNameAction.skillName 			= nil
	BAForShowSkillNameAction.targetUI			= nil
	BAForShowSkillNameAction.nameBg 			= nil
	------------------ functions -----------------------
	function BAForShowSkillNameAction:start( ... )
		
		if(self.targetUI and self.skillName and self.skillName ~= "nil" and self.skillName ~= "") then
			local postion = self.targetUI:globalCenterPoint()

			local onActionComplete = function ( ... )
				self:onAllActionComplete()
			end
			
			self.nameBg = CCSprite:create(BATTLE_CONST.SKILL_NAME_IMG)
	        self.nameBg:setAnchorPoint(CCP_HALF)
	        self.nameBg:setPosition(postion)

	        BattleLayerManager.battleAnimationLayer:addChild(self.nameBg)

	        local nameLabel = CCLabelTTF:create(self.skillName,g_sFontName,30)
	        nameLabel:setAnchorPoint(CCP_HALF)
	        nameLabel:setPosition(self.nameBg:getContentSize().width*0.5,self.nameBg:getContentSize().height*0.5)
	        self.nameBg:addChild(nameLabel)

	        local defenderActionArray = CCArray:create()
	        defenderActionArray:addObject(CCDelayTime:create(1.5))
	        --defenderActionArray:addObject(CCMoveBy:create(1,ccp(0,m_currentAttacker:getContentSize().height*m_currentAttacker:getScale()*0.5)))
	        defenderActionArray:addObject(CCCallFuncN:create(onActionComplete))
	        self.nameBg:runAction(CCSequence:create(defenderActionArray))

	 
		-- else			
			
		end
		self:complete()
		
	end

	function BAForShowSkillNameAction:onAllActionComplete( ... )
		--print("BAForShowSkillNameAction:oncompActionlete")
		if(self.nameBg) then
			-- local ani = tolua.cast(self.nameBg,"CCSprite")
			if(self.nameBg:getParent()) then
				self.nameBg:removeFromParentAndCleanup(true)
			end
			self.nameBg = nil
		end
 		-- self:complete()
	end
return BAForShowSkillNameAction
