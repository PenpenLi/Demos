require (BATTLE_CLASS_NAME.class)
local BattelEvtCallBacker = class("BattelEvtCallBacker")
 
	------------------ properties ----------------------
	
	BattelEvtCallBacker.completeCall				= nil --
	BattelEvtCallBacker.keyFrameCall				= nil --
	BattelEvtCallBacker.dispatcherName				= nil
	------------------ functions -----------------------


	function BattelEvtCallBacker:ctor()
		self.completeCall 							= require(BATTLE_CLASS_NAME.CallHandleArray).new()
		self.keyFrameCall 							= require(BATTLE_CLASS_NAME.CallHandleArray).new()
		ObjectTool.setProperties(self)
		-- --print("@@@@@@@@@@@@@@@@@@@@@@@@@  BattelEvtCallBacker:ctor->",self.completeCall,self.keyFrameCall)
	end
	--添加结束事件的回调（注意：回调1次后自动销毁）
	function BattelEvtCallBacker:addCallBacker(selfPointer,calller,callTime)
		local handle 								= require(BATTLE_CLASS_NAME.CallHandle).new()
		handle.selfPointer							= selfPointer

		handle.calller 								= calller
		if callTime == nil or tonumber(callTime) <= 0   then
			handle.leftTime								= 1
		else
			handle.leftTime								= tonumber(callTime)
		end
		----print("BattelEvtCallBacker:addCallBacker:",handle.selfPointer.name)
		self.completeCall:add(handle)

	end
	-- 添加关键帧回调（注意：回调1次后自动销毁）
	function BattelEvtCallBacker:runKeyFrameCallBack(target,data)
		 if self.keyFrameCall ~= nil then 
		 	self.keyFrameCall:runArray(target,data)
		 end
	end

	function BattelEvtCallBacker:toString()
		 self.completeCall:toString()
	end
	
	function BattelEvtCallBacker:clearAll()
		 self.completeCall:clearAll()
		 self.keyFrameCall:clearAll()
	end

	function BattelEvtCallBacker:runCompleteCallBack(target,data)
	-- --print("################################# BattelEvtCallBacker:runCompleteCall",data," 属于:",self.dispatcherName)
		 self.completeCall:runArray(target,data)
	end

	function BattelEvtCallBacker:runKeyFrameCall(data)
		 if self.keyFrameCall ~= nil then 
		 	self.keyFrameCall:runArray(target,data)
		 end
	end

 return BattelEvtCallBacker