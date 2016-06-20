 -- buff添加
require (BATTLE_CLASS_NAME.class)
local BSBuffAddBB = class("BSBuffAddBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
 

 		------------------ properties ----------------------
 		BSBuffAddBB.addEffectName 				= nil -- 添加buff特效
 		BSBuffAddBB.addPostion 					= nil -- 添加特效挂点
 		BSBuffAddBB.buffid 						= nil -- buffid
 		BSBuffAddBB.hasAddBuffEff 				= nil -- 是否有添加特效
 		BSBuffAddBB.needAddIcon 				= nil -- 是否需要添加
 		BSBuffAddBB.iconName					= nil -- 图标名字
 		BSBuffAddBB.heroUI						= nil -- 目标
 		BSBuffAddBB.targetId 					= nil -- 目标id
 		BSBuffAddBB.addSound					= nil -- 添加特效声音
 		BSBuffAddBB.addTip						= nil -- 添加提示图片名
 		BSBuffAddBB.hasAddBuffTip				= false -- 是否有添加提示
 		BSBuffAddBB.des							= "BSBuffAddBB"
 		------------------ functions -----------------------
 		
		function BSBuffAddBB:reset( id,targetId )
 
			self.bufffId 			= id												-- buff数据 		外部数据
			self.targetid 			= targetId

			local target 			= BattleMainData.fightRecord:getTargetData(targetId)
			self.heroUI 			= target.displayData 	
			self.target 			= target			 			-- 目标
			--buff图标
			self.iconName			= db_buff_util.getIcon(id)	 -- 来自buffid			-- buff图标名			
			--print("BuffAddLogic get buff icon:",self.iconName)
			-- for k,buffid in pairs(data or {}) do
			-- 	if(buffid)then
			-- 	end
			-- end
			-- 有添加特效
			self.addEffectName 		= db_buff_util.getAddEffectName(id) 				-- 添加特效 		来自buffid 			
			

		 	self.addPostion 		= db_buff_util.getAddPostion(id) 				-- buff图标挂点 	来自buffid
			--print("BuffAddLogic get buff add postion:",self.addPostion)
		 	-- 有添加icon(因为icon可能会被重复添加,所以需要检测是否需要显示类)
		 	-- local buffCount 		= target:getBuffCount(id)
		 	self.needAddIcon  		= self.iconName ~=nil			-- 是否需要添加icon 1.有图标 2.buff的count == 1
		 	-- 有添加特效
		 	self.hasAddBuffEff 		= self.addEffectName ~= nil 						-- 是否有添加buff特效	
		 	
		 	self.addSound 			= db_buff_util.getAddSound(id)
		 	-- 获取buff添加文字图片
		 	self.addTip				= db_buff_util.getAddTip(id)

		 	self.hasAddBuffTip 		= self.addTip ~= nil and self.addTip ~= ""
		 	
		 	Logger.debug("BuffAddLogic get buff  addEffectName:" .. tostring(addEffectName) .. " hasAddBuffEff:" .. tostring(self.hasAddBuffEff) .. " addTip:" .. tostring(self.addTip) .. " hasAddTip:".. tostring(self.hasAddBuffTip))
			
 
		end
 
		
return BSBuffAddBB