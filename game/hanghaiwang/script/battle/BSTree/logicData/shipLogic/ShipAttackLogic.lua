
-- 主船回合
module("ShipAttackLogic",package.seeall)

function getLogicData()
		return {
						type=BATTLE_CONST.NODE_OR,
						des="攻击者技能释放",
						weight=3000,
						children={
										-- 同时 暂时不显示 todo
											-- 主船ui属性显示
											-- 初始化主船(船体,炮管)
										{
											type=BATTLE_CONST.NODE_PARALLEL_OR,
											-- actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
											des="attacker 同时播放 ",
											weight=3000,
										  	children = 		{
										  								{
																			type=BATTLE_CONST.NODE_AND,
																			des="显示主船信息",
																			weight=3000,
																			children =  {

																							{
																								type=BATTLE_CONST.NODE_CONDITION,
																								des="是否显示主船信息",
																								p1="isShowShipInfo",
																								v1=true,
																								conditionType=BATTLE_CONST.CONDITION_EQUAL,
																								dtype="bool",
																								weight=100
																							}
																							,
																							-- 主船ui属性显示
																							{
																								type=BATTLE_CONST.NODE_DECORATOR_CF,
																								weight = 90,
																								des="装饰节点",
																								children = {
																												{
																													type=BATTLE_CONST.NODE_ACTION,
																													actionType=BATTLE_CONST.SHIP_ACTION_SHOW_SHIP_INFO,
																													des="主船ui属性显示",
																													selectors={"shipInfoSound","soundName","teamid","teamid"},
																													weight=99

																												}
																													

															  												}
															  								}
															  							}
															  			}

										  								,
																		{
																			type=BATTLE_CONST.NODE_AND,
																			des="显示战斗力提升",
																			weight=2000,
																			children =  {

																							{
																								type=BATTLE_CONST.NODE_CONDITION,
																								des="是否显示战斗力提升",
																								p1="isShowFightUp",
																								v1=true,
																								conditionType=BATTLE_CONST.CONDITION_EQUAL,
																								dtype="bool",
																								weight=1000
																							}
																							,

																							{
																								type=BATTLE_CONST.NODE_OR,
																								-- actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
																								des="战斗力提升动画 ",
																								weight=800,
																							  	children = 	{

																							  					{
																													type=BATTLE_CONST.NODE_DECORATOR_CF,
																													weight = 100,
																													des="延迟",
																													children = {
																																	{
																																		type=BATTLE_CONST.NODE_ACTION,
																																		actionType=BATTLE_CONST.ACTION_DELAY,
																																		des="延迟",
																																		selectors={"shipInfoKeyTime","total"},
																																		weight=99

																																	}
																																}
																												}
																												,
																							  					-- 主船ui属性显示
																												{
																													type=BATTLE_CONST.NODE_DECORATOR_CF,
																													weight = 90,
																													des="装饰节点",
																													children = {
																																	{
																																		type=BATTLE_CONST.NODE_ACTION,
																																		actionType=BATTLE_CONST.SHIP_ACTION_SHOW_TEAM_FIGHT_UP,
																																		des="是否显示战斗力提升",
																																		selectors={"teamid","teamid"},
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
										-- 入场动画
										{
											type=BATTLE_CONST.NODE_OR,
											des="入场动画",
											weight=1800,
											children={
																	-- 根据入场动画类型播放动画

																	{
																			type=BATTLE_CONST.NODE_AND,
																			des="驶入",
																			weight=800,
																			children =  {
																							{
																								type=BATTLE_CONST.NODE_CONDITION,
																								des="是否是驶入入场方式",
																								p1="isMoveInStyle",
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
																													actionType=BATTLE_CONST.SHIP_ACTION_ENTER_SCENCE,
																													des="入场",
																													selectors={"enterSceneSound","enterSceneSound","shipUI","shipUI"},
																													weight=99

																												}
																											}
																							}
																							


																						}
																	}
																	-- 还可以支持其他方式,不过暂时就一个
													  }
										}
										,

 
										-- 如果是主船射击技能	
										-- 瞄准动作
											-- 主船炮旋转
											-- 瞄准镜动画
										
										{
											type=BATTLE_CONST.NODE_PARALLEL_OR,
											-- actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
											des="主船瞄准 ",
											weight=850,
										  	children = 		{





																			{
																					type=BATTLE_CONST.NODE_AND,
																					des="瞄准",
																					weight=800,
																					children =  {
																									{
																										type=BATTLE_CONST.NODE_CONDITION,
																										des="是否是旋转瞄准射击模式",
																										p1="isRotationAimStyle",
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
																															actionType=BATTLE_CONST.SHIP_ACTION_ROTATION_GUN,
																															des="瞄准动作",
																															selectors={"rotationSound","soundName","gunUI","gunUI","rotationTo","rotationTo"},
																															weight=99

																														}
																													}
																									}
																									


																								}
																			}
																			,
																			{
																						type=BATTLE_CONST.NODE_AND,
																						des="瞄准特效-只有中间有",
																						weight=750,
																						children =  {
																										{
																											type=BATTLE_CONST.NODE_CONDITION,
																											des="是否只显示1个居中瞄准",
																											p1="isAimEffAtCenter",
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
																																actionType=BATTLE_CONST.ACTION_PLAY_EFFECT_AT_POSITION,
																																des="单一瞄准特效(敌方居中)",
																																selectors={"aimCenterX","postionX","aimCenterY","postionY","aimAnimation","animationName"},
																																weight=99

																															}
																														}
																										}
																										


																									}
																			}
																			,
																			{
																						type=BATTLE_CONST.NODE_AND,
																						des="瞄准特效--每个人都有瞄准特效",
																						weight=740,
																						children =  {
																										{
																											type=BATTLE_CONST.NODE_CONDITION,
																											des="是否只显示1个居中瞄准",
																											p1="isAimEffOnEvery",
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
																																actionType=BATTLE_CONST.SHIP_ACTION_PLAY_EFFECT_AT_TARGETS,
																																des="每个人特效",
																																selectors={"targetsUI","targets","aimAnimationName","animationName"},
																																weight=99

																															}
																														}
																										}
																										


																									}
																			}
																			,
																			{
																						type=BATTLE_CONST.NODE_AND,
																						des="显示技能名称",
																						weight=700,
																						children =  {
																										{
																											type=BATTLE_CONST.NODE_CONDITION,
																											des="是否显示技能名称",
																											p1="isShowSkillName",
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
																																actionType=BATTLE_CONST.SHIP_ACTION_SHOW_SKILL_NAME,
																																des="技能名显示",
																																selectors={"skillNamePosX","posX","skillNamePosY","posY","skillNameImg","skillNameImageName"},
																																weight=99

																															}
																														}
																										}
																										


																									}
																			}


										  					}

										}
										-- 射击动画
										,
										{
											type=BATTLE_CONST.NODE_AND,
											des="发射炮弹",
											weight=740,
											children =  {
															{
																type=BATTLE_CONST.NODE_CONDITION,
																des="如果是发射炮弹",
																p1="isFireBulletSkill",
																v1=true,
																conditionType=BATTLE_CONST.CONDITION_EQUAL,
																dtype="bool",
																weight=100
															}
															,

															{
																type=BATTLE_CONST.NODE_PARALLEL_OR,
																-- actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
																des="射击 ",
																weight=800,
															  	children = 		{

															  						
																					{
																						type=BATTLE_CONST.NODE_DECORATOR_CF,
																						weight = 1000,
																						des="射击特效",
																						children = {
																										{
																											type=BATTLE_CONST.NODE_ACTION,
																											actionType=BATTLE_CONST.SHIP_ACTION_PLAY_GUN_ANIMATION,
																											des="播放射击动画",
																											selectors={"fireActionName","animationName","shipUI","shipUI"},
																											weight=99

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
																						weight = 100,
																						des="射击特效(炮口冒烟等)",
																						children = {
																										{
																											type=BATTLE_CONST.NODE_ACTION,
																											actionType=BATTLE_CONST.SHIP_ACTION_PLAY_ANIMATION_AT_SHIP,
																											des="射击特效(炮口冒烟等)",
																											selectors={"muzzleEffectSound","soundName","muzzleEffectRotation","rotation", "shipUI","shipUI","muzzleEffect","animationName"},
																											weight=99

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
											des="蓄力",
											weight=740,
											children =  {
															{
																type=BATTLE_CONST.NODE_CONDITION,
																des="如果是蓄力",
																p1="isAaccumulateSkill",
																v1=true,
																conditionType=BATTLE_CONST.CONDITION_EQUAL,
																dtype="bool",
																weight=100
															}
															,

															{
																type=BATTLE_CONST.NODE_PARALLEL_OR,
																-- actionType=ACTION_RUN_ACTION_IN_SAME_TIME,
																des="蓄力特效延迟",
																weight=800,
															  	children = 		{

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
																						weight = 100,
																						des="延迟",
																						children = {
																										{
																											type=BATTLE_CONST.NODE_ACTION,
																											actionType=BATTLE_CONST.ACTION_DELAY,
																											des="延迟",
																											selectors={"aaccumulateEffTime","total"},
																											weight=99

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
											weight = 700,
											des="装饰节点",
											children = {
															{
																type=BATTLE_CONST.NODE_ACTION,
																actionType=BATTLE_CONST.SHIP_ACTION_QUIT_SCENCE,
																des="退场",
																selectors={"shipUI","shipUI"},
																weight=99

															}
														}
										}
										-- 如果是主船射击技能	
											-- 瞄准动作
												-- 主船炮旋转
												-- 瞄准镜动画
											-- 射击动画

										-- 退场动画
											-- 根据退场动画类型播放动画
										
										,

										{
											type=BATTLE_CONST.NODE_ACTION,
											actionType=BATTLE_CONST.ACTION_NODE_END,
											des="shipAttackLogicData 结束",
											weight=600,
										}

								 }

				}
end