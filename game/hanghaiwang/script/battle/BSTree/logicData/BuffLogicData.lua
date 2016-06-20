module("BuffLogicData",package.seeall)
-- 免疫buff

-- function getInterestEventList()
-- 	return nil
-- end

function getLogicData()
			-- --print("BuffLogicData")
			return  {
						type=BATTLE_CONST.NODE_OR,
						des="buffRoot",
						children={	
										{

											type=BATTLE_CONST.NODE_AND,
											des="buff删除",
											weight=900,
											children = 	{ 
																				{
																					type=BATTLE_CONST.NODE_CONDITION,
																					des="可以删除buff",
																					p1="hasDeleteTimeBuff",
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
																										actionType=BATTLE_CONST.ACTION_BS_DELETE_BUFF,
																										des="buff删除action",
																										selectors={"targetUI","heroUI","deleteList","deleteList","targetId","targetId"},
																										weight=1000
																									}
																								}
																	 
																				} 
														}
										}
										,
										{

											type=BATTLE_CONST.NODE_AND,
											des="buff免疫",
											weight=990,
											children = 	{ 
																				{
																					type=BATTLE_CONST.NODE_CONDITION,
																					des="可以免疫buff",
																					p1="hasImTimeBuff",
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
																										actionType=BATTLE_CONST.ACTION_BS_IM_BUFF,
																										des="buff免疫action",
																										selectors={"targetUI","heroUI","imList","imList","targetId","targetId"},
																										weight=1000
																									}
																								}
																	 
																				} 
														}
										}
										,
										{

											type=BATTLE_CONST.NODE_AND,
											des="添加buff",
											weight=980,
											children = 	{ 
																				{
																					type=BATTLE_CONST.NODE_CONDITION,
																					des="可以添加buff",
																					p1="hasAddTimeBuff",
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
																										actionType=BATTLE_CONST.ACTION_BS_ADD_BUFF,
																										des="buff添加action",
																										selectors={"targetUI","heroUI","addList","addList","targetId","targetId"},
																										weight=1000
																									}
																								}
																	 
																				} 
														}
										}
										,
										{

											type=BATTLE_CONST.NODE_AND,
											des="buff伤害",
											weight=970,
											children = 	{ 
																				{
																					type=BATTLE_CONST.NODE_CONDITION,
																					des="可以伤害buff",
																					p1="hasDamageTimeBuff",
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
																										actionType=BATTLE_CONST.ACTION_BS_DAMAGE_BUFF,
																										des="buff伤害action",
																										selectors={"target","target","delayBuffDamage","delayBuffDamage","targetId","targetId","targetUI","heroUI","damageList","damageList"},
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
											des="buffLogicData 结束",
											weight=800,
										}
								}
					}
	end	
