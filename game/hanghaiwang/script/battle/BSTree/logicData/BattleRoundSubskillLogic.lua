

-- 攻击
module("BattleRoundSubskillLogic",package.seeall)

-- function getInterestEventList()
function getLogicData()
			return {

					type=BATTLE_CONST.NODE_OR,
						des="回合技能",
						weight=1000,
						children={
										{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 1000,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_RUN_ALL_BUFF_BY_TIME,
																		des="回合前所有buff",
																		selectors={"allBuffs","buffList","startTimeValue","timeType"},
																		weight=1000
																	}
															}
										}
										,
										 
										{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 850,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_BS_HANDLE_SKILL,
																		des="技能分配",
																		selectors={"roundData","roundData"},
																		weight=1000
																	}
															}
										}
									 

										,
										{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 750,
												des="回合终所有buff",
												children = {

																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_RUN_ALL_BUFF_BY_TIME,
																		des="回合中所有buff",
																		selectors={"allBuffs","buffList","middleTimeValue","timeType"},
																		weight=1000
																	}
															}
										}
										,
										{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 800,
												des="回合终所有buff",
												children = {

																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_RUN_ALL_BUFF_BY_TIME,
																		des="回合前所有buff",
																		selectors={"allBuffs","buffList","endTimeValue","timeType"},
																		weight=1000
																	}
															}
										}
										,
										{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 700,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_BS_CHECK_UA_COMPLETE,
																		des="检测被攻击者是否执行完毕",
																		selectors={"allBeAttackers","targets"},
																		weight=1000
																	}
															}
										}
										,
										{
											-- 结束
												type=BATTLE_CONST.NODE_ACTION,
												actionType=BATTLE_CONST.ACTION_NODE_END,
												des="BattleRoundLogicData伤害结束",
												weight=500
										}
								 }

			}
end