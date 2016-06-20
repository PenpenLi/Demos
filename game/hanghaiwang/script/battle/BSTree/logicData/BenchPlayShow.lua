

module("BenchPlayShow",package.seeall)


function getLogicData( ... )
 	return {

						type=BATTLE_CONST.NODE_OR,
						des="替补上产",
						children={

									{
										-- 指定位置目标消失	
									},
									{
										-- 指定位置播放出场特效
									}
									,
									{
										-- 玩家出现
									}
									


								}

			}
end