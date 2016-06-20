-- 顶上战争
local BattleTopStaticBattleMediator = class("BattleTopStaticBattleMediator")
BattleTopStaticBattleMediator.name 					= "BattleTopStaticBattleMediator"
-- eJytVl1oXEUU3nv3dJObNUk3MUkbQklBMIFSkk3ahlgkbJaQllLDbinxqZndO5u97t296927sUEEr1FbsVT0pQqC2GDxoQ/qxiLFVloqCL70qQ/WJ0VQ8B9EqEI8M7M/cze5GwUf9rJnznxzzvnmfDPTEVY6U8RxTKrtVzrCSgT/k3SO2vD8/V8+jOg0Qws6WjfujXSStGNYBXj567Nh2yoXdFAGiG0nqBjXNIYHgbOrg6DUBz96SDIqsrHBDGZpNlmmsLm5+bfKlwEWNgQXjreD0qG1sSndeVLQrWcKQeZ7FIG9mEKc5BGoBdmEPp0bp1aLFPMTxmlilimsfVDgUXZz7AhiewTkYVD6Ye3jUck72uy9OiFS7AJFhQdfPSXqDMHlRZ6bVLuMDPbDbxNeCmTftwEvI7Lvu4NegmTfzytSMmxdYCmF4GI7TyZY9fHRJqi7/qyCm2zbs1nD1IXDu4bWILszVc5kqC1mRYRxTIfX0prD6B3SdOIQ3Lt64WzeoJg+hNP2wdBwzV1p7RY9IDGcqzM8tgPDD3r8Gf7e8mf4h2F/hn93vAxXGDu5EKwfbbCzhV7sk1+fU2quXJPrx6W6y2xy/bToKd2slx7n0Xb5lu6+dcK/PvelpLeIDR47BFd2N9pku3Tcz2ICWFMhLx1l3w5q80b8F3nX8qiteGGGLyi3azNp7qt7a1hxLMjSS22Tj4eAu7p/Z7jV02B76q72+feGe+1Jf/mpO8jvvScUZY+P7NRqY/lI5P8TWI3Khsamd6Lyy/4WVN5cbUHltYkWVN56RMrpL6/U5hqMbCc19/oeX62512d8xeZ+2uWvNrWl2t7OtKjz/IEtpdQFN9hoDHa/bE3qxT+6Ed1LikWbGCVihtqSyaSWWsbTNrAP1O58uWSkmaGlbEOHtXtLkbJtnmFGaP/UoUPRI9HU2OQRnUymopNhh5L8OLtPCyRPQ9r4WHS8rYww993DYZOuUBMeG3Ash5jzxVmr5MClN2YjRmnBJKvUDnbj5TBPbUt0Q1sWcYwLLetU/0WKVskQl/sUKHvpimWu0DNi3UA4T87OF+GVbwKRdBkfB+xCh176dNkoHitkLE1cPsmcYZr4v5dd+NzAS35APD2q5kyfTomTFVaApTLDey/Gv3EIYuw5CMyzUMdBPYGrncTfAlzsSaAST0mYCsdU4gB+mPW5BB7tMmaDYzbisMsPc2UwgScpw7CKYrSQzuJ4X8ZYzjpzlp2m8MLdLoXvRRRXjYaC44cZY/o0vH67eFR9XOsU0fAdE2OfOARqsd4Z9oS6nUjA+wv19PDxwgAjcb4BHHBpygO4cxABugQYZYDROKj/LgKqLcY+Es3nvljyIC6nEvj4kRA5hshJJJ/7c8GLmEbEmIQwGcKUKD7/eVOMk4iIM8RptBfhzU/wWv4Hk1Bfew==
-- armyid 1
-- eJyNVM9PE0EU7myfC9sKda1APHojHgitSPmxGFIJKQ0hhBLjDae7U7phu1u3uwgJUYFEOMDFP8DEcFCvhnjzYtSzJw7qyYM3Y2JISIwJvJldpCVUOexk33zzfd+8N/MmFidtRep5FlOSJBYnikvnGRweHv5RcZbqC8yFx19+flANVmK2gdHbPa2N6p7p2LCTjruObxtAuqjrzrBgWlG4UKJCbcN5YEdlZAyrbggCSeLSMVpBGyXKF3YYIphdrjLUCYI71PIZrO1PEb6iXWhol4BcDihXgHTC2ne1Dh05jX7LClSG358fnsJWfySIACUgwHFZpNgKGysxIBeVCyEWTNeTo53wywp1Eft4Ctt/FOiCAIV1Kzz5unSi+leyQSPcDK96A3UrL5jRZoms7Tp1iXDlkLjTHQPpH8TV16XmFZD+U4GDseYVOMg0q4B0ngo08rZGT7IQmzkjkad6nWF9+tGQyK/HGbzdWeQlabXqUrNGLbmlUCgoxfkJAyKKx6+ilKj4NVMXE0XXNGB9j6q+a83xQL7WZwymbmQMmrmpD/ZnSsW4x2glxRvIphUmK6nedKrFR9rq8/64xRaZBcNdnuNRK1e97dQ8lCupZm3aosvMjSawJ3LMdYIStZSRx9NRyl74p1admhn0Ty+Qq2zRsRbZXKAbiVfoUq4K22/uqbqPfcg7GJLsvm9WJ+ySoxCion5hwbQs/E/yDhcB9m9X0ORh2N1hMOqVgyjCtzIgzmNIjBoAet+CyCi3ygKModo4fjm8qHk8rUnkcKcss/UyzneUzPmyN+64Ovbyp3YiapRG1etyNN0DUi8Yadh8drdP6g/ejAH+VAzxQYPIsdeL1ixIJ1bvZvLwcnryeHv4LnCCponCnEV434MEo44wwgkjGvc/jwNeniE+1KW/8Wq0gbEp57FzOGMK42nYXl8h5Agwdk+t
-- armyid 2

function BattleTopStaticBattleMediator:getInterests( ... )

		return {	
					NotificationNames.EVT_SINGLE_BATTLE_INI,					-- 初始化
					NotificationNames.EVT_PLAY_RECORD_COMPLETE, 				-- 单场战斗完成
		            -- NotificationNames.EVT_CLOSE_RESULT_WINDOW,				-- 特殊战斗不弹结算
		            NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE,		 	-- 战斗动画播放完毕
	                -- NotificationNames.EVT_REPLAY_RECORD,						-- 特殊战斗不重播
	                NotificationNames.EVT_TEAM_SHOW_COMPLETE,           		-- 出场动画完成
	                NotificationNames.EVT_TEAM_ENDSHOW_COMPLETE,         		-- 退场特效完毕
	                NotificationNames.EVT_SINGLE_BATTLE_CHANGE_SCENE_COMPLETE
		 		} 
	end
	 

 
	function BattleTopStaticBattleMediator:handleNotifications(eventName,data)
		if eventName ~= nil then
			-- 初始化单场战斗
			if eventName == NotificationNames.EVT_SINGLE_BATTLE_INI then
				  self.armyid = tonumber(data)
				  -- print("--- BattleTopStaticBattleMediator:handleNotifications ini")
				  -- self.armyid = tonumber(data[1])
		          EventBus.regestMediator(require("script/battle/mediator/BattleBackGroundMediator"))     
		          EventBus.regestMediator(require("script/battle/mediator/BattleRecordPlayMediator"))
		          -- EventBus.regestMediator(require("script/battle/mediator/BattleResultWindowMediator"))
		          -- EventBus.regestMediator(require("script/battle/mediator/BattleFormationMediator"))
		          -- EventBus.regestMediator(require("script/battle/mediator/StrongHoldMediator"))
		          EventBus.regestMediator(require("script/battle/mediator/BattleTeamShowMediator"))
		          EventBus.regestMediator(require("script/battle/mediator/BattleInfoUIMediator"))
		          EventBus.regestMediator(require("script/battle/mediator/BattleChangeSceneShowMediator"))
		          EventBus.regestMediator(require("script/battle/mediator/BattleTouchScreenShowNameMediator"))
		          -- EventBus.regestMediator(require("script/battle/mediator/BattleBenchInfoMediator"))
		          
		          -- EventBus.regestMediator(require("script/battle/mediator/BattleTalkMediator"))
		          -- 初始化屏幕参数
		          BattleMainData.iniScreenParameter()       
							-- 动作渲染开始
		          BattleActionRender.start()
		           
		          

		          EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_TOPSHOW_CHANGE_SCENE_START)
 
			-- 转场结束
	        elseif eventName == NotificationNames.EVT_SINGLE_BATTLE_CHANGE_SCENE_COMPLETE then
          			-- 创建队伍人员显示
          			BattleTeamDisplayModule.createHeroDisplayToMainData()
	        		-- 链接战斗数据的display
          			BattleMainData.linkAndRefreshHeroesDisplay()

	        		EventBus.sendNotification(NotificationNames.EVT_TEAM_SHOW_START,self.armyid)
			         
			-- 战斗前动画逻辑
	        elseif eventName == NotificationNames.EVT_TEAM_SHOW_COMPLETE then
	        		
	        	 -- 显示变速按钮
			          -- EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SPEED_BT)
			          -- 显示调过战斗按钮
			          EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SKIP_BT)
			          -- 显示替补ui
			          -- EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_ADD)
			          -- EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_INI_FROM_BATTLE_STRING)
			          -- battling show
			          local roundLogic        = nil
                        if(self.armyid) then
                          local has  = db_battlingShow_util.hasArmyLogic(self.armyid)
                          if(has) then
                            roundLogic = db_battlingShow_util.getItemByid(self.armyid)
                          end
                        end
                       -- print("--- topshow roundLogic:",self.armyid,roundLogic)
			          
 						-- 应策划需求 3倍速
		           		local nextSpeed = BattleMainData.maxTimeSpeed()
	    		   		CCDirector:sharedDirector():getScheduler():setTimeScale(nextSpeed)
			            -- 播放战斗录像
			          EventBus.sendNotification(NotificationNames.EVT_PLAY_RECORD_START,roundLogic)



	        -- 战斗录像播放完毕
	        elseif eventName == NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE then
	           CCDirector:sharedDirector():getScheduler():setTimeScale(1)
			   -- 停止触屏显示名字功能
	           EventBus.sendNotification(NotificationNames.EVT_DISABLE_TOUCH_SHOW_NAME)
			   -- EventBus.sendNotification(NotificationNames.EVT_SHOW_RESULT_WINDOW)
			   -- 结算面板出现时,删除调过按钮和加速按钮
	           EventBus.sendNotification(NotificationNames.EVT_UI_REMOVE_SKIP_BT)  
	           EventBus.sendNotification(NotificationNames.EVT_UI_REMOVE_SPEED_BT) 

	           -- 播放退场逻辑
	           EventBus.sendNotification(NotificationNames.EVT_TEAM_ENDSHOW_START,self.armyid)

			-- 退场动画逻辑
			elseif eventName == NotificationNames.EVT_TEAM_ENDSHOW_COMPLETE then
	         
				   
 
					-- CCDirector:sharedDirector():getScheduler():setTimeScale(1)
					EventBus.removeMediator("BattleBackGroundMediator")
		        	BattleTeamDisplayModule.removeAll()


		        	  -- --print("结束退出战斗模块")
		              --print("############## StrongHoldMediator 结束退出战斗模块")
		             EventBus.removeMediator("BattleBackGroundMediator")
		             EventBus.removeMediator("BattleRecordPlayMediator")
		             EventBus.removeMediator("BattleResultWindowMediator")
		             EventBus.removeMediator("BattleFormationMediator")
		          
		             EventBus.removeMediator("BattleTeamShowMediator")
		             EventBus.removeMediator("BattleInfoUIMediator")
		             EventBus.removeMediator("BattleTalkMediator")
		              BattleTeamDisplayModule.removeAll()
		              BattleLayerManager.release()
		              SpriteFramesManager.release()
		              CCDirectorAnimationinterval:getInstance():resumeAnimationInterval()

		              -- BattleLayer.closeLayer() -- 移出战斗场景层, 老的战斗模块
		              BattleState.setPlaying(false)
		              -- BattleMainData.runCompleteCallBack()
		              local request = BattleMainData.getCallBackRequest()
		              require "script/module/switch/SwitchCtrl"
		              -- SwitchCtrl.postBattleNotification("END_BATTLE") -- 2014.11.24 应小周要求单场战斗不发
		              EventBus.removeMediator("BattleTopStaticBattleMediator")
		         
		             EventBus.release()
		             BattleActionRender.removeAll()
		             BattleMainData.releaseData()
		             AudioHelper.stopMusic()
		             BattleNodeFactory.release()
		             
		             CCTextureCache:sharedTextureCache():removeUnusedTextures()
		             -- print("---------dump---------")
		             -- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
		             BattleModule.destroy()
		             request()
				 
			end -- if end
		end -- if end
	end -- function end

	function BattleTopStaticBattleMediator:onRegest( ... )
 
	end -- function end

	function BattleTopStaticBattleMediator:onRemove( ... )
 		CCDirector:sharedDirector():getScheduler():setTimeScale(1)
	end


	function BattleTopStaticBattleMediator:getHandler()
		return self.handleNotifications
	end



return BattleTopStaticBattleMediator