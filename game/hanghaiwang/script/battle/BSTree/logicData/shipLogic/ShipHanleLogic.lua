-- 技能
module("ShipHanleLogic",package.seeall)

-- function getInterestEventList()
-- 	return nil
-- end

function getLogicData()
			return  {	
						type=BATTLE_CONST.NODE_OR,
						des="攻击者技能释放",
						weight=1000,
						children={

										{

											type=BATTLE_CONST.NODE_PARALLEL_OR ,
											weight=900,
											des="技能组合",
											children = 	
														{
															{

																type=BATTLE_CONST.NODE_OR,
																des="显示逻辑",
																weight=1000,
																children=	{
																				
																						{
																									type=BATTLE_CONST.NODE_AND,
																									des="如果发射子弹",
																									weight=2000,
																									children =  
																												{
																															{
																																type=BATTLE_CONST.NODE_CONDITION,
																																des="如果有弹道",
																																p1="isFireBullet",
																																v1=true,
																																conditionType=4,
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
																																					actionType=BATTLE_CONST.SHIP_ACTION_REMOTE_FIRE,
																																					selectors = {"gravityOfPoint","toPosition","isBulletOnEvery","isBulletAtEveryOne","distancePathName","distancePathName","underAttackers","underAttackers","attackerUI","attackerUI"},
																																					des="远程打击",
																																					weight=900
																																				}
																								  											}
																							  								}

																												}
																						}

																						,
																						{
																							type=BATTLE_CONST.NODE_AND,
																							des="技能特效",
																							weight=1500,
																							children =  
																										{
																													{
																																type=BATTLE_CONST.NODE_CONDITION,
																																des="如果有技能特效",
																																p1="hasBulletSkillEff",
																																v1=true,
																																conditionType=4,
																																dtype="bool",
																																weight=1000
																													}
																													,
																													{

																																type=BATTLE_CONST.NODE_PARALLEL_OR ,
																																weight=900,
																																des="技能特效",
																																children = 	{
																																						{
																																								type=BATTLE_CONST.NODE_AND,
																																								des="每个对象都有一个特效",
																																								weight=900,
																																								children =  
																																											{

																																													{
																																																type=BATTLE_CONST.NODE_CONDITION,
																																																des="如果特效类型为每个人",
																																																p1="isEffOnEveryOne",
																																																v1=true,
																																																conditionType=4,
																																																dtype="bool",
																																																weight=1000
																																													}
																																													,
																																													
																																													{
																																														type=BATTLE_CONST.NODE_DECORATOR_CF,
																																														weight = 90,
																																														des="装饰节点",
																																														children = {
																																																		{
																																																			type=BATTLE_CONST.NODE_ACTION,
																																																			actionType=BATTLE_CONST.SHIP_ACTION_PLAY_EFFECT_AT_TARGETS,
																																																			des="每个人特效",
																																																			selectors={"targetsUI","targets","skillEffectName","animationName"},
																																																			weight=99

																																																		}
																																																	}
																																													}
																																											}

																																							}
																																							,

																																							{
																																								type=BATTLE_CONST.NODE_AND,
																																								des="目标中心位置播发特效",
																																								weight=800,
																																								children =  
																																											{

																																													{
																																																type=BATTLE_CONST.NODE_CONDITION,
																																																des="如果特效类型为每个人",
																																																p1="isEffOnCenter",
																																																v1=true,
																																																conditionType=4,
																																																dtype="bool",
																																																weight=1000
																																													}
																																													,

																																													{
																																														type=BATTLE_CONST.NODE_DECORATOR_CF,
																																														weight = 90,
																																														des="装饰节点",
																																														children = {
																																																		{
																																																			type=BATTLE_CONST.NODE_ACTION,
																																																			actionType=BATTLE_CONST.ACTION_PLAY_EFFECT_AT_POSITION,
																																																			des="技能特效(敌方居中)",
																																																			selectors={"skillEffectPosX","postionX","skillEffectPosY","postionY","skillEffectName","animationName"},
																																																			weight=99

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
																									des="蓄力技能",
																									weight=1400,
																									children =  
																												{
																							
																														{
																															type=BATTLE_CONST.NODE_CONDITION,
																															des="蓄力技能",
																															p1="isAaccumulateSkill",
																															v1=true,
																															conditionType=4,
																															dtype="bool",
																															weight=1000
																														}

																														,
																														-- {
																														-- 		type=BATTLE_CONST.NODE_PARALLEL_OR ,
																														-- 		weight=900,
																														-- 		des="蓄力",
																														-- 		children = 	{

																														{
																															type=BATTLE_CONST.NODE_DECORATOR_CF,
																															weight = 900,
																															des="蓄力特效",
																															children = {
																																			{
																																				type=BATTLE_CONST.NODE_ACTION,
																																				actionType=BATTLE_CONST.SHIP_ACTION_PLAY_ANIMATION_AT_SHIP,
																																				des="蓄力特效",
																																				selectors={"aaccumulateEffRotation","rotation","shipUI","shipUI","aaccumulateEff","animationName"},
																																				weight=99

																																			}
																																		}
																														}
																																				-- ,
																																				-- {
																													  					-- 			type=BATTLE_CONST.NODE_DECORATOR_CF,
																													  					-- 			weight = 900,
																													  					-- 			des="装饰节点",
																													  					-- 			children = {
																														  				-- 							{
																																			 --  							type=BATTLE_CONST.NODE_ACTION,
																																				-- 						actionType=BATTLE_CONST.SHIP_ACTION_ANIMATION_DAMAGE_TRIGER,
																																				-- 						des="伤害触发器",
																																				-- 						weight=1000
																																				-- 					}
																													  					-- 						}
																																				-- }

																																			-- }
																														-- }
																												}

																						}
																						-- ,
																						-- {			-- 一般技能就是什么都不做,直接出发击中和伤害,一般是给子技能用的
																						-- 			type=BATTLE_CONST.NODE_AND,
																						-- 			des="一般技能",
																						-- 			weight=1300,
																						-- 			children =  
																						-- 						{

																						-- 								{
																						-- 									type=BATTLE_CONST.NODE_CONDITION,
																						-- 									des="一般技能",
																						-- 									p1="isNormalSkill",
																						-- 									v1=true,
																						-- 									conditionType=4,
																						-- 									dtype="bool",
																						-- 									weight=1000
																						-- 								}

																						-- 								,

																						-- 								-- {
																						-- 								-- 	type=BATTLE_CONST.NODE_PARALLEL_OR ,
																						-- 								-- 	weight=900,
																						-- 								-- 	des="释放技能",
																						-- 								-- 	children = 		{
																						-- 	  							{
																						-- 	  								type=BATTLE_CONST.NODE_DECORATOR_CF,
																						-- 	  								weight = 900,
																						-- 	  								des="装饰节点",
																						-- 	  								children = {
																						-- 		  											{
																						-- 							  							type=BATTLE_CONST.NODE_ACTION,
																						-- 														actionType=BATTLE_CONST.ACTION_SKILL_SPELL_ATTACK,
																						-- 														des="一般技能打击",
																						-- 														weight=1000
																						-- 													}
																						-- 	  											}
																						-- 	  							}

																						-- 					}
																						-- }

																			}
															}
															,
															{
																type=BATTLE_CONST.NODE_DECORATOR_CF,
								  								weight = 900,
								  								des="数据逻辑(伤害触发)",
								  								children = {
																				{														  							
														  							type=BATTLE_CONST.NODE_ACTION,
																					actionType=BATTLE_CONST.SHIP_ACTION_ANIMATION_DAMAGE_TRIGER,
																					des="伤害触发",
																					selectors = {"underAttackers","underAttackers","skillEffectName","animationName","skillDelayStart","delayStart","eachDelay","eachDelay"},
																					weight=900
																				}
								  											}
							  								}
														}
										}
								}


					}
end
