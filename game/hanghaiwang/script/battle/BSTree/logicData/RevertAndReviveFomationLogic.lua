
module("RevertAndReviveFomationLogic",package.seeall)


function getLogicData( ... )
	 return 
	{
		type=BATTLE_CONST.NODE_OR,
				des="RevertAndReviveFomationLogic",
				weight= 1000,
				children= {
							-- 同时执行
								-- 如果有死亡英雄
									-- 激活UI
									-- 复活特效
									-- 渐现
									-- link


								-- 如果有未死替补
									-- 顺序执行
										-- 同时执行
											-- 激活ui
											-- 下场特效
											-- 渐现
										-- 同时执行
											-- normalState
											-- 复活
											-- 渐现
						  }


	}
end