-- 删除buff
module("BuffDeleteLogicData",package.seeall)


-- function getInterestEventList()
-- 	return nil
-- end
function getLogicData(   )
		return  {
					  

						type=BATTLE_CONST.NODE_OR,
						des="删除buff",
						children={
										{
											type=BATTLE_CONST.NODE_AND,
											des="删除特效",
											weight=990,
											children = 		{
																	{
																		type=BATTLE_CONST.NODE_CONDITION,
																		des="有删除特效",
																		p1="hasDelEff",
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
																							des="buff删除特效action",
																							selectors={"targetUI","heroUI","deleteEffectName","animationName"},
																							weight=1000
																						}
																					}
														 
																	} 
															}
										}

										,

										{

											type=BATTLE_CONST.NODE_AND,
											des="删除buf图标",
											weight=980,
											children = 		{
																	{
																		type=BATTLE_CONST.NODE_CONDITION,
																		des="需要删除buff图标",
																		p1="needDelIcon",
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
																							actionType=BATTLE_CONST.ACTION_REMOVE_BUFF_ICON,
																							des="buff删除特效action",
																							selectors={"targetUI","heroUI","iconName","iconName","target","target","bufffId","buffid"},
																							weight=1000
																						}
																					}
														 
																	} 
															}		
										}
										,
										{
											type=BATTLE_CONST.NODE_ACTION,
											actionType=BATTLE_CONST.ACTION_NODE_END,
											des="buffDelLogicData 结束",
											weight=900,
										}
								 }

				}
end
