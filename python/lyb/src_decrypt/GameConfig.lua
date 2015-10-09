GameConfig = {

	Animate_FreamRate = 1/24;
	Game_FreamRate = 1/60;
    CC_PLATFORM_IOS = 1;
    CC_PLATFORM_ANDROID = 2;
    CC_PLATFORM_WIN32 = 3;
    STAGE_WIDTH = 1280;
    STAGE_HEIGHT = 720;
    
    HTTP_IP = "http://119.29.36.240:8088/"; --"http://10.130.132.235:8088/";--

	-- 平台编号
    -- android
    -- 0  self debug
	-- 1  lan
	-- 2  0--wan/ 1--official/ 2--android test
	-- 3  xiaomi
	-- 4  360
	-- 5  uc
	-- 6  baidu
	-- 7  huawei
	-- 8  oppo
	-- 9  iqiyi
    -- 10 yingyongbao
    -- 11 zhangzong
    -- 12 易接
    -- 13 vivo
    -- 14 联想
    -- 15 金立
    -- 16 酷派
    
    PLATFORM_CODE_DEBUG = "0";
	PLATFORM_CODE_LAN = "1";
	PLATFORM_CODE_WAN = "2";
	PLATFORM_CODE_MI = "3";
	PLATFORM_CODE_360 = "4";
	PLATFORM_CODE_UC = "5";
	PLATFORM_CODE_BAIDU = "6";
	PLATFORM_CODE_HUAWEI = "7";
    PLATFORM_CODE_OPPO = "8";
    PLATFORM_CODE_IQIYI = "9"; 
    PLATFORM_CODE_YINGYONGBAO = "10";
    PLATFORM_CODE_ZZ = "11";
    PLATFORM_CODE_YJ = "12";

    PLATFORM_CODE_VIVO = "13";
    PLATFORM_CODE_LENOVO = "14";        
    PLATFORM_CODE_JINLI = "15";
    PLATFORM_CODE_COOLPAD = "16";    

    -- ios
    -- 100 appstore
    -- 101 ios 91
    -- 102 ios xy
    -- 103 ios debug
    -- 104 ios ky
    -- 105 ios tongbutui

    PLATFORM_CODE_IOS_APPLE = "100";
    PLATFORM_CODE_IOS_91 = "101";
    PLATFORM_CODE_IOS_XY = "102";
    PLATFORM_CODE_IOS_BASE = "103";
    PLATFORM_CODE_IOS_KY = "104";
    PLATFORM_CODE_IOS_TONGBUTUI = "105";

	-- 游戏职业
	PLAYER_CARRER_1 = 1; --剑君
	PLAYER_CARRER_2 = 2; --拳皇
	PLAYER_CARRER_3 = 3; --枪王
	PLAYER_CARRER_4 = 4; --弓圣
	PLAYER_CARRER_5 = 5; --怪物、宠物
	
    -- 货币类型
	CURRENCY_TYPE_EXP = 1;  -- 经验
	CURRENCY_TYPE_SILVER = 2;  -- 银两
	CURRENCY_TYPE_GOLD = 3;  -- 元宝

    CURRENCY_TYPE_FRIENDPOINT = 16;  -- 友情点FriendPoint服务端用的这个字段，为了统一
	
    ROLE_STAND      = 1;
    ROLE_RUN     = 2;
    ROLE_STAND_CITY      = 6;
    ROLE_STAND_UP_CITY      = 9;
    ROLE_SIT_DOWN_CITY      = 10;
    ROLE_SIT_CITY      = 11;
    
    
    TRANSFORM_HEAD = 1;
	TRANSFORM_BODY = 2;
    TRANSFORM_WEAPON = 3;
	TRANSFORM_HORSE = 4;

    --次数
    -- --轮回盘武将库
    -- USER_TIMER_TYPE1_1 = "8_1";
    -- USER_TIMER_TYPE8_2 = "8_2";
    -- USER_TIMER_TYPE8_3 = "8_3";
    --竞技场
    USER_CDTIME_TYPE_1 = 1;
    --琅琊试炼
    USER_CDTIME_TYPE_2 = 2;
    
    --珍宝阁
    USER_CDTIME_TYPE_3 = 3;
    --摇钱树
    USER_CDTIME_TYPE_4 = 4;
    --劫色刷新
    USER_CDTIME_TYPE_5 = 5;
    --万妖谷
    USER_CDTIME_TYPE_6 = 6;
    --女仆对话
    USER_CDTIME_TYPE_7 = 7;
    --英魂招募
    USER_CDTIME_TYPE_8 = 8;
    --英魂限时招募活动，免费招募cd
    USER_CDTIME_TYPE_9 = 9;

    -- --英魂升级
    -- HERO_LEVELUP_TYPR2_1 = "2_1";
    -- HERO_LEVELUP_TYPR2_2 = "2_2";
    -- HERO_LEVELUP_TYPR2_3 = "2_3";
    -- HERO_LEVELUP_TYPR2_4 = "2_4";
    -- HERO_LEVELUP_TYPR2_5 = "2_5";

    -- --决战巅峰
    -- ARENA_TIMER_TYPE = 2;
	
    -- --每日任务
    -- EVERY_DAY_TASK_25 = 25;
    -- EVERY_DAY_TASK_26 = 26;
    -- EVERY_DAY_TASK_27 = 27;
    -- EVERY_DAY_TASK_28 = 28;
    -- EVERY_DAY_TASK_29 = 29;
    
    -- HERO_SCENE_PLACE_1 = "1";
    -- HERO_SCENE_PLACE_2 = "2";
    -- HERO_SCENE_PLACE_3 = "3";
   
    -- --英魂槽
    -- USER_TIMER_TYPE_2 = 2;

    -- --武将招募位置
    -- GENERAL_EMPLOY_GROUP_1 = 1;
    -- GENERAL_EMPLOY_GROUP_2 = 2;
    -- GENERAL_EMPLOY_GROUP_3 = 3;
    
    --     --任务状态
    -- TASK_FATCHABLE = 1;--可接
    -- TASK_NOT_DONE = 2;--已接未完成
    -- TASK_DONE_NOT_COMPLETE = 3;--已接已完成 未交
    -- TASK_COMPLETE = 4;--已完成 已交 
    
    --1表示完成状态
    STRONG_POINT_STATE_1 = 1;
    --2表示未完成，并且不能进入
    STRONG_POINT_STATE_2 = 2;
    --3表示未完成，并且能进入
    STRONG_POINT_STATE_3 = 3;
    --4表示未完成，并且需要对话
    STRONG_POINT_STATE_4 = 4;

    --任务事件类型
    TASK_EVENT_TYPE_1 = 1;-- 关卡ID
    TASK_EVENT_TYPE_2 = 2;--NPC
    TASK_EVENT_TYPE_3 = 3;--打开界面
    TASK_EVENT_TYPE_4 = 4;--战场id
    TASK_EVENT_TYPE_5 = 5;--道具id
    TASK_EVENT_TYPE_6 = 6;--随机关卡
    TASK_EVENT_TYPE_7 = 7;--探点关卡
    
    -- --背包中功能ID,英魂碎片
    -- BAG_ITEM_DEBRIS_10 = 10;
   
    --场景类型1
    --城区
    SCENE_TYPE_1 = 1;
    --场景类型2
    --脚本战斗
    SCENE_TYPE_2 = 2;
    --战场
    SCENE_TYPE_3 = 3;
    --家族
    SCENE_TYPE_4 = 4;
    --preload场景
    SCENE_TYPE_6 = 6;
    
    --    --道具功能0
    -- ITEM_FUNCTION_0 = 0; 
    -- --道具功能1
    -- ITEM_FUNCTION_1 = 1;
    -- --道具功能2
    -- ITEM_FUNCTION_2 = 2;
    -- --道具功能3
    -- ITEM_FUNCTION_3 = 3;
    -- --道具功能4
    -- ITEM_FUNCTION_4 = 4;
    --     --开格子
    -- ITEM_FUNCTION_5 = 5;
    --     --材料
    -- ITEM_FUNCTION_6 = 6;
    --     --礼包
    -- ITEM_FUNCTION_7 = 7;
    --     --宝箱
    -- ITEM_FUNCTION_8 = 8;
    --     --道具功能9
    -- ITEM_FUNCTION_9 = 9;
    --     --道具功能10
    -- ITEM_FUNCTION_10 = 10;
    --     --女仆送礼道具
    -- ITEM_FUNCTION_11 = 11;
    -- --悬赏
    -- ITEM_FUNCTION_12 = 12;
    -- --英魂不进背包
    -- ITEM_FUNCTION_13 = 13;
    -- --开英魂格子
    -- ITEM_FUNCTION_14 = 14;
    -- --宠物升级
    -- ITEM_FUNCTION_15 = 15;
    -- --增加体力
    -- ITEM_FUNCTION_16 = 16;
    -- --珍宝阁制作材料
    -- ITEM_FUNCTION_17 = 17;
    -- --英魂转移道具
    -- ITEM_FUNCTION_18 = 18;
    -- --使用无效果的道具
    -- ITEM_FUNCTION_19 = 19;
    -- --升资质道具
    -- ITEM_FUNCTION_20 = 20;
    -- --装备镶嵌宝石
    -- ITEM_FUNCTION_21 = 21;
    -- --宝石接连符文
    -- ITEM_FUNCTION_22 = 22;
    -- --使用得宠物
    -- ITEM_FUNCTION_23 = 23;
    -- --称号
    -- ITEM_FUNCTION_24 = 24;
    -- --缩短时间
    -- ITEM_FUNCTION_25 = 25;   
    -- --轮回盘转盘道具
    -- ITEM_FUNCTION_26 = 26;  
    
   --  --关卡图片的宽
   --  OUTER_ART_WIDTH = 90;
	
   -- --关卡图片的高
   --  OUTER_ART_HEIGHT = 60;
    
    DEFAULT_FONT_NAME = "resource/font/Microsoft YaHei.ttf";
	
    -- 版本号
    -- VERSION = "1.2.1";
    
    MAIN_SCENE = "mainScene";
    BATTLE_SCENE = "battleScene";
    PRELOAD_SCENE = "preloadScene";
    -- FUNCTION_SCENE = "funtionScene";
    
    PRELOAD_LAYER_UI = 1;
    PRELOAD_PARTICLE_SYSTEM_UI = 2;
    PRELOAD_SHIFT_UI = 3;
    FUNCTION_LAYER_UI = 1;

    --推送记录
    HERO_SCENE_MAINTYPE_3 = 3;

    --宠物的缩放比例
    PET_SCALE_RATE = 0.35;
    --英魂库格子附加数
    ACCUMULATE_TYPE_1 = 1;

   
    --老虎机 玩到第几次
    ACCUMULATE_TYPE_4 = 4;
    --悬赏
    ACCUMULATE_TYPE_11 = 11;
    --小助手次数
    ACCUMULATE_TYPE_8 = 8;
    --小助手活跃度
    ACCUMULATE_TYPE_9 = 9;
    --决战巅峰
    ACCUMULATE_TYPE_6 = 6;
    --灵机一洞
    ACCUMULATE_TYPE_20 = 20;
    --英魂招募 招募武将次数
    ACCUMULATE_TYPE_21 = 21;

    --英雄志漫画
    ACCUMULATE_TYPE_28 = 28;
    --首冲
    ACCUMULATE_TYPE_52 = 52;
	
	--================= 品质颜色
	QUALITY_COLOR_WHITE = "#ffffff";  -- 白
	QUALITY_COLOR_GREEN = "#00ff00";  -- 绿
	QUALITY_COLOR_BLUE = "#00ffff";  -- 蓝
	QUALITY_COLOR_PURPLE = "#ff4cf0";  -- 紫
	QUALITY_COLOR_ORANGE = "#ffa000";  -- 橙
	QUALITY_COLOR_RED = "#ff0000";  -- 红

    QUALITY_6 = 6;  -- 白
    QUALITY_5 = 5;  -- 绿
    QUALITY_4 = 4;  -- 蓝
    QUALITY_3 = 3;  -- 紫
    QUALITY_2 = 2;  -- 橙
    QUALITY_1 = 1;  -- 红

    TOP_DIRECTION = 1;
    DOWN_DIRECTION = 2;
    LEFT_DIRECTION = 3;
    RIGHT_DIRECTION = 4;
    CENTER_DIRECTION = 5;
    
    HAND_OFFSET = 1;
    TEXT_BG_OFFSET = 2;
    ALL_OFFSET = 3;

    TUTOR_UI = 1;
    TUTOR_MAP = 2;

    --人物头顶的名字x偏移
    ROLE_NAME_X_OFFSET = -60;

    --人物头顶的名字y偏移
    ROLE_NAME_CITY_Y_OFFSET = 184;

    --起名字任务，这个任务比较特殊，当这个任务变成已接受未完成时打开起名字界面
    NAME_TASK_ID = 100006;
    --npc名字的颜色
    NPC_NAME_COLOR = 16580352; --"#fcff00";
    --自己名字的颜色
    MY_NAME_COLOR = 65532;--"#00fffc";
    --其他玩家名字的颜色
    OTHER_NAME_COLOR = 16777215;--"#ffffff";
    
    --玩家在城区中的状态  站立
    USER_MAP_INFO_STATE_1 = 1;
    --玩家在城区中的状态  走动
    USER_MAP_INFO_STATE_2 = 2;
    --玩家在城区中的状态  打坐
    USER_MAP_INFO_STATE_3 = 3;

    --正常状态
    STATE_TYPE_1 = 1;
    --副本状态
    STATE_TYPE_2 = 2;
        --挂机状态
    STATE_TYPE_3 = 3;


    --非快速战斗
    STRONGPOINT_PARAM_TYPE_1 = 1;
    --快速战斗
    STRONGPOINT_PARAM_TYPE_2 = 2;
    --藏宝图
    STRONGPOINT_PARAM_TYPE_3 = 3;
    --藏宝图
    TEAM_SHADOW_BAG_CRITICAL_COUNT = 8;

    --家族城区的id
    FAMILY_CITY_ID = 1;

    --宠物技能
    PET_ACTIVE_SKILL_MAX = 4;
    PET_PASSIVE_SKILL_MAX = 4;
    PET_SKILL_LEVEL_MAX = 9;

    --神秘商店一次刷新6个
    SHOP_MYSTERY_MAX = 6;

        --右上角头像坐标
    REN_WU_TOU_XIANG_X = 1136;

    REN_WU_TOU_XIANG_Y = 586; 

    -- 连接类型
    -- 0 正常连接
    -- 1 断线重连
    -- 2 退出登录
    -- 3 被踢下线    
    CONNECT_TYPE_0 = 0;
    CONNECT_TYPE_1 = 1;
    CONNECT_TYPE_2 = 2;
    CONNECT_TYPE_3 = 3;

    --排行榜
    Ranking_Type_6 = 6;

    TUTOR_STORY_BTN_W = 90;
    TUTOR_STORY_BTN_H = 100;

    TUTOR_BIG_BTN_W = 80;
    TUTOR_BIG_BTN_H = 80;
   
    TUTOR_SMALL_BTN_W = 70;
    TUTOR_SMALL_BTN_H = 70;

    BG_YZ_R = 65;--地图背景yz轴倾斜角
    BG_XY_R = 15;--地图背景xy轴倾斜角
};