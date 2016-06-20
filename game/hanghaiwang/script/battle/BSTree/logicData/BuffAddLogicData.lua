module("BuffAddLogicData",package.seeall)

-- function getInterestEventList()
-- 	return nil
-- end

	function getLogicData( ... )
		return  {

						type=BATTLE_CONST.NODE_OR,
						des="添加buff",
						children={
									{
										type=BATTLE_CONST.NODE_AND,
										des="buff添加特效",
										weight=990,
										children = {
														{
															type=BATTLE_CONST.NODE_CONDITION,
															des="有buff添加特效",
															p1="hasAddBuffEff",
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
																				selectors={"heroUI","heroUI","addEffectName","animationName","addSound","soundName"},
																				des="buff添加特效action",
																				weight=1000
																			}
																		}
											 
														} 
											
													}
									}
									,
									{
										type=BATTLE_CONST.NODE_AND,
										des="添加buff图标",
										weight=980,
										children = {
														{
															type=BATTLE_CONST.NODE_CONDITION,
															des="需要添加buff图标",
															p1="needAddIcon",
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
																				actionType=BATTLE_CONST.ACTION_ADD_BUFF_ICON,
																				des="添加buff图标",
																				weight=1000
																			}
																		}
											 
														} 
											
													}										
									}
									,


									{
										type=BATTLE_CONST.NODE_AND,
										des="buff添加解释图片",
										weight=970,
										children = {
														{
															type=BATTLE_CONST.NODE_CONDITION,
															des="有解释图片",
															p1="hasAddBuffTip",
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
																				type=BATTLE_CONST.NODE_CUSTOM_ACTION,
																				-- type=BATTLE_CONST.NODE_ACTION,
																				actionType=BATTLE_CONST.ACTION_SHOW_BUFF_ADD_TIP,
																				des="buff解释",
																				selectors={"heroUI","target","addTip","tip"},
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
										des="buffAddLogicData 结束",
										weight=900,
									}

								}
				}
	end