
module("BenchShowLogic",package.seeall)


function getLogicData( ... )
 	return {

						type=BATTLE_CONST.NODE_OR,
						des="替补上场",
						children={
									{
										type=BATTLE_CONST.NODE_PARALLEL_OR,
										des="上场动作 同时播放 ",
										weight=900,
									  	children =  {
														{
																-- 显示激活必须要在数据激活之前
																-- 替补显示数据激活(不显示,同时被替换人消失)
																type=BATTLE_CONST.NODE_DECORATOR_CF,
																weight = 1000,
																des="装饰节点",
																children = {
																					{
																						type=BATTLE_CONST.NODE_ACTION,
																						actionType=BATTLE_CONST.ACTION_ACTIVE_BENCH_DISPLAY_DATA,
																						des="替补显示数据激活",
																						selectors={"benchID","hid","benchPosition","position","teamid","teamid"},
																						weight=1000
																					}
																			}
														}
														,
														{
															-- 替补数据激活
															type=BATTLE_CONST.NODE_DECORATOR_CF,
															weight = 900,
															des="装饰节点",
															children = {
																				{
																					type=BATTLE_CONST.NODE_ACTION,
																					actionType=BATTLE_CONST.ACTION_ACTIVE_BENCH_DATA,
																					des="替补数据激活",
																					selectors={"benchID","hid","benchPosition","position","teamid","teamid"},
																					weight=1000
																				}
																		}


														}
														,
									  					{
															-- 指定位置播放出场特效
															type=BATTLE_CONST.NODE_DECORATOR_CF,
															weight = 800,
															des="装饰节点",
															children = {
																			{

																				type=BATTLE_CONST.NODE_ACTION,
																				actionType=BATTLE_CONST.ACTION_PLAY_EFFECT_AT_POSITION,
																				selectors={"postionX","postionX","postionY","postionY","showEffectName","animationName"},
																				des="上场特效",
																				weight=1000
																			}
																		}

														}
														,
														{
															-- 替补渐隐出现
															type=BATTLE_CONST.NODE_DECORATOR_CF,
															weight = 700,
															des="装饰节点",
															children = {
																				{
																					type=BATTLE_CONST.NODE_ACTION,
																					actionType=BATTLE_CONST.TARGET_FADE_IN_WITH_ID,
																					des="渐隐出现",
																					selectors={"benchs","idList","fadeInTime","time"},
																					weight=1000
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
											des="benchShow结束",
											weight=500
									}

									


								}

			} 
end
