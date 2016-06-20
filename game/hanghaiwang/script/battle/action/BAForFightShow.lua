-- 开场战斗专用出场特效
require (BATTLE_CLASS_NAME.class)
local BAForFightShow = class("BAForFightShow",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForFightShow.effect_1 			= nil
	BAForFightShow.effect_2 			= nil
	BAForFightShow.effect_3				= nil

	BAForFightShow.target 			 	= nil

	------------------ functions -----------------------
 	function BAForFightShow:start()
  		
	end


	 -- 播放三个组合的动画()
 	function BAForFightShow:playThreeAsOne( first,second,third )


 			local animation1 = ObjectTool.getAnimation(first,false)
 			-- 第一个动画的结束回调
 			local fnMovementCall1 = function ( sender, MovementEventType )
						 
					 	
					-- 如果是第一个动画播放完毕,我们继续播放第二个
			 		if (MovementEventType == EVT_COMPLETE) then 
			 				-- 删除前一个动画
							if(animation1 ~= nil and animation1:getParent() ~= nil and animation1:retainCount() > 0) then
								animation1:removeFromParentAndCleanup(true)
							end

							-- 播放第二个
							local animation2 = ObjectTool.getAnimation(second,false)
							-- 第二个的回调
							local fnMovementCall2 = function ( sender, MovementEventType )
								 
							 
								 		if (MovementEventType == EVT_COMPLETE) then 
												if(animation2 ~= nil and animation2:getParent() ~= nil and animation2:retainCount() > 0) then
													animation2:removeFromParentAndCleanup(true)
												end
										end

					 		end
					 		-- 第二个动画的关键帧
					 		local fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					 							 		 Logger.debug("fnFrameCall:" .. frameEventName)
							 							local animation3 = ObjectTool.getAnimation(third,false)
												  		local fnMovementCall3 = function ( sender, MovementEventType )

												  			if (MovementEventType == EVT_COMPLETE) then 
																	if(animation3 ~= nil and animation3:getParent() ~= nil and animation3:retainCount() > 0) then
																		animation3:removeFromParentAndCleanup(true)
																	end
															end

												  		end -- f end
												  		animation3:getAnimation():setMovementEventCallFunc(fnMovementCall3)
												end -- f end
					 		animation2:getAnimation():setMovementEventCallFunc(fnMovementCall2)
					 		animation2:getAnimation():setFrameEventCallFunc(fnFrameCall)
					end -- if end




			end -- f end
 
	 		animation1:getAnimation():setMovementEventCallFunc(fnMovementCall1)

 	end -- f end
return BAForFightShow