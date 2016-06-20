
-- 显示buff添加特效


local BAForShowAddBuffEffect = class("BAForShowAddBuffEffect",require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero))
 
	------------------ properties ----------------------
 
	------------------ functions -----------------------
 

	-- 运行函数
	function BAForShowAddBuffEffect:start(data)
		 -- 如果有对应的数据
		 if(self.blackBoard.heroUI~= nil and self.blackBoard.addEffectName ~= nil  ) then
		 	self.heroUI 		= self.blackBoard.heroUI
		 	self.animationName  = self.blackBoard.addEffectName
		 	-- 伤害位置
		 	self.atPostion 		= BATTLE_CONST.POS_MIDDLE--self.blackBoard.addPostion
		 	--print("BAForShowAddBuffEffect:start addbuff:",self.atPostion)
		 	self.super.start(self,data)
		 else -- 不用播放添加特效
		 	--print("BAForShowAddBuffEffect start -> complete")
		 	self:complete()
		 end
	end
return BAForShowAddBuffEffect