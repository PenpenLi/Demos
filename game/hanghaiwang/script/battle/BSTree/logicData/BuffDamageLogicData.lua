module("BuffDamageLogicData",package.seeall)
-- function getInterestEventList()
-- 	return nil
-- end
function getLogicData(   )
		return  {
					 

						type=BATTLE_CONST.NODE_OR,
						des="buff伤害",
						weight= 1000,
						children= 	{
											{
												-- buff伤害组合
												type=BATTLE_CONST.NODE_PARALLEL_OR,
												des="buff伤害组合",
												weight= 1000,
												children=
															{

																{
																	type=BATTLE_CONST.NODE_AND,
																	des="伤害特效",
																	weight=1000,
																	children= 
																				{
																						{
																							type=BATTLE_CONST.NODE_CONDITION,
																							des="有buff伤害特效",
																							p1="hasDamageAnimation",
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
																												des="buff伤害特效",
																												--ps="1,2",
																												selectors={"attackerUI","heroUI","damageEffectName","animationName"},
																												weight=1000
																											}
																										}
																			 
																						} 
																				}
																}
																,






																{

																			type=BATTLE_CONST.NODE_AND,
																			des="死亡动作",
																			weight=910,
																			children= 	{


																									{
																										type=BATTLE_CONST.NODE_CONDITION,
																										des="死亡",
																										p1="willDie",
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
																															actionType=BATTLE_CONST.ACTION_BS_DIE,
																															des="死亡BSTree",
																															selectors={"target","target"},
																															weight=1000
																														}
																													}
																						 
																									} 



																						}
																}
																,




																{
																	type=BATTLE_CONST.NODE_AND,
																	des="人物受伤动作",
																	weight=900,
																	children= 
																				{

																						{
																							type=BATTLE_CONST.NODE_CONDITION,
																							des="死亡",
																							p1="willDie",
																							v1=false,
																							conditionType=BATTLE_CONST.CONDITION_EQUAL,
																							dtype="bool",
																							weight=1000
																						}
																						,
																						{
																							type=BATTLE_CONST.NODE_CONDITION,
																							des="是否播放人物动作",
																							p1="hasBuffAction",
																							v1=true,
																							conditionType=BATTLE_CONST.CONDITION_EQUAL,
																							dtype="bool",
																							weight=1100
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
																												des="人物buff受伤动作",
																												selectors={"attackerUI","heroUI","damageActionName","animationName"},
																												weight=1000
																											}
																										}
																			 
																						} 

																				}
																}
																,
																-- 策划要求buff伤害为0时需要显示
																{
																	type=BATTLE_CONST.NODE_AND,
																	des="伤害相关动画",
																	weight=950,
																	children= {
																						-- {
																						-- 	type=BATTLE_CONST.NODE_CONDITION,
																						-- 	des="没有怒气伤害",
																						-- 	p1="hasRageDamage",
																						-- 	v1=false,
																						-- 	conditionType=BATTLE_CONST.CONDITION_EQUAL,
																						-- 	dtype="bool",
																						-- 	weight=1000
																						-- }
																						-- ,
																						{
																							type=BATTLE_CONST.NODE_CONDITION,
																							des="没有hp rage 伤害值", --这里是为了防止多重显示
																							p1="hasDamage",
																							v1=false,
																							conditionType=BATTLE_CONST.CONDITION_EQUAL,
																							dtype="bool",
																							weight=9000
																						}
																						,
																						{
																							type=BATTLE_CONST.NODE_DECORATOR_CF,
																							weight = 8000,
																							des="装饰节点",
																							children = {
																											{
																												type=BATTLE_CONST.NODE_ACTION,
																												actionType=BATTLE_CONST.ACTION_SHOW_NUMBER,
																												des="伤害数字显示",
																												-- ps="1,4,5,8",
																												selectors={"attackerUI","heroUI","buffDamageTitle","title","hpDamage","value","hpNumberColor","color","showHpSign","showSign","showZero","showZero"},
																												weight=1000
																											}
																										}
																						}
																				}
																}
																						

																,
																{
																	type=BATTLE_CONST.NODE_AND,
																	des="伤害相关动画",
																	weight=800,
																	children= 
																				{
																						 {
																							type=BATTLE_CONST.NODE_CONDITION,
																							des="有buff伤害",
																							p1="hasDamage",
																							v1=true,
																							conditionType=BATTLE_CONST.CONDITION_EQUAL,
																							dtype="bool",
																							weight=1000
																						}
																						-- ,
																						-- -- 策划要求buff伤害为0时需要显示
																						-- {
																						-- 	type=BATTLE_CONST.NODE_AND,
																						-- 	des="伤害相关动画",
																						-- 	weight=950,
																						-- 	children= {
																						-- 						-- {
																						-- 						-- 	type=BATTLE_CONST.NODE_CONDITION,
																						-- 						-- 	des="没有怒气伤害",
																						-- 						-- 	p1="hasRageDamage",
																						-- 						-- 	v1=false,
																						-- 						-- 	conditionType=BATTLE_CONST.CONDITION_EQUAL,
																						-- 						-- 	dtype="bool",
																						-- 						-- 	weight=1000
																						-- 						-- }
																						-- 						-- ,
																						-- 						{
																						-- 							type=BATTLE_CONST.NODE_CONDITION,
																						-- 							des="没有hp rage 伤害值", --这里是为了防止多重显示
																						-- 							p1="hasDamage",
																						-- 							v1=false,
																						-- 							conditionType=BATTLE_CONST.CONDITION_EQUAL,
																						-- 							dtype="bool",
																						-- 							weight=9000
																						-- 						}
																						-- 						,
																						-- 						{
																						-- 							type=BATTLE_CONST.NODE_DECORATOR_CF,
																						-- 							weight = 8000,
																						-- 							des="装饰节点",
																						-- 							children = {
																						-- 											{
																						-- 												type=BATTLE_CONST.NODE_ACTION,
																						-- 												actionType=BATTLE_CONST.ACTION_SHOW_NUMBER,
																						-- 												des="伤害数字显示",
																						-- 												-- ps="1,4,5,8",
																						-- 												selectors={"attackerUI","heroUI","buffDamageTitle","title","hpDamage","value","hpNumberColor","color","showHpSign","showSign","showZero","showZero"},
																						-- 												weight=1000
																						-- 											}
																						-- 										}
																						-- 						}
																						-- 				}
																						-- }
																						,
																						{
																							type=BATTLE_CONST.NODE_PARALLEL_OR,
																							des="有buff伤害or",
																							weight= 900,
																							children=
																									{
																											{
																												type=BATTLE_CONST.NODE_AND,
																												des="hp伤害相关动画",
																												weight=800,
																												children = 
																															{
																																{
																																
																																	type=BATTLE_CONST.NODE_CONDITION,
																																	des="有hp伤害",
																																	p1="hasHpDamage",
																																	v1=true,
																																	conditionType=BATTLE_CONST.CONDITION_EQUAL,
																																	dtype="bool",
																																	weight=1000
																											 
																																}
																																,

																																{
																																	type=BATTLE_CONST.NODE_PARALLEL_OR,
																																	des="害数字,血条",
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
																																											actionType=BATTLE_CONST.ACTION_CHANGE_HP,
																																											des="伤害数据",
																																											-- ps="1,4,5,8",
																																											selectors={"target","target","hpDamage","value"},
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
																																											actionType=BATTLE_CONST.ACTION_SHOW_NUMBER,
																																											des="伤害数字显示",
																																											-- ps="1,4,5,8",
																																											selectors={"attackerUI","heroUI","buffDamageTitle","title","hpDamage","value","hpNumberColor","color","showHpSign","showSign"},
																																											weight=1000
																																										}
																																									}
																																					}
																																					-- , buffui改变已经融合到了hp数值变化中 

																																					-- {
																																					-- 	type=BATTLE_CONST.NODE_DECORATOR_CF,
																																					-- 	weight = 900,
																																					-- 	des="装饰节点",
																																					-- 	children = {
																																					-- 					{
																																					-- 						type=BATTLE_CONST.NODE_ACTION,
																																					-- 						actionType=BATTLE_CONST.ACTION_HP_BAR_CHANGE,
																																					-- 						des="buff血条",
 
																																					-- 						-- selectors={"attackerUI","heroUI","hpDamage","value"},
																																					-- 						selectors={"target","target","hpDamage","value"},
																																											
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
																												-- rage
																												type=BATTLE_CONST.NODE_AND,
																												des="rage伤害相关动画",
																												weight=800,
																												children = 
																															{

																																{
																																	type=BATTLE_CONST.NODE_CONDITION,
																																	des="有怒气伤害",
																																	p1="hasRageDamage",
																																	v1=true,
																																	conditionType=BATTLE_CONST.CONDITION_EQUAL,
																																	dtype="bool",
																																	weight=1000
																																}
																																,
																																{





																																	type=BATTLE_CONST.NODE_PARALLEL_OR,
																																	des="怒气动画,伤害数值",
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
																																										-- 应策划需求 怒气改为必须播放完毕才结束
																																										-- type=BATTLE_CONST.NODE_INSTANT_ACTION,
																																										actionType=BATTLE_CONST.ACTION_RAGE_CHANGE_ANI,
																																										des="怒气变化动画",
																																										--ps="1,6",
																																										selectors={"attackerUI","target","rageDamage","value","rageUp","rageUp"},
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
																																										-- actionType=BATTLE_CONST.ACTION_RAGE_BAR_CHANGE,
																																										actionType=BATTLE_CONST.ACTION_CHANGE_RAGE,
																																										
																																										des="怒气改变",
																																										selectors={"target","target","rageDamage","value"},
																																										--ps="attackerUI:heroUI,rageDamage:value",
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

																				}
																}
															}

											}
											,
											{
												-- 结束
												type=BATTLE_CONST.NODE_ACTION,
												actionType=BATTLE_CONST.ACTION_NODE_END,
												des="buff伤害结束",
												weight=900
											}

									}
					 
				}

	end
