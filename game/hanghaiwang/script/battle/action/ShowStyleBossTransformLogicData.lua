




--- stronghold中 boss变身

module("ShowStyleBossTransformLogicData",package.seeall)
 

function getLogicData()
return  {
			type=BATTLE_CONST.NODE_OR,
						des="move0",
						children={
								 	-- 隐藏 -> 敌方
					  				-- 隐藏 -> team1Show

					  				-- 多目标播放特效 -> 播放effect1 boss
					  				-- 多目标fadeIn 	-> boss
					  				-- 对话1
 


									-- 多目标播放特效 -> 播放effect1 小兵
					  				-- 多目标fadeIn 	-> 新出现队员 小兵

					  				-- 对话2

					  				-- 显示战斗场次
					  				
					  				-- 多目标播放特效 -> 新出现队员 team1Show
					  				-- 多目标fadeIn 	-> 新出现队员 team1Show


 
									-- 结束
								 }
		}
end -- function end