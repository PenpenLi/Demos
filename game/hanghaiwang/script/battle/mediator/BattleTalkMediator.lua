-- battle对话



local BattleTalkMediator 					= class("BattleTalkMediator")
 
 
	------------------ properties ----------------------
	BattleTalkMediator.name 					= "BattleTalkMediator"
	BattleTalkMediator.state 					= nil
	BattleTalkMediator.talksChangeBackGround	= nil	-- 对话换背景
	BattleTalkMediator.talkChangeMusic			= nil   -- 对话换音乐
	BattleTalkMediator.talkId 					= nil
	BattleTalkMediator.disposed 				= nil
	------------------ const ----------------------
 	BattleTalkMediator.STATE_IDLE 				= 1
 	BattleTalkMediator.STATE_TALK 				= 2
 	BattleTalkMediator.STATE_TALK_CHANGE_BG 	= 3
 	-- BattleTalkMediator.STATE_TALK_CHANGE_MUSIC				= 2
	------------------ functions -----------------------
	function BattleTalkMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					NotificationNames.EVT_TALK_PLAY_TALK,
					-- NotificationNames.EVT_TALK_PLAY_TALK_COMPLETE,
					NotificationNames.EVT_TALK_SET_TALK_BG,
					NotificationNames.EVT_TALK_SET_TALK_MUSIC,
					NotificationNames.EVT_TALK_REQUEST_CHANGE_BG_END
					-- NotificationNames.EVT_TALK_REQUEST_CHANGE_MUSIC_END 声音立即设置了 不需要异步
				}
	end -- function end

	function BattleTalkMediator:onRegest( ... )
		-- --print()
		--print("BattleTalkMediator onRegest")
		self.state = self.STATE_IDLE
		ObjectTool.setProperties(self)
		self.disposed = false
		Logger.debug("!!!! BattleTalkMediator:onRemove")
		--print("BattleTalkMediator:onRegest:",self.instanceName())
		-- self.talkId = self.STATE_IDLE
	end -- function end

	function BattleTalkMediator:onRemove( ... )
 		self.state = self.STATE_IDLE
 		self.disposed = true
 		--print("BattleTalkMediator:onRemove:",self.instanceName())
	end -- function end

	function BattleTalkMediator:getHandler()
		return self.handleNotifications
	end


	function BattleTalkMediator:handleNotifications(eventName,data)
		--local  ins = require("script/notification/NotificationNames")
		-- --print("StrongHoldMediator handleNotifications call:",eventName,"data:",data)
		if eventName ~= nil then



			-- 执行对话
			if eventName == NotificationNames.EVT_TALK_PLAY_TALK then

					if(self.STATE_IDLE == self.state) then
						--print("BattleTalkMediator:播放对话",tonumber(data))
						self.talkId = tonumber(data)
	 					self:playTalk(self.talkId)
					else
						--print("self.state:",self.state)
						error("BattleTalkMediator 正在执行")
					end -- if end

			-- 设置对话换背景数据
			elseif eventName == NotificationNames.EVT_TALK_SET_TALK_BG then
					self.talksChangeBackGround = data

			-- 设置对话换声音数据[todo]
			elseif eventName == NotificationNames.EVT_TALK_SET_TALK_MUSIC then
					self.talkChangeMusic = data


			-- 对话引起的背景改变完成了
			elseif eventName == NotificationNames.EVT_TALK_REQUEST_CHANGE_BG_END then
					self.state = self.STATE_IDLE
					EventBus.sendNotification(NotificationNames.EVT_TALK_PLAY_TALK_COMPLETE)
			end -- if end

		end -- ifend
	end

	function BattleTalkMediator:playTalk( talkId )
			  -- 结算面板出现时,删除调过按钮和加速按钮
	          EventBus.sendNotification(NotificationNames.EVT_UI_REMOVE_SKIP_BT)  
	          EventBus.sendNotification(NotificationNames.EVT_UI_REMOVE_SPEED_BT) 

				self.state = self.STATE_TALK
		 		-- require "script/module/talk/TalkCtrl"
		        TalkCtrl.create(talkId)
		        TalkCtrl.setCallbackFunction(function( ... )
		        	if(self.disposed~= true) then
		        		  self:onTalkComplete(talkId)

		        		  if(BattleMainData.canSpeedUp == true) then
							  -- 显示变速按钮
					          EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SPEED_BT)
					      end

				          if(BattleMainData.canJumpBattle == true) then
					          -- 显示调过战斗按钮
					          EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SKIP_BT)
					      end
				     end
		        
		        end)
	end

	function BattleTalkMediator:onTalkComplete(talkid)
		if(self.talksChangeBackGround ~= nil and 
		   self.talksChangeBackGround[talkid] ~= nil) then
		   self.state = self.STATE_TALK_CHANGE_BG
		   --print("有对话事件!!!",talkid,self.talksChangeBackGround[talkid])
			-- 发送改变事件
			EventBus.sendNotification(NotificationNames.EVT_TALK_REQUEST_CHANGE_BG,self.talksChangeBackGround[talkid])
		else
			self.state = self.STATE_IDLE
			EventBus.sendNotification(NotificationNames.EVT_TALK_PLAY_TALK_COMPLETE)
		end
		-- todo 背景声音改变 

	end
 return BattleTalkMediator