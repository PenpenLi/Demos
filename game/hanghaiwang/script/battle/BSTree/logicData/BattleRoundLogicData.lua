



-- 攻击
module("BattleRoundLogicData",package.seeall)

-- function getInterestEventList()
function getLogicData()
			return {
						type=BATTLE_CONST.NODE_OR,
						des="回合技能",
						weight=1000,
						children={

																	
										{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 2000,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_DELAY,
																		des="回合delay",
																		selectors={"preStartDelay","total"},
																		weight=1000
																	}
															}
										}
										,
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
											type=BATTLE_CONST.NODE_PARALLEL_OR,
											-- actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
											des="怒气遮罩",
											weight=980,
										  	children = 	{
										  
															{
																type=BATTLE_CONST.NODE_AND,
																des="怒气遮罩:静态图片",
																weight=980,
																children = {	
																				{
																					
																					type=BATTLE_CONST.NODE_CONDITION,
																					des="如果是怒气技能",
																					p1="isRageSkill",
																					v1=true,
																					conditionType=BATTLE_CONST.CONDITION_EQUAL,
																					dtype="bool",
																					weight=1000
																											
																				}
																				,
																				{
																					
																					type=BATTLE_CONST.NODE_CONDITION,
																					des="如果不是动画遮罩",
																					p1="isAnimationRageMask",
																					v1=false,
																					conditionType=BATTLE_CONST.CONDITION_EQUAL,
																					dtype="bool",
																					weight=980
																											
																				}

																				,
																				{
																					type=BATTLE_CONST.NODE_PARALLEL_OR,
																					-- actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
																					des="attacker 同时播放 ",
																					weight=900,
																				  	children = 	{				
																				  						-- 		{ 
																												-- 	type=BATTLE_CONST.NODE_DECORATOR_CF,
																												-- 	weight = 1000,
																												-- 	des="装饰节点",
																												-- 	children = {

																												-- 						{
																												-- 							type=BATTLE_CONST.NODE_INSTANT_ACTION,
																												-- 							actionType=BATTLE_CONST.ACTION_HIDE_TARGETS,
																												-- 							des="隐藏",
																												-- 							selectors={"skillUnEffectTargets","targets"},
																												-- 							weight=1000
																												-- 						}
																												-- 				}
																												-- }
																												-- ,
																												{ 
																													type=BATTLE_CONST.NODE_DECORATOR_CF,
																													weight = 900,
																													des="装饰节点",
																													children = {

																																		{
																																			type=BATTLE_CONST.NODE_INSTANT_ACTION,
																																			actionType=BATTLE_CONST.ACTION_ADD_IMG_RAGE_MASK,
																																			des="添加Mask",
																																			selectors= {"rageMaskName","rageMaskName"},
																																			weight=1000
																																		}
																																}
																												}
																												,
																												{
																													type=BATTLE_CONST.NODE_DECORATOR_CF,
																													weight = 800,
																													des="装饰节点",
																													children = {

																																		{
																																			type=BATTLE_CONST.NODE_INSTANT_ACTION,
																																			actionType=BATTLE_CONST.ACTION_UP_TARGET_ZODER,
																																			des="up ZOder",
																																			selectors={"skillEffectTargets","targets"},
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
																des="怒气遮罩:动画",
																weight=900,
																children = {	
																				{
																					
																					type=BATTLE_CONST.NODE_CONDITION,
																					des="如果是怒气技能",
																					p1="isRageSkill",
																					v1=true,
																					conditionType=BATTLE_CONST.CONDITION_EQUAL,
																					dtype="bool",
																					weight=1000
																											
																				}
																				,
																				{
																					
																					type=BATTLE_CONST.NODE_CONDITION,
																					des="如果是动画类型遮罩",
																					p1="isAnimationRageMask",
																					v1=true,
																					conditionType=BATTLE_CONST.CONDITION_EQUAL,
																					dtype="bool",
																					weight=980
																											
																				}

																				,


																				{
																					type=BATTLE_CONST.NODE_PARALLEL_OR,
																					-- actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
																					des="attacker 同时播放 ",
																					weight=900,
																				  	children = 	{	

																										{
																											type=BATTLE_CONST.NODE_DECORATOR_CF,
																											weight = 910,
																											des="装饰节点",
																											children = {

																																{
																																	type=BATTLE_CONST.NODE_INSTANT_ACTION,
																																	actionType=BATTLE_CONST.ACTION_UP_TARGET_ZODER,
																																	des="up ZOder",
																																	selectors={"skillEffectTargets","targets"},
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
																																	type=BATTLE_CONST.NODE_INSTANT_ACTION,
																																	actionType=BATTLE_CONST.ACTION_ADD_ANI_RAGE_MASK,
																																	selectors={"rageMaskName","rageMaskName"},
																																	des="添加Mask",
																																	weight=1000
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
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 950,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_SET_Z_ORDER,
																		des="ZOder",
																		selectors={"attackerUI","target","attackerZOderTo","zValue"},
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
																		actionType=BATTLE_CONST.ACTION_BS_ATTACK,
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
																		actionType=BATTLE_CONST.ACTION_BS_HANDLE_SKILL,
																		des="技能分配",
																		selectors={"roundData","roundData"},
																		eventTrigger="EVT_EXCUTE_SKILL",
																		weight=1000
																	}
															}
										}
										,
										{
											 
											type=BATTLE_CONST.NODE_AND,
											des="总伤害动画",
											weight=845,
											children = {	
															{
																
																type=BATTLE_CONST.NODE_CONDITION,
																des="是多段伤害",
																p1="isMulityAttack",
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
																						type=BATTLE_CONST.NODE_INSTANT_ACTION,
																						actionType=BATTLE_CONST.ACTION_SHOW_TOTAL_HURT,
																						des="总伤害动画",
																						selectors={"totalDamage","value"},
																						weight=1000
																					}
																			}
															}
														}


										}
										,

										{
												type=BATTLE_CONST.NODE_AND,
												weight = 849,
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
																							actionType=BATTLE_CONST.ACTION_BS_SUBSKILL,
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
											type=BATTLE_CONST.NODE_AND,
											des="怒气遮罩",
											weight=845,
											children = {	
															{
																
																type=BATTLE_CONST.NODE_CONDITION,
																des="如果是怒气技能",
																p1="isRageSkill",
																v1=true,
																conditionType=BATTLE_CONST.CONDITION_EQUAL,
																dtype="bool",
																weight=1000
																						
															}
															,
															{
																type=BATTLE_CONST.NODE_PARALLEL_OR,
																-- actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
																des="删除mask + 恢复zOder",
																weight=900,
															  	children = 	{
															 
															  		
															  				-- 		{ 
																					-- 	type=BATTLE_CONST.NODE_DECORATOR_CF,
																					-- 	weight = 1000,
																					-- 	des="装饰节点",
																					-- 	children = {

																					-- 						{
																					-- 							type=BATTLE_CONST.NODE_INSTANT_ACTION,
																					-- 							actionType=BATTLE_CONST.ACTION_VISIBLE_TARGETS,
																					-- 							des="显示隐藏目标",
																					-- 							selectors={"skillUnEffectTargets","targets"},
																					-- 							weight=1000
																					-- 						}
																					-- 				}
																					-- }
																					-- ,

																					{ 
																						type=BATTLE_CONST.NODE_DECORATOR_CF,
																						weight = 900,
																						des="装饰节点",
																						children = {

																											{
																												type=BATTLE_CONST.NODE_INSTANT_ACTION,
																												actionType=BATTLE_CONST.ACTION_REMOVE_IMG_RAGE_MASK,
																												des="删除Mask",
																												weight=1000
																											}
																									}
																					}
																					,
																					{
																																												type=BATTLE_CONST.NODE_DECORATOR_CF,
																						weight = 800,
																						des="装饰节点",
																						children = {

																											{
																												type=BATTLE_CONST.NODE_INSTANT_ACTION,
																												actionType=BATTLE_CONST.ACTION_RESUME_TARGET_ZODER,
																												des="恢复zOder",
																												selectors={"skillEffectTargets","targets"},
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
											des="提前执行后一个action",
											weight=842,
											children = {	
																	{
																		
																		type=BATTLE_CONST.NODE_CONDITION,
																		des="是否可以提前执行",
																		p1="canPreStart",
																		v1=true,
																		conditionType=BATTLE_CONST.CONDITION_EQUAL,
																		dtype="bool",
																		weight=1000
																								
																	}
																	,
																	{

																		type=BATTLE_CONST.NODE_DECORATOR_CF,
																		weight = 840,
																		des="装饰节点",
																		children = {
																						{

																							type=BATTLE_CONST.NODE_ACTION,
																							actionType=BATTLE_CONST.ACTION_SEND_PRESTART_EVT,
																							-- selectors={"preStartDelay","preStartDelay"},
																							des="发送执行下一个人物回合的触发事件",
																							weight=1000

																						}

																					}
																	}
														}
											
										}
										,

										-- 如果不是怒气 且 没有魔法特效
										{
											type=BATTLE_CONST.NODE_AND,
											des="提前执行后一个action",
											weight=841,
											children = {	
																	{
																		
																		type=BATTLE_CONST.NODE_CONDITION,
																		des="是否可以提前执行",
																		p1="needStun",
																		v1=true,
																		conditionType=BATTLE_CONST.CONDITION_EQUAL,
																		dtype="bool",
																		weight=1000
																								
																	}
																	,
																	{
																			type=BATTLE_CONST.NODE_DECORATOR_CF,
																			weight = 550,
																			des="装饰节点",
																			children = {
																								{
																									type=BATTLE_CONST.NODE_ACTION,
																									actionType=BATTLE_CONST.ACTION_DELAY,
																									des="回合delay",
																									selectors={"stunTime","total"},
																									weight=1000
																								}
																						}
																	}
														}
											
										}







										,
										{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 840,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_MOVE_BACK,
																		des="移动回去",
																		selectors={"attackerUI","targetUI"},
																		-- eventTrigger="EVT_EXCUTE_SKILL",
																		weight=1000
																	}
															}

										}

										,
										{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 830,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_SET_Z_ORDER,
																		des="ZOder",
																		selectors={"attackerUI","target","attackerZOderFrom","zValue"},
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
																		selectors={"allBeAttackers","targets","attacker","attacker"},
																		weight=1000
																	}
															}
										}
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
												-- 注意这个节点的顺序 必须要在替补逻辑之后  
												-- 濒死处理有2种情况:
												--					1.替补在攻击者位置出现:如果在前面 那么逻辑就变成-> 死亡技能释放,坟头动画.... 这和策划预期不一致

												--					2.替补不出现
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 560,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_HANDLE_NEAR_DEATH,
																		des="处理濒死",
																		selectors={"attacker","target"},
																		weight=1000
																	}
															}
										}
										,
										{
												type=BATTLE_CONST.NODE_DECORATOR_CF,
												weight = 550,
												des="装饰节点",
												children = {
																	{
																		type=BATTLE_CONST.NODE_ACTION,
																		actionType=BATTLE_CONST.ACTION_DELAY,
																		des="回合delay",
																		selectors={"smallRoundDelay","total"},
																		weight=1000
																	}
															}
										}
										-- ,
										-- {
										-- 		type=BATTLE_CONST.NODE_DECORATOR_CF,
										-- 		weight = 600,
										-- 		des="装饰节点",
										-- 		children = {
										-- 							{
										-- 								type=BATTLE_CONST.NODE_ACTION,
										-- 								actionType=BATTLE_CONST.ACTION_DELAY,
										-- 								des="结束延迟",
										-- 								selectors={"smallRoundDelay","total"},
										-- 								weight=1000
										-- 							}
										-- 					}
										-- }

 
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
