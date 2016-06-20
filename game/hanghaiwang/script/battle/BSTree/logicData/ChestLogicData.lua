

-- 攻击
module("ChestLogicData",package.seeall)

-- function getInterestEventList()
-- 	return nil
-- end

function getLogicData()
	return {
						type=BATTLE_CONST.NODE_OR,
						des="宝箱飞逻辑",
						weight=1000,
						children={

										{
											type=BATTLE_CONST.NODE_AND,
											des="是否有宝箱掉落",
											weight=980,
											children =  {
															{
																type=BATTLE_CONST.NODE_CONDITION,
																des="if有宝箱掉落",
																p1="hasItemDrop",
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
																					des="物品掉落及飞",
																					selectors={"hasRageSkillBar","hasRageSkillBar","skillIconURL","iconURL","rageSkillHeadImgURL","imgURL","rageBarMusic","rageBarMusic"},
																					weight=99

																				}
																			}
															}

														}
										}
									 
										  
								  }
			}
end