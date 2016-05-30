-- appear：引导出现条件，必须满足所有条件引导才会执行
--		noPopup：当前场景没有弹窗出现
-- 		scene：当前场景，worldMap为藤蔓界面，game为棋盘界面，当是棋盘界面时，para代表当前关卡号（大括号则是其中任意关卡号可触发）
--		popup：有窗口弹出，popup表示面板的名称（具体值参考已有引导或找技术确认）
-- 		topLevel：用户当前等级
-- 		popDown：有窗口消失，popup表示面板的名称（具体值参考已有引导或找技术确认）
-- 		numMoves：玩家在关卡中进行的交换次数
-- 		onceLevel：该条引导在该关卡中仅出现一次
-- 		onceOnly：该引导在玩家整个游戏过程中仅出现一次（除非清除本地数据）
-- 		staticBoard：当前为棋盘的稳定状态  ××××这个条件在游戏中的引导配置中产品经常忘加，部分引导不加可能引起不良后果。请作为默认要加的条件处理！××××
-- 		getItem：用户在游戏中获得了一个道具（目前只有19关礼盒引导使用，有类似需求请先找技术确认）
-- 		curLevelGuided：当前关卡已经有过某条引导，guide为关卡号列表
-- 		swap：用户进行了一次交换，from和to分别是交换的两个棋盘坐标
-- 		click：用户点击（有需求找技术确认）
-- 		topPassedLevel：用户最高的已通过的关卡
-- 		hasGuide：之前曾引导过某些引导之一，目前只有进化版雪怪在用（虽然表面上看着觉得应该没问题的……但如果要用最好还是让技术再看一眼）
--
-- action：引导的执行内容，会逐个执行。一些类型的引导会自己判断条件自动消失，因此有些引导disappear部分并没有内容。××××但是disappear部分必须要写！××××
-- 		这个部分请暂时先参考下方的解释以及已有引导作为范例，因为以前的实现实在不优雅……所以不排除啥时候看不顺眼就给重构了也说不定……
-- 
-- disappear：引导消失条件，满足条件之一引导即消失
-- 		这一项中具体值与appear中一致，仅为判断方式（一个是必须全满足，一个是其中之一满足）不同

--mask、pan、hand：半透明遮盖、文字面板、手型提示
--Delay、fade：出现延迟、淡入过程时间
--panType =up/down 小浣熊向上/下看的动画
--ignoreCharacter  小浣熊是否隐藏
--panAlign =winY/viewY/matrixU/matrixD  1280窗口从下向上的像素/实际屏幕从下向上的像素/下沿在棋盘第几行/上沿在棋盘第几行
--panPosY：面板y坐标，根据panAlign是像素数或者棋盘的行数
--panAnimal:面板上出现的动物素材，animal="bear"：动物名，special="normal"：特效状态  
--         scale = ccp(1, 1)：x,y方向拉伸 x = 115, y = -130：面板上的x,y坐标，y是负数
--panAnimal = {[1] = {animal = "chicken", special = "wrap", scale = ccp(1, 1), x = 0, y = 0},}
-- animalType = {["horse"] = 1, ["frog"] = 2, ["bear"] = 3, ["cat"] = 4, ["fox"] = 5, ["chicken"] = 6, ["color"] = 7}
-- specialType = {["normal"] = 1, ["line"] = 7, ["column"] = 6, ["wrap"] = 8}
--panImage：面板上除了动物之外的图片，属性同panAnimal
--action type：gameSwap 交换，showObj：展示关卡目标 showTile：展示棋盘上的某个格子 ；showInfo：只有文字图片的说明面板
--             showPreProp：展示前置道具 ，startInfo 开始游戏面版上的关卡目标 ,tempProp ，临时道具，19关专用
--             moveCount ： 展示剩余步数面板，showUFO 展示飞碟
--action array：高亮区域，allow：允许交换区域。from，to：手势移动位置
--multRadius = 1.8 ：高亮原型的半径比例，maskPos = ccp(185, 730)：高亮原型的圆心地址  
--appear :出现时机，onceOnly：一台设备只出现一次（记在apptmp文件里）， onceLevel： 一关只出现一次，防止打开面板再次出现用
--showHint :自动动画，animPosY ,animDelay, panOrigin ,panFinal, panDelay, text ,animScale,animRotate
--posAdd:因为位置的不同，一些情况下需要加一个位置的偏移量，以对准正确的位置。
-- touchDelay :有些新手引导面板弹出后，过一段时间点击屏幕才会收起来
--type = "staticBoard"：这个参数表示该引导只有在棋盘稳定时才会启动

local vs = Director:sharedDirector():getVisibleSize()
local vo = Director:sharedDirector():getVisibleOrigin()

Guides = table.const
{
	-- 第1关，点击关卡花
	[10] = {
		appear = {
			{type = "noPopup"},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 1},
		},
		action = {
			[1] = {type = "clickFlower", para = 1 , handDelay = 1},
		},
		disappear = {
			{type = "popup"},
			{type = "scene", scene = "game"}
		}
	},
	-- 点击第一关开始按钮
	[11] = {
		appear = {
			{type = "popup", popup = "startGamePanel", para = 1},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 1},
		},
		action = {
			[1] = {type = "startPanel"},
		},
		disappear = {
			{type = "popdown", popdown = "startGamePanel"},
			{type = "noPopup"},
			{type = "scene", scene = "game"},
		}
	},
	-- 上下交换
	[12] = {
		appear = {
			{type = "scene", scene = "game", para = 1},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 1},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 5, c = 3, countR = 4, countC = 1}}, 
				allow = {r = 3, c = 3, countR = 2, countC = 1}, 
				from = ccp(2, 3.5), to = ccp(3.2, 3.5), 
				text = "tutorial.game.text102", panType = "up", panAlign = "matrixD", panPosY = 6, 
				handDelay = 1.2 , panDelay = 0.8,
				panAnimal = {
					[1] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 207, y = -58},
					[2] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 133, y = -103},
					[3] = {animal = "chicken", special = "normal", scale = ccp(0.7, 0.7), x = 292, y = -103}, 
				}
			},
		},
		disappear = {
			{type = "swap", from = ccp(2, 3), to = ccp(3, 3)},
		}
	},
	-- 左右交换
	[13] = {
		appear = {
			{type = "scene", scene = "game", para = 1},
			{type = "numMoves", para = 1},
			{type = "staticBoard"},
			{type = "topLevel", para = 1},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 3, c = 5, countR = 1, countC = 4}}, 
				allow = {r = 3, c = 5, countR = 1, countC = 2}, 
				from = ccp(3.3, 5), to = ccp(3.3, 6.3), 
				text = "tutorial.game.text103", panType = "up", panAlign = "matrixD", panPosY = 5, panFlip="true",
				handDelay = 1.2 , panDelay = 0.8 , 
			},
		},
		disappear = {
			{type = "swap", from = ccp(3, 5), to = ccp(3, 6)},
		}
	},
	-- 任务目标:再消除4只青蛙
	[14] = {
		appear = {
			{type = "scene", scene = "game", para = 1},
			{type = "numMoves", para = 2},
			{type = "staticBoard"},
			{type = "topLevel", para = 1},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showObj", opacity = 0xCC, index = 1, 
				text = "tutorial.game.text104", panAlign = "winY", panPosY = 920, panType = "up", 
				maskDelay = 1,maskFade = 0.4, panDelay = 1.3, panFade = 0.2, touchDelay = 1.9,
				panAnimal = {
					[1] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 227, y = -60},},
			},
			--自动动画1，提示消除青蛙
			[2] = {type = "showEliminate", r = 5, c = 7}
		},
		disappear = {
			{type = "scene", scene = ""},
			{type = "swap"}
		}
	},
	-- 第2关，点击关卡花
	[20] = {
		appear = {
			{type = "noPopup"},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 2},
		},
		action = {
			[1] = {type = "clickFlower", para = 2 ,handDelay = 4},
		},
		disappear = {
			{type = "popup"},
			{type = "scene", scene = "game"}
		}
	},
	-- 点击第二关开始按钮
	[21] = {
		appear = {
			{type = "popup", popup = "startGamePanel", para = 2},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 2},
		},
		action = {
			[1] = {type = "startPanel"},
		},
		disappear = {
			{type = "popdown", popdown = "startGamePanel"},
			{type = "noPopup"},
			{type = "scene", scene = "game"},
		}
	},
	-- 合成直线特效熊
	[22] = {
		appear = {
			{type = "scene", scene = "game", para = 2},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 2},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 2, c = 2, countR = 1, countC = 4}, 
					[2] = {r = 1, c = 3, countR = 1, countC = 1},}, 
				allow = {r = 2, c = 3, countR = 2, countC = 1}, 
				from = ccp(1, 3.5), to = ccp(2.2, 3.5), 
				text = "tutorial.game.text202", panType = "up", panAlign = "matrixD", panPosY = 4 , 
				handDelay = 1.2 , panDelay = 0.8, 
				panAnimal = {
					[1] = {animal = "bear", special = "normal", scale = ccp(0.7, 0.7), x = 140, y = -60},
					[2] = {animal = "bear", special = "normal", scale = ccp(0.7, 0.7), x = 178, y = -115},
					[3] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 358, y = -60},
				}
			}
		},
		disappear = {
			{type = "swap", from = ccp(1, 3), to = ccp(2, 3)},
		}
	},
	-- 说明直线特效熊，使用直线特效
	[23] = {
		appear = {
			{type = "scene", scene = "game", para = 2},
			{type = "numMoves", para = 1},
			{type = "staticBoard"},
			{type = "topLevel", para = 2},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {[1] = {r = 2, c = 3, countR = 1, countC = 1}}, 
				text = "tutorial.game.text203",panType = "up" , panAlign = "matrixD" , panPosY = 3.5,
				panDelay = 0.8, maskDelay = 0.3 ,maskFade = 0.4,touchDelay = 1.4,
			},
			[2] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 5, c = 3, countR = 4, countC = 1}}, 
				allow = {r = 3, c = 3, countR = 2, countC = 1}, 
				from = ccp(2, 3.5), to = ccp(3.2, 3.5), 
				text = "tutorial.game.text204",panType = "down", panAlign = "matrixU", panPosY = 1.5,
				handDelay = 1.2 , panDelay = 0.8
			},
		},
		disappear = {
			{type = "swap", from = ccp(2, 3), to = ccp(3, 3)},
		}
	},
	-- 对直线特效的各种合成方式的说明
	[24] = {
		appear = {
			{type = "scene", scene = "game", para = 2},
			{type = "numMoves", para = 2},
			{type = "staticBoard"},
			{type = "topLevel", para = 2},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showInfo", opacity = 0xCC, 
			    text = "tutorial.game.text205", 
			    maskDelay = 0.8, maskFade = 0.2, panDelay = 0.8, panFade = 0.1,touchDelay = 1.4,
				panAnimal = {
					--第一行横排小熊
					[1] = {animal = "bear", special = "normal", scale = ccp(1, 1), x = 110, y = -210-40},
					[2] = {animal = "bear", special = "normal", scale = ccp(1, 1), x = 190, y = -210-40},
					[3] = {animal = "bear", special = "normal", scale = ccp(1, 1), x = 270, y = -210-40},
					[4] = {animal = "bear", special = "normal", scale = ccp(1, 1), x = 350, y = -210-40},
					[5] = {animal = "bear", special = "column", scale = ccp(1, 1), x = 525, y = -210-40},
					--第二行竖排小熊
					[6] = {animal = "bear", special = "normal", scale = ccp(1, 1), x = 230, y = -300-40},
					[7] = {animal = "bear", special = "normal", scale = ccp(1, 1), x = 230, y = -380-40},
					[8] = {animal = "bear", special = "normal", scale = ccp(1, 1), x = 230, y = -460-40},
					[9] = {animal = "bear", special = "normal", scale = ccp(1, 1), x = 230, y = -540-40},
					[10] = {animal = "bear", special = "line", scale = ccp(1, 1), x = 525, y = -410-40},
				},
				panImage = {
					[1] = { image = "guides_panImage_equa.png", scale = ccp(1, 1) , x = 435 , y = -210-40},
					[2] = { image = "guides_panImage_equa.png", scale = ccp(1, 1) , x = 435 , y = -410-40},
				},
			},
			[2] = {type = "showHint", text = "tutorial.game.text206", 
				reverse = true ,animPosY = 0, panOrigin = ccp(-550,130),panFinal = ccp(120,130), animScale = 0.7,
				animDelay = 0.8, panDelay = 1.2 ,
			},
		},
		disappear = {
			{type = "scene", scene = ""},
		}
	},
	-- 第3关，点击关卡花
	[30] = {
		appear = {
			{type = "noPopup"},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 3},
		},
		action = {
			[1] = {type = "clickFlower", para = 3},
		},
		disappear = {
			{type = "popup"},
			{type = "scene", scene = "game"}
		}
	},
	-- 点击第三关开始按钮
	[31] = {
		appear = {
			{type = "popup", popup = "startGamePanel", para = 3},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 3},
		},
		action = {
			[1] = {type = "startPanel"},
		},
		disappear = {
			{type = "popdown", popdown = "startGamePanel"},
			{type = "noPopup"},
			{type = "scene", scene = "game"},
		}
	},
	-- 合成区域特效
	[32] = {
		appear = {
			{type = "scene", scene = "game", para = 3},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 3},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 5, c = 3, countR = 4, countC = 1}, 
					[2] = {r = 3, c = 4, countR = 1, countC = 2},
				}, 
				allow = {r = 3, c = 3, countR = 2, countC = 1}, 
				from = ccp(2, 3.5), to = ccp(3.2, 3.5),
				text = "tutorial.game.text302",panType = "up", panAlign = "matrixD", panPosY = 5.5 ,
				handDelay = 1.2 , panDelay = 0.8,
				panImage = {
				    --T和L型图片已经替换
					[1] = {image = "guides_panImage_L.png", scale=ccp(0.9, 0.9) , x = 63 , y = -115 ,},
					[2] = {image = "guides_panImage_T.png", scale=ccp(0.9, 0.9) , x = 200 , y = -112 ,},
				},
			},
		},
		disappear = {
			{type = "swap", from = ccp(2, 3), to = ccp(3, 3)},
		}
	},
	-- 使用区域特效
	[33] = {
		appear = {
			{type = "scene", scene = "game", para = 3},
			{type = "numMoves", para = 1},
			{type = "staticBoard"},
			{type = "topLevel", para = 3},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 5, c = 3, countR = 1, countC = 4},}, 
				allow = {r = 5, c = 3, countR = 1, countC = 2}, 
				from = ccp(5.3, 3), to = ccp(5.3, 4.3), 
				text = "tutorial.game.text303",panType = "up", panAlign = "matrixD", panPosY = 6,
				handDelay = 1.2 , panDelay = 0.8,
			},
		},
		disappear = {
			{type = "swap", from = ccp(5, 3), to = ccp(5, 4)},
		}
	},
	-- 显示区域特效规则信息，继续游戏
	[34] = {
		appear = {
			{type = "scene", scene = "game", para = 3},
			{type = "numMoves", para = 2},
			{type = "staticBoard"},
			{type = "topLevel", para = 3},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showInfo", opacity = 0xCC, 
				text = "tutorial.game.text304", 
				maskDelay = 0.8, maskFade = 0.2, panDelay = 0.8, panFade = 0.1,touchDelay = 1.4,
				panAnimal = {
				--第一组青蛙
				[1] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 110, y = -155-20},
				[2] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 170, y = -275-20},
				[3] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 230, y = -275-20},
				[4] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 110, y = -215-20},
				[5] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 110, y = -275-20},
				--第二组青蛙
				[6] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 300, y = -155-20},
				[7] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 360, y = -155-20},
				[8] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 420, y = -155-20},
				[9] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 360, y = -215-20},
				[10] = {animal = "frog", special = "normal", scale = ccp(0.7, 0.7), x = 360, y = -275-20},
				--区域特效青蛙
				[11] = {animal = "frog", special = "wrap", scale = ccp(0.7, 0.7), x = 520, y = -215-20},
				},			
				panImage = {
				[1] = {image = "guides_panImage_equa.png",scale = ccp(0.8,0.8) , x = 275 , y = -215 -20},
				[2] = {image = "guides_panImage_equa.png",scale = ccp(0.8,0.8) , x = 465 , y = -215 -20},
				[3] = {image = "guides.panImage_baozha.png",scale = ccp(1,1) , x = 260 , y = - 570 -15}
 				},
			},
			--自动动画3，现在棋盘上就有炸弹
			[2] = {type = "showHint", text = "tutorial.game.text305",
				animPosY = 660, animMatrixR = 6, animScale = 0.7, panOrigin= ccp(720,810),panFinal= ccp(200,810),
				panMatrixOriginR = 8.3, panMatrixFinalR = 8.3,
			}
		},
		disappear = {
			{type = "scene", scene = ""},
		}
	},
	-- 第4关，点击关卡花
	[40] = {
		appear = {
			{type = "noPopup"},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 4},
		},
		action = {
			[1] = {type = "clickFlower", para = 4},
		},
		disappear = {
			{type = "popup"},
			{type = "scene", scene = "game"}
		}
	},
	-- 点击第四关开始按钮
	[41] = {
		appear = {
			{type = "popup", popup = "startGamePanel", para = 4},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 4},
		},
		action = {
			[1] = {type = "startPanel"},
		},
		disappear = {
			{type = "popdown", popdown = "startGamePanel"},
			{type = "noPopup"},
			{type = "scene", scene = "game"},
		}
	},
	-- 合成魔力鸟
	[42] = {
		appear = {
			{type = "scene", scene = "game", para = 4},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 4},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 6, c = 2, countR = 5, countC = 1}, 
					[2] = {r = 4, c = 3, countR = 1, countC = 1},
				}, 
				allow = {r = 4, c = 2, countR = 1, countC = 2}, 
				from = ccp(4.3, 3), to = ccp(4.3, 2.3), 
				text = "tutorial.game.text402",panType = "up", panAlign = "matrixD", panPosY = 6.5, 
				handDelay = 1.2 , panDelay = 0.8,
				panAnimal = {
					--合成魔力鸟的图片演示,差动物之间切换的动画
					[1] = {animal = "fox", special = "normal", scale = ccp(0.7, 0.7), x = 70, y = -185-15},
					[2] = {animal = "fox", special = "normal", scale = ccp(0.7, 0.7), x = 125, y = -185-15},
					[3] = {animal = "fox", special = "normal", scale = ccp(0.7, 0.7), x = 180, y = -185-15},
					[4] = {animal = "fox", special = "normal", scale = ccp(0.7, 0.7), x = 235, y = -185-15},
					[5] = {animal = "fox", special = "normal", scale = ccp(0.7, 0.7), x = 290, y = -185-15},					
					[6] = {animal = "color", special = "normal", scale = ccp(0.7, 0.7), x = 380, y = -185-15},
				},
				panImage = {
				[1] = {image = "guides_panImage_equa.png",scale = ccp(0.8,0.8) , x = 335 , y = -185-15},
				}, 
			},
		},
		disappear = {
			{type = "swap", from = ccp(4, 3), to = ccp(4, 2)},
		}
	},
	-- 使用魔力鸟特效
	[43] = {
		appear = {
			{type = "scene", scene = "game", para = 4},
			{type = "numMoves", para = 1},
			{type = "staticBoard"},
			{type = "topLevel", para = 4},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 6, c = 2, countR = 1, countC = 2} },
				allow = {r = 6, c = 2, countR = 1, countC = 2}, 
				from = ccp(6.3, 2), to = ccp(6.3, 3.3), 
				text = "tutorial.game.text403", panType = "up", panAlign = "matrixD", panPosY = 8,
				maskDelay = 0.7 ,handDelay = 1 , panDelay = 0.9,
				panAnimal = {
					[1] = {animal = "color", special = "normal", scale = ccp(0.7, 0.7), x = 107, y = -60},
				}
			},
		},
		disappear = {
			{type = "swap", from = ccp(6, 2), to = ccp(6, 3)},
		}
	},
	-- 还剩18步，高亮步数面板
	[44] = {
		appear = {
			{type = "scene", scene = "game", para = 4},
			{type = "numMoves", para = 2},
			{type = "staticBoard"},
			{type = "topLevel", para = 4},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "moveCount", opacity = 0xCC, posAdd = ccp(-100,-90),
				width = 180, height = 160, 
				text = "tutorial.game.text404", 
				panType = "up" ,panAlign = "winY" , panPosY = 950, panFlip ="true",
				maskDelay = 1 ,maskfade = 0.3, panDelay = 1.2, touchDelay = 1.7
			},
		},
		disappear = {}
	},
	-- 第5关，点击关卡花
	[50] = {
		appear = {
			{type = "noPopup"},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 5},
		},
		action = {
			[1] = {type = "clickFlower", para = 5},
		},
		disappear = {
			{type = "popup"},
			{type = "scene", scene = "game"}
		}
	},
	-- 点击第五关开始按钮
	[51] = {
		appear = {
			{type = "popup", popup = "startGamePanel", para = 5},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 5},
		},
		action = {
			[1] = {type = "startPanel"},
		},
		disappear = {
			{type = "popdown", popdown = "startGamePanel"},
			{type = "noPopup"},
			{type = "scene", scene = "game"},
		}
	},
	-- 两个直线特效交换
	[52] = {
		appear = {
			{type = "scene", scene = "game", para = 5},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 5},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 3, c = 5, countR = 2, countC = 1},}, 
				allow = {r = 3, c = 5, countR = 2, countC = 1}, 
				from = ccp(2, 5.5), to = ccp(3.2, 5.5), 
				text = "tutorial.game.text502",panType = "up", panAlign = "matrixD", panPosY = 5,
				handDelay = 1.2 , panDelay = 0.8,
			},
		},
		disappear = {
			{type = "swap", from = ccp(2, 5), to = ccp(3, 5)},
		}
	},
	-- 继续游戏
	[53] = {
		appear = {
			{type = "scene", scene = "game", para = 5},
			{type = "numMoves", para = 1},
			{type = "staticBoard"},
			{type = "topLevel", para = 5},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showHint",text = "tutorial.game.text503",
				reverse = true ,animPosY = 0, panOrigin = ccp(-550,130),panFinal = ccp(120,130), animScale = 0.7,
				animDelay = 0.8, panDelay = 1.2 ,
			}
		},
		disappear = {
			{type = "scene", scene = ""},
		}
	},
	-- 第6关,点击关卡花
	[60] = {
		appear = {
			{type = "noPopup"},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 6},
		},
		action = {
			[1] = {type = "clickFlower", para = 6},
		},
		disappear = {
			{type = "popup"},
			{type = "scene", scene = "game"}
		}
	},
	-- 点击第六关开始按钮
	[61] = {
		appear = {
			{type = "popup", popup = "startGamePanel", para = 6},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 6},
		},
		action = {
			[1] = {type = "startPanel"},
		},
		disappear = {
			{type = "popdown", popdown = "startGamePanel"},
			{type = "noPopup"},
			{type = "scene", scene = "game"},
		}
	},
	-- 魔力鸟和直线特效交换
	[62] = {
		appear = {
			{type = "scene", scene = "game", para = 6},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 6},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 2, c = 5, countR = 1, countC = 2},}, 
				allow = {r = 2, c = 5, countR = 1, countC = 2}, 
				from = ccp(2.3, 5), to = ccp(2.3, 6.3), 
				text = "tutorial.game.text602",panType = "up", panAlign = "matrixD", panPosY = 4, panFlip ="true",
				handDelay = 1.2 , panDelay = 0.8,
			},
		},
		disappear = {
			{type = "swap", from = ccp(2, 5), to = ccp(2, 6)},
		}
	},
	-- 展示各种特效交换的组合
	[63] = {
		appear = {
			{type = "scene", scene = "game", para = 6},
			{type = "numMoves", para = 1},
			{type = "staticBoard"},
			{type = "topLevel", para = 6},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showInfo", opacity = 0xCC, 
				text = "tutorial.game.text603", 
				maskDelay = 1.8, maskFade = 0.3, panDelay = 1.8, panFade = 0.2, touchDelay = 2.4,
				panAnimal = {
					--第一行，横-竖，横-炸，横-鸟
					[1] = {animal = "cat", special = "line", scale = ccp(1, 1), x = 135, y = -255},
					[2] = {animal = "frog", special = "column", scale = ccp(1, 1), x = 160, y = -280},
					[3] = {animal = "cat", special = "line", scale = ccp(1, 1), x = 285, y = -255},
					[4] = {animal = "bear", special = "wrap", scale = ccp(1, 1), x = 320, y = -280},
					[5] = {animal = "cat", special = "line", scale = ccp(1, 1), x = 455, y = -255},
					[6] = {animal = "color", special = "normal", scale = ccp(1, 1), x = 480, y = -280},
					--第二行，炸-炸，炸-鸟，鸟-鸟
					[7] = {animal = "bear", special = "wrap", scale = ccp(1, 1), x = 135, y = -410},
					[8] = {animal = "frog", special = "wrap", scale = ccp(1, 1), x = 160, y = -435},
					[9] = {animal = "bear", special = "wrap", scale = ccp(1, 1), x = 285, y = -410},
					[10] = {animal = "color", special = "normal", scale = ccp(1, 1), x = 320, y = -435},
					[11] = {animal = "color", special = "normal", scale = ccp(1, 1), x = 455, y = -410},
					[12] = {animal = "color", special = "normal", scale = ccp(1, 1), x = 480, y = -435},
				}
			},
			--自动动画6，注意过关目标，祝你好运
			[2] = {type = "showHint", text = "tutorial.game.text604",
				reverse = true ,animPosY = 0, panOrigin = ccp(-550,130),panFinal = ccp(80,130), animScale = 0.7,
				animDelay = 0.8, panDelay = 1.2 ,
			}
		},
		disappear = {
			{type = "scene", scene = ""},
		}
	},
	-- 第8关，消除冰块
	[80] = {
		appear = {
			{type = "scene", scene = "game", para = 8},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 8},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 4, c = 3, countR = 1, countC = 3}, 
					[2] = {r = 3, c = 3, countR = 1, countC = 1},
				}, 
				allow = {r = 4, c = 3, countR = 2, countC = 1},
				from = ccp(3, 3.5), to = ccp(4.2, 3.5), 
				text = "tutorial.game.text800",panType = "up", panAlign = "matrixD", panPosY = 5,
				handDelay = 1.2 , panDelay = 0.8,
			},
		},
		disappear = {
			{type = "swap", from = ccp(3, 3), to = ccp(4, 3)},
		}
	},
	[81] = {
		appear = {
			{type = "scene",scene = "game", para = 8},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 8},
			{type = "noPopup"},
			{type = "onceLevel"},
			{type = "staticBoard"}
		},
		action = {
			[1]= {	type = "showHint",text ="tutorial.game.text801",
				reverse = true ,animPosY = 0, panOrigin = ccp(-550,130),panFinal = ccp(80,130), animScale = 0.7,
				animDelay = 0.2, panDelay = 0.5 , 
			},
		},
		disappear = {
			{type = "scene", scene = ""},
		},
	},
	-- 第11关，展示前置+3步
	[110] = {
		appear = {
			{type = "popup", popup = "startGamePanel", para = 11},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 11},
			{type = "onceOnly"},
		},
		action = {
			[1] = {type = "showPreProp", opacity = 0xCC, index = 1, 
				text = "tutorial.game.text1100", multRadius = 1.8 ,maskPos = ccp(185, 730),
				panType = "up", panAlign = "winY", panPosY = 550,
				maskDelay = 0.3,maskFade = 0.5 ,panDelay = 0.5,	touchDelay = 1.1			
			},
		},
		disappear = {
			{type = "popdown", popdown = "startGamePanel"},
		},
	},
	-- 第12关，金豆荚确认，掉落一次
	[120] = {
		appear = {
			{type = "scene", scene = "game", para = 12},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 12},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {[1] = {r = 2, c = 5, countR = 1, countC = 1}}, 
				text = "tutorial.game.text1200",panType = "up", panAlign = "matrixD", panPosY = 4, panFlip = true , 
				panDelay = 0.8, maskDelay = 0.5 ,maskFade = 0.4, touchDelay = 1.1
			},
			[2] = {type = "gameSwap", opacity = 0xCC, 
				array = {
						[1] = {r = 2, c = 5, countR = 1, countC = 1},
						[2] = {r = 7, c = 5, countR = 4, countC = 1}
						}, 
				allow = {r = 7, c = 5, countR = 2, countC = 1}, 
				from = ccp(7, 5.5), to = ccp(5.8, 5.5),
				text = "tutorial.game.text1201",panType = "down", panAlign = "matrixU", panPosY = 2,
				panDelay =0.1 , handDelay = 0.3 ,
			}
		},
		disappear = {
			{type = "swap", from = ccp(7, 5), to = ccp(6, 5)},
		}
	},
	-- 消除第二次，金豆荚掉落
	[121] = {
		appear = {
			{type = "scene", scene = "game", para = 12},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 12},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 8, c = 5, countR = 1, countC = 1}, 
					[2] = {r = 9, c = 3, countR = 1, countC = 4}
				}, 
				allow = {r = 9, c = 3, countR = 1, countC = 2}, 
				from = ccp(9.3, 3), to = ccp(9.3, 4), 
				text = "tutorial.game.text1203",panType = "down", panAlign = "matrixU", panPosY = 3.5,
				handDelay = 0.9 , panDelay = 0.6,
			},
		},
		disappear = {
			{type = "swap", from = ccp(9, 3), to = ccp(9, 4)},
		}
	},
	-- 任务目标:再收集一个金豆荚
	[123] = {
		appear = {
			{type = "scene", scene = "game", para = 12},
			{type = "numMoves", para = 2},
			{type = "staticBoard"},
			{type = "topLevel", para = 12},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showObj", opacity = 0xCC, index = 1, 
				text = "tutorial.game.text1204",panType = "up", panAlign = "winY", panPosY = 920,
				maskDelay = 0.8,maskFade = 0.4, panDelay = 1.1,touchDelay = 1.7
			},
		},
		disappear = {}
	},
	-- 第13关，展示前置刷新
	[130] = {
		appear = {
			{type = "popup", popup = "startGamePanel", para = 13},
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 13},
			{type = "onceOnly"},
		},
		action = {
			[1] = {type = "showPreProp", opacity = 0xCC, index = 2, 
				text = "tutorial.game.text1300", multRadius = 1.8 ,maskPos = ccp(360, 730),
				panType = "up", panAlign = "winY", panPosY = 550, 
				maskDelay = 0.3,maskFade = 0.4 ,panDelay = 0.5, touchDelay = 1.1
			},
		},
		disappear = {
			{type = "popdown", popdown = "startGamePanel"},
		},
	},
	--第15关，雪块说明
	[150] = {
		appear = {
			{type = "scene", scene = "game", para = 15},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 15},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
			array = {
				[1] = {r = 3, c = 4, countR = 3, countC = 1},
				[2] = {r = 3, c = 8, countR = 3, countC = 1},
				[3] = {r = 3, c = 5, countR = 1, countC = 3},
			}, 
			text = "tutorial.game.text1500",panType = "up", panAlign = "matrixD", panPosY = 4.5 ,panFlip = "true",
			panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4, touchDelay = 1.7 
			},
		},
		disappear = {}
	},
	[151] = {
		appear = {
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 15},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "topPassedLevel", para = 15}
		},
		action = {
			[1] = {type = "showUnlock", opacity = 0xCC, 
			text = "tutorial.game.text1510",panType = "up", panAlign = "winY", panPosY = 440,
			panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4, touchDelay = 1.7 , cloudId = 40002
			},
		},
		disappear = {}
	},
	[152] = {
		appear = {
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 30},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "topPassedLevel", para = 30}
		},
		action = {
			[1] = {type = "showUnlock", opacity = 0xCC, 
			text = "tutorial.game.text1520",panType = "up", panAlign = "winY", panPosY = 440,
			panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4, touchDelay = 1.7 , cloudId = 40003
			},
		},
		disappear = {
		}
	},
	[153] = {
		appear = {
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 45},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "topPassedLevel", para = 45}
		},
		action = {
			[1] = {type = "showUnlock", opacity = 0xCC, 
			text = "tutorial.game.text1530",panType = "up", panAlign = "winY", panPosY = 440,
			panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4, touchDelay = 1.7 , cloudId = 40004
			},
		},
		disappear = {
		}
	},
	--第17关，时间关目标说明
	[170] = {
		appear = {
			{type = "popup", popup = "startGamePanel", para = 17},
			{type = "scene", scene ="worldMap"},
			{type = "topLevel", para = 17},
			{type = "onceOnly"},
		},
		action = {
			[1] = {type = "startInfo", opacity = 0xCC, index = 1, 
				text = "tutorial.game.text1700", maskPos = ccp(536, 940),multRadius=1.1 ,
				panType = "up", panAlign = "winY", panPosY = 720, panFlip = "true",
				maskDelay = 0.3,maskFade = 0.4 ,panDelay = 0.5, touchDelay = 1
			},
		},
		disappear = {
			{type = "popdown", popdown = "startGamePanel"},
		},
	},
	--第19关，礼盒说明
	[190] = {
		appear = {
			{type = "scene", scene = "game", para = 19},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 19},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
			array = {[1] = {r = 4, c = 4, countR = 1, countC = 1},}, 
			text = "tutorial.game.text1800",panType = "up", panAlign = "matrixD", panPosY = 5.5 ,
			panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4, touchDelay = 1.7
			},
		},
		disappear = {}
	},
	--礼盒中获得临时道具的说明
	[191] = {
		appear = {
			{type = "scene", scene = "game", para = 19},
			{type = "getItem", item = "gift"},
			{type = "topLevel", para = 19},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "tempProp", opacity = 0xCC, index = 2, 
				text = "tutorial.game.text1901", multRadius = 1.3,
				panType = "down", panAlign = "viewY", panPosY = 650, 
				maskDelay = 0.3,maskFade = 0.4 ,panDelay = 0.5 , touchDelay = 1.1
			},
		},
		disappear = {}
	},
	--第47关，目标是直线特效时候的引导
	[470] = {
		appear = {
			{type = "scene", scene = "game", para = 47},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 47},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showObj", opacity = 0xCC, index = 1, 
			text = "tutorial.game.text4700", panType = "up", panAlign = "winY", panPosY = 920,
			maskDelay = 1,maskFade = 0.4, panDelay = 1.3, touchDelay = 1.9
			}, 
		},
		disappear = {}
	},
	--第76关，毒液说明
	[760] = {
		appear = {
			{type = "scene", scene = "game", para = 76},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 76},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
					[1] = {r = 6, c = 2, countR = 1, countC = 1},
					[2] = {r = 9, c = 2, countR = 1, countC = 1},
					[3] = {r = 6, c = 5, countR = 1, countC = 1},
					[4] = {r = 9, c = 5, countR = 1, countC = 1},
					[5] = {r = 6, c = 8, countR = 1, countC = 1},
					[6] = {r =9, c = 8, countR = 1, countC = 1},
				}, 
				text = "tutorial.game.text7600",panType = "down", panAlign = "matrixU", panPosY = 4.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4, touchDelay = 1.7
			},
		},
		disappear = {}
	},
	--第91关，银币说明
	[910] = {
		appear = {
			{type = "scene", scene = "game", para = 91},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 91},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {					[1] = {r = 9, c =6, countR = 6, countC =1}, 
					[2] = {r = 4, c =7, countR = 1, countC =3},
					[3] = {r = 9, c =8, countR = 1, countC =1}, 
					[4] = {r = 8, c =7, countR = 1, countC =1},
					[5] = {r = 8, c =9, countR = 1, countC =1}, 
					[6] = {r = 7, c =8, countR = 1, countC =1}, 
					[7] = {r = 6, c =7, countR = 1, countC =1},
					[8] = {r = 6, c =9, countR = 1, countC =1},
					[9] = {r = 5, c =8, countR = 1, countC =1},
				}, 
				text = "tutorial.game.text9100",panType = "down", panAlign = "matrixU", panPosY = 3.5 ,panFlip = "true",
			},
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4, touchDelay = 1.7
		},
		disappear = {}
	},
	--第106关，褐色毛球说明
	[1060] = {
		appear = {
			{type = "scene", scene = "game", para = 106},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 106},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
					[1] = {r = 4, c = 2, countR = 1, countC = 1},
					[2] = {r = 4, c = 9, countR = 1, countC = 1},
				}, 
				text = "tutorial.game.text10600",panType = "up", panAlign = "matrixD", panPosY = 5.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear = {}
	},
    --第121鸡窝关，指示鸡窝的位置，消除一次
	[1210] = {
		appear = {
			{type = "scene", scene = "game", para = 121},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 121},
			{type = "noPopup"},
			{type = "onceLevel"},
			{type = "onceOnly"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
					[1] = {r = 4, c = 7, countR = 1, countC = 1}
				}, 
				text = "tutorial.game.text12100",panType = "up", panAlign = "matrixD", panPosY = 5.5, 
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
			[2] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 4, c = 5, countR = 1, countC = 1}, 
					[2] = {r = 4, c = 6, countR = 3, countC = 1}
				}, 
				allow = {r = 4, c = 5, countR = 1, countC = 2}, 
				from = ccp(4.3, 5), to = ccp(4.3, 6), 
				text = "tutorial.game.text12101",panType = "up", panAlign = "matrixD", panPosY = 6.5,
				panDelay =0.1 , handDelay = 0.3 ,
			},
		},
		disappear = {
			{type = "swap", from = ccp(4, 5), to = ccp(4, 6)},
		}
	},
	-- 消除第二次，炸鸡窝第二次
	[1211] = {
		appear = {
			{type = "scene", scene = "game", para = 121},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 121},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = { 1210 },}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 5, c = 6, countR = 3, countC = 1 }, 
					[2] = {r = 3, c = 7, countR = 1, countC = 1 }
				}, 
				allow = {r = 3, c = 6, countR = 1, countC = 2}, 
				from = ccp(3.3, 6), to = ccp(3.3, 7), 
				text = "tutorial.game.text12102",panType = "up", panAlign = "matrixD", panPosY = 6.5,
				handDelay = 0.9 , panDelay = 0.6,
			},
		},
		disappear = {
			{type = "swap", from = ccp(3, 6), to = ccp(3, 7)},
		}
	},
	-- 消除第三次，炸出小鸡
	[1212] = {
		appear = {
			{type = "scene", scene = "game", para = 121},
			{type = "numMoves", para = 2},
			{type = "topLevel", para = 121},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = { 1210, 1211 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 3, c = 8, countR = 1, countC = 1 }, 
					[2] = {r = 4, c = 7, countR = 1, countC = 3 },
					[3] = {r = 5, c = 8, countR = 1, countC = 1 },
				}, 
				allow = {r = 4, c = 8, countR = 1, countC = 2}, 
				from = ccp(4.3, 8), to = ccp(4.3, 9), 
				text = "tutorial.game.text12103",panType = "up", panAlign = "matrixD", panPosY = 6.5,
				handDelay = 1.3 , panDelay = 1.1, maskDelay = 0.9
			},
		},
		disappear = {
			{type = "swap", from = ccp(4, 8), to = ccp(4, 9)},
		}
	},
	--136彩云关，展示彩云，消除一次
	[1360] = {
		appear = {
			{type = "scene", scene = "game", para = 136},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 136},
			{type = "noPopup"},
			{type = "onceLevel"},
			{type = "onceOnly"},
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
					[1] = {r = 9, c = 1, countR = 3, countC = 1},
					[2] = {r = 9, c = 2, countR = 3, countC = 1},
					[3] = {r = 9, c = 3, countR = 2, countC = 1},
					[4] = {r = 9, c = 4, countR = 1, countC = 1},
					[5] = {r = 8, c = 6, countR = 3, countC = 1},
					[6] = {r = 9, c = 7, countR = 2, countC = 1},
					[7] = {r = 9, c = 8, countR = 4, countC = 1},
					[8] = {r = 9, c = 9, countR = 2, countC = 1},
				}, 
				text = "tutorial.game.text13600", panType = "down", panAlign = "matrixU", panPosY = 2.5, panFlip = "true",
				panDelay = 4, maskDelay = 3.9 ,maskFade = 0.4,touchDelay = 4.2
			},
			[2] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 7, c = 7, countR = 4, countC = 1}, 
					[2] = {r = 5, c = 6, countR = 1, countC = 1}
				}, 
				allow = {r = 5, c = 6, countR = 1, countC = 2}, 
				from = ccp(5.3, 6), to = ccp(5.3, 7), 
				text = "tutorial.game.text13601",panType = "down", panAlign = "matrixU", panPosY = 2.5, panFlip = "true" ,
				panDelay =0.1 , handDelay = 0.3 
			}
		},
		disappear = {
			{type = "swap", from = ccp(5, 6), to = ccp(5, 7)},
		}
	},
	-- 消除红宝石云彩一次
	[1361] = {
		appear = {
			{type = "scene", scene = "game", para = 136},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 136},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 1360 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 6, c = 6, countR = 1, countC = 1 }, 
					[2] = {r = 7, c = 6, countR = 1, countC = 3 },
					[3] = {r = 8, c = 8, countR = 1, countC = 1 }
				}, 
				allow = {r = 7, c = 6, countR = 2, countC = 1}, 
				from = ccp(6, 6.3), to = ccp(7, 6.3), 
				text = "tutorial.game.text13602",panType = "down", panAlign = "matrixU", panPosY = 3.5, panFlip = "true" ,
				handDelay = 0.9 , panDelay = 0.6,
			},
		},
		disappear = {
			{type = "swap", from = ccp(6, 6), to = ccp(7, 6)},
		}
	},
	-- 消除第三次，让云层上升
	[1362] = {
		appear = {
			{type = "scene", scene = "game", para = 136},
			{type = "numMoves", para = 2},
			{type = "topLevel", para = 136},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 1360, 1361 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 7, c = 3, countR = 1, countC = 1 }, 
					[2] = {r = 6, c = 1, countR = 1, countC = 5 },
				}, 
				allow = {r = 7, c = 3, countR = 2, countC = 1}, 
				from = ccp(7, 3.3), to = ccp(6, 3.3), 
				text = "tutorial.game.text13603",panType = "down", panAlign = "matrixU", panPosY = 3.5, 
				handDelay = 1.3 , panDelay = 1.1, maskDelay = 0.9
			},
		},
		disappear = {
			{type = "swap", from = ccp(7, 3), to = ccp(6, 3)},
		}
	},
		[1363] = {
		appear = {
			{type = "scene", scene = "game", para = 136},
			{type = "numMoves", para = 3},
			{type = "staticBoard"},
			{type = "topLevel", para = 136},
			{type = "noPopup"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 1360, 1361, 1362 },}
		},
		action = {
			[1] = {type = "showHint",text = "tutorial.game.text503",
				reverse = true ,animPosY = 0, panOrigin = ccp(-550,130),panFinal = ccp(120,130), animScale = 0.7,
				animDelay = 0.8, panDelay = 1.2 ,
			}
		},
		disappear = {
			{type = "scene", scene = ""},
		}
	},
--第166关，金豆荚说明
	[1660] = {
		appear = {
			{type = "scene", scene = "game", para = 166},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 166},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
   			[1] = {type = "showUFO", opacity = 0xCC, 
				position = ccp(1, 4), width = 0, height = 0, oval = true, deltaY = 15,
				text = "tutorial.game.text16601",panType = "up", panAlign = "matrixD", panPosY = 3.5 ,
				panDelay = 1.1, maskDelay = 1.2 ,maskFade = 0.4,touchDelay = 1.7, panFlip = true ,
				panImage = {
					[1] = { image = "guides_ufo.png", scale = ccp(1, 1) , x = 300 , y = 230},
				},
			}
		},
		disappear = {}
	},
--第167关，火箭说明
	[1670] = {
		appear = {
			{type = "scene", scene = "game", para = 167},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 167},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 5, c = 5, countR = 1, countC = 1}, 
					[2] = {r = 4, c = 4, countR = 1, countC = 3}
				}, 
				allow = {r = 5, c = 5, countR = 2, countC = 1}, 
				from = ccp(5, 5), to = ccp(4, 5), 
				text = "tutorial.game.text16701",panType = "up", panAlign = "matrixD", panPosY =  6.5, panFlip = "true" ,
				panDelay =0.1 , handDelay = 0.3,
				panImage = {
					[1] = { image = "guides_ufo.png", scale = ccp(1, 1) , x = 720 - 140 , y = 0, rotation=-12.7},
					[2] = { image = "guides_ufo_rocket.png", scale = ccp(1, 1) , x = 720 - 57 , y = -105, rotation=-39},
				},
			},
		},
		disappear = {
			{type = "swap", from = ccp(5, 5), to = ccp(4, 5)},
		},
	},
--第181关，章鱼说明
	[1810] = {
		appear = {
			{type = "scene", scene = "game", para = 181},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 181},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 8, c = 3, countR = 1, countC = 1},
				    [2] = {r = 8, c = 5, countR = 1, countC = 1},
				    [3] = {r = 8, c = 7, countR = 1, countC = 1},
				}, 
				text = "tutorial.game.text18100",panType = "down", panAlign = "matrixD", panPosY = 2.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
			[2] = {type = "showObj", opacity = 0xCC, index = 2, 
				text = "tutorial.game.text18101", panType = "up",panAlign = "matrixD", panPosY = 2.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear = {}
	},	

	--- 第182关，章鱼冰道具说明
	[1820] = {
		appear = {
			{type = "scene", scene ="game", para = 182},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 182},
			{type = "onceOnly"},
			{type = "onceLevel"},
			{type = "noPopup"},
		},
		action = {
			[1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text18200", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 720, panFlip = "true",
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 10052,
			},
			[2] = {type = "giveProp", opacity = 0xCC, index = 1, 
				text = "tutorial.game.text18201", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 720, panFlip = "true",
				maskDelay = 0.3,maskFade = 0.4 ,panDelay = 0.5, touchDelay = 1,
				propId = 10052, tempPropId = 10053, count = 1,
				panImage = {
						[1] = { image = "Prop_10052_sprite0000", scale = ccp(1, 1) , x = 450 , y = -175},
					},
			},
		},
		disappear = {},
	},

--第196关，地格说明	
	[1960] = {
		appear = {
			{type = "scene", scene = "game", para = 196},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 196},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 4, c = 4, countR = 1, countC = 1},
				    [2] = {r = 4, c = 6, countR = 1, countC = 1},
				}, 
				text = "tutorial.game.text19600",panType = "up", panAlign = "matrixD", panPosY = 4.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		},
		disappear = {}
	},
	-- 消除第一次，地块边缘变色说明，障碍地格说明
	[1961] = {
		appear = {
			{type = "scene", scene = "game", para = 196},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 196},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 1960 },},
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 4, c = 4, countR = 1, countC = 1},
				    [2] = {r = 4, c = 6, countR = 1, countC = 1},
				}, 
				text = "tutorial.game.text19601",panType = "up", panAlign = "matrixD", panPosY = 4.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
			[2]= {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 6, c = 2, countR = 1, countC = 1},
				}, 
				text = "tutorial.game.text19602",panType = "down", panAlign = "matrixD", panPosY = 1.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear = {
			{type = "swap", from = ccp(7, 3), to = ccp(6, 3)},
		}
	},
	--[[
	不要打开，否则进关卡就卡死-。-
	--第211关，雪怪说明	 ,废弃
    [2110] = {
		appear = {},
		action = {},
		disappear = {}
	},
	-- 消除第一次，雪怪右上角处的冰消除，进入下一步说明,废弃
	[2111] = {
		appear = {},
		action = {},
		disappear = {}
	},
	--]]
--弹框引导
	[2114] = {
		appear = {
			{type = "hasGuide", guideArray = {2110, 2111}},
			{type = "scene", scene = "game", para ={212, 215, 223, 228, 229, 237, 239, 243, 249, 252, 255, 258, 264, 269, 284, 296, 302, 342, 350, 375, 395, 431, 462, 506, 536}},
			{type = "numMoves", para = 0},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
		    [1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 9, c = 1, countR = 9, countC = 9}, 
				}, 
				text = "tutorial.game.text21104",panType = "up", panAlign = "matrixD", panPosY = 7.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear = {}
	},

--新引导
	[2112] = {
		appear = {
			{type = "scene", scene = "game", para = 211},
			{type = "numMoves", para = 0},
			--{type = "topLevel", para = 211},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 4, c = 2, countR = 1, countC = 1},
				    [2] = {r = 4, c = 3, countR = 1, countC = 1},
				    [3] = {r = 5, c = 2, countR = 1, countC = 1},
				    [4] = {r = 5, c = 3, countR = 1, countC = 1},
				}, 
				text = "tutorial.game.text21100",panType = "up", panAlign = "matrixD", panPosY = 5.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		    [2] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 3, c = 3, countR = 1, countC = 4},
                         [2] = {r = 5, c = 2, countR = 2, countC = 2},
				}, 
				allow = {r = 3, c = 5, countR = 1, countC = 2}, 
				from = ccp(3.3, 6), to = ccp(3.3, 5.3), 
				text = "tutorial.game.text21101", panType = "up", panAlign = "matrixD", panPosY = 5.5, panFlip="true",
				handDelay = 1.2 , panDelay = 0.8 , 
		    },
		},
		disappear = {
			{type = "swap", from = ccp(3, 6), to = ccp(3, 5)},
		}
	},
	-- 消除第一次，雪怪右上角处的冰消除，进入下一步说明
	[2113] = {
		appear = {
			{type = "scene", scene = "game", para = 211},
			{type = "numMoves", para = 1},
			--{type = "topLevel", para = 211},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 2112 },},
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 4, c = 2, countR = 1, countC = 1},
				    [2] = {r = 4, c = 3, countR = 1, countC = 1},
				    [3] = {r = 5, c = 2, countR = 1, countC = 1},
				    [4] = {r = 5, c = 3, countR = 1, countC = 1}, 
				}, 
				text = "tutorial.game.text21102",panType = "up", panAlign = "matrixD", panPosY = 5.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
			[2] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 4, c = 2, countR = 1, countC = 1},
				    [2] = {r = 4, c = 3, countR = 1, countC = 1},
				    [3] = {r = 5, c = 2, countR = 1, countC = 1},
				    [4] = {r = 5, c = 3, countR = 1, countC = 1}, 
				    [5] = {r = 4, c = 7, countR = 1, countC = 1},
				    [6] = {r = 4, c = 8, countR = 1, countC = 1},
				    [7] = {r = 5, c = 7, countR = 1, countC = 1},
				    [8] = {r = 5, c = 8, countR = 1, countC = 1},
				}, 
				text = "tutorial.game.text21103",panType = "up", panAlign = "matrixD", panPosY = 6.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear = {}
	},
--第241关，黑色毛球说明	
	[2410] = {
		appear = {
			{type = "scene", scene = "game", para = 241},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 241},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 9, c = 2, countR = 1, countC = 1},
				    [2] = {r = 9, c = 4, countR = 1, countC = 1},
				    [3] = {r = 9, c = 6, countR = 1, countC = 1},
				    [4] = {r = 9, c = 8, countR = 1, countC = 1},
				}, 
				text = "tutorial.game.text24100",panType = "down", panAlign = "matrixD", panPosY = 3.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		},
		disappear = {}
	},
--第271关，含羞草说明	
	[2710] = {
		appear = {
			{type = "scene", scene = "game", para = 271},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 271},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {{r = 5, c = 1, countR = 1, countC = 1}}, 
				text = "tutorial.game.text27100",panType = "up", panAlign = "matrixD", panPosY = 5.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		    [2] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 2, c = 3, countR = 1, countC = 1},
                         [2] = {r = 4, c = 2, countR = 3, countC = 1},
                         [3] = {r = 5, c = 1, countR = 1, countC = 1},
				}, 
				allow = {r = 2, c = 2, countR = 1, countC = 2}, 
				from = ccp(2.3, 3), to = ccp(2.3, 2.3), 
				text = "tutorial.game.text27101", panType = "up", panAlign = "matrixD", panPosY = 5.5, panFlip="true",
				handDelay = 1.2 , panDelay = 0.8 , 
		    },
		},
		disappear = {
			{type = "swap", from = ccp(2, 3), to = ccp(2, 2)},
		},
	},
-- 消除第一次，绿叶球就要向外生长了，进入下一步说明
	[2711] = {
		appear = {
			{type = "scene", scene = "game", para = 271},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 271},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 2710 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 5, c = 1, countR = 1, countC = 1},
                         [2] = {r = 6, c = 3, countR = 1, countC = 1},
                         [3] = {r = 7, c = 2, countR = 1, countC = 3},
				}, 
				allow = {r = 7, c = 3, countR = 2, countC = 1}, 
				from = ccp(6.3, 3.3), to = ccp(7.3, 3.3), 
				text = "tutorial.game.text27102", panType = "down", panAlign = "matrixD", panPosY = 0.5, panFlip="true",
				handDelay = 1.2 , panDelay = 0.8 , 
		    },
		},
		disappear = {
			{type = "swap", from = ccp(6, 3), to = ccp(7, 3)},
		}
	},
-- 消除第二次，绿叶球向外生长两格，进入下一步说明
	[2712] = {
		appear = {
			{type = "scene", scene = "game", para = 271},
			{type = "numMoves", para = 2},
			{type = "topLevel", para = 271},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceOnly"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 2711 },},
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 5, c = 1, countR = 1, countC = 3},
				}, 
				text = "tutorial.game.text27103",panType = "up", panAlign = "matrixD", panPosY = 6.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
			[2] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 5, c = 3, countR = 1, countC = 3},
				}, 
				text = "tutorial.game.text27104",panType = "up", panAlign = "matrixD", panPosY = 6.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear ={}
	},		
--第331关，蜗牛说明
	[3310] = {
			appear = {
				{type = "scene", scene = "game", para = 331},
				{type = "numMoves", para = 0},
				{type = "topLevel", para = 331},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"}
			},
			action = {
				[1] = {type = "showTile", opacity = 0xCC, 
					array = {{r = 1, c = 8, countR = 1, countC = 1}}, 
					text = "tutorial.game.text33100",panType = "up", panAlign = "matrixD", panPosY = 3.5 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},			
			    [2] = {type = "gameSwap", opacity = 0xCC, 
					array = {[1] = {r = 4, c = 8, countR = 4, countC = 1},
	                         [2] = {r = 2, c = 7, countR = 1, countC = 1},
					}, 
					allow = {r = 2, c = 7, countR = 1, countC = 2}, 
					from = ccp(2.3, 8.3), to = ccp(2.3, 7.3), 
					text = "tutorial.game.text33101", panType = "up", panAlign = "matrixD", panPosY = 5.0, panFlip="true",
					handDelay = 1.2 , panDelay = 0.8 , 
			    },
			},
			disappear = {
				{type = "swap", from = ccp(2, 7), to = ccp(2, 8)},
			},
		},
-- 消除第一次，消除与蜗牛相邻的小动物，进入下一步说明
	[3311] = {
			appear = {
				{type = "scene", scene = "game", para = 331},
				{type = "numMoves", para = 1},
				{type = "topLevel", para = 331},
				{type = "noPopup"},
				{type = "staticBoard"},
				{type = "onceOnly"},
				{type = "onceLevel"},
				{type = "curLevelGuided", guide = { 3310 },},
			},
			action = {
				[1] = {type = "showTile", opacity = 0xCC, 
					array = {
					    [1] = {r = 4, c = 8, countR = 4, countC = 1},
					    [2] = {r = 4, c = 6, countR = 1, countC = 1},
					}, 
					text = "tutorial.game.text33102",panType = "up", panAlign = "matrixD", panPosY = 5.0 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},			
			},
			disappear = {}
		},
	[160000] = {
			appear = {
				{type = "scene", scene = "game", 
				para = {
				160001,160002,160003,160004,160005,160006,160007,160008,160009,160010,160011,160012,160013,
				160014,160015}},
				{type = "numMoves", para = 0},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"},
			},
			action = {
				[1] = {type = "showInfo", opacity = 0xCC, 
					array = {
					    [1] = {r = 4, c = 8, countR = 4, countC = 1},
					    [2] = {r = 4, c = 6, countR = 1, countC = 1},
					}, 
					text = "tutorial.game.textrabbit",panType = "up", panAlign = "matrixD", panPosY = 5.0 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7,
					panImage = {
						[1] = { image = "rabbit_guide.png", scale = ccp(1, 1) , x = 300 , y = -300},
					},
				},
				[2] = {type = "showProp",
					opacity = 0xCC, index = 1, 
					text = "tutorial.game.text.prop.10055", 
					multRadius=1.1 ,
					panType = "down", panAlign = "winY", panPosY = 720, panFlip = "true",
					maskDelay = 0.2,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 10055,
				},
				[3] = {type = "showProp",
					opacity = 0xCC, index = 1, 
					text = "tutorial.game.text.prop.10056", 
					multRadius=1.1 ,
					panType = "down", panAlign = "winY", panPosY = 720, panFlip = "true",
					maskDelay = 0.2,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 10056,
				},			
			},
			disappear = {}
		},
		-- 活动关卡引导
	[130000] = {
		appear = {
				{type = "scene", scene = "game", para = {130001, 130002, 130003, 130004, 130005}},
				{type = "numMoves", para = 0},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"},
			},
		action = {
				[1] = {type = "showInfo", opacity = 0xCC, 
					text = "activity.mid.autumn.tutorial",panType = "up", panAlign = "matrixD", panPosY = 5.0 ,panFlip="true",
					panDelay = 5.2, maskDelay = 5.1 ,maskFade = 0.4,touchDelay = 1.7,
					panImage = {
						[1] = { image = "guides_panImage_mayday_boss.png", scale = ccp(1, 1) , x = 300 , y = -300},
					},
				},			
			},
		disappear = {}
	},
	[150000] = {
		appear = {
				{type = "scene", scene = "game", para = {150037, 150038, 150039, 150040, 150041}},
				{type = "numMoves", para = 0},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"},
			},
		action = {
				[1] = {type = "showInfo", opacity = 0xCC, 
					text = "activity.thanksgiving.tutorial",panType = "up", panAlign = "matrixD", panPosY = 5.0 ,panFlip="true",
					panDelay = 5.2, maskDelay = 5.1 ,maskFade = 0.4,touchDelay = 1.7,
					panImage = {
						[1] = { image = "guides_thanksgiving.png", scale = ccp(1, 1) , x = 300 , y = -300},
					},
				},			
			},
		disappear = {}
	},
--第376关，传送带说明
	[3760] = {
			appear = {
				{type = "scene", scene = "game", para = 376},
				{type = "numMoves", para = 0},
				{type = "topLevel", para = 376},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"}
			},
			action = {
				[1] = {type = "showTile", opacity = 0xCC, 
					array = {{r = 4, c = 1, countR = 1, countC = 9}}, 
					text = "tutorial.game.text37600",panType = "up", panAlign = "matrixD", panPosY = 5.5 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},			
			},
			disappear = {},
	},	
--第406关，海洋生物说明
	[4060] = {
		appear = {
			{type = "scene", scene = "game", para = 406},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 406},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 3, c = 2, countR = 3, countC = 1},
                         [2] = {r = 1, c = 3, countR = 1, countC = 1},
				}, 
				allow = {r = 1, c = 2, countR = 1, countC = 2}, 
				from = ccp(1, 2.3), to = ccp(1, 3.3), 
				text = "tutorial.game.text40600", panType = "up", panAlign = "matrixD", panPosY = 6, 
				handDelay = 1.2 , panDelay = 0.8, 
				},
			},
		disappear = {
			{type = "swap", from = ccp(1, 2), to = ccp(1, 3)},
		},
	},
	[4061] = {
		appear = {
			{type = "scene", scene = "game", para = 406},
			{type = "numMoves", para = 1},
			{type = "staticBoard"},
			{type = "topLevel", para = 406},
			{type = "noPopup"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 4060 },},
		},
		action = {
			[1] = {type = "showObj", opacity = 0xCC, index = 2, 
				text = "tutorial.game.text40601", panAlign = "winY", panPosY = 920, panType = "up", 
				maskDelay = 1,maskFade = 0.4, panDelay = 1.3, panFade = 0.2, touchDelay = 1.9,
				width = 3, height = 1.2,
			},
		},
		disappear = {},
	},
--第436关，增益障碍说明
[4360] = {
		appear = {
			{type = "scene", scene = "game", para = 436},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 436},
			{type = "noPopup"},
			{type = "onceLevel"},
			{type = "onceOnly"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
					[1] = {r = 5, c = 5, countR = 1, countC = 1}
				}, 
				text = "tutorial.game.text43600",panType = "up", panAlign = "matrixD", panPosY = 6.5, 
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
			[2] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 4, c = 3, countR = 1, countC = 1}, 
					[2] = {r = 5, c = 3, countR = 1, countC = 3}
				}, 
				allow = {r = 5, c = 3, countR = 2, countC = 1}, 
				from = ccp(4, 3.3), to = ccp(5, 3.3), 
				text = "tutorial.game.text43601",panType = "up", panAlign = "matrixD", panPosY = 6.5,
				panDelay =0.1 , handDelay = 0.3 ,
			},
		},
		disappear = {
			{type = "swap", from = ccp(4, 3), to = ccp(5, 3)},
		}
	},
--消除第二次
[4361] = {
		appear = {
			{type = "scene", scene = "game", para = 436},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 436},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = { 4360 },}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 5, c = 5, countR = 1, countC = 1 }, 
					[2] = {r = 7, c = 6, countR = 3, countC = 1 }
				}, 
				allow = {r = 5, c = 5, countR = 1, countC = 2}, 
				from = ccp(5.3, 5), to = ccp(5.3, 6), 
				text = "tutorial.game.text43602",panType = "up", panAlign = "matrixD", panPosY = 7.5,
				handDelay = 0.9 , panDelay = 0.6,
			},
		},
		disappear = {
			{type = "swap", from = ccp(5, 5), to = ccp(5, 6)},
		}
	},
--第三步说明
[4362] = {
		appear = {
			{type = "scene", scene = "game", para = 436},
			{type = "numMoves", para = 2},
			{type = "topLevel", para = 436},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = { 4361 },}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 5, c = 6, countR = 1, countC = 1},
				}, 
				text = "tutorial.game.text43603",panType = "up", panAlign = "matrixD", panPosY = 6.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		},
		disappear = {}
	},	
--第466关，蜂蜜说明
	[4660] = {
		appear = {
			{type = "scene", scene = "game", para = 466},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 466},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 5, c = 6, countR = 1, countC = 1},
                         [2] = {r = 6, c = 6, countR = 1, countC = 2},
                         [3] = {r = 7, c = 5, countR = 1, countC = 2}
				}, 
				allow = {r = 6, c = 6, countR = 1, countC = 2}, 
				from = ccp(6, 6.3), to = ccp(6, 7.3), 
				text = "tutorial.game.text46600", panType = "up", panAlign = "matrixD", panPosY = 7.5, 
				handDelay = 1.2 , panDelay = 0.8, 
				},
			},
		disappear = {
			{type = "swap", from = ccp(6, 6), to = ccp(6, 7)},
		},
	},
--消除第二次
    [4661] = {
		appear = {
			{type = "scene", scene = "game", para = 466},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 466},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = { 4660 },}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 6, c = 4, countR = 1, countC = 1 }, 
					[2] = {r = 7, c = 3, countR = 1, countC = 3 },
					[3] = {r = 8, c = 4, countR = 1, countC = 1 }
				}, 
				allow = {r = 7, c = 3, countR = 1, countC = 2}, 
				from = ccp(7, 3.3), to = ccp(7, 4.3), 
				text = "tutorial.game.text46601",panType = "down", panAlign = "matrixD", panPosY = 1,
				handDelay = 0.9 , panDelay = 0.6,
			},
		},
		disappear = {
			{type = "swap", from = ccp(7, 3), to = ccp(7, 4)},
		}
	},
--消除第三次
    [4662] = {
		appear = {
			{type = "scene", scene = "game", para = 466},
			{type = "numMoves", para = 2},
			{type = "topLevel", para = 466},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = { 4661 },}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 9, c = 5, countR = 4, countC = 1 }
				}, 
				allow = {r = 7, c = 5, countR = 2, countC = 1}, 
				from = ccp(6.3, 5), to = ccp(7.3, 5), 
				text = "tutorial.game.text46602",panType = "down", panAlign = "matrixD", panPosY = 1.5,
				handDelay = 0.9 , panDelay = 0.6,
			},
		},
		disappear = {
			{type = "swap", from = ccp(6, 5), to = ccp(7, 5)},
		}
	},
--第四步说明
    [4663] = {
		appear = {
			{type = "scene", scene = "game", para = 466},
			{type = "numMoves", para = 3},
			{type = "topLevel", para = 466},
			{type = "noPopup"},
            {type = "staticBoard"},
			{type = "curLevelGuided", guide = { 4662 },}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 5, c = 3, countR = 1, countC = 3 },
				    [2] = {r = 6, c = 3, countR = 1, countC = 3 },
				    [3] = {r = 7, c = 3, countR = 1, countC = 3 },				    
				}, 
				text = "tutorial.game.text46603",panType = "up", panAlign = "matrixD", panPosY = 8,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		},
		disappear = {}
	},	
--圣诞关卡引导
    [180000] = {
			appear = {
				{type = "scene", scene = "game", para = {180001,180002,180003,180004,180005}},
				{type = "noPopup"},
				{type = "numMoves", para = 0},
				{type = "onceOnly"},
				{type = "onceLevel"},
			},
			action = {
				[1] = {type = "showTile", opacity = 0xCC, 
					array = {}, 
					text = "tutorial.game.text1800010",panType = "up", panAlign = "matrixD", panPosY = 3.5 ,panFlip="true",
					panDelay = 5.2, maskDelay = 5.1 ,maskFade = 0.4,touchDelay = 1.7
				}
			},
			disappear = {
				
			},
		},
	[180001] = {
			appear = {
				{type = "scene", scene = "game", para = {180001,180002,180003,180004,180005}},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"},
				{type = 'halloweenBoss'},
				{type = "numMoves", para = 0},
			},
			action = {	
			    [1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 1, c = 1, countR = 1.7, countC = 9 }}, 
					text = "tutorial.game.text1800011",panType = "up", panAlign = "matrixD", panPosY = 3.5 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},		
				[2] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 9, c = 3, countR = 2, countC = 3 }}, 
					text = "tutorial.game.text1800012",panType = "up", panAlign = "matrixD", panPosY = 2 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},
			},
			disappear = {
				{type = "swap", from = ccp(2, 7), to = ccp(2, 8)},
			},
		},
	[210000] = {
			appear = {
				{type = "scene", scene = "game", para = {230007, 230008, 230009, 230010, 230011, 230012}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstShowFirework', value = true}
			},
			action = {	
			    [1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230001", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = -58,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
				}	
			},
			disappear = {
			},
		},
	[210001] = {
			appear = {
				{type = "scene", scene = "game", para = {230007, 230008, 230009, 230010, 230011, 230012}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstQuestionMark', value = true}
			},
			action = {	
			    [1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 1, c = 1, countR = 1, countC = 1 }}, 
					offsetY = 4.5,
					text = "tutorial.game.text230002",panType = "up", panAlign = "matrixD", panPosY = 4.5, panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},	
			},
			disappear = {
			},
		},
	[210002] = {
			appear = {
				{type = "scene", scene = "game", para = {230007, 230008, 230009, 230010, 230011, 230012}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstFullFirework', value = true}
			},
			action = {	
			    [1] = {type = "showCustomizeArea", opacity = 0xCC, 
					offsetX = -80, offsetY = -65, width = 150, height = 150, position = ccp(349, 131), --默认值
					text = "tutorial.game.text230003",panType = "up", panAlign = "matrixD", panPosY = 5 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				}
			},
			disappear = {
			},
		},
	[210003] = {
		appear = {
			{type = "scene", scene = "game", para ={230007, 230008, 230009, 230010, 230011, 230012}},
			{type = "onceLevel"},
			{type = "noPopup"},
			{type = 'waitSignal', name = 'showFullFireworkTip', value = true}
		},
		action = {	
			[1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230004", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = -58,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
			}
		},
		disappear = {
		},
	},
	[230100] = {
			appear = {
				{type = "scene", scene = "game", para = {230101,230102,230103,230104,230105,230106,230107,230108,230109,230110,230111,230112,230113,230114,230115,230116,230117,230118,230119,230120}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstShowFirework', value = true}
			},
			action = {
			    [1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230006", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
				}	
			},
			disappear = {
			},
		},
	[230101] = {
			appear = {
				{type = "scene", scene = "game", para = {230101,230102,230103,230104,230105,230106,230107,230108,230109,230110,230111,230112,230113,230114,230115,230116,230117,230118,230119,230120}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstQuestionMark', value = true}
			},
			action = {	
			    [1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 1, c = 1, countR = 1, countC = 1 }}, 
					offsetY = 4.5,
					text = "tutorial.game.text230007",panType = "up", panAlign = "matrixD", panPosY = 4.5, panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},	
			},
			disappear = {
			},
		},
	[230102] = {
			appear = {
				{type = "scene", scene = "game", para = {230101,230102,230103,230104,230105,230106,230107,230108,230109,230110,230111,230112,230113,230114,230115,230116,230117,230118,230119,230120}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstFullFirework', value = true}
			},
			action = {	
			    [1] = {type = "showProp",
					opacity = 0xCC, index = 1, 
					text = "tutorial.game.text230008", 
					multRadius=1.1 ,
					panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
					maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
				}
			},
			disappear = {
			},
		},
	[230103] = {
		appear = {
			{type = "scene", scene = "game", para ={230101,230102,230103,230104,230105,230106,230107,230108,230109,230110,230111,230112,230113,230114,230115,230116,230117,230118,230119,230120}},
			{type = "onceLevel"},
			{type = "noPopup"},
			{type = 'waitSignal', name = 'showFullFireworkTip', value = true}
		},
		action = {	
			[1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230009", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
			}
		},
		disappear = {
		},
	},
	[230104] = {
		appear = {
			{type = "scene", scene = "game", para ={230101,230102,230103,230104,230105,230106,230107,230108,230109,230110,230111,230112,230113,230114,230115,230116,230117,230118,230119,230120}},
			{type = "onceLevel"},
			{type = "noPopup"},
			{type = 'waitSignal', name = 'forceUseFullFirework', value = true}
		},
		action = {	
			[1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230010", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 3, propId = 9999,
			}
		},
		disappear = {
		},
	},

	--春季周赛引导
	[230200] = {
			appear = {
				{type = "scene", scene = "game", para = {230203,230204,230205,230206,230207,230208,230209,230210,230211,230212,230213,230214,230215,230216,230217,230218,230219,230220,230221,230222}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstShowFirework', value = true}
			},
			action = {
			    [1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230011", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
				}	
			},
			disappear = {
			},
		},
	[230201] = {
			appear = {
				{type = "scene", scene = "game", para = {230203,230204,230205,230206,230207,230208,230209,230210,230211,230212,230213,230214,230215,230216,230217,230218,230219,230220,230221,230222}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstQuestionMark', value = true}
			},
			action = {	
			    [1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 1, c = 1, countR = 1, countC = 1 }}, 
					offsetY = 4.5,
					text = "tutorial.game.text230012",panType = "up", panAlign = "matrixD", panPosY = 4.5, panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},	
			},
			disappear = {
			},
		},
	[230202] = {
			appear = {
				{type = "scene", scene = "game", para = {230203,230204,230205,230206,230207,230208,230209,230210,230211,230212,230213,230214,230215,230216,230217,230218,230219,230220,230221,230222}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstFullFirework', value = true}
			},
			action = {	
			    [1] = {type = "showProp",
					opacity = 0xCC, index = 1, 
					text = "tutorial.game.text230013", 
					multRadius=1.1 ,
					panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
					maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
				}
			},
			disappear = {
			},
		},
	[230203] = {
		appear = {
			{type = "scene", scene = "game", para ={230203,230204,230205,230206,230207,230208,230209,230210,230211,230212,230213,230214,230215,230216,230217,230218,230219,230220,230221,230222}},
			{type = "onceLevel"},
			{type = "noPopup"},
			{type = 'waitSignal', name = 'showFullFireworkTip', value = true}
		},
		action = {	
			[1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230014", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
			}
		},
		disappear = {
		},
	},
	[230204] = {
		appear = {
			{type = "scene", scene = "game", para ={230203,230204,230205,230206,230207,230208,230209,230210,230211,230212,230213,230214,230215,230216,230217,230218,230219,230220,230221,230222}},
			{type = "onceLevel"},
			{type = "noPopup"},
			{type = 'waitSignal', name = 'forceUseFullFirework', value = true}
		},
		action = {	
			[1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230015", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 3, propId = 9999,
			}
		},
		disappear = {
		},
	},

	--端午节关卡引导
    [220000] = {
			appear = {
				{type = "scene", scene = "game", para = {220001,220002,220003,220004,220005}},
				{type = "noPopup"},
				{type = "numMoves", para = 0},
				{type = "onceOnly"},
				{type = "onceLevel"},
			},
			action = {
				[1] = {type = "showTile", opacity = 0xCC, 
					array = {}, 
					text = "tutorial.game.text2000010",panType = "up", panAlign = "matrixD", panPosY = 3.5 ,panFlip="true",
					panDelay = 5.2, maskDelay = 5.1 ,maskFade = 0.4,touchDelay = 1.7
				}
			},
			disappear = {
			},
		},
	[220001] = {
			appear = {
				{type = "scene", scene = "game", para = {220001,220002,220003,220004,220005}},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"},
				{type = 'halloweenBoss'},
				{type = "numMoves", para = 0},
			},
			action = {	
			    [1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 1, c = 1, countR = 2, countC = 9 }}, 
					text = "tutorial.game.text2000011",panType = "up", panAlign = "matrixD", panPosY = 3.5 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},		
				[2] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 9, c = 3, countR = 2, countC = 3 }}, 
					text = "tutorial.game.text2000012",panType = "up", panAlign = "matrixD", panPosY = 2 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},
			},
			disappear = {
				{type = "swap", from = ccp(2, 7), to = ccp(2, 8)},
			},
		},
	[220002] = {
			appear = {
				{type = "scene", scene = "game", para = {220001,220002,220003,220004,220005}},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"},
				{type = "goldZongzi"},
				{type = "numMoves", para = 0},
			},
			action = {	
			    [1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 1, c = 1, countR = 1, countC = 1 }}, 
					text = "tutorial.game.text2000013",panType = "up", panAlign = "matrixD", panPosY = 3.5 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},
			},
			disappear = {},
		},
	--两周年活动
    [250006] = {
			appear = {
				{type = "scene", scene = "game", para = {250101}},
				{type = "noPopup"},
				{type = "numMoves", para = 0},
				{type = "onceOnly"},
				{type = "onceLevel"},
			},
			action = {
				[1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 9, c = 1, countR = 3, countC = 9 }}, 
					text = "tutorial.game.text2501011",panType = "down", panAlign = "matrixD", panPosY = 3.5 ,panFlip="true",
					panDelay = 5.2, maskDelay = 5.1 ,maskFade = 0.4,touchDelay = 1.7
				}
			},
			disappear = {
			},
		},
	[250007] = {
			appear = {
				{type = "scene", scene = "game", para = {250101}},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"},
				{type = 'halloweenBoss'},
			},
			action = {	
			 --    [1] = {type = "showTile", opacity = 0xCC, 
				-- 	array = {[1] = {r = 2, c = 1, countR = 3, countC = 9 }}, 
				-- 	text = "tutorial.game.text2500015",panType = "up", panAlign = "matrixD", panPosY = 3.5 ,panFlip="true",
				-- 	panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				-- },		
				[1] = {type = "showTile", opacity = 0xCC, 
					array = {
					[1] = {r = 1, c = 1, countR = 2, countC = 3 },  -- magicTile
					-- [2] = {r = 2, c = 1, countR = 3, countC = 9 }, -- boss
					}, 
					text = "tutorial.game.text2501012",panType = "down", panAlign = "matrixD", panPosY = 2 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},
			},
			disappear = {
			},
		},
	[250008] = {
			appear = {
				{type = "scene", scene = "game", para = {250101}},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"},
				{type = "goldZongzi"},
			},
			action = {	
			    [1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 1, c = 1, countR = 1, countC = 1 }}, 
					text = "tutorial.game.text2501013",panType = "down", panAlign = "matrixD", panPosY = 2 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},
			},
			disappear = {},
		},
	[250009] = {
			appear = {
				{type = "scene", scene = "game", para = {250101}},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"},
				{type = "waitSignal", name = 'halloweenBossDie', value = true},
			},
			action = {	
			    [1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 9, c = 1, countR = 3, countC = 9 }}, 
					text = "tutorial.game.text2501014",panType = "down", panAlign = "matrixD", panPosY = 3 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},
			},
			disappear = {},
		},
--第496关，流沙说明
	[4960] = {
			appear = {
				{type = "scene", scene = "game", para = 496},
				{type = "numMoves", para = 0},
				{type = "topLevel", para = 496},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"}
			},
			action = {
				[1] = {type = "showTile", opacity = 0xCC, 
					array = {{r = 6, c = 4, countR = 3, countC = 3}}, 
					text = "tutorial.game.text49600",panType = "down", panAlign = "matrixD", panPosY = 7 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},			
			},
			disappear = {},
		},
--第526关，锁链说明
[5260] = {
		appear = {
			{type = "scene", scene = "game", para = 526},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 526},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {{r = 7, c = 1, countR = 1.5, countC = 2.5}}, 
				text = "tutorial.game.text52600",panType = "down", panAlign = "matrixD", panPosY = 1.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		    [2] = {type = "showTile", opacity = 0xCC, 
				array = {{r = 5.5, c = 4.5, countR = 2, countC = 2}}, 
				text = "tutorial.game.text52601",panType = "up", panAlign = "matrixD", panPosY = 6.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},		
		},
		disappear = {
		},
	},
--第556关，魔法石说明
    [5560] = {
		appear = {
			{type = "scene", scene = "game", para = 556},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 556},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {{r = 9, c = 5, countR = 1, countC = 1}}, 
				text = "tutorial.game.text55600",panType = "down", panAlign = "matrixD", panPosY = 4.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		    [2] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 7, c = 5, countR = 1, countC = 1 },
				    [2] = {r = 8, c = 4, countR = 1, countC = 3 },
				    [3] = {r = 9, c = 3, countR = 1, countC = 5 },				    
				}, 
				text = "tutorial.game.text55601",panType = "down", panAlign = "matrixD", panPosY = 2.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
			[3] = {type = "showObj", opacity = 0xCC, index = 2, 
				text = "tutorial.game.text55602",panType = "up", panAlign = "matrixD", panPosY = 1 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},		
		},
		disappear = {
		},
	},
--第200004-200007关，手机解锁关卡，松鼠和橡果的说明
	[2000000] = {
		appear = {
			{type = "scene", scene = "game", para = {200004,200005,200006,200007}},
			{type = "numMoves", para = 0},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showUFO", opacity = 0xCC, 
				position = ccp(9, 5), width = 1.65, height = 1.8, oval = true, deltaY = 15,
				text = "tutorial.game.text2000000",panType = "down", panAlign = "matrixD", panPosY = 3 ,panFlip="true",
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
			[2] = {type = "showObj", opacity = 0xCC, index = 1, 
				text = "tutorial.game.text2000001",panType = "up", panAlign = "matrixD", panPosY = 2 ,panFlip="true",
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear = {
		},
	},
--第586关，移动地块说明
	[5860] = {
			appear = {
				{type = "scene", scene = "game", para = 586},
				{type = "numMoves", para = 0},
				{type = "topLevel", para = 586},
				{type = "noPopup"},
				{type = "onceOnly"},
				{type = "onceLevel"}
			},
			action = {
				[1] = {type = "showTile", opacity = 0xCC, 
					array = {{r = 3, c = 4, countR = 1, countC = 1}}, 
					text = "tutorial.game.text58600",panType = "up", panAlign = "matrixD", panPosY = 5 ,panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},			
			},
			disappear = {},
		},

--第631关，萌豆说明
    [6310] = {
		appear = {
			{type = "scene", scene = "game", para = 631},
			{type = "numMoves", para = 0},
			{type = "topLevel", para =631},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 1, c = 4, countR = 1, countC = 2},
                         [2] = {r = 2, c = 5, countR = 1, countC = 1},
                         [3] = {r = 3, c = 5, countR = 1, countC = 1}
				}, 
				allow = {r = 1, c = 4, countR = 1, countC = 2}, 
				from = ccp(1, 4.3), to = ccp(1, 5.3), 
				text = "tutorial.game.text63100", panType = "up", panAlign = "matrixD", panPosY = 4, 
				handDelay = 1.2 , panDelay = 0.8, 
				},
			},
		disappear = {
			{type = "swap", from = ccp(1, 4), to = ccp(1, 5)},
		},
	},
--消除第二次
    [6311] = {
		appear = {
			{type = "scene", scene = "game", para =631},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 631},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = { 6310 },}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 2, c = 6, countR = 1, countC = 1}, 
					[2] = {r = 3, c = 5, countR = 1, countC = 3},
				}, 
				allow = {r = 3, c = 6, countR = 2, countC = 1}, 
				from = ccp(2.3, 6), to = ccp(3.3, 6), 
				text = "tutorial.game.text63101",panType = "up", panAlign = "matrixD", panPosY = 5,
				handDelay = 0.9 , panDelay = 0.6,
			},
		},
		disappear = {
			{type = "swap", from = ccp(2, 6), to = ccp(3, 6)},
		}
	},
--消除第三次
    [6312] = {
		appear = {
			{type = "scene", scene = "game", para = 631},
			{type = "numMoves", para = 2},
			{type = "topLevel", para = 631},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = { 6311 },}
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 2, c = 6, countR = 1, countC = 1 },
                    [2] = {r = 3, c = 5, countR = 1, countC = 3 }
				}, 
				allow = {r = 3, c = 6, countR = 2, countC = 1}, 
				from = ccp(2.3, 6), to = ccp(3.3, 6), 
				text = "tutorial.game.text63102",panType = "up", panAlign = "matrixD", panPosY = 4,
				handDelay = 0.9 , panDelay = 0.6,
			},
		},
		disappear = {
			{type = "swap", from = ccp(2, 6), to = ccp(3, 6)},
		}
	},	

--第30关，灰色毛球新手引导
[300] = {
		appear = {
			{type = "scene", scene = "game", para = 30},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 30},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {{r = 3, c = 1, countR = 1, countC = 1}}, 
				text = "tutorial.game.text3000",panType = "up", panAlign = "matrixD", panPosY = 4,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		    [2] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 1, c = 7, countR = 1, countC = 1},
                         [2] = {r = 2, c = 7, countR = 1, countC = 2},
                         [3] = {r = 3, c = 7, countR = 1, countC = 1},
                         [4] = {r = 3, c = 1, countR = 1, countC = 2},
				}, 
				allow = {r = 2, c = 7, countR = 1, countC = 2}, 
				from = ccp(2, 8), to = ccp(2, 7), 
				text = "tutorial.game.text3001", panType = "up", panAlign = "matrixD", panPosY = 4, panFlip="true",
				handDelay = 1.2 , panDelay = 0.8 , 
		    },
		},
		disappear = {
			{type = "swap", from = ccp(2, 8), to = ccp(2, 7)},
		},
	},
-- 消除第一次，毛球蹦走，进入下一步说明
	[301] = {
		appear = {
			{type = "scene", scene = "game", para = 30},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 30},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 300 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 1, c = 3, countR = 1, countC = 2},
                         [2] = {r = 2, c = 3, countR = 1, countC = 1},
                         [3] = {r = 3, c = 2, countR = 1, countC = 2},
				}, 
				allow = {r = 1, c = 3, countR = 1, countC = 2}, 
				from = ccp(1.3, 4), to = ccp(1.3, 3), 
				text = "tutorial.game.text3002", panType = "up", panAlign = "matrixD", panPosY = 4,
				handDelay = 1.2 , panDelay = 0.8 , 
		    },
		},
		disappear = {
			{type = "swap", from = ccp(1, 4), to = ccp(1, 3)},
		}
	},
--十一关卡引导
--消除第一次，引导点亮路径，刺猬前进
    [2600010] = {
			appear = {
			{type = "scene", scene = "game", para = 260001},
			{type = "numMoves", para = 0},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		     },
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 6, c = 2, countR = 1, countC = 1},
                         [2] = {r = 7, c = 3, countR = 4, countC = 1},
				}, 
				allow = {r = 6, c = 2, countR = 1, countC = 2}, 
				from = ccp(6, 2.3), to = ccp(6, 3.3), 
				text = "tutorial.game.text26000100", panType = "up", panAlign = "matrixD", panPosY = 8, 
				maskDelay = 6, maskFade = 0.4, touchDelay = 7.5, handDelay = 6.9, panDelay = 6.5, 
				},
			},
		disappear = {
			{type = "swap", from = ccp(6, 2), to = ccp(6, 3)},
		},
	},
	--第二步：引导收集苹果攒能量及消除触发滚屏规则
    [2600011] = {
		appear = {
			{type = "scene", scene = "game", para =260001},
			{type = "numMoves", para = 1},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = {2600010},},
		},
		action = {
			[1] = {type = "showObj", opacity = 0xCC, index = 1, 
				text = "tutorial.game.text26000101",panType = "up", panAlign = "matrixD", panPosY = 0,
				maskDelay = 0.8,maskFade = 0.4, panDelay = 1.1,touchDelay = 1.7
			},
			[2] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 7, c = 6, countR = 1, countC = 2 },
				         [2] = {r = 8, c = 1, countR = 1, countC = 9 },
                         [3] = {r = 9, c = 1, countR = 1, countC = 9 },
				}, 
				allow = {r = 8, c = 7, countR = 1, countC = 2}, 
				from = ccp(8, 7.3), to = ccp(8, 8.3), 
				text = "tutorial.game.text26000102",panType = "down", panAlign = "matrixD", panPosY = 3,
				handDelay = 0.9 , panDelay = 0.6,
			},
		},
		disappear = {
			{type = "swap", from = ccp(8, 7), to = ccp(8, 8)},
		},
	},	

     --第三步：引导点击刺猬放大招
    [2600012] = {
			appear = {
				{type = "scene", scene = "game", para = 260001},
				{type = "noPopup"},
			    {type = 'waitSignal', name = "hedgehogCrazy", value = true},
			    {type = "onceOnly"},
			    {type = "onceLevel"}
			},
			action = {
				[1] = {type = "clickTile", opacity = 0xCC,
				array = {[1] = {r = 2, c = 3, countR = 1, countC = 1}}, 
				text = "tutorial.game.text26000103",panType = "down" , panAlign = "matrixD" , panPosY = 0,
				panDelay = 0.8, maskDelay = 0.3 ,maskFade = 0.4,touchDelay = 1.4,
			},

			},
			disappear = {
				{type = "click", {value = true}},
			}
		},
		--15年圣诞关卡引导
--消除第一次，引导点亮路径，刺猬前进
    [2600140] = {
			appear = {
			{type = "scene", scene = "game", para = 260014},
			{type = "numMoves", para = 0},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		     },
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, ignoreCharacter = true,
				array = {[1] = {r = 5, c = 5, countR = 1, countC = 1},
                         [2] = {r = 4, c = 3, countR = 1, countC = 4},
				}, 
				allow = {r = 5, c = 5, countR = 2, countC = 1}, 
				from = ccp(5.1, 5), to = ccp(4.1, 5), 
				text = "tutorial.game.text26000100", panType = "up", panAlign = "matrixD", panPosY = 6, 
				maskDelay = 6, maskFade = 0.4, touchDelay = 7.5, handDelay = 6.9, panDelay = 6.5, 
				panImage = {
					[1] = { image = "christmas_dc_up.png", scale = ccp(1, 1) , x =556 , y = -121},
				},
				},
			},
		disappear = {
			{type = "swap", from = ccp(5, 5), to = ccp(4, 5)},
		},
	},
	--第二步：引导收集苹果攒能量及消除触发滚屏规则
    [2600141] = {
		appear = {
			{type = "scene", scene = "game", para =260014},
			{type = "numMoves", para = 1},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = {2600140},},
		},
		action = {
			[1] = {type = "showObj", opacity = 0xCC, index = 1, ignoreCharacter = true,
				text = "tutorial.game.text26000101",panType = "up", panAlign = "matrixD", panPosY = 0,
				maskDelay = 0.8,maskFade = 0.4, panDelay = 1.1,touchDelay = 1.7,
				panImage = {
					[1] = { image = "christmas_dc_up.png", scale = ccp(1, 1) , x =556 , y = -121},
				},
			},
			[2] = {type = "gameSwap", opacity = 0xCC, ignoreCharacter = true, 
				array = {[1] = {r = 5, c = 9, countR = 1, countC = 1 },
						 [2] = {r = 7, c = 8, countR = 4, countC = 1 },
				         [3] = {r = 8, c = 1, countR = 1, countC = 9 },
                         [4] = {r = 9, c = 1, countR = 1, countC = 9 },
				}, 
				allow = {r = 5, c = 8, countR = 1, countC = 2}, 
				from = ccp(5, 9), to = ccp(5, 8), 
				text = "tutorial.game.text26000102",panType = "down", panAlign = "matrixD", panPosY = 0,
				handDelay = 0.9 , panDelay = 0.6,
				panImage = {
					[1] = { image = "christmas_dc_down.png", scale = ccp(1, 1) , x =513 , y = -121},
				},
			},
		},
		disappear = {
			{type = "swap", from = ccp(5, 9), to = ccp(5, 8)},
		},
	},	

     --第三步：引导点击刺猬放大招
    [2600142] = {
			appear = {
				{type = "scene", scene = "game", para = 260014},
				{type = "noPopup"},
			    {type = 'waitSignal', name = "hedgehogCrazy", value = true},
			    {type = "onceOnly"},
			    {type = "onceLevel"}
			},
			action = {
				[1] = {type = "clickTile", opacity = 0xCC, ignoreCharacter = true,
				array = {[1] = {r = 2, c = 3, countR = 1, countC = 1}}, 
				text = "tutorial.game.text26000103",panType = "down" , panAlign = "matrixD" , panPosY = 0,
				panDelay = 0.8, maskDelay = 0.3 ,maskFade = 0.4,touchDelay = 1.4,
				panImage = {
					[1] = { image = "christmas_dc_down.png", scale = ccp(1, 1) , x =513 , y = -121},
				},
			},

		},
			disappear = {
				{type = "click", {value = true}},
			}
		},

	--2016春节新手引导消除桃子
    [2700010] = {
		appear = {
			{type = "scene", scene = "game", para = 270001},
			{type = "numMoves", para = 0},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
	     },
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 3, c = 5, countR = 1, countC = 1},
                         [2] = {r = 7, c = 2, countR = 3, countC = 3},
				}, 
				allow = {r = 6, c = 3, countR = 2, countC = 1}, 
				from = ccp(5.1, 3), to = ccp(6.1, 3), 
				text = "tutorial.game.text27000100", panType = "up", panAlign = "matrixD", panPosY = 7.5, 
				maskDelay = 6, maskFade = 0.4, touchDelay = 6.5, handDelay = 7.9, panDelay = 6.5, 
				--panImage = {
					--[1] = { image = "christmas_dc_up.png", scale = ccp(1, 1) , x =556 , y = -121},
				--},
			},
		},
		disappear = {
			{type = "swap", from = ccp(5, 3), to = ccp(6, 3)},
		},
	},
	--2016春节新手引导消除桃子
	 [2700014] = {
		appear = {
			{type = "scene", scene = "game", para = 270001},
			{type = "numMoves", para = 1},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = {2700010},},
	     },
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 3, c = 5, countR = 1, countC = 1},
                         [2] = {r = 7, c = 6, countR = 3, countC = 3},
				}, 
				allow = {r = 6, c = 7, countR = 2, countC = 1}, 
				from = ccp(5.1, 7), to = ccp(6.1, 7), 
				text = "tutorial.game.text27000103", panType = "up", panAlign = "matrixD", panPosY = 7.5, 
				maskDelay = 2, maskFade = 0.4, touchDelay = 3.5, handDelay = 3, panDelay = 2.5, 
				--panImage = {
					--[1] = { image = "christmas_dc_up.png", scale = ccp(1, 1) , x =556 , y = -121},
				--},
			},
		},
		disappear = {
			{type = "swap", from = ccp(5, 7), to = ccp(6, 7)},
		},
	},

	--2016春节点击猴子不能放大招
    [2700011] = {
		appear = {
			{type = "scene", scene = "game", para = {270001,270002,270003,270004,270005}},
			{type = "noPopup"},
		    {type = 'waitSignal', name = "wukongGuideJumpClick", value = true},
		    --{type = "onceOnly"},
		    --{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {}, --由wukongGuideJump处传入
				text = "tutorial.game.text27000102",panType = "down", panAlign = "matrixD", panPosY = 2.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear = {
			--{type = "click", {value = true}},
		}
	},

	--2016春节点击猴子不能放大招
	[2700012] = {
		appear = {
			{type = "scene", scene = "game", para = {270001,270002,270003,270004,270005}},
			{type = "noPopup"},
		    {type = 'waitSignal', name = "wukongGuideJumpAuto", value = true},
		    --{type = "onceOnly"},
		    --{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {}, --由wukongGuideJump处传入
				text = "tutorial.game.text27000102",panType = "down", panAlign = "matrixD", panPosY = 2.5 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear = {
			--{type = "click", {value = true}},
		}
	},

    --2016春节引导点击猴子放大招
    [2700013] = {
		appear = {
			{type = "scene", scene = "game", para = 270001},
			{type = "noPopup"},
		    {type = 'waitSignal', name = "wukongCrazy", value = true},
		    {type = "onceOnly"},
		    {type = "onceLevel"}
		},
		action = {
			[1] = {type = "clickTile", opacity = 0xCC, 
				array = {[1] = {r = 2, c = 3, countR = 1, countC = 1}}, 
				text = "tutorial.game.text27000101",panType = "up" , panAlign = "matrixD" , panPosY = 4,
				panDelay = 0.8, maskDelay = 0.3 ,maskFade = 0.4,touchDelay = 1.4,
				--panImage = {
					--[1] = { image = "christmas_dc_down.png", scale = ccp(1, 1) , x =513 , y = -121},
				--},
			},
		},
		disappear = {
			{type = "click", {value = true}},
		}
	},

	--2016春节2新手引导消除桃子
    [2700020] = {
		appear = {
			{type = "scene", scene = "game", para = 270002},
			{type = "numMoves", para = 0},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
	     },
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 3, c = 5, countR = 1, countC = 1},
				         [2] = {r = 4, c = 3, countR = 1, countC = 3},
				}, 
				allow = {r = 4, c = 5, countR = 2, countC = 1}, 
				from = ccp(3.1, 5), to = ccp(4.1, 5), 
				text = "tutorial.game.text27000200", panType = "up", panAlign = "matrixD", panPosY = 4.5, 
				maskDelay = 6, maskFade = 0.4, touchDelay = 6.5, handDelay = 7.9, panDelay = 6.5, 
				--panImage = {
					--[1] = { image = "christmas_dc_up.png", scale = ccp(1, 1) , x =556 , y = -121},
				--},
			},
		},
		disappear = {
			{type = "swap", from = ccp(3, 5), to = ccp(4, 5)},
		},
	},

--第276关，含羞草2说明	
	[2760] = {
		appear = {
			{type = "scene", scene = "game", para = 276},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 276},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {{r = 9, c = 4, countR = 1, countC = 1},
				 {r = 9, c = 6, countR = 1, countC = 1}}, 
				text = "tutorial.game.text27600",panType = "down", panAlign = "matrixD", panPosY = 4 ,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		    [2] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 3, c = 1, countR = 1, countC = 1},
					 [2] = {r = 3, c = 2, countR = 3, countC = 1},
					 [3] = {r = 9, c = 4, countR = 1, countC = 1},
					 [4] = {r = 9, c = 6, countR = 1, countC = 1},
				}, 
				allow = {r = 3, c = 1, countR = 1, countC = 2}, 
				from = ccp(3, 2), to = ccp(3, 1.3), 
				text = "tutorial.game.text27601", panType = "up", panAlign = "matrixD", panPosY = 4, panFlip="false",
				handDelay = 1.2 , panDelay = 0.8 , 
		    },
		},
		disappear = {
			{type = "swap", from = ccp(3, 1), to = ccp(3, 2)},
		},
	},
-- 消除第一次，绿叶球就要向外生长了，进入下一步说明
	[2761] = {
		appear = {
			{type = "scene", scene = "game", para = 276},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 276},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 2760 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 9, c = 4, countR = 1, countC = 1}},
				array = {[1] = {r = 9, c = 6, countR = 1, countC = 1},
					 [2] = {r = 3, c = 6, countR = 3, countC = 1},
					 [3] = {r = 2, c = 5, countR = 1, countC = 1},
				}, 
				allow = {r = 2, c = 5, countR = 1, countC = 2}, 
				from = ccp(2.3, 5.3), to = ccp(2.3, 6.3), 
				text = "tutorial.game.text27602", panType = "up", panAlign = "matrixD", panPosY = 3.5, panFlip="true",
				handDelay = 1.2 , panDelay = 0.8 , 
		    },
		},
		disappear = {
			{type = "swap", from = ccp(2, 5), to = ccp(2, 6)},
		}
	},
-- 消除第二次，绿叶球向外生长两格，进入下一步说明
	[2762] = {
		appear = {
			{type = "scene", scene = "game", para = 276},
			{type = "numMoves", para = 2},
			{type = "topLevel", para = 276},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 2761 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 9, c = 4, countR = 1, countC = 1},
					 [2] = {r = 8, c = 3, countR = 1, countC = 3},
					 [3] = {r = 7, c = 3, countR = 1, countC = 1},
				}, 
				allow = {r = 8, c = 3, countR = 2, countC = 1}, 
				from = ccp(8.3, 3.3), to = ccp(7.3, 3.3), 
				text = "tutorial.game.text27603", panType = "down", panAlign = "matrixD", panPosY = 2.5, panFlip="false",
				handDelay = 1.2 , panDelay = 0.8 , 
		    },
		},
		disappear = {
			{type = "swap", from = ccp(8, 3), to = ccp(7, 3)},
		}
	},	
-- 消除第三次，绿叶球再向外生长两格，进入下一步说明
	[2763] = {
		appear = {
			{type = "scene", scene = "game", para = 276},
			{type = "numMoves", para = 3},
			{type = "topLevel", para = 276},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = { 2762 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 9, c = 6, countR = 1, countC = 1},
					 [2] = {r = 6, c = 5, countR = 1, countC = 3},
					 [3] = {r = 5, c = 5, countR = 1, countC = 1},
				}, 
				allow = {r = 6, c = 5, countR = 2, countC = 1}, 
				from = ccp(6.3, 5.3), to = ccp(5.3, 5.3), 
				text = "tutorial.game.text27604", panType = "down", panAlign = "matrixD", panPosY = 0.5, panFlip="true",
				handDelay = 1.2 , panDelay = 0.8 , 
			},
		},
		disappear = {
			{type = "swap", from = ccp(6, 5), to = ccp(5, 5)},
		}
	},
-- 最后一步说明
	[2764] = {
		appear = {
			{type = "scene", scene = "game", para = 276},
			{type = "numMoves", para = 4},
			{type = "topLevel", para = 276},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = { 2763 },},
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {
				    [1] = {r = 9, c = 4, countR = 3, countC = 3},
				}, 
				text = "tutorial.game.text27605",panType = "down", panAlign = "matrixD", panPosY = 2.5 ,panFlip="false",
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear ={}
	},
--第676关，染色宝宝新手引导
[6760] = {
		appear = {
			{type = "scene", scene = "game", para = 676},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 676},
			{type = "noPopup"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {{r = 3, c = 5, countR = 2, countC = 1}}, 
				text = "tutorial.game.text67600",panType = "up", panAlign = "matrixD", panPosY = 4,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		   [2] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 8, c = 5, countR = 1, countC = 1},
                         [2] = {r = 7, c = 4, countR = 1, countC = 3},
				}, 
				allow = {r = 8, c = 5, countR = 2, countC = 1}, 
				from = ccp(7.3, 5), to = ccp(8.3, 5), 
				text = "tutorial.game.text67601", panType = "down", panAlign = "matrixD", panPosY = 3,
				handDelay = 1.2 , panDelay = 0.8 , 
		   },
		},
		disappear = {
			{type = "swap", from = ccp(7, 5), to = ccp(8, 5)},
		},
	},
--蓄能过程
	[6761] = {
		appear = {
			{type = "scene", scene = "game", para = 676},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 676},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 6760 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 7, c = 5, countR = 1, countC = 1},
                         [2] = {r = 8, c = 4, countR = 1, countC = 3},
				}, 
				allow = {r = 8, c = 5, countR = 2, countC = 1}, 
				from = ccp(7.3, 5), to = ccp(8.3, 5), 
				text = "tutorial.game.text67602", panType = "down", panAlign = "matrixD", panPosY = 3,
				handDelay = 1.2 , panDelay = 0.8 ,
		   },
		},
		disappear = {
			{type = "swap", from = ccp(7, 5), to = ccp(8, 5)},
		},
	},
	
--充满能量，引导交换染色宝宝
	[6762] = {
		appear = {
			{type = "scene", scene = "game", para = 676},
			{type = "numMoves", para = 2},
			{type = "topLevel", para = 676},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 6761 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 2, c = 5, countR = 2, countC = 1},
				}, 
				allow = {r = 2, c = 5, countR = 2, countC = 1}, 
				from = ccp(2.3, 5), to = ccp(1.3, 5), 
				text = "tutorial.game.text67603", panType = "up", panAlign = "matrixD", panPosY = 4,
				handDelay = 1.2 , panDelay = 0.8 , 
		   },
		},
		disappear = {
			{type = "swap", from = ccp(1, 5), to = ccp(2, 5)},
		}
	},
	--730关 引导特效让染色宝宝充能
	-- 730染色宝宝交换引导
	[7300] = {
		appear = {
			{type = "scene", scene = "game", para = 730},
			{type = "noPopup"},
			{type = "topLevel", para = 730},
			{type = "onceOnly"},
			{type = "onceLevel"},
		    {type = 'waitSignal', name = "twoCrystalStones", value = true},
		},
		action = {	
		    [1] = {type = "gameSwap", opacity = 0xCC, 
				array = {}, 
				allow = {r = 1, c = 1, countR = 1, countC = 2}, 
				from = ccp(1, 1), to = ccp(1, 2), 
				text = "tutorial.game.text73000", panType = "up", panAlign = "matrixD", panPosY = 4, panFlip="true",
				handDelay = 1.2, panDelay = 0.8, 
			},		
		},
		disappear = {
			{type = "swap", from = ccp(1, 1), to = ccp(1, 2)},
		},
	},
	[7301] = {
		appear = {
			{type = "scene", scene = "game", para = 730},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 730},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			--{type = "onceOnly"},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 9, c = 2, countR = 3, countC = 2},
				}, 
				allow = {r = 7, c = 2, countR = 1, countC = 2}, 
				from = ccp(7, 3), to = ccp(7, 2), 
				text = "tutorial.game.text73001", panType = "down", panAlign = "matrixD", panPosY = 2,
				handDelay = 1.2 , panDelay = 0.8 , 
		   },
		},
		disappear = {
			{type = "swap", from = ccp(7, 3), to = ccp(7, 2)},
		}
	},
--第736关，闪电鸟新手引导
[7360] = {
		appear = {
			{type = "scene", scene = "game", para = 736},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 736},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		},
		action = {
			[1] = {type = "showTile", opacity = 0xCC, 
				array = {[1] = {r = 2, c = 2, countR = 1, countC = 1},
				         [2] = {r = 2, c = 8, countR = 1, countC = 1},
				         [3] = {r = 8, c = 2, countR = 1, countC = 1},
				         [4] = {r = 8, c = 8, countR = 1, countC = 1},}, 
				text = "tutorial.game.text73600",panType = "up", panAlign = "matrixD", panPosY = 3.5,
				panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
			},			
		   [2] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 1, c = 7, countR = 1, countC = 1},
                         [2] = {r = 2, c = 7, countR = 1, countC = 3},
				}, 
				allow = {r = 2, c = 7, countR = 2, countC = 1}, 
				from = ccp(1.3, 7), to = ccp(2.3, 7), 
				text = "tutorial.game.text73601", panType = "up", panAlign = "matrixD", panPosY = 3,
				handDelay = 1.2 , panDelay = 0.8 , 
		   },
		},
		disappear = {
			{type = "swap", from = ccp(1, 7), to = ccp(2, 7)},
		},
	},
--第二步
	[7361] = {
		appear = {
			{type = "scene", scene = "game", para = 736},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 736},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 7360 },},
		},
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 2, c = 8, countR = 1, countC = 1},
					[2] = {r = 7, c = 1, countR = 1, countC = 1},
					[3] = {r = 8, c = 1, countR = 1, countC = 3},
				}, 
				allow = {r = 8, c = 1, countR = 2, countC = 1}, 
				from = ccp(7.3, 1), to = ccp(8.3, 1), 
				text = "tutorial.game.text73602", panType = "down", panAlign = "matrixD", panPosY = 3,
				handDelay = 1.2 , panDelay = 0.8 ,
		   },
		},
		disappear = {
			{type = "swap", from = ccp(7, 1), to = ccp(8, 1)},
		},
	},

	--荷塘新手引导
    [7960] = {
		appear = {
			{type = "scene", scene = "game", para = 796},
			{type = "numMoves", para = 0},
			{type = "staticBoard"},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
	     },
		action = {
			[1] = {type = "showInfo", opacity = 0xCC, 
				--text = "tutorial.game.text304", 
				maskDelay = 0.8, maskFade = 0.2, panDelay = 0.8, panFade = 0.1,touchDelay = 1.4,			
				panImage = {
				[1] = {image = "guides.panImage_lotus.png",scale = ccp(1,1) , x = 310 , y = -360}
 				},
			},
		  [2] = {type = "gameSwap", opacity = 0xCC, 
				array = {
					[1] = {r = 3, c = 5, countR = 1, countC = 1},
					[2] = {r = 4, c = 4, countR = 1, countC = 3},
				}, 
				allow = {r = 4, c = 5, countR = 2, countC = 1}, 
				from = ccp(3.3, 5), to = ccp(4.3, 5), 
				text = "tutorial.game.text796", panType = "up", panAlign = "matrixD", panPosY = 5,
				handDelay = 1.2 , panDelay = 0.8 , 
		   },
		},
		disappear = {
			{type = "swap", from = ccp(3, 5), to = ccp(4, 5)},
		},
	},



--六一关卡引导
--消除第一次，引导点亮路径，木马前进
    [2601010] = {
			appear = {
			{type = "scene", scene = "game", para = 260101},
			{type = "numMoves", para = 0},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "onceLevel"}
		     },
		action = {
			[1] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 6, c = 2, countR = 1, countC = 1},
                         [2] = {r = 7, c = 3, countR = 4, countC = 1},
				}, 
				allow = {r = 6, c = 2, countR = 1, countC = 2}, 
				from = ccp(6, 2.3), to = ccp(6, 3.3), 
				text = "tutorial.game.text26010100", panType = "up", panAlign = "matrixD", panPosY = 8, 
				maskDelay = 6, maskFade = 0.4, touchDelay = 7.5, handDelay = 6.9, panDelay = 6.5, 
				},
			},
		disappear = {
			{type = "swap", from = ccp(6, 2), to = ccp(6, 3)},
		},
	},
	--第二步：引导收集弹珠攒能量及消除触发滚屏规则
    [2601011] = {
		appear = {
			{type = "scene", scene = "game", para =260101},
			{type = "numMoves", para = 1},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "curLevelGuided", guide = {2601010},},
		},
		action = {
			[1] = {type = "showObj", opacity = 0xCC, index = 1, 
				text = "tutorial.game.text26010101",panType = "up", panAlign = "matrixD", panPosY = 0,
				maskDelay = 0.8,maskFade = 0.4, panDelay = 1.1,touchDelay = 1.7
			},
			[2] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 7, c = 6, countR = 1, countC = 1 },
				         [2] = {r = 8, c = 1, countR = 1, countC = 9 },
                         [3] = {r = 9, c = 1, countR = 1, countC = 9 },
				}, 
				allow = {r = 9, c = 2, countR = 2, countC = 1}, 
				from = ccp(8.3, 2), to = ccp(9.3, 2), 
				text = "tutorial.game.text26010102",panType = "down", panAlign = "matrixD", panPosY = 3,
				handDelay = 0.9 , panDelay = 0.6,
			},
		},
		disappear = {
			{type = "swap", from = ccp(8, 2), to = ccp(9, 2)},
		},
	},	

     --第三步：引导点击木马放大招
    [2601012] = {
			appear = {
				{type = "scene", scene = "game", para = 260101},
				{type = "noPopup"},
			    {type = 'waitSignal', name = "hedgehogCrazy", value = true},
			    {type = "onceOnly"},
			    {type = "onceLevel"},
			},
			action = {
				[1] = {type = "clickTile", opacity = 0xCC,
				array = {[1] = {r = 2, c = 3, countR = 1, countC = 1}}, 
				text = "tutorial.game.text26010103",panType = "down" , panAlign = "matrixD" , panPosY = 0,
				panDelay = 0.8, maskDelay = 0.3 ,maskFade = 0.4,touchDelay = 1.4,
			},

			},
			disappear = {
				{type = "click", {value = true}},
			}
		},
--夏季周赛引导（带水滴宝宝版）
	[2303011] = {
			appear = {
				{type = "scene", scene = "game", para = {230301}},
				{type = "onceOnly"},
				{type = "staticBoard"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstShowFirework', value = true},
			},
			action = {
			    [1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230011", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
				},
				[2] = {type = "gameSwap", opacity = 0xCC, 
				array = {[1] = {r = 4, c = 4, countR = 1, countC = 3},
                         [2] = {r = 5, c = 5, countR = 1, countC = 1},
				}, 
				allow = {r = 5, c = 5, countR = 2, countC = 1}, 
				from = ccp(4.3, 5), to = ccp(5.3, 5), 
				text = "tutorial.game.text230016", panType = "up", panAlign = "matrixD", panPosY = 6, 
				maskDelay = 0, maskFade = 0.4, touchDelay = 1.5, handDelay = 0.9, panDelay = 0.5, 
				},
			},
			disappear = {
			{type = "swap", from = ccp(4, 5), to = ccp(5, 5)},
			},
		},
	[2303012] = {
			appear = {
				{type = "scene", scene = "game", para = {230301}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = "staticBoard"},
				{type = 'waitSignal', name = 'firstQuestionMark', value = true},
				{type = "curLevelGuided", guide = { 2303011 },},
			},
			action = {	
			    [1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 1, c = 1, countR = 1, countC = 1 }}, 
					offsetY = 4.5,
					text = "tutorial.game.text230012",panType = "up", panAlign = "matrixD", panPosY = 4.5, panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},	
			},
			disappear = {
			},
		},
	[2303013] = {
			appear = {
				{type = "scene", scene = "game", para = {230301}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = "staticBoard"},
				{type = 'waitSignal', name = 'firstFullFirework', value = true},
				{type = "curLevelGuided", guide = { 2303011 },},
			},
			action = {	
			    [1] = {type = "showProp",
					opacity = 0xCC, index = 1, 
					text = "tutorial.game.text230013", 
					multRadius=1.1 ,
					panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
					maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
				}
			},
			disappear = {
			},
		},
	[2303014] = {
		appear = {
			{type = "scene", scene = "game", para ={230301}},
			{type = "onceLevel"},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = 'waitSignal', name = 'showFullFireworkTip', value = true},
			{type = "curLevelGuided", guide = { 2303011 },},
		},
		action = {	
			[1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230014", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
			}
		},
		disappear = {
		},
	},
	[2303015] = {
		appear = {
			{type = "scene", scene = "game", para ={230301}},
			{type = "onceLevel"},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = 'waitSignal', name = 'forceUseFullFirework', value = true},
			{type = "curLevelGuided", guide = { 2303011 },},
		},
		action = {	
			[1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230015", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 3, propId = 9999,
			}
		},
		disappear = {
		},
	},
--夏季周赛引导（不带水滴宝宝版）
[2303311] = {
			appear = {
				{type = "scene", scene = "game", para = {230331}},
				{type = "onceOnly"},
				{type = "staticBoard"},
				{type = "noPopup"},
				{type = 'waitSignal', name = 'firstShowFirework', value = true},
			},
			action = {
			    [1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230011", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
				},
			},
			disappear = {
			},
		},
	[2303312] = {
			appear = {
				{type = "scene", scene = "game", para = {230331}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = "staticBoard"},
				{type = 'waitSignal', name = 'firstQuestionMark', value = true},
				{type = "curLevelGuided", guide = { 2303311 },},
			},
			action = {	
			    [1] = {type = "showTile", opacity = 0xCC, 
					array = {[1] = {r = 1, c = 1, countR = 1, countC = 1 }}, 
					offsetY = 4.5,
					text = "tutorial.game.text230012",panType = "up", panAlign = "matrixD", panPosY = 4.5, panFlip="true",
					panDelay = 1.1, maskDelay = 0.8 ,maskFade = 0.4,touchDelay = 1.7
				},	
			},
			disappear = {
			},
		},
	[2303313] = {
			appear = {
				{type = "scene", scene = "game", para = {230331}},
				{type = "onceOnly"},
				{type = "noPopup"},
				{type = "staticBoard"},
				{type = 'waitSignal', name = 'firstFullFirework', value = true},
				{type = "curLevelGuided", guide = { 2303311 },},
			},
			action = {	
			    [1] = {type = "showProp",
					opacity = 0xCC, index = 1, 
					text = "tutorial.game.text230013", 
					multRadius=1.1 ,
					panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
					maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
				}
			},
			disappear = {
			},
		},
	[2303314] = {
		appear = {
			{type = "scene", scene = "game", para ={230331}},
			{type = "onceLevel"},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = 'waitSignal', name = 'showFullFireworkTip', value = true},
			{type = "curLevelGuided", guide = { 2303311 },},
		},
		action = {	
			[1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230014", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 1, propId = 9999,
			}
		},
		disappear = {
		},
	},
	[2303315] = {
		appear = {
			{type = "scene", scene = "game", para ={230331}},
			{type = "onceLevel"},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = 'waitSignal', name = 'forceUseFullFirework', value = true},
			{type = "curLevelGuided", guide = { 2303311 },},
		},
		action = {	
			[1] = {type = "showProp",
				opacity = 0xCC, index = 1, 
				text = "tutorial.game.text230015", 
				multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 600, panFlip = "true", offsetX = 0,
				maskDelay = 1,maskFade = 0.4 ,panDelay = 1, touchDelay = 3, propId = 9999,
			}
		},
		disappear = {
		},
	},
}

GuideSeeds = table.const
{
	[1] = 1389943462,
	[2] = 1394088236,
	[3] = 1395992355,
	[4] = 1394096931,
	[5] = 1395993581,
	[6] = 1396066208,
	[8] = 1388138716,
	[12] = 1394099839,
	[121]=1440413286,
	[136] = 1395387867,
	[211] = 1441522423,
	[271] = 1441520945,
	[276] = 1448613867,
	[331] = 1440928205,
	[436] = 1441521759,
	[466] = 1440933409,
	[467] = 1440679879,
	[631] = 1440677804,
	[30] = 1440761545,
	[260001] = 1442306154,
	[167] = 1444733242,
	[260014] = 1448520404,
	[676] = 1451023816,
	[270001] = 1454309081,
	[260101] = 1462779018,
}