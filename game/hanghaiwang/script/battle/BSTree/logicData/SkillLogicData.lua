
-- 技能
module("SkillLogicData",package.seeall)

-- function getInterestEventList()
-- 	return nil
-- end

function getLogicData()
			return  {
				type=BATTLE_CONST.NODE_OR,
				des="释放技能",
				children=	{

								{
									type=BATTLE_CONST.NODE_AND,
									des="人物显示状态",
									weight=1200,
									children =  
												{

														{
															type=BATTLE_CONST.NODE_CONDITION,
															des="是否隐藏卡牌",
															p1="hideAttacker",
															v1=true,
															conditionType=4,
															dtype="bool",
															weight=1000
														}

														,

						
							  							{
							  								type=BATTLE_CONST.NODE_DECORATOR_CF,
							  								weight = 1000,
							  								des="装饰节点",
							  								children = {
								  											{
													  							type=BATTLE_CONST.NODE_ACTION,
																				actionType=BATTLE_CONST.ACTION_SET_TARGET_UNVISABLE,
																				selectors={"attackerUI","target","attackerHideLevel","value"},
																				des="设置目标不可见",
																				weight=1000
																			}
							  											}
							  							}
						
												}
								},


								{
									type=BATTLE_CONST.NODE_OR,
									des="一般技能",
									weight=1000,
									children =  
												{			
															{
																type=BATTLE_CONST.NODE_AND,
																des="撞击技能",
																weight=10010,
																children =  
																			{
																			

																					{
																						type=BATTLE_CONST.NODE_CONDITION,
																						des="撞击技能",
																						p1="isImpactSill",
																						v1=true,
																						conditionType=4,
																						dtype="bool",
																						weight=1000
																					}

																					,

														  							{
														  								type=BATTLE_CONST.NODE_DECORATOR_CF,
														  								weight = 900,
														  								des="撞击装饰节点",
														  								children = {
															  											{
																				  							type=BATTLE_CONST.NODE_ACTION,
																											actionType=BATTLE_CONST.ACTION_FLY_ATTACK,
																											des="一般技能打击",
																											weight=1000
																										}
														  											}
														  							}

																												


																												
																					


																			}
															}
															,
															{
																type=BATTLE_CONST.NODE_AND,
																des="全屏后方穿刺技能",
																weight=10000,
																children =  
																			{
																			

																					{
																						type=BATTLE_CONST.NODE_CONDITION,
																						des="全屏后方穿刺技能",
																						p1="isBackRemoteSkill",
																						v1=true,
																						conditionType=4,
																						dtype="bool",
																						weight=1000
																					}

																					,

														  							{
														  								type=BATTLE_CONST.NODE_DECORATOR_CF,
														  								weight = 900,
														  								des="撞击装饰节点",
														  								children = {
															  											{
																				  							type=BATTLE_CONST.NODE_ACTION,
																											actionType=BATTLE_CONST.ACTION_REMOTE_FROM_BACK,
																											des="全屏后方穿刺技能打击",
																											weight=1000
																										}
														  											}
														  							}

																												


																												
																					


																			}
															}
															,

															{
																type=BATTLE_CONST.NODE_AND,
																des="穿刺技能",
																weight=9999,
																children =  
																			{
																			

																					{
																						type=BATTLE_CONST.NODE_CONDITION,
																						des="穿刺技能",
																						p1="isPierceSkill",
																						v1=true,
																						conditionType=4,
																						dtype="bool",
																						weight=1000
																					}

																					,

														  							{
														  								type=BATTLE_CONST.NODE_DECORATOR_CF,
														  								weight = 900,
														  								des="撞击装饰节点",
														  								children = {
															  											{
																				  							type=BATTLE_CONST.NODE_ACTION,
																											actionType=BATTLE_CONST.ACTION_REMOTE_PIERCE,
																											des="全屏穿刺技能打击",
																											weight=1000
																										}
														  											}
														  							}

																												


																												
																					


																			}
															}
															,





															{
																type=BATTLE_CONST.NODE_AND,
																des="一般技能",
																weight=1001,
																children =  
																			{

																					{
																						type=BATTLE_CONST.NODE_CONDITION,
																						des="一般技能",
																						p1="isNormalSkill",
																						v1=true,
																						conditionType=4,
																						dtype="bool",
																						weight=1000
																					}

																					,

																					{
																						type=BATTLE_CONST.NODE_PARALLEL_OR ,
																						weight=900,
																						des="释放技能",
																						children = 		{
																					  							{
																					  								type=BATTLE_CONST.NODE_DECORATOR_CF,
																					  								weight = 1000,
																					  								des="装饰节点",
																					  								children = {
																						  											{
																											  							type=BATTLE_CONST.NODE_ACTION,
																																		actionType=BATTLE_CONST.ACTION_SKILL_SPELL_ATTACK,
																																		des="一般技能打击",
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
																																		actionType=BATTLE_CONST.ACTION_SKILL_RANGE_ATTACK,
																																		des="一般技能范围特效",
																																		weight=900
																																	}
																					  											}
																												}


																									}			
																					}
																					-- {
																					-- 	type=NODE_ACTION,
																					-- 	actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
																					-- 	des="同时播放",
																					-- 	weight=900,
																					--   	actionsChildren =   {
																					  							
																					--   							{
																					-- 	  							type=NODE_ACTION,
																					-- 								actionType=ACTION_SKILL_SPELL_ATTACK,
																					-- 								des="一般技能打击",
																					-- 								weight=1000
																					-- 							}
																					-- 							,
																					-- 							{														  							
																					-- 	  							type=NODE_ACTION,
																					-- 								actionType=ACTION_SKILL_RANGE_ATTACK,
																					-- 								des="一般技能范围特效",
																					-- 								weight=900
																					-- 							}

																					-- 						}

																					-- }


																		}
															}

															,

															{
																type=BATTLE_CONST.NODE_AND,
																des="远程技能",
																weight=1000,
																children =  
																			{
																						{
																							type=BATTLE_CONST.NODE_CONDITION,
																							des="if远程技能",
																							p1="isRemoteSkill",
																							v1=true,
																							conditionType=4,
																							dtype="bool",
																							weight=1000
																						}
																						,
																						{
																							-- 同时播放
																							-- 远程弹道魔法特效(挂接到攻击者身上)
																							-- 顺序播放
																								-- 弹道魔法特效关键帧延迟
																								-- 远程弹道

																							type=BATTLE_CONST.NODE_PARALLEL_OR ,
																							weight=900,
																							des="弹道同时播放",
																							children = 	{


																												{	
																													type=BATTLE_CONST.NODE_DECORATOR_CF,
																													weight = 900,
																													des="装饰节点",
																													children = {
																																	{

																																		type=BATTLE_CONST.NODE_ACTION,
																																		actionType=BATTLE_CONST.ACTION_EFFECT_AT_HERO,
																																		des="攻击者弹道触发动画",
																																		selectors={"attackEffctPosition","atPostion","attackerUI","heroUI","attackEffectName","animationName","attackEffectRotation","rotation"},
																																		weight=1000
																																	}

																																}
																									 
																												}
																												,
																												{
																													type=BATTLE_CONST.NODE_OR,
																													des="延迟+弹道",
																													weight = 800,
																													children=	{
																										  								
																									  									{
																																				type=BATTLE_CONST.NODE_DECORATOR_CF,
																																				weight = 1000,
																																				des="装饰节点",
																																				children = {
																																									{
																																										type=BATTLE_CONST.NODE_ACTION,
																																										actionType=BATTLE_CONST.ACTION_DELAY,
																																										des="回合delay",
																																										selectors={"attackEffectKeyFrame","total"},
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
																																								actionType=BATTLE_CONST.ACTION_REMOTE_ATTACK,
																																								des="远程打击",
																																								weight=900
																																							}
																											  											}
																										  								}
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
									type=BATTLE_CONST.NODE_AND,
									des="人物显示状态还原",
									weight=900,
									children =  
												{

														{
															type=BATTLE_CONST.NODE_CONDITION,
															des="是否隐藏卡牌",
															p1="hideAttacker",
															v1=true,
															conditionType=4,
															dtype="bool",
															weight=1000
														}

														,

						
							  							{
							  								type=BATTLE_CONST.NODE_DECORATOR_CF,
							  								weight = 1000,
							  								des="装饰节点",
							  								children = {
								  											{
													  							type=BATTLE_CONST.NODE_ACTION,
																				actionType=BATTLE_CONST.ACTION_SET_TARGET_VISABLE,
																				selectors={"attackerUI","target","attackerHideLevel","value"},
																				des="设置目标可见",
																				weight=1000
																			}
							  											}
							  							}
						
												}
								},
								{
											type=BATTLE_CONST.NODE_ACTION,
											actionType=BATTLE_CONST.ACTION_NODE_END,
											des="SkillLogicData 结束",
											weight=800,
								}
							}
			}
end