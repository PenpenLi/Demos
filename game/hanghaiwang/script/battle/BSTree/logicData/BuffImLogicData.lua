
module("BuffImLogicData",package.seeall)
-- 免疫buff
 
-- function getInterestEventList()
-- 	return nil
-- end
function getLogicData()
		return  {
					  

						type=BATTLE_CONST.NODE_OR,
						des="免疫Root",
						children={
										{
											type=BATTLE_CONST.NODE_AND,
											des="buff添加特效And",
											weight=990,
											children = 		{
																	{
																		type=BATTLE_CONST.NODE_CONDITION,
																		des="有buff添加特效",
																		p1="hasAddBuffEff",
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
																							actionType=BATTLE_CONST.ACTION_EFFECT_AT_HERO,
																							des="buff添加特效action",
																							selectors={"targetUI","heroUI","addEffectName","animationName"},
																							weight=1000
																						}
																					}
														 
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
																actionType=BATTLE_CONST.ACTION_REACTION_ANI,
																-- des="reaction动画",
																--ps="1,2",
																selectors={"targetUI","target","imEffectName","reactionBitmapPath"},															
																-- actionType=BATTLE_CONST.ACTION_EFFECT_AT_HERO,
																des="免疫动画",
																-- selectors={"targetUI","heroUI","imEffectName","animationName"},
																weight=1000
															}
														}
							 
										} 
										,
										{
												-- 结束
												type=BATTLE_CONST.NODE_ACTION,
												actionType=BATTLE_CONST.ACTION_NODE_END,
												des="免疫buff结束",
												weight=900
										}
	 
								 }

				}
end
