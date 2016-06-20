module("BATTLE_CONST",package.seeall)
	
DROP_ITEM_SIZE 										= 56
-- 怒气黑色遮罩tag
RAGE_MASK_TAG 										= 19867303
RAGE_MASK_URL 										= "images/battle/icon/battleRageMask.png"
test_URL 											= "images/battle/icon/icon_resource.png"
RAGE_MASK_DIR 										= "images/battle/icon/"
RAGE_MASK_ALL_BLACK_URL 							= "images/battle/icon/blackRageMask.png"
FIGHT_UP_ICON 										= "images/battle/ship/ship_fight_force.png"

TEAM1												= 1					--	队伍1
TEAM2												= 2					--	队伍2
-- 节点结果
NODE_FALSE											= 1 				-- 相当于返回false
NODE_TRUE											= 2					-- 相当于返回true
NODE_RUNNING 										= 3 				-- 当前节点正在运行
NODE_COMPLETE						  				= 4					-- 当前节点运行完毕


-- 宝箱类型
CHEST_HERO_PART										= 1 				-- 英雄碎片
CHEST_ITEM 											= 2 				-- 物品

BENCH_CLICK_EFFECT									= "tibu_click"		-- 替补按钮点击特效
BENCH_UI_REVIVE_EFFECT								= "tibu_flash" 		-- 替补menu中 人物复活特效
BENCH_REVIVE_EFFECT 								= "tibu_arise" 		-- 替补menu中 人物复活特效


  --  战斗难度：简单
HARD_LEVEL_SIMPLE									= "simple"		
HARD_LEVEL_NORMAL									= "normal"			--	战斗难度：一般
HARD_LEVEL_HARD										= "hard"			--	战斗难度：难

CARD_DEMON_GRADE									= 99
 
PLAYER_NPC_ID										= 1

ID_MARK												= 10000000	--id分界线（hero和monster）

MOVE_TO_COST_TIME									= 0.1 				-- 移动到指定距离花费的时间
IMPACT_TO_COST_TIME									= 0.1
KEY_FRAME_SHAKE_TIME								= 0.3

MOVE_IDLE_COST_TIME									= 1 				-- 原地移动需要时间

BACK_GROUND_MOVE_COST_TIME							= 1 				-- 背景移动耗时

ANIMATION_WALK_0									= "A006"
ANIMATION_BUFFER 									= "hurt2"
ANIMATION_DEAD 										= "images/battle/xml/action/T007_0"
ANIMATION_ATTACK									= "A004"
ANIMATION_IMPACT 									= "A002" -- todo 暂无所以用原来的替换
-- ANIMATION_WALK_0									= "images/battle/xml/action/walk_0"
-- ANIMATION_BUFFER 									= "images/battle/xml/action/hurt2_u_0"
-- ANIMATION_DEAD 										= "images/battle/xml/action/T007_0"
-- TIP_TEXTURE_URL										= "images/battle/icon/battleTip.png" -- 战斗中文本提示底图
TIP_TEXTURE_URL										= "images/battle/mystical_shop_txt_bg.png" -- 战斗中文本提示底图

HERO_MOVE_COST_TIME 								= 2.5

BULLET_SPEED										= 6 * 60

FRAME_TIME											= 1/60

ANIMATION_RAGE_FIRE 								= "meffect_31"

MAX_ROUND											= 30

CONDITION_BIG_THAN									= 1
CONDITION_BETWEEN									= 2
CONDITION_LESS_THAN									= 3
CONDITION_EQUAL 									= 4
CONDITION_NOT_EQUAL									= 5

ANIMATION_SCALE 						= 1 -- 战斗动画缩放比

WALK_SOUND_TIME 						= 0.45

 NODE_CONDITION 						= 1
 NODE_ACTION	 						= 2
 NODE_OR 								= 3
 NODE_AND	 							= 4
 NODE_MOVETO	 						= 5
 NODE_ATTACK_ANI	 					= 6
 NODE_DECORATOR_CF 						= 8 -- 装饰节点,子节点返会complete时返回false
 NODE_PARALLEL_OR						= 9 -- 同时执行,结果用or逻辑
 NODE_INSTANT_ACTION 					= 10 -- 瞬时action
 NODE_CUSTOM_ACTION 					= 11 -- 根据action决定是否瞬时
 
 ACTION_MOVETO 							= 1
 ACTION_PLAY_ATTACK_ACTION 				= 2	-- 攻击者技能动作
 ACTION_PLAY_RAGE_FIRE_EFFECT 			= 3 -- 怒气曝气特效
 ACTION_RUN_ACTION_IN_SAME_TIME 		= 4 -- 怒气曝气特效
 ACTION_ATTACKER_TRIGGER		 		= 5 -- 攻击关键帧触发
 ACTION_RAGE_FIRE 						= 6	-- 播放怒气释放特效
 ACTION_RAGE_SKILL_BAR 					= 7	-- 怒气动画条

 ACTION_SKILL_SPELL_ATTACK 				= 8	-- 一般技能打击

 ACTION_SKILL_RANGE_ATTACK 				= 9 -- 技能范围打击(无伤害,只有特效)

 ACTION_REMOTE_ATTACK 					= 10 -- 远程技能打击
 ACTION_SHOW_ADD_BUFF_EFF				= 11
 ACTION_ADD_BUFF_ICON					= 12
 ACTION_NODE_END 						= 13
 ACTION_EFFECT_AT_HERO 					= 14 -- 英雄身上播放特效
 ACTION_XML_ANI_AT_HERO					= 15 -- 英雄身上播放xml动画

 ACTION_SHOW_NUMBER 					= 16 -- 英雄位置上显示数字(多用于伤害显示)
 ACTION_RAGE_BAR_CHANGE 				= 17 -- 改变指定英雄的怒气数量ui
 ACTION_HP_BAR_CHANGE 					= 18 --  改变指定英雄的hp数量ui
 ACTION_REMOVE_BUFF_ICON 				= 19 -- 删除buff图标 BAForRemoveBuffIcon


 ACTION_BS_TREE 						= 20
 
 ACTION_BS_DELETE_BUFF					= 21
 ACTION_BS_ADD_BUFF						= 22
 ACTION_BS_IM_BUFF						= 23
 ACTION_BS_DAMAGE_BUFF 					= 24 

ACTION_CHANGE_HP						= 25	-- 修改hp数据
ACTION_CHANGE_RAGE						= 26	-- 修改怒气数据

ACTION_BS_CHANGE_RAGE					= 27

ACTION_RUN_ALL_BUFF_BY_TIME 			= 28

ACTION_BS_ATTACK 						= 29 -- 攻击逻辑action
ACTION_BS_HANDLE_SKILL 					= 30 -- 分发逻辑action
ACTION_BS_CHECK_UA_COMPLETE				= 31 -- 检测被攻击者是否执行完动作
ACTION_BS_SUBSKILL 						= 32 -- 子技能
ACTION_BS_ROUND_SKILL					= 33 -- 回合技能

ACTION_RAGE_CHANGE_ANI 					= 34 -- 怒气改变动画
ACTION_REACTION_ANI 					= 35
ACTION_CALL_DIE_FUNCTION 				= 36
ACTION_ADD_EFFECT_TO_HERO				= 37
ACTION_BS_DIE 							= 38

ACTION_HIDE_TARGETS						= 39 -- 隐藏目标(BattleObjectDisplay)
ACTION_MOVE_BACKGROUND					= 40 -- 移动背景地图
ACTION_TRAGETS_PLAY_MOVE				= 41 -- 指定目标播放移动动画(归哪个时间)
ACTION_TRAGETS_FADE_IN					= 42 -- 指定目标淡入或者淡出
ACTION_SHOW_BATTLE_NUM_INFO				= 43 -- 显示战斗场次
ACTION_MOVE_ARMY_FROM_FAR				= 44 -- 让敌人从远处移动过来
ACTION_TARGES_PLAY_EFFECT 				= 45 -- 指定目标播放指定特效


ACTION_DELAY							= 46 -- 延迟
ACTION_FLY_ATTACK						= 47 -- 撞击动作

ACTION_REMOTE_FROM_BACK					= 48 -- 从敌军后方出来的弹道
ACTION_REMOTE_PIERCE					= 49 -- 穿刺技能

ACTION_SHOW_SKILL_NAME					= 50 -- 显示技能名称

ACTION_MOVE_BACK 						= 51 -- 移动回去

ACTION_SEND_NOTIFICATION				= 52 -- 发送通知

ACTION_PUSH_BUFF						= 53 -- push buff信息到执行目标

ACTION_MOVE_TARGETS_TO					= 54 -- push buff信息到执行目标

ACTION_SET_Z_ORDER						= 55 -- 设置z

ACTION_SHOW_TOTAL_HURT 					= 56

ACTION_SET_TARGET_VISABLE 				= 57 -- 设置可见
ACTION_SET_TARGET_UNVISABLE 			= 58 -- 设置为不可见

ACTION_UP_TARGET_ZODER 					= 59 -- 设置目标zOder
ACTION_RESUME_TARGET_ZODER 				= 60 -- 恢复目标zOder

ACTION_ADD_IMG_RAGE_MASK				= 61 -- 添加怒气遮罩(图片类)
ACTION_REMOVE_IMG_RAGE_MASK		 		= 62 -- 删除怒气遮罩(图片类)
ACTION_VISIBLE_TARGETS 					= 63


ACTION_ADD_ANI_RAGE_MASK 				= 64 -- 添加怒气遮罩(动画类)
ACTION_REMOVE_ANI_RAGE_MASK 			= 65 -- 删除怒气遮罩(动画类)
ACTION_ZOOM_SCENE		 	 			= 66 -- 删除怒气遮罩(动画类)
ACTION_KICK_OUT 		 	 			= 67 -- 踢飞动作
ACTION_HANDLE_NEAR_DEATH 				= 68 -- 处理濒死
ACTION_TO_RAW_POSTION	 				= 69 -- 玩家到指定位置
ACTION_SEND_PRESTART_EVT	 			= 70 -- 发送提前执行下一个人物回合数据



ACTION_BS_SHIP_ATTACK 						= 500 -- 攻击逻辑action
ACTION_BS_SHIP_HANDLE_SKILL 				= 501 -- 分发逻辑action
ACTION_BS_SHIP_SUBSKILL 					= 502 -- 子技能
-- ACTION_BS_SHIP_ROUND_SKILL					= 503 -- 回合技能



ACTION_SHOW_ARMY_MOVE_IN 				= 1000
ACTION_SHOW_SELF_MOVE_IN 				= 1001

ACTION_SHOW_SELF_MOVEING 				= 1002

ACTION_SHOW_LIGHTING_EFFECT				= 1003
ACTION_SHOW_LIGHTING_MAGIC				= 1004
ACTION_SHOW_HIDE_TARGET					= 1005
ACTION_SHOW_TALK 						= 1006

ACTION_SHOW_SCALE_DOWN 					= 1007

ACTION_MOVE_TARGET_DOWN 				= 1008
ACTION_MOVE_TARGET_UP 					= 1009

ACTION_SHOW_TARGET_WITH_EFFECT 			= 1010
ACTION_CHANGE_MUSIC 					= 1011
ACTION_CHANGE_BACKGROUND 				= 1012
ACTION_PLAY_EFFECT_AT_SCENE 			= 1013
ACTION_SET_TARGETS_VISABLE				= 1014




ACTION_TEAM1_OUT 						= 1015
ACTION_TEAM2_OUT 						= 1016
ACTION_HIDE_TARGETS_WITH_EFFECT			= 1017
ACTION_DELAY_FROM_ANIMATION				= 1018

ACTION_SHOW_BUFF_ADD_TIP				= 1019
ACTION_SHOW_TIP_ON_CENTER				= 1020

ACTION_ACTIVE_BENCH_DATA				= 1021
ACTION_ACTIVE_BENCH_DISPLAY_DATA		= 1022
ACTION_PLAY_EFFECT_BY_ID				= 1023
ACTION_BS_BENCH_SHOW					= 1024 -- 替补逻辑

ACTION_PLAY_EFFECT_AT_POSITION			= 1025


ACTION_SHOW_TITLE_AND_BLACK_BG	 		= 1026 -- 显示指定问题并黑屏

ACTION_SHOW_BOSS_INFO 					= 1027

ARENA_JUMP_BATTLE_TIP_ID				= 4505


ADVENTURE_JUMP_BATTLE_TIP_ID			= 4383
TARGET_FADE_IN_WITH_ID					= 4506
ICOPY_BATTLE_NOT_JUMP_TIP				= 4507
IMPELDOWN_JUMP_BATTLE_TIP_ID			= 7038 -- 深海监狱跳过提示


-----------------------  ship action
SHIP_ACTION_ENTER_SCENCE 				= 10000
SHIP_ACTION_QUIT_SCENCE 				= 10001
SHIP_ACTION_SHOW_SHIP_INFO 				= 10002
SHIP_ACTION_ROTATION_GUN				= 10003
SHIP_ACTION_PLAY_EFFECT_AT_TARGETS		= 10004
SHIP_ACTION_PLAY_GUN_ANIMATION			= 10005
SHIP_ACTION_PLAY_ANIMATION_AT_SHIP		= 10006
SHIP_ACTION_SHOW_SKILL_NAME				= 10007	 
SHIP_ACTION_REMOTE_FIRE					= 10008  -- 主船弹道
SHIP_ACTION_ANIMATION_DAMAGE_TRIGER		= 10009  -- 伤害触发器(和动画绑定)
SHIP_ACTION_SHOW_TEAM_FIGHT_UP			= 10010  -- 显示队伍战斗力上升动画
SHIP_ACTION_SHOW_SHIP_INFO				= 10011  -- 显示主船信息

----------------------- hero postion

POS_HEAD								= 1 -- 卡片顶
POS_MIDDLE								= 2 -- 卡片中间
POS_FEET 								= 3 -- 卡片脚
POS_BUFF 								= 4 -- 特殊buff挂点

------------------- reaction
REACTION_NONE							= 0
REACTION_HIT							= 1
REACTION_DODGE							= 2
REACTION_REHIT							= 3
REACTION_BLOCK							= 4

------------------- reaction animation name
REACTION_ANIMATION_HURT								= "hurt1"
REACTION_ANIMATION_DODGE							= "dodge1"
REACTION_ANIMATION_BLOCK							= "parry"
-------------------- reaction effect name
REACTION_EFFECT_BLOCK								= "heffect_4" --heffect_4 未完成

------------------- xml animation
XML_ANI_DIE_HERO_DIE					= "die"
EFFECT_DIE_1							= "die_1_1"
EFFECT_DIE_2							= "die_1_2"
EFFECT_GUIHUO 							= "guihuo"
EFFECT_DIAOLUO 							= "drop_ying"
---------------------  number color

NC_RED 									= "red"
NC_GREEN 								= "green"
NC_CRITICAL 							= "critical"
-------------------
 
STENDCIL_IMAGE							= "images/battle/rage_head/nuqitouxiang_04.png"

AUTO_FIGHT_UP							= "images/battle/btn/btn_autofight_n.png"
AUTO_FIGHT_DOWN							= "images/battle/btn/btn_autofight_d.png"

CANCLE_AUTO_FIGHT_UP					= "images/battle/btn/btn_cancle_autofight_n.png"
CANCLE_AUTO_FIGHT_DOWN					= "images/battle/btn/btn_cancle_autofight_d.png"

-------------------- propertySetter
PS_AttackerUIToHeroUI									= 1
PS_DamageEffectNameToAnimationName						= 2
PS_DamageActionNameToAnimationName						= 3
PS_HpDamageToValue 										= 4
PS_HpNumberColorToColor 								= 5
PS_BuffChangeEffectToAnimationName 						= 6
PS_RageDamgeToValue 									= 7
PS_BuffDamageTitleToTitle								= 8

--------------------- effect
-- EFFECT_ANGER_DOWN 						= "images/battle/number/angerdown.png"
-- EFFECT_ANGER_UP							= "images/battle/number/angerup.png"

-- EFFECT_BLOCK 							= "images/battle/number/block.png"
-- EFFECT_CRITICAL 						= "images/battle/number/critical.png"
-- EFFECT_DODGE 							= "images/battle/number/dodge.png"
-- EFFECT_FIGHT_BACK						= "images/battle/number/fightback.png"
-- EFFECT_IMMUNITY							= "images/battle/number/immunity.png"

RAGE_UP_IMG_TEXT						= "angerup.png"
RAGE_DOWN_IMG_TEXT						= "angerdown.png"

BLOCK_IMG_TEXT 							= "block.png"
CRITICAL_IMG_TEXT 	 					= "critical.png"
DODGE_IMG_TEXT 	 						= "dodge.png"
FIGHT_BACK_IMG_TEXT 					= "fightback.png"
IMMUNITY_IMG_TEXT 						= "immunity.png"

---------------------- 位图名字
-- BITMAP_CRITICAL							= "critical.png" 				
-- BITMAP_DODGE							= "dodge.png" 
-- BITMAP_BLOCK							= "block.png"
BITMAP_BLANK 							= "blank.png"
----------------------  hp bar 
HP_BAR_PATH 							= "images/battle/card/BattleHPBar.plist"
HP_BAR_TEXTURE_PATH 					= "images/battle/card/BattleHPBar.png"

HP_BAR_BIG_PATH 						= "images/battle/bigcard/BattleBigHPBar.plist"
HP_BAR_BIG_TEXTURE_PATH 				= "images/battle/bigcard/BattleBigHPBar.png"

HP_BAR_SUPER_PATH 						= "images/battle/card3x/BattleSuperHPBar.plist"
HP_BAR_SUPER_TEXTURE_PATH 				= "images/battle/card3x/BattleSuperHPBar.png"

-- 无边框卡牌血条
HP_BAR_4X_PATH 						= "images/battle/card4x/Battle4xHPBar.plist"
HP_BAR_4X_TEXTURE_PATH 				= "images/battle/card4x/Battle4xHPBar.png"


HP_BAR_BACK_SMALL							= "BattleHPBar_red.png"
HP_BAR_PROGRESS_SMALL						= "BattleHPBar_green.png"

HP_BAR_BACK_BIG 							= "BattleBigHPBar_red.png"
HP_BAR_PROGRESS_BIG 						= "BattleBigHPBar_green.png"

HP_BAR_BACK_SUPER 							= "BattleSuperHPBar_red.png"
HP_BAR_PROGRESS_SUPER 						= "BattleSuperHPBar_green.png"

HP_BAR_BACK_4X								= "Battle4xHPBar_red.png"
HP_BAR_PROGRESS_4X 							= "Battle4xHPBar_green.png"
----------------------- rage bar

RAGE_BAR_PATH 							= "images/battle/anger/nomal.png"
RAGE_BAR_BIG_PATH 						= "images/battle/anger/big.png"
RAGE_BAR_X_PATH 						= "images/battle/anger/X.png"
RAGE_BAR_NUMBER_PATH 					= "images/battle/anger"
RAGE_DOT_ANIMATION						= "nuqi_1"

-- 小卡片:怒气闪动动画
RAGE_SHINE_ANI							= "nuqi_1"
-- 大卡牌:怒气闪动动画
RAGE_SHINE_ANI_BIG						= "nuqi_1_b"
-- 超大牌:怒气闪动动画
RAGE_SHINE_ANI_SUPER					= "nuqi_x3"

-- 无边框:怒气闪动动画
RAGE_SHINE_ANI_OUTLINE					= "nuqi_x4"


-- 小卡片:怒气豆图片,怒气小于4时应用
RAGE_DOT_IMG							= "images/battle/card/nuqi_1_10.png"
-- 大卡牌:怒气豆图片,怒气小于4时应用
RAGE_DOT_IMG_BIG						= "images/battle/bigcard/nuqi10.png"
-- 超大牌:怒气豆图片,怒气小于4时应用
RAGE_DOT_IMG_SUPER						= "images/battle/card3x/nuqi20.png"

-- 无边框:怒气豆图片,怒气小于4时应用
RAGE_DOT_IMG_4X							= "images/battle/card4x/nuqi30.png" 

-- 小卡牌怒气超过4时的资源
RAGE_OVER_FOUR_PLIST	  			 	= "images/battle/card/over_four.plist"	-- plist
RAGE_OVER_FOUR_TEXTURE	  			 	= "images/battle/card/over_four.png"	-- 大贴图

RAGE_OVER_FOUR_X 						= "over_four_x.png"		-- x帧名
RAGE_OVER_FOUR_LITTLE_DOT 				= "over_four_ldot.png"  -- 小红点帧名
-- RAGE_OVER_FOUR_LITTLE_DOT 				= "over_four_ldot.png"  -- 小红点帧名
-- RAGE_OVER_FOUR_BIG_DOT 					= "over_four_bdot.png"		-- 大红点帧名
RAGE_OVER_FOUR_BIG_DOT 					= "over_four_bdot.png"		-- 大红点帧名
RAGE_OVER_FOUR_NUM_PRE 					= "over_four_" 		-- 数字前缀名字

--大卡牌超过4时的资源

RAGE_OVER_FOUR_BIG_PLIST	  			= "images/battle/bigcard/over_four_b.plist"
RAGE_OVER_FOUR_BIG_TEXTURE	  			= "images/battle/bigcard/over_four_b.png"

RAGE_OVER_FOUR_X_BIG 					= "over_four_b_x.png"
RAGE_OVER_FOUR_LITTLE_DOT_BIG 			= "over_four_b_ldot.png"
RAGE_OVER_FOUR_BIG_DOT_BIG 				= "over_four_b_bdot.png"
RAGE_OVER_FOUR_NUM_PRE_BIG 				= "over_four_b_"



--超大卡牌超过4时的资源

RAGE_OVER_FOUR_SUPER_PLIST	  				= "images/battle/card3x/over_four_s.plist"
RAGE_OVER_FOUR_SUPER_TEXTURE	  			= "images/battle/card3x/over_four_s.png"

RAGE_OVER_FOUR_X_SUPER 						= "over_four_s_x.png"
RAGE_OVER_FOUR_LITTLE_DOT_SUPER 			= "over_four_s_ldot.png"
RAGE_OVER_FOUR_BIG_DOT_SUPER 				= "over_four_s_bdot.png"
RAGE_OVER_FOUR_NUM_PRE_SUPER 				= "over_four_s_"


--无边框卡牌超过4时的资源

RAGE_OVER_FOUR_4x_PLIST	  				= "images/battle/card4x/over_four_4x.plist"
RAGE_OVER_FOUR_4x_TEXTURE	  			= "images/battle/card4x/over_four_4x.png"

RAGE_OVER_FOUR_X_4x 					= "over_four_4x_x.png"
RAGE_OVER_FOUR_LITTLE_DOT_4x 			= "over_four_4x_ldot.png"
RAGE_OVER_FOUR_BIG_DOT_4x 				= "over_four_4x_bdot.png"
RAGE_OVER_FOUR_NUM_PRE_4x 				= "over_four_4x_"



----------------------- 贝里活动

EVENT_BELLY_LABEL_BACK					= ""

----------------------- speed

SPELL_SPEED											= 30 * 60 * 0.7-- 远程弹道的速度


--------------------------------- skill bg
SKILL_NAME_IMG  						= "images/battle/skill_bg.png"

--------------------------------- buff time


--------------------------------- effect
EFFECT_REVIVED							= "die_2" -- 复活翅膀
EFFECT_REVIVED_COMPLETE					= "die_3" -- 复活特效
EFFECT_DIE								= "meffect_die"
BT_START 								= 1
BT_MIDDLE 								= 2
BT_END 									= 3
-- EFFECT_RAGE_MASK_GROUP 					=  "meffect_"
--------------------------------- buff type

BF_ADD									= 1
BF_REMOVE								= 2
BF_IM									= 3
BF_DAMAGE								= 4

--------------------------------- battle number title 
BNT_NUMBER_PATH 						= "images/battle/title"
BNT_BG									= "images/battle/title/title_bg.png"
BNT_SEPARATOR 							= "images/battle/title/separator.png"

--------------------------------- stronghold battle number 

STRONGHOLD_BATTLE_NUM_PATH 				= "images/battle/number/strongholdNum"
STRONGHOLD_SEPARATOR 					= "images/battle/number/strongholdNum/fight_progress_xiexian.png"
-- SBATTLE_NUM_READ						= "images/battle/number/strongholdNum"

--------------------------------- battle show effect 
BSE_EFFECT1 							= "meffect_cx"
BSE_EFFECT2								= "meffect_16"
---------------------------------- background move direction
DIR_UP 									= -1
DIR_DOWN								= 1

---------------------------------   number 
NUMBER_RED 								= "red"
NUMBER_RED_PLIST						= "images/battle/number/number/red.plist"
NUMBER_RED_TEXTURE						= "images/battle/number/number/red.png"

NUMBER_GREEN 							= "green"
NUMBER_GREEN_PLIST						= "images/battle/number/number/green.plist"
NUMBER_GREEN_TEXTURE					= "images/battle/number/number/green.png"

NUMBER_ORANGE 							= "critical"
NUMBER_ORANGE_PLIST						= "images/battle/number/number/critical.plist"
NUMBER_ORANGE_TEXTURE					= "images/battle/number/number/critical.png"


												-- battleWords.plist
ALL_WORDS_PLIST 						= "images/battle/number/battleWords.plist"
ALL_WORDS_TEXTURE 						= "images/battle/number/battleWords.png"

BATTLE_UI_PLIST 								= "images/battle/icon/battleUI.plist"
BATTLE_UI_TEXTURE 								= "images/battle/icon/battleUI.png"

NUMBER_RAGE_UP 							= "battle_rageup_num"
NUMBER_RAGE_DOWN 						= "battle_ragedown_num"


NUMBER_TOTAL_HURT 						= "b_total_hurt_num"
NUMBER_TOTAL_HURT_PLIST					= "images/battle/number/number/b_total_hurt_num0.plist"
NUMBER_TOTAL_HURT_TEXTURE				= "images/battle/number/number/b_total_hurt_num0.png"

----------------------------------- battle type (copy type)
-- 1普通，2精英，3活动
BTYPE_COPY_NORMAL							= 1 -- 一般副本
BTYPE_COPY_JY								= 2 -- 精英副本
BTYPE_AREAN									= 3 -- 竞技场
BTYPE_COPYU_HUODONG							= 4 -- 活动副本
BTYPE_COPYU_HUODONG_BEILI					= 5 -- 贝里活动副本
----------------------------------- battle parameters
ARENA_BACKGROUND = "bgfightJiaban01.jpg" -- 竞技场背景名称
ARENA_BACKMUSIC = "fight3.mp3" -- 竞技场音乐
ARENA_SKIP_BATTLE = true


TOWER_BACKGROUND = "bgfighthuangjinzhong14.jpg" -- 神秘空岛
TOWER_BACKMUSIC = "fight2.mp3"


ROB_BACKGROUND = "bgfightJiaban01.jpg" -- 打劫背景名称
ROB_BACKMUSIC = "fight2.mp3" -- 打劫音乐



MINE_BACKGROUND = "bgfight05_haian.jpg" -- 资源矿背景名称
MINE_BACKMUSIC = "fight3.mp3" -- 资源矿音乐

-- Tutorial2_BAKCGROUND = ""  
TUTORIAL1_BACKGROUND = "bgfightsenlin04.jpg" -- 新手引导战1
TUTORIAL2_BACKGROUND = "bgfightsenlin04.jpg" -- 新手引导战2


-- top show
TOPSHOW1_BACKGROUND = "bgfightchuxingtai00.jpg" -- 顶上战争1
TOPSHOW2_BACKGROUND = "bgfightchuxingtai00.jpg" -- 顶上战争2

TOPSHOW1_BACKMUSIC = "copy1.mp3"
TOPSHOW2_BACKMUSIC = "copy1.mp3"


WA_BACKGROUND = "bgfightJiaban01.jpg"
WA_BACKMUSIC = "fight2.mp3"

ROB_SKIP_BATTLE = true
 
WINDOW_ROB 					= 10001 -- 打劫结束面板
WINDOW_ARENA 				= 10000 -- 竞技场结束面板
WINDOW_COPY 				= 10002 -- 副本结束面板
WINDOW_NORMAL 		    	= 10003 -- 副本结束面板
WINDOW_ARENA_BILLBOARD  	= 10004 -- 竞技场排行榜录像面板
WINDOW_EVENT_BELLY  		= 10005 -- 贝利活动副本战斗胜利结算面板调用（没有失败情况）
WINDOW_EVENT 		  		= 10006 -- 非贝利活动副本战斗
WINDOW_SEA_PIEA 		  	= 10007 -- 神秘空岛
WINDOW_BOSSS	 		  	= 10008 -- 神秘空岛
WINDOW_ADVENTURE	 		= 10009 -- 奇遇
WINDOW_MINE	 				= 10010 -- 资源矿战斗
WINDOW_GUIDE	 			= 10011 -- 工会战
WINDOW_PVP	 				= 10012 -- 切磋
WINDOW_IMPEL                = 10013 -- 深海监狱
WINDOW_AWAKING              = 10014 -- 觉醒
WINDOW_WA                   = 10015 -- 巅峰对决
-- WINDOW_ARENA_BILLBOARD  = 10007 -- 竞技场排行榜录像面板
 ---------------------- battle start max
 MAX_POSTION 							= 3


----------------------- action mp3
WALK_SOUND 	= "A006_step_0"

RAGE_SKILL_SOUND = "nuqitouxiang"
-- 总伤害动画名字
TOTAL_HURT_ANIMATION_NAME = "battle_total_hurt"


----------------------- boss info

BOSS_INFO_UI 			= "ui/battle_boss.json"
----------------------- ship info
SHIP_INFO_UI 			= "ui/battle_ship.json"


----------------------- string
						  
LABEL_1 				= "    赤犬的熔岩和白胡子的地震相撞，\n这巨大的能量毁灭了整座岛屿。  \n随着岛的下沉，众人匆忙撤离。   "
LABEL_2 				= "不过这并不是终点，我们的船长，\n   你的冒险，才刚刚开始……              "
LABEL_3 				= "贝里不足，无法复活"
LABEL_4 				= "第一章：为了梦想，启航！          "

LABEL_5 				= gi18nString(4503)--"主角等级达到5级可开启2倍加速"
LABEL_6 				= gi18nString(4504)--"主角等级达到40级可开启3倍加速"


LABEL_7 				= gi18nString(4501)--"VIP8玩家主角等级达到40级或通关该据点可跳过战斗"
LABEL_8 				= gi18nString(4502)--"VIP8或主角等级达到50级可跳过战斗"
LABEL_9 				= gi18nString(4506)--"VIP8或主角等级达到50级可跳过战斗"
LABEL_10 				= gi18nString(4508)--"VIP8或主角等级达到50级可跳过战斗"
--难度名字转换[1,2,3]
function getHardLevelName( level )
	if 	level == 1 then
		return HARD_LEVEL_SIMPLE
	elseif level == 2 then
		return HARD_LEVEL_NORMAL
	elseif level == 3 then
		return HARD_LEVEL_HARD
	end
	return HARD_LEVEL_SIMPLE
end


-- 数字动画类型
NUM_ANI_CRTICAL 		= 1
NUM_ANI_NUMBER  		= 2
NUM_ANI_UP 				= 3
NUM_ANI_DOWN 			= 4
NUM_ANI_RED 			= 5
NUM_ANI_MULITY 			= 6
NUM_ANI_GREEN 			= 7
NUM_ANI_HURT_TYPE_1 	= 8
NUM_ANI_SCALE_SHOW  	= 9
NUM_ANI_CRTICAL_TEXT  	= 10
NUM_ANI_CRTICAL_MULITY 	= 11 -- 暴击多段
NUM_ANI_RAGE_UP 		= 12
NUM_ANI_RAGE_DOWN 		= 13
BATTLE_DROP_BACK_IMG 												= "images/base/potential/border.png"

BATTLE_DROP_SHINE_NAME 												= "flash_box"

BATTLE_DROP_ITEM_INCOME												= "fight_box"

BATTLE_DROP_ITEM_PARTICLE											= "granule_box"


-- 替补ui
BENCH_BT_NORMAL														= "images/battle/card/btn_bench_n.png"
BENCH_BT_DOWN														= "images/battle/card/btn_bench_h.png"
BENCH_BT_MENU														= "images/battle/card/bench_photo_bg.png"



---

DIE_ACTION  														= 1 -- 使用死亡动作
DIE_KICK_OUT 														= 2 -- 使用踢飞

	-- 策划需求,3倍卡牌需要有个整体偏移....
	X3_DY = 0.1
-- 卡牌ui

	-- 小卡片 4个怒气点相对于卡牌的百分比位置
	UI_SMALL_CARD_RAGE_DOT_X_POS = {-0.341,-0.230,-0.119,0}
	UI_SMALL_CARD_RAGE_DOT_Y_POS =  -0.32
	-- 怒气大点位置
	UI_SMALL_CARD_RAGE_BDOT_POS =  {0.178,-0.325}
	-- 怒气 x 图形位置
	UI_SMALL_CARD_RAGE_XIMG_POS =  {0.296,-0.325}
	-- 怒气数字位置
	UI_SMALL_CARD_RAGE_NUMIMG_POS =  {0.385,-0.325}
	
	UI_SMALL_CARD_HPOINT_4 		= {0.281,-0.183}




	-- 2x卡片 4个怒气点相对于卡牌的百分比位置
	UI_BIG_CARD_RAGE_DOT_X_POS = {-0.338,-0.232,-0.126,-0.020}
	UI_BIG_CARD_RAGE_DOT_Y_POS =  -0.319
	UI_BIG_CARD_RAGE_BDOT_POS =  {0.182,-0.319}
	UI_BIG_CARD_RAGE_XIMG_POS =  {0.293,-0.327}
	UI_BIG_CARD_RAGE_NUMIMG_POS =  {0.384,-0.327}

	UI_BIG_CARD_HPOINT_4 		= {0.323,-0.211}
	

	-- 3x卡片 4个怒气点相对于卡牌的百分比位置
	UI_X3_CARD_RAGE_DOT_X_POS = {-0.345,-0.230,-0.115,0}
	UI_X3_CARD_RAGE_DOT_Y_POS =  -0.323 + X3_DY
	UI_X3_CARD_RAGE_BDOT_POS =  {0.176,-0.323 + X3_DY}
	UI_X3_CARD_RAGE_XIMG_POS =  {0.281,-0.333 + X3_DY}
	UI_X3_CARD_RAGE_NUMIMG_POS =  {0.367,-0.333 + X3_DY}
	UI_X3_CARD_HPOINT_4 		= {0.342,-0.132}
	
	-- 4x卡片 4个怒气点相对于卡牌的百分比位置
	UI_X4_CARD_RAGE_DOT_X_POS = {-0.111,-0.060,-0.010,0.040}
	UI_X4_CARD_RAGE_BLANK_X_POS = {-0.111,-0.062,-0.016,0.040}
	UI_X4_RAGE_DOT_Y_POS = -0.142
	UI_X4_CARD_RAGE_BDOT_POS =  {0.097,-0.142}
	UI_X4_CARD_RAGE_XIMG_POS =  {0.137,-0.150}
	UI_X4_CARD_RAGE_NUMIMG_POS =  {0.168,-0.146}
	UI_X4_CARD_HPOINT_4 		= {0.219,-0.073}


	UI_X3_HP_BAR_X	= {0,-0.432 +  X3_DY}
	UI_X2_HP_BAR_X	= {0,-0.434}
	UI_X1_HP_BAR_X	= {0,-0.443}
	UI_X4_HP_BAR_X	= {0.013,-0.190}


	CARD_X1_HERO_IMG_Y = -0.262
	CARD_X2_HERO_IMG_Y = -0.263
	CARD_X3_HERO_IMG_Y = -0.266 + X3_DY
	CARD_X4_HERO_IMG_Y = -0.240

	NAME_X1_Y = 0.560
	NAME_X2_Y = 0.541
	NAME_X3_Y = 0.517 + X3_DY
	NAME_X4_Y = 0.708
	-- 战斗速度倍率

	CARD_X4_IMPACT_Y = -0.0458333343
	CARD_X3_IMPACT_Y = -0.2388 + X3_DY


	SPEED_1 = 1.2
	SPEED_2 = 1.5
	SPEED_3 = 1.9
	-- UI_X3_HP_BAR_Y	= {0,0.432}


	BATTLE_DROP_SOUND = "tansuo02.mp3"


	------- 副本战斗类型
	BATTLE_API_TYPE_SINGLE = 1 			-- 单场战斗接口
	BATTLE_API_STRONGHOLD_SINGLE = 2    -- stronghold型单场

	BATTLE_TYPE_COPY_SINGLE = 1 		-- 副本单场
	BATTLE_TYPE_COPY_GUIDE = 9 			-- 公会战
	BATTLE_TYPE_COPY_EVENT_BELLY = 10 	-- 副本单场
	BATTLE_TYPE_ARENA = 2 				-- 竞技场
	BATTLE_TYPE_MINE = 3 				-- 资源矿
	BATTLE_TYPE_SKYPIE = 4 				-- 神秘空岛
	BATTLE_TYPE_TOWER = 5 				-- 推塔
	BATTLE_TYPE_IMPEL = 6 				-- 深海监狱
	BATTLE_TYPE_ROB = 7 				-- 打劫
	BATTLE_TYPE_PVP = 8 				-- 切磋
    BATTLE_TYPE_WA = 9 					 --巅峰对决


	SHIP_INFO_ANI = "ship_attr"

	-- BATTLE_TYPE_SINGLE_BATLLE = 
