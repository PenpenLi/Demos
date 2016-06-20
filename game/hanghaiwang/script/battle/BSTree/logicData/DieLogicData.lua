

module("DieLogicData",package.seeall)
-- 免疫buff

-- function getInterestEventList()
-- 	return nil
-- end

function getLogicData()
return  {
						
				type=BATTLE_CONST.NODE_OR,
				des="DieLogicData",
				weight= 1000,
				children= {
									{

											type=BATTLE_CONST.NODE_PARALLEL_OR,
											des="xml动画+掉落事件",
											weight=2000,
											children={	

														{
																				type=BATTLE_CONST.NODE_OR,
																				des="死亡XML动画",
																				weight= 1000,
																				children= {


																									{
																											type=BATTLE_CONST.NODE_AND,
																											weight = 900,
																											des="踢飞死亡",
																											children = {



																																{
																																	type=BATTLE_CONST.NODE_CONDITION,
																																	des="是踢飞死亡",
																																	p1="kickOut",
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
																																							actionType=BATTLE_CONST.ACTION_KICK_OUT,
																																							des="踢飞",
																																							selectors={"targetData","targetData"},
																																							weight=1000
																																						}
																																				}
																																}

																														}
																									}
																									,

																									{
																											type=BATTLE_CONST.NODE_AND,
																											weight = 850,
																											des="动作死亡",
																											children = {



																																{
																																	type=BATTLE_CONST.NODE_CONDITION,
																																	des="是动作死亡",
																																	p1="actionDie",
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
																																							actionType=BATTLE_CONST.ACTION_XML_ANI_AT_HERO,
																																							des="死亡XML动画",
																																							selectors={"targetUI","heroUI","dieAnimationName","animationName"},
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
																															actionType=BATTLE_CONST.ACTION_CALL_DIE_FUNCTION,
																															selectors={"targetUI","targetUI"},
																															des="调用死亡",
																															weight=1000
																														}
																													}

																									}

																									
																							}

																				

														}
														,
														{
														 -- 延迟 + 动画
														 	type=BATTLE_CONST.NODE_OR,
															des="DieLogicData",
															weight= 900,
															children= {

													 							{	-- 这里增加延迟是为了达到:xml关键帧时触发死亡特效
																					type=BATTLE_CONST.NODE_DECORATOR_CF,
																					weight = 1000,
																					des="装饰节点",
																					children = {
																									{
																										type=BATTLE_CONST.NODE_ACTION,
																										actionType=BATTLE_CONST.ACTION_DELAY,
																										selectors={"dieXMLKeyFrame","total"},
																										des="延迟动作关键帧",
																										weight=1000
																									}
																								}
																	 
																				}
																				,

																				{
																					type=BATTLE_CONST.NODE_PARALLEL_OR,
																					des="DieLogicGroup",
																					weight=900,
																					children=
																					{
																						{	
																							type=BATTLE_CONST.NODE_DECORATOR_CF,
																							weight = 900,
																							des="装饰节点",
																							children = {
																											{
																												type=BATTLE_CONST.NODE_ACTION,
																												-- actionType=BATTLE_CONST.ACTION_EFFECT_AT_HERO,
																												-- selectors={"targetUI","heroUI","dieEffectName","animationName"},
																												actionType=BATTLE_CONST.ACTION_PLAY_EFFECT_AT_POSITION,
																												selectors={"targetX","postionX","targetY","postionY","dieEffectName","animationName"},
																												des="死亡特效meffect_die",
																												weight=900
																											}
																										}
																			 
																						}
																						
																						,
																						

																						{
																								type=BATTLE_CONST.NODE_AND,
																								weight = 800,
																								des="英雄死亡额外动画",
																								children = {



																													{
																														type=BATTLE_CONST.NODE_CONDITION,
																														des="是英雄",
																														p1="isMonster",
																														v1=false,
																														conditionType=BATTLE_CONST.CONDITION_EQUAL,
																														dtype="bool",
																														weight=1000
																													}
																													,
																													{
																														type=BATTLE_CONST.NODE_CONDITION,
																														des="是否播放坟头",
																														p1="isShowGraveStone",
																														v1=true,
																														conditionType=BATTLE_CONST.CONDITION_EQUAL,
																														dtype="bool",
																														weight=950
																													}
																													,

																													{
																																			type=BATTLE_CONST.NODE_OR,
																																			-- type=BATTLE_CONST.NODE_PARALLEL_OR,
																																			des="英雄死亡坟头+ 鬼火",
																																			weight= 900,
																																			children=
																																					{		
																																							 --- 死亡后坟头要掉落在玩家原始站立位置,所以我们需要重置玩家位置
																																							{	
																																								type=BATTLE_CONST.NODE_DECORATOR_CF,
																																								weight = 1200,
																																								des="装饰节点",
																																								children = {
																																												{
																																													type=BATTLE_CONST.NODE_ACTION,
																																													actionType=BATTLE_CONST.ACTION_TO_RAW_POSTION,
																																													selectors={"targetUI","heroUI"},
																																													des="还原玩家位置",
																																													weight=2000
																																												}
																																											}
																																				 		
																																							}
																																							,
																																							-- {
																																							-- 	type=BATTLE_CONST.NODE_CONDITION,
																																							-- 	des="没有替补上场",
																																							-- 	p1="hasBench",
																																							-- 	v1=true,
																																							-- 	conditionType=BATTLE_CONST.CONDITION_EQUAL,
																																							-- 	dtype="bool",
																																							-- 	weight=1000
																																							-- }
																																							-- ,		
																																							{	
																																								type=BATTLE_CONST.NODE_DECORATOR_CF,
																																								weight = 1000,
																																								des="装饰节点",
																																								children = {
																																												{
																																													type=BATTLE_CONST.NODE_ACTION,
																																													actionType=BATTLE_CONST.ACTION_DELAY,
																																													selectors={"dieEffectKeyFrame","total"},
																																													des="延迟坟头动画关键帧",
																																													weight=2000
																																												}
																																											}
																																				 
																																							}
																																							,
																																								-- , 																																
																																							{	
																																								type=BATTLE_CONST.NODE_DECORATOR_CF,
																																								weight = 900,
																																								des="装饰节点",
																																								children = {
																																												{
																																													type=BATTLE_CONST.NODE_ACTION,
																																													actionType=BATTLE_CONST.ACTION_EFFECT_AT_HERO,
																																													selectors={"targetUI","heroUI","fentouEffectName","animationName"},
																																													des="鬼魂动作1",
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
																																													actionType=BATTLE_CONST.ACTION_ADD_EFFECT_TO_HERO,
																																													selectors={"targetUI","heroUI","fentou1EffectName","animationName"}, -- ,"loopFenTou","autoLoop"
																																													des="死亡坟头动画",
																																													weight=1000
																																												}
																																											}
																																				 
																																							}
																																						
																																					}
																													}



																											}
																						}











																						,

																						{
																							type=BATTLE_CONST.NODE_AND,
																							weight = 850,
																							des="掉落物品事件",
																							children = {



																												{
																													type=BATTLE_CONST.NODE_CONDITION,
																													des="是怪物",
																													p1="isMonster",
																													v1=true,
																													conditionType=BATTLE_CONST.CONDITION_EQUAL,
																													dtype="bool",
																													weight=1000
																												}
																												,
																												{
																													type=BATTLE_CONST.NODE_CONDITION,
																													des="该英雄掉落装备",
																													p1="willDropItem",
																													v1=true,
																													conditionType=BATTLE_CONST.CONDITION_EQUAL,
																													dtype="bool",
																													weight=900
																												}
																												,
						 																						{
																														type=BATTLE_CONST.NODE_PARALLEL_OR,
																														des="掉落动画 + 事件",
																														weight=800,
																														children=
																														{
																															{
																																type=BATTLE_CONST.NODE_DECORATOR_CF,
																																weight = 700,
																																des="装饰节点",
																																children = {
																																				{
																																					type=BATTLE_CONST.NODE_ACTION,
																																					actionType=BATTLE_CONST.ACTION_SEND_NOTIFICATION,
																																					selectors={"chestEvent","notificationName","targetData","data","dropEventDelay","delay"},
																																					des="掉落事件",
																																					weight=1000
																																				}
																																			}
																																
																															} 
																															,
																															{	
																																type=BATTLE_CONST.NODE_DECORATOR_CF,
																																weight = 950,
																																des="装饰节点",
																																children = {
																																				{
																																					type=BATTLE_CONST.NODE_ACTION,
																																					-- actionType=BATTLE_CONST.ACTION_EFFECT_AT_HERO,
																																					actionType=BATTLE_CONST.ACTION_PLAY_EFFECT_AT_POSITION,
																																					selectors={"targetX","postionX","targetY","postionY","dropItemShineName","animationName"},
																																					-- selectors={"targetUI","heroUI","dropItemShineName","animationName"},
																																					des="死亡掉落特效",
																																					weight=900
																																				}
																																			}
																												 
																															}
																														}
																												}
																												


																																	-- }
																												-- }
																												

																										}
																					}


																					}	
																				}
																				

																		}
														}
													}
									}
									
									,
									 
									{
										-- 结束
										type=BATTLE_CONST.NODE_ACTION,
										actionType=BATTLE_CONST.ACTION_NODE_END,
										des="bDieLogicData结束",
										weight=900
									}


							   }
						



		}
end