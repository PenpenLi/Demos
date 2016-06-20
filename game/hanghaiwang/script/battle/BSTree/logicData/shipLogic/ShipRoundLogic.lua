
-- 主船回合
module("ShipRoundLogic",package.seeall)

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
												weight = 900,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_BS_SHIP_ATTACK,
																		des="攻击技能BS",
																		selectors={"roundData","roundData"},
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
																		actionType=BATTLE_CONST.ACTION_BS_SHIP_HANDLE_SKILL,
																		des="技能分配",
																		selectors={"roundData","roundData"},
																		eventTrigger="EVT_EXCUTE_SKILL",
																		weight=1000
																	}
															}
										}
										,
										{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 820,
												des="回合中所有buff",
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
												type=BATTLE_CONST.NODE_AND,
												weight = 810,
												des="子技能",
												children = {



																	{
																		type=BATTLE_CONST.NODE_CONDITION,
																		des="有子技能",
																		p1="hasSubSkills",
																		v1=true,
																		conditionType=BATTLE_CONST.CONDITION_EQUAL,
																		dtype="bool",
																		weight=1000
																	}
																	,

																	{	
																		type=BATTLE_CONST.NODE_DECORATOR_CF,
																		weight = 900,
																		des="装饰节点",
																		children = {
																						{
																							type=BATTLE_CONST.NODE_ACTION,
																							actionType=BATTLE_CONST.ACTION_BS_SHIP_SUBSKILL,
																							selectors={"subSkillsList","subSkillsList"},
																							des="子技能",
																							weight=1000
																						}
																					}
														 
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
																		des="回合终所有buff",
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
																		selectors={"allBeAttackers","targets","shipUI","attacker"},
																		weight=1000
																	}
															}
										}

										-- {
										-- 		type=BATTLE_CONST.NODE_DECORATOR_CF,
										-- 		weight = 550,
										-- 		des="装饰节点",
										-- 		children = {
										-- 							{
										-- 								type=BATTLE_CONST.NODE_ACTION,
										-- 								actionType=BATTLE_CONST.ACTION_DELAY,
										-- 								des="回合delay",
										-- 								selectors={"smallRoundDelay","total"},
										-- 								weight=1000
										-- 							}
										-- 					}
										-- }
										-- ,
										,
											{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 600,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_BS_BENCH_SHOW,
																		des="替补上场逻辑",
																		selectors={"benchsInfo","showList"},
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
end -- function end
-- 	return {[1]=NotificationNames.EVT_SKILL_NODE_ACTIVE}
-- end
