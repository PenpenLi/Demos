

-- 攻击
module("AttackLogicData",package.seeall)

-- function getInterestEventList()
-- 	return nil
-- end

function getLogicData()
			return {

						type=BATTLE_CONST.NODE_OR,
						des="攻击者技能释放",
						children={
							-- {
							-- 	type=NODE_CONDITION,
							-- 	des="攻击数据",
							-- 	p1="haveBattleData",
							-- 	v1=true,
							-- 	conditionType=4,
							-- 	dtype="bool",
							-- 	weight=100
							-- },
							{
								type=BATTLE_CONST.NODE_OR,
								des="攻击者相关",
								weight=990,
								children = 
								{
									{
										type=BATTLE_CONST.NODE_DECORATOR_CF,
										weight = 1000,
										des="装饰节点",
										children = {
														{
															type=BATTLE_CONST.NODE_ACTION,
															actionType=BATTLE_CONST.ACTION_MOVETO,
															des="移动到",
															selectors={"moveCostTime","moveCostTime"},
															weight=1000
														}
													}
										-- type=NODE_ACTION,
										-- actionType=ACTION_MOVETO,
										-- des="移动到",
										-- weight=1000
									}

									,

									{
										type=BATTLE_CONST.NODE_AND,
										des="怒气头像",
										weight=980,
										children =  {
														{
															type=BATTLE_CONST.NODE_CONDITION,
															des="是否是怒气技能",
															p1="hasRageSkillBar",
															v1=true,
															conditionType=BATTLE_CONST.CONDITION_EQUAL,
															dtype="bool",
															weight=100
														}
														,
														{
															type=BATTLE_CONST.NODE_DECORATOR_CF,
															weight = 90,
															des="装饰节点",
															children = {

																			{
																				type=BATTLE_CONST.NODE_ACTION,
																				actionType=BATTLE_CONST.ACTION_RAGE_SKILL_BAR,
																				des="怒气头像",
																				selectors={"hasRageSkillBar","hasRageSkillBar","skillIconURL","iconURL","rageSkillHeadImgURL","imgURL","rageBarMusic","rageBarMusic"},
																				weight=99

																			}
																		}
														}

													}
									}
									,

									{
																		type=BATTLE_CONST.NODE_AND,
																		weight = 950,
																		des="曝气",
																		children = {



																							{
																								type=BATTLE_CONST.NODE_CONDITION,
																								des="是怒气技能",
																								p1="hasRagePingEffect",
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
																													des="爆豆特效",
																													actionType= BATTLE_CONST.ACTION_RAGE_FIRE,
																													weight=1000
																												}	
																											}

																  							}
																					}
									  											
									}

									,

									{
										type=BATTLE_CONST.NODE_PARALLEL_OR,
										-- actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
										des="attacker 同时播放 ",
										weight=900,
									  	children = 		  {

																{
																	type=BATTLE_CONST.NODE_AND,
																	des="技能名字",
																	weight=800,
																	children =  {
																					{
																						type=BATTLE_CONST.NODE_CONDITION,
																						des="是否是怒气技能",
																						p1="isRageSkill",
																						v1=true,
																						conditionType=BATTLE_CONST.CONDITION_EQUAL,
																						dtype="bool",
																						weight=100
																					}
																					,

																					-- {
																					-- 	type=BATTLE_CONST.NODE_CONDITION,
																					-- 	des="没有怒气技能头像",
																					-- 	p1="hasRageSkillBar",
																					-- 	v1=false,
																					-- 	conditionType=BATTLE_CONST.CONDITION_EQUAL,
																					-- 	dtype="bool",
																					-- 	weight=100
																					-- }
																					-- ,

																					{
																						type=BATTLE_CONST.NODE_CONDITION,
																						des="显示文本技能名称",
																						p1="isShowRageSkillNameLabel",
																						v1=true,
																						conditionType=BATTLE_CONST.CONDITION_EQUAL,
																						dtype="bool",
																						weight=100
																					}
																					,

																					
																					{
																						type=BATTLE_CONST.NODE_DECORATOR_CF,
																						weight = 90,
																						des="装饰节点",
																						children = {
																										{
																											type=BATTLE_CONST.NODE_ACTION,
																											actionType=BATTLE_CONST.ACTION_SHOW_SKILL_NAME,
																											des="技能名字",
																											selectors={"attackerUI","targetUI","skillName","skillName"},
																											weight=99

																										}
																									}
																					}
																					


																				}
																}




																,
																{
																			type=BATTLE_CONST.NODE_AND,
																			des="反击提示文字",
																			weight=930,
																			children = {	
																							{
																								
																								type=BATTLE_CONST.NODE_CONDITION,
																								des="如果是反击技能",
																								p1="isBeatBackSkill",
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
																														-- type=BATTLE_CONST.NODE_CUSTOM_ACTION,
																														type=BATTLE_CONST.NODE_ACTION,
																														actionType=BATTLE_CONST.ACTION_SHOW_BUFF_ADD_TIP,
																														des="buff解释",
																														selectors={"attackerUI","target","BeatTextName","tip"},
																														weight=1000
																													}
																												}
																	 
																				
																							}
																						}
																		-- }

													  					
													  			-- 	}



																}

																,

																 -- 攻击者的蓄力特效
																{
																	type=BATTLE_CONST.NODE_AND,
																	des="蓄力特效",
																	weight=920,
																	children = 		{
																							{
																								type=BATTLE_CONST.NODE_CONDITION,
																								des="有蓄力特效",
																								p1="hasRageFire",
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
																													des="蓄力特效",
																													selectors={"attackerUI","heroUI","rageFireEffect","animationName","rageFirePosition","atPostion"},
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
														  					-- 		{
																					-- 	type=BATTLE_CONST.NODE_ACTION,
																					-- 	des="攻击动作",
																					-- 	actionType= BATTLE_CONST.ACTION_PLAY_ATTACK_ACTION,
																					-- 	weight=990
																					-- }	

																					{
																						type=BATTLE_CONST.NODE_ACTION,
																						actionType=BATTLE_CONST.ACTION_XML_ANI_AT_HERO,
																						des="技能xml攻击动作",
																						-- selectors="attackerUI:heroUI,attackAnimation:animationName",
																						selectors={"attackerUI","heroUI","attackAnimation","animationName"},
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
																						type=BATTLE_CONST.NODE_ACTION ,
																						des="攻击动作触发",
																						actionType=BATTLE_CONST.ACTION_ATTACKER_TRIGGER,
																						weight=980
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
																						type=BATTLE_CONST.NODE_ACTION ,
																						des="攻击者怒气",
																						actionType=BATTLE_CONST.ACTION_BS_CHANGE_RAGE,
																						-- selectors="roundData:rageData",
																						selectors={"roundData","rageData"},
																						weight=980
																					}	
																				}
									  								
									  							}
					 
												 			}
									}
									-- ,

									-- {
									-- 	type=BATTLE_CONST.NODE_DECORATOR_CF,
									-- 	weight = 800,
									-- 	des="装饰节点",
									-- 	children = {
							  -- 							{
									-- 						type=BATTLE_CONST.NODE_ACTION,
									-- 						actionType=1,
									-- 						des="移动回",
									-- 						weight=980
									-- 					}	
									-- 				}

									-- }
									
								}
							}
							,
							-- 攻击者buff(攻击后buff)
							{
								 type=BATTLE_CONST.NODE_DECORATOR_CF,
								 weight = 800,
								 des="装饰节点",
																		children = {
															  							{
																							type=BATTLE_CONST.NODE_ACTION ,
																							des="攻击者技能动作后buff",
																							actionType=BATTLE_CONST.ACTION_PUSH_BUFF,
																							-- selectors="roundData:rageData",
																							selectors={"attacker","target","middleTimeValue","timeType","attackerbuffinfo","buffInfo"},
																							weight=980
																						}	
																					}
									  								

							}
							,

							-- {
							-- 	type=BATTLE_CONST.NODE_AND,
							-- 	des="移动延迟",
							-- 	weight=750,
							-- 	children =  {
							-- 					{
							-- 						type=BATTLE_CONST.NODE_CONDITION,
							-- 						des="技能是否需要移动",
							-- 						p1="needMove",
							-- 						v1=true,
							-- 						conditionType=BATTLE_CONST.CONDITION_EQUAL,
							-- 						dtype="bool",
							-- 						weight=100
							-- 					}
												 
							-- 					,
							-- 					{
							-- 						type=BATTLE_CONST.NODE_DECORATOR_CF,
							-- 						weight = 90,
							-- 						des="装饰节点",
							-- 						children = {
							-- 										{
							-- 											type=BATTLE_CONST.NODE_ACTION,
							-- 											actionType=BATTLE_CONST.ACTION_DELAY,
							-- 											des="延迟",
							-- 											selectors={"moveSkillDelay","total"},
							-- 											weight=99

							-- 										}
							-- 									}
							-- 					}
												


							-- 				}
							-- },

							{
								type=BATTLE_CONST.NODE_ACTION,
								actionType=BATTLE_CONST.ACTION_NODE_END,
								des="AttackLogicData 结束",
								weight=700,
							}
						}
					}
end
