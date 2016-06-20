require (BATTLE_CLASS_NAME.class)
local BattleForEverCallBacker = class("BattleForEverCallBacker")
 
	------------------ properties ----------------------
	
	BattleForEverCallBacker.foreverCall				= nil --
 
 
	------------------ functions -----------------------


	function BattleForEverCallBacker:ctor()
		self.foreverCall 							= require(BATTLE_CLASS_NAME.CallHandleArray).new()
		ObjectTool.setProperties(self)
	end
	--添加结束事件的回调（注意：回调是永久性的,只有调用clearAll才会清除）
	function BattleForEverCallBacker:addCallBacker(selfPointer,calller)
		local handle 								= require(BATTLE_CLASS_NAME.CallForverHandle).new()
		handle.selfPointer							= selfPointer

		handle.calller 								= calller
		 
		self.foreverCall:add(handle)

	end
 
	function BattleForEverCallBacker:clearAll()
		 self.foreverCall:clearAll()
	end

	function BattleForEverCallBacker:runCompleteCallBack(target,data)
	-- --print("################################# BattelEvtCallBacker:runCompleteCall",data," 属于:",self.dispatcherName)
		 self.foreverCall:runArray(target,data)
	end
	function BattleForEverCallBacker:toString()
		 self.foreverCall:toString()
	end

 return BattleForEverCallBacker