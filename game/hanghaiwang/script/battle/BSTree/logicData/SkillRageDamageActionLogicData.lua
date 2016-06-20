

module("SkillRageDamageActionLogicData",package.seeall)
-- function getInterestEventList()
-- 	return nil
-- end
function getLogicData(   )
	return 
	{
			type=BATTLE_CONST.NODE_OR,
						des="SkillRageDamageActionLogicData",
						children={

										{
											type=BATTLE_CONST.NODE_AND,
											des="技能怒气动作",
											weight=1000,
											children = 	{

																{
																	type=BATTLE_CONST.NODE_CONDITION,
																	des="有怒气变化",
																	p1="hasRageChange",
																	v1=true,
																	conditionType=BATTLE_CONST.CONDITION_EQUAL,
																	dtype="bool",
																	weight=1000
																}
																,

																{	
																	
																	type=BATTLE_CONST.NODE_PARALLEL_OR,
																	des="怒气伤害组合",
																	weight= 900,
																	children=
																					{

																							{	
																								type=BATTLE_CONST.NODE_DECORATOR_CF,
																								weight = 1000,
																								des="装饰节点",
																								children = {
																												{
																													type=BATTLE_CONST.NODE_ACTION,
																													actionType=BATTLE_CONST.ACTION_CHANGE_RAGE,
																													selectors={"target","target","value","value"},
																													des="怒气数据",
																													weight=1000
																												}
																											}
																				 
																							}
																							-- ,
																							-- {	
																							-- 	type=BATTLE_CONST.NODE_DECORATOR_CF,
																							-- 	weight = 900,
																							-- 	des="装饰节点",
																							-- 	children = {
																							-- 					{
																							-- 						type=BATTLE_CONST.NODE_ACTION,
																							-- 						actionType=BATTLE_CONST.ACTION_RAGE_BAR_CHANGE,
																							-- 						selectors={"targetUI","heroUI","value","value"},
																							-- 						des="怒气条改变",
																							-- 						weight=1000
																							-- 					}
																							-- 				}
																				 
																							-- }

																					}
													 
																} 



														}
										}
										,
										{
											type=BATTLE_CONST.NODE_ACTION,
											actionType=BATTLE_CONST.ACTION_NODE_END,
											des="buffAddLogicData 结束",
											weight=900,
										}
								 }
	}
end