BattleConfig = {

	-- 战场类型
	--普通关卡战斗
	BATTLE_TYPE_1 = 1;
	--竞技场
	BATTLE_TYPE_2 = 2;
	--十国争霸
	BATTLE_TYPE_3 = 3;
	--新手战场
	BATTLE_TYPE_4 = 4;
	--东宫高手（银两副本）
	BATTLE_TYPE_5 = 5;
	--穆府家将（经验副本）
	BATTLE_TYPE_6 = 6;
	--守护战场
	BATTLE_TYPE_7 = 7;
	--攻城战场
	BATTLE_TYPE_8 = 8;	
	--朝堂争辩
	BATTLE_TYPE_9 = 9;
	--英雄志关卡战斗
	BATTLE_TYPE_10 = 10;
	--五行战斗
	BATTLE_TYPE_11 = 11;
	-- 寻宝
	BATTLE_TYPE_12 = 12;

	-- 战场层
	Battle_LAYER_MAP_BG   = 1;
	Battle_LAYER_MAP      = 2;
	Battle_LAYER_EFFECTS_BACK = 3;
	Battle_LAYER_PLAYERS  = 4;
	Battle_LAYER_EFFECTS  = 5;
	Battle_LAYER_STOPSKILL  = 6;
	Battle_LAYER_EFFECTS_SCREEN = 7;
	Battle_LAYER_UI       = 8;
	Battle_LAYER_SHIFT_SCENE = 9;
	Battle_LAYER_TOP = 10;

	-- 战场相关
	BATTLE_TYPE_STRONGPOINT = 1;
	BATTLE_TYPE_ARENA = 2;
	BATTLE_TYPE_COPY = 3;
	BATTLE_TYPE_DUEL = 4;
	BATTLE_TYPE_MULTIPLE_PK = 5;
	BATTLE_UNITID_10000 = 10000;

	-- 战场单元类型
	BATTLE_OWER = 1; -- 玩家
	--BATTLE_GENERAL = 2; -- 武将（已不用）
	BATTLE_MONSTER = 3;-- 怪物
	--BATTLE_FLYEFFECT = 4; --飞行特效（已不用）
	BATTLE_PET = 2; -- 英雄
	--友军
	BATTLE_FRIEND = 6;

	BATTLE_RAGE = 7;--怒气飘字;
	BATTLE_YONGBING = 8;--佣兵;
	-- 动作相关
	HOLD = 1;--战斗待机
	RUN = 2;--跑步
	BEATTACKED = 3;--被击
	BEATTACKED_DOWN = 4;--被击倒
	ATTACK = 5;--普通攻击
	ATTACK_PASSIVE = 6;--被动攻击
	ATTACK_ENERGY = 7;--能量满攻击
	HIT_FLY = 8;--击飞
	SHAN_BI = 9;--闪避
	PAO_WU_XIAN = 10;--抛物线
	CHONG_CI = 11;--冲刺

	PAO_WU_XIAN_1 = 1;
	PAO_WU_XIAN_2 = 2;

	JUMP_TIME = 0.5;--跳跃时间
	JUMP_MAXTIME = 500;--跳跃时间

	-- 换装部位
	--TRANSFORM_HEAD = 1;
	TRANSFORM_BODY = 1;
	TRANSFORM_WEAPON = 3;
	--TRANSFORM_HORSE = 4;

	EFFECT_HEIGHT = 60; --
	--SITE_Y = 180; -- 战场Y坐标
	Up_Y = 505; --上方可行走最高点
	Down_Y = 125; --下方可行走最低点
	MAP_LIMIT = 2;

	SOURCE_URL = "resource/image/arts/";

	-- 战斗效果
	EFFECT_ABLOOD = 5;--加血
	EFFECT_RBLOOD = 6;--减血
	EFFECT_POISON = 7; -- 中毒

	-- 攻击结果类型	
	ATTACK_RESULT_DODGE = 2;	--闪避
	ATTACK_RESULT_CRITRAL = 5;	-- 暴击
	ATTACK_RESULT_PARRY = 3;	 -- 格挡
	ATTACK_RESULT_MISS = 4; --miss
	ATTACK_RESULT_6 = 6; --破击

	--自身Timer的触发移动
	ScreemMove_Type_1 = 1;
	--外部距离的触发移动
	ScreemMove_Type_2 = 2;

	MAIN_PLAYER = "MAIN_PLAYER";
	MY_PET = "MY_PET";
	Text_Field = "Text_Field";

	--震屏左右
	SHAKE_SCREEN_1 = 1;
	--上下
	SHAKE_SCREEN_2 = 2;
	--上下左右
	SHAKE_SCREEN_3 = 3;
	--上下左右小震屏
	SHAKE_SCREEN_4 = 4;
	--上下左右中震屏
	SHAKE_SCREEN_5 = 5;

	Battle_From_Type_0 = 0;--默认为0，
	Battle_From_Type_1 = 1;--从小秘进入战场
	Battle_From_Type_2 = 2;--从日常进入战场

	Battle_Dialog_Inter = "inter";
	Battle_Dialog_Leave = "leave";
	Battle_Dialog_Middle_Before = "middleBefore"; -- 一波开始前
	Battle_Dialog_Middle_Behind = "middleBehind"; -- 一波结束
	Battle_Dialog_GREEN = "greenhand";

	Battle_StandPoint_1 = 1;--左边
	Battle_StandPoint_2 = 2;--右边

	Battle_Status_1 = 1;--默认的战斗状态
	Battle_Status_2 = 2;--回放的战斗状态
	Battle_Status_3 = 3;--前端演算状态

	Battle_down_1 = 1;--没有下载
	Battle_down_2 = 2;--正在下载
	Battle_down_3 = 3;--完成下载
	Battle_Card_TimeOut = 0.3;

	RoleScaleNum = 0.8;
	BossScaleNum = 1.7;
	--前端用优先级--------
	ROLE_HOLD = 1;--空闲
	ROLE_MOVE = 2;--行动
	ROLE_BEATTACKED = 3;--被攻击
	ROLE_ATTACK = 4;--攻击动画
	ROLE_DEAD = 5;--死亡
	--前端用优先级--------

	-- 上下左右刷怪地点 只有X坐标 Y是居中算出来的
	LEFT_POSITION_X = 200;

	RIGHT_POSITION_X = 1080;
	Attack_Offset = 150;--攻击时额外加的时间，防止数据同步临界问题
	BeAttack_Offset = 120;--被攻击时额外加的时间，防止数据同步临界问题
	LIMIT_LEFT_ADD_X = 150;
	LIMIT_RIGHT_ADD_X = -250;
	YU_DI_X3 = GameConfig.STAGE_WIDTH/3;
	YU_DI_X2 = GameConfig.STAGE_WIDTH/2;
	SKILL_SECTOR_ID = 5;
	Friend_Time = 15000;

	Change_Purse_Distance = 0.75;

	SortOn_0 = "SortOn_0";--角色层排序0
	SortOn_1000000 = "SortOn_1000000";--角色层排序1000000
	Is_Fly_Effect = "isFlyEffect";
	Is_Daoju_Drop = "isDaojuDrop";
	Is_Player_Role = "isPlayerRole";
	Battle_Map_Name = "battleMap";
	GreenBattleHP = 250000;

	SELECT_TARGET_DIS = 50;
	Max_Power_Num = 7;
	BG_YK = math.cos(math.rad(GameConfig.BG_YZ_R))*math.cos(math.rad(GameConfig.BG_XY_R));
	BG_XK = math.cos(math.rad(GameConfig.BG_YZ_R))*math.sin(math.rad(GameConfig.BG_XY_R));
	BG_XK_3 = math.tan(math.rad(GameConfig.BG_XY_R));
	Battle_Pos_YU = GameConfig.STAGE_HEIGHT*0.55;--上y
	Battle_Pos_YM = GameConfig.STAGE_HEIGHT*0.425;--中y
	Battle_Pos_YD = GameConfig.STAGE_HEIGHT*0.3;--下y
	Battle_Pos_LXM = GameConfig.STAGE_WIDTH*0.25;--左边中心格子x
	Battle_Pos_RXM = GameConfig.STAGE_WIDTH*0.75;--右边中心格子x
	Battle_Pos_DX = 150;--格子宽
	Battle_Pos_RD = 50;--行x方向差值
	SkillSDJfanW1 = 1;--单体
	SkillSDJfanW2 = 2;--横排
	SkillSDJfanW3 = 3;--竖排
	SkillSDJfanW4 = 4;--全屏
	SkillSDJfanW5 = 5;--全屏
	Effect_Text_Shanbi = 1315;
	Effect_Text_Yujing = 1316;
	Effect_Text_Huixin = "1";
	Effect_Text_ZhuDang = "2";
	Effect_Text_HuixinID = 1314;
	Effect_Text_ZhaojiaID = 1317;
};
Battle_Pos_L={
	[1] = ccp(BattleConfig.Battle_Pos_LXM+BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YU);
	[2] = ccp(BattleConfig.Battle_Pos_LXM+BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YM);
	[3] =  ccp(BattleConfig.Battle_Pos_LXM-BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YD);
	[4] =  ccp(BattleConfig.Battle_Pos_LXM+BattleConfig.Battle_Pos_RD,BattleConfig.Battle_Pos_YU);
	[5] =  ccp(BattleConfig.Battle_Pos_LXM,BattleConfig.Battle_Pos_YM);
	[6] =  ccp(BattleConfig.Battle_Pos_LXM-BattleConfig.Battle_Pos_RD,BattleConfig.Battle_Pos_YD);
	[7] =  ccp(BattleConfig.Battle_Pos_LXM+BattleConfig.Battle_Pos_RD-BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YU);
	[8] =  ccp(BattleConfig.Battle_Pos_LXM-BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YM);
	[9] =  ccp(BattleConfig.Battle_Pos_LXM-BattleConfig.Battle_Pos_RD-BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YD);
	[10] =  ccp(BattleConfig.Battle_Pos_LXM+BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YU);
	[11] =  ccp(BattleConfig.Battle_Pos_LXM+BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YM);
	[12] =  ccp(BattleConfig.Battle_Pos_LXM-BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YD);
	[13] =  ccp(BattleConfig.Battle_Pos_LXM+BattleConfig.Battle_Pos_RD-BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YU);
	[14] =  ccp(BattleConfig.Battle_Pos_LXM-BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YM);
	[15] =  ccp(BattleConfig.Battle_Pos_LXM-BattleConfig.Battle_Pos_RD-BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YD);
	[16] =  ccp(BattleConfig.Battle_Pos_LXM+(BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX)*0.5,(BattleConfig.Battle_Pos_YU+BattleConfig.Battle_Pos_YM)*0.5);
	[17] =  ccp(BattleConfig.Battle_Pos_LXM+(BattleConfig.Battle_Pos_DX-BattleConfig.Battle_Pos_RD)*0.5,(BattleConfig.Battle_Pos_YM+BattleConfig.Battle_Pos_YD)*0.5);
	[18] =  ccp(BattleConfig.Battle_Pos_LXM-(BattleConfig.Battle_Pos_DX-BattleConfig.Battle_Pos_RD)*0.5,(BattleConfig.Battle_Pos_YU+BattleConfig.Battle_Pos_YM)*0.5);
	[19] =  ccp(BattleConfig.Battle_Pos_LXM-(BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX)*0.5,(BattleConfig.Battle_Pos_YM+BattleConfig.Battle_Pos_YD)*0.5);
	[20] =  ccp(BattleConfig.Battle_Pos_LXM,BattleConfig.Battle_Pos_YM);
	[21] =  ccp(-100,GameConfig.STAGE_HEIGHT*0.5);
};
Battle_Pos_R={
	[1] =  ccp(BattleConfig.Battle_Pos_RXM-BattleConfig.Battle_Pos_RD-BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YU);
	[2] =  ccp(BattleConfig.Battle_Pos_RXM-BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YM);
	[3] =  ccp(BattleConfig.Battle_Pos_RXM+BattleConfig.Battle_Pos_RD-BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YD);
	[4] =  ccp(BattleConfig.Battle_Pos_RXM-BattleConfig.Battle_Pos_RD,BattleConfig.Battle_Pos_YU);
	[5] =  ccp(BattleConfig.Battle_Pos_RXM,BattleConfig.Battle_Pos_YM);
	[6] =  ccp(BattleConfig.Battle_Pos_RXM+BattleConfig.Battle_Pos_RD,BattleConfig.Battle_Pos_YD);
	[7] =  ccp(BattleConfig.Battle_Pos_RXM-BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YU);
	[8] =  ccp(BattleConfig.Battle_Pos_RXM+BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YM);
	[9] =  ccp(BattleConfig.Battle_Pos_RXM+BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX,BattleConfig.Battle_Pos_YD);
	[10] =  ccp(BattleConfig.Battle_Pos_RXM-BattleConfig.Battle_Pos_RD-BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YU);
	[11] =  ccp(BattleConfig.Battle_Pos_RXM-BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YM);
	[12] =  ccp(BattleConfig.Battle_Pos_RXM+BattleConfig.Battle_Pos_RD-BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YD);
	[13] =  ccp(BattleConfig.Battle_Pos_RXM-BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YU);
	[14] =  ccp(BattleConfig.Battle_Pos_RXM+BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YM);
	[15] =  ccp(BattleConfig.Battle_Pos_RXM+BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX*0.5,BattleConfig.Battle_Pos_YD);
	[16] =  ccp(BattleConfig.Battle_Pos_RXM-(BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX)*0.5,(BattleConfig.Battle_Pos_YU+BattleConfig.Battle_Pos_YM)*0.5);
	[17] =  ccp(BattleConfig.Battle_Pos_RXM-(BattleConfig.Battle_Pos_DX-BattleConfig.Battle_Pos_RD)*0.5,(BattleConfig.Battle_Pos_YM+BattleConfig.Battle_Pos_YD)*0.5);
	[18] =  ccp(BattleConfig.Battle_Pos_RXM+(BattleConfig.Battle_Pos_DX-BattleConfig.Battle_Pos_RD)*0.5,(BattleConfig.Battle_Pos_YU+BattleConfig.Battle_Pos_YM)*0.5);
	[19] =  ccp(BattleConfig.Battle_Pos_RXM+(BattleConfig.Battle_Pos_RD+BattleConfig.Battle_Pos_DX)*0.5,(BattleConfig.Battle_Pos_YM+BattleConfig.Battle_Pos_YD)*0.5);
	[20] =  ccp(BattleConfig.Battle_Pos_RXM,BattleConfig.Battle_Pos_YM);
	[21] =  ccp(GameConfig.STAGE_WIDTH+100,GameConfig.STAGE_HEIGHT*0.5);
};