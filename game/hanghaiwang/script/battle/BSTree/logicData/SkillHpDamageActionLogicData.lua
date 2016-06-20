
module("SkillHpDamageActionLogicData",package.seeall)

-- function getInterestEventList()
-- 	return nil
-- end

function getLogicData(   )
		return  {
					type=BATTLE_CONST.NODE_OR,
						des="SkillHpDamageActionLogicData",
						children={
										{
												-- buff伤害组合
												type=BATTLE_CONST.NODE_PARALLEL_OR,
												des="SkillHpDamage英雄伤害动作组合",
												weight= 1000,
												children=
														{			
																	{
																				type=BATTLE_CONST.NODE_AND,
																				des="击中效果",
																				weight=2000,
																				children= 
																							{
																									{
																										type=BATTLE_CONST.NODE_CONDITION,
																										des="显示击中效果",
																										p1="showHitEffect",
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
																															des="击中特效",
																															--ps="1,2",
																															selectors={"targetUI","heroUI","attackHitEffectName","animationName"},
																															weight=1000
																														}
																													}
																									}
																							}

																		
																	}
																	,
																	{


																				type=BATTLE_CONST.NODE_AND,
																				des="伤害数据",
																				weight=1000,
																				children= 
																							{
																									{
																										type=BATTLE_CONST.NODE_CONDITION,
																										des="有伤害数据",
																										p1="hasHpDamage",
																										v1=true,
																										conditionType=BATTLE_CONST.CONDITION_EQUAL,
																										dtype="bool",
																										weight=1000
																									}
																									,
																									{
																										type=BATTLE_CONST.NODE_PARALLEL_OR,
																										des="伤害显示组合",
																										weight= 900,
																										children= 	{

																														{	
																															type=BATTLE_CONST.NODE_DECORATOR_CF,
																															weight = 900,
																															des="装饰节点",
																															children = {
																																			{
																																				type=BATTLE_CONST.NODE_ACTION,
																																				actionType=BATTLE_CONST.ACTION_CHANGE_HP,
																																				des="伤害数据action",
																																				--ps="1,2",
																																				selectors={"target","target","value","value"},
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
																																				type=BATTLE_CONST.NODE_INSTANT_ACTION,
																																				actionType=BATTLE_CONST.ACTION_SHOW_NUMBER,
																																				des="伤害数字显示",
																																				-- ps="1,4,5,8",
																																				selectors={"targetUI","heroUI","damageShowNumber","value","color","color","skillDamageTitle","title","isMulityTime","isMulityTime","isLastMulityTime","isLastMulityTime","isFatal","isFatal"}, -- ,hpNumberColor:color
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
																																selectors={"target","target","skill","skill"},
																																weight=1000
																															}
																														}
																							 
																										} 



																							}
																	}
																	,
																	{

																				type=BATTLE_CONST.NODE_AND,
																				des="xml动作",
																				weight=900,
																				children= 
																							{		-- 如果没有死亡
																									{
																										type=BATTLE_CONST.NODE_CONDITION,
																										des="死亡",
																										p1="willDie",
																										v1=false,
																										conditionType=BATTLE_CONST.CONDITION_EQUAL,
																										dtype="bool",
																										weight=1100
																									}
																									,
																									{
																										type=BATTLE_CONST.NODE_CONDITION,
																										des="有xml动画",
																										p1="hasXMLAnimation",
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
																															des="受伤害xml动画",
																															--ps="1,2",
																															selectors={"targetUI","heroUI","xmlAnimationName","animationName"},
																															weight=1000
																														}
																													}
																						 
																									} 

																							}
																	}
																	,
																	{

																				type=BATTLE_CONST.NODE_AND,
																				des="reaction动画",
																				weight=800,
																				children= 
																							{
																									{
																										type=BATTLE_CONST.NODE_CONDITION,
																										des="有reaction动画(格挡,反击等文字动画)",
																										p1="hasReactionLabelAnimation",
																										v1=true,
																										conditionType=BATTLE_CONST.CONDITION_EQUAL,
																										dtype="bool",
																										weight=1000
																									}
																									,
																									{
																										type=BATTLE_CONST.NODE_CONDITION,
																										des="多段的第一次伤害",
																										p1="isFirstTime",
																										v1=true,
																										conditionType=BATTLE_CONST.CONDITION_EQUAL,
																										dtype="bool",
																										weight=950
																									}
																									,
																									
																									{	
																										type=BATTLE_CONST.NODE_DECORATOR_CF,
																										weight = 900,
																										des="装饰节点",
																										children = {
																														{
																															type=BATTLE_CONST.NODE_INSTANT_ACTION,
																															actionType=BATTLE_CONST.ACTION_REACTION_ANI,
																															des="reaction动画",
																															--ps="1,2",
																															selectors={"targetUI","target","reactionLabelAnimationName","reactionBitmapPath"},
																															weight=1000
																														}
																													}
																						 
																									} 

																							}
																	}
																	,
																	{

																				type=BATTLE_CONST.NODE_AND,
																				des="reactionextra动画",
																				weight=700,
																				children= 
																							{
																									{
																										type=BATTLE_CONST.NODE_CONDITION,
																										des="reaction额外特效",
																										p1="hasReactionAnimation",
																										v1=true,
																										conditionType=BATTLE_CONST.CONDITION_EQUAL,
																										dtype="bool",
																										weight=1000
																									}
																									,
																									{
																										type=BATTLE_CONST.NODE_CONDITION,
																										des="是否显示反击特效",
																										p1="showBlockReactionAnimation",
																										v1=true,
																										conditionType=BATTLE_CONST.CONDITION_EQUAL,
																										dtype="bool",
																										weight=2000

																									}
																									
																									,
																									{	
																										type=BATTLE_CONST.NODE_DECORATOR_CF,
																										weight = 900,
																										des="装饰节点",
																										children = {
																														{
																															type=BATTLE_CONST.NODE_INSTANT_ACTION,
																															actionType=BATTLE_CONST.ACTION_EFFECT_AT_HERO,
																															des="reaction动画",
																															--ps="1,2",
																															selectors={"targetUI","heroUI","reactionEffectName","animationName"},
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
												-- 结束
												type=BATTLE_CONST.NODE_ACTION,
												actionType=BATTLE_CONST.ACTION_NODE_END,
												des="DamageActionLogicData 结束",
												weight=900
										}
								 }
				}
end