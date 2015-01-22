--mask、pan、hand：半透明遮盖、文字面板、手型提示
--Delay、fade：出现延迟、淡入过程时间
--panType =up/down 小浣熊向上/下看的动画
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

local vs = Director:sharedDirector():getVisibleSize()
local vo = Director:sharedDirector():getVisibleOrigin()

Guides = table.const
{
	-- 弹出新手面板
	[0] = {
		appear = {
			{type = "scene", scene = "worldMap"},
			{type = "topLevel", para = 1},
			{type = "onceOnly"}
		},
		action = {
			[1] = {type = "beginnerPanel"},
		},
		disappear = {
			{type = "popdown", popdown = "beginnerPanel"},
		}
	},
	-- 转盘引导
	[1] = {
		appear = {
			{type = "turnTableEnable", value = true},
			{type = "onceOnly"},
		},
		action = {
			[1] = {type = "turnTableSlide", delay = 2},
		},
		disappear = {
			{type = "popdown", popdown = "turnTablePanel"},
			{type = "turnTableEnable", value = false},
		},
	},
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
			[2] = {type = "showEliminate", c = 7}
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
	--解锁16关金银果树提示
	[160] = {
		appear = {
			{type = "scene", scene = "worldMap"},
			{type = "button", button = "fruitTree"},
			{type = "topLevel", para = 16},
			{type = "noPopup"},
			{type = "onceOnly"},
		},
		action = {
			[1] = {type = "fruitTreeButton", opacity = 0xCC,
				text = "tutorial.game.text1600", panType = "down", panAlign = "viewY",
				panPosY = 500, maskDelay = 0.3, maskFade = 0.4, panDelay = 0.5, touchDelay = 1.1
			},
		},
		disappear = {
			{type = "popup"},
			{type = "result", key = "fruitTreeButton", value = false},
			{type = "scene", scene = "game"},
			{type = "scene", scene = "fruitTree"},
		}
	},
	--金银果树点击果实
	[161] = {
		appear = {
			{type = "scene", scene = "fruitTree"},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "success", guide = {160},},
		},
		action = {
			[1] = {type = "clickFruit", index = 4, limitGrowCount = 5, handDelay = 0.5},
		},
		disappear = {
			{type = "scene", scene = "game"},
			{type = "scene", scene = "worldMap"},
			{type = "popup"},
			{type = "fruitClicked", index = 4},
		}
	},
	--金银果树果实操作
	[162] = {
		appear = {
			{type = "scene", scene = "fruitTree"},
			{type = "noPopup"},
			{type = "onceOnly"},
			{type = "fruitClicked", index = 4},
			{type = "success", guide = {160, 161},},
		},
		action = {
			[1] = {type = "fruitButton", text = "tutorial.game.text1601",
				panType = "up", panAlign = "viewY", panPosY = 400, maskDelay = 0.3,
				maskFade = 0.4, panDelay = 0.5, touchDelay = 1.1
			},
		},
		disappear = {
			{type = "scene", scene = "game"},
			{type = "scene", scene = "worldMap"},
			{type = "fruitNotClicked"},
			{type = "fruitButtonClick", button = "pick"},
			{type = "fruitButtonClick", button = "regen"},
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
	[310] = {
		appear = {
			{type = "noPopup"},
			{type = "scene", scene = "worldMap"},
			{type = "button", button = "weeklyRace"},
			{type = "topLevel", para = 31},
			{type = "onceOnly"}
		},
		action = {
			[1] = {type = "weeklyRaceButton", opacity = 0xCC, index = 1, 
				text = "tutorial.game.text3100", maskPos = ccp(536, 940),multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 1080,
				maskDelay = 0.3,maskFade = 0.4 ,panDelay = 0.5, touchDelay = 1
			},
		},
		disappear = {}
	},
	[311] = {
		appear = {
			{type = "noPopup"},
			{type = "scene", scene = "worldMap"},
			{type = "button", button = "rabbitWeeklyRace"},
			{type = "topLevel", para = 31},
			{type = "onceOnly"}
		},
		action = {
			[1] = {type = "rabbitWeeklyButton", opacity = 0xCC, index = 1, 
				text = "tutorial.game.text3100", maskPos = ccp(536, 940),multRadius=1.1 ,
				panType = "down", panAlign = "winY", panPosY = 1080,
				maskDelay = 0.3,maskFade = 0.4 ,panDelay = 0.5, touchDelay = 1
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
    --鸡窝关，指示鸡窝的位置，消除一次
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
	--彩运关，展示彩云，消除一次
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
				position = ccp(1, 4), width = 1.75, height = 0.75, oval = true, deltaY = 15,
				text = "tutorial.game.text16600",panType = "up", panAlign = "matrixD", panPosY = 3.5 ,
				panDelay = 1.1, maskDelay = 1.2 ,maskFade = 0.4,touchDelay = 1.7
			},
		},
		disappear = {}
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
		disappear = {
			{},
		},
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
--第211关，雪怪说明	
	[2110] = {
		appear = {
			{type = "scene", scene = "game", para = 211},
			{type = "numMoves", para = 0},
			{type = "topLevel", para = 211},
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
	[2111] = {
		appear = {
			{type = "scene", scene = "game", para = 211},
			{type = "numMoves", para = 1},
			{type = "topLevel", para = 211},
			{type = "noPopup"},
			{type = "staticBoard"},
			{type = "onceLevel"},
			{type = "curLevelGuided", guide = { 2110 },},
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
		},
		disappear = {
			{},
		}
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
			{type = "onceOnly"},
			{type = "onceLevel"}
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
		}
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
	[121] = 1394521266,
	[136] = 1395387867,
	[436] = 1415094147,
	[466] = 1416810132,
}