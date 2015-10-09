
BattleConstants = {};

-- 战场状态
BattleConstants.BATTLE_WAITING = 1;
BattleConstants.BATTLE_START = 2;
BattleConstants.BATTLE_OVER = 3;
BattleConstants.BATTLE_PAUSE = 4;
BattleConstants.BATTLE_ROUND_WAIT = 5;--波
BattleConstants.BATTLE_PAUSE_SCRIPT = 6;--波

BattleConstants.Animate_Fream = 24;--60帧和30帧都不用改
BattleConstants.Frame_Time = 1000/60;--与后端update为60毫秒

-- /** 技能释放目标作用对象 ******/ fjm
-- /** 火球类：1 **/
BattleConstants.CastTargetTypeEnemyTarget1 = 1;
--/** 冲击波类：2 **/
BattleConstants.CastTargetTypeEnemyTarget2 = 2;
--/** 火雨类：3 **/
BattleConstants.CastTargetTypeEnemyTarget3 = 3;
--/** 冲刺类：4 **/
BattleConstants.CastTargetTypeEnemyTarget4 = 4;
--/** 旋风斩类：5 **/
BattleConstants.CastTargetTypeEnemyTarget5 = 5;
--/** 践踏：6 */
BattleConstants.CastTargetTypeEnemyTarget6 = 6;
--/** 扇形攻击：7 **/
BattleConstants.CastTargetTypeEnemyTarget7 = 7;
-- --/** 自己buf **/
BattleConstants.CastTargetTypeEnemyTarget8 = 8;
-- --/** 友方范围buf **/
BattleConstants.CastTargetTypeEnemyTarget9 = 9;
-- --/** 敌方范围buf **/
BattleConstants.CastTargetTypeEnemyTarget10 = 10;
-- --/** 三段击 菱形多次 **/
BattleConstants.CastTargetTypeEnemyTarget11 = 11;
-- --/** 三段击 扇形多次 **/
BattleConstants.CastTargetTypeEnemyTarget12 = 12;
-- --/** 敌方（以自身到目标方向的一段距离） **/
-- BattleConstants.CastTargetTypeEnemyTargetDirect = 9;
-- --/** 击中目标后特效消失，并以其为圆心造成伤害。 **/
-- BattleConstants.CastTargetType_10 = 10;

BattleConstants.Target_Select_type1 = 1;--血量最低
BattleConstants.Target_Select_type2 = 2;--近战



BattleConstants.Target_Position_type1 = 1;--近战
BattleConstants.Target_Position_type2 = 2;--中程
BattleConstants.Target_Position_type3 = 3;--远程

-- /**************************
--  * 武将相关
--  ***************************/
--// 剑
BattleConstants.GENERAL_CARRER_1 = 1;
--// 武
BattleConstants.GENERAL_CARRER_2 = 2;
--// 枪
BattleConstants.GENERAL_CARRER_3 = 3;
--// 弓
BattleConstants.GENERAL_CARRER_4 = 4;
--// 通用
BattleConstants.GENERAL_CARRER_5 = 5;
-- --冰
-- BattleConstants.SKILL_TYPE_1 = 1;
-- --火
-- BattleConstants.SKILL_TYPE_2 = 2;
-- --毒
-- BattleConstants.SKILL_TYPE_3 = 3;
-- --内功
-- BattleConstants.SKILL_TYPE_4 = 4;
-- --外功
-- BattleConstants.SKILL_TYPE_5 = 5;
-- --增益型
-- BattleConstants.SKILL_TYPE_6 = 6;

BattleConstants.MONSTER_DYNAMIC_ID_MIN = 50000;
BattleConstants.VALUE_0 = 0;
BattleConstants.SKILL_EFFECT_ID_40 = 40
BattleConstants.SKILL_EFFECT_ID_50 = 50
BattleConstants.SKILL_EFFECT_ID_52 = 52
BattleConstants.SKILL_EFFECT_ID_62 = 62
BattleConstants.SKILL_EFFECT_ID_63 = 63
BattleConstants.SKILL_EFFECT_ID_64 = 64
BattleConstants.SKILL_EFFECT_ID_65 = 65
BattleConstants.SKILL_EFFECT_ID_66 = 66
BattleConstants.SKILL_EFFECT_ID_67 = 67

--区分战场中的部队立场 部队立场1
BattleConstants.STANDPOINT_P1 = 1
--区分战场中的部队立场 部队立场2
BattleConstants.STANDPOINT_P2 = 2

BattleConstants.EQUIPMENT_PLACE4 = 4
BattleConstants.EQUIPMENT_PLACE1 = 1

BattleConstants.ONE_FRAME_MILLISECONDS = 60
BattleConstants.BATTLE_FIELD_ROBOT_USER_ID_MIN = 2140000000
BattleConstants.MAX_VALUE = 2147483647
BattleConstants.BATTLE_FIELD_ID_100002 = 100002

-- /**
-- * 战场 普通状态
-- */
BattleConstants.BATTLE_FIELD_STATE_1 = 1;
-- /**
-- * 战场 无双状态
-- */
BattleConstants.BATTLE_FIELD_STATE_2 = 2;

-- 势力
BattleConstants.STANDPOINT_1 = 1;
BattleConstants.STANDPOINT_2 = 2;
-- 被动技能触发条件
BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_1 = 1;
BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_2 = 2;
BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_3 = 3;
BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_4 = 4;
BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_5 = 5;
-- batteUnit类型
-- generalUnit
BattleConstants.BATTLE_UNIT_TYPE_1 = 1;
--
BattleConstants.BATTLE_UNIT_TYPE_2 = 2;
-- monster
BattleConstants.BATTLE_UNIT_TYPE_3 = 3;

BattleConstants.BATTLE_UNIT_TYPE_4 = 4;
-- petUnit
BattleConstants.BATTLE_UNIT_TYPE_5 = 5;

BattleConstants.HUNDRED_THOUSAND = 100000;
--战场user的id的基础值
BattleConstants.BATTLE_USER_OBJECT_ID_PREFIX = 1000
--持续伤害方式
BattleConstants.SKILL_EFFECT_HURI_WAY_1 = 1;
BattleConstants.SKILL_EFFECT_HURI_WAY_2 = 2;

BattleConstants.SKILL_EFFECT_ID_1 = 1;
BattleConstants.SKILL_EFFECT_ID_2 = 2;
BattleConstants.SKILL_EFFECT_ID_3 = 3;
BattleConstants.SKILL_EFFECT_ID_4 = 4;
BattleConstants.SKILL_EFFECT_ID_5 = 5;
BattleConstants.SKILL_EFFECT_ID_6 = 6;
BattleConstants.SKILL_EFFECT_ID_7 = 7;
BattleConstants.SKILL_EFFECT_ID_8 = 8;
BattleConstants.SKILL_EFFECT_ID_11 = 11;
BattleConstants.SKILL_EFFECT_ID_33 = 33;
BattleConstants.SKILL_EFFECT_ID_35 = 35;
BattleConstants.SKILL_EFFECT_ID_39 = 39;
BattleConstants.SKILL_EFFECT_ID_41 = 41;
BattleConstants.SKILL_EFFECT_ID_42 = 42;
BattleConstants.SKILL_EFFECT_ID_80 = 80;

-- BattleConstants.SKILL_EFFECT_TYPE_1 = 1;
-- BattleConstants.SKILL_EFFECT_TYPE_2 = 2;
-- BattleConstants.SKILL_EFFECT_TYPE_3 = 3;
-- BattleConstants.SKILL_EFFECT_TYPE_4 = 4;
BattleConstants.SKILL_EFFECT_TYPE_3001 = 3001;
BattleConstants.SKILL_EFFECT_TYPE_3002 = 3002;
BattleConstants.SKILL_EFFECT_TYPE_3003 = 3003;
BattleConstants.SKILL_EFFECT_TYPE_3004 = 3004;
BattleConstants.SKILL_EFFECT_TYPE_3005 = 3005;
BattleConstants.SKILL_EFFECT_TYPE_3006 = 3006;
BattleConstants.SKILL_EFFECT_TYPE_3007 = 3007;
BattleConstants.SKILL_EFFECT_TYPE_3008 = 3008;
BattleConstants.SKILL_EFFECT_TYPE_3009 = 3009;
BattleConstants.SKILL_EFFECT_TYPE_3010 = 3010;
BattleConstants.SKILL_EFFECT_TYPE_3017 = 3017;
BattleConstants.SKILL_EFFECT_TYPE_3100 = 3100;
BattleConstants.SKILL_EFFECT_TYPE_3150 = 3150;
BattleConstants.SKILL_EFFECT_TYPE_3200 = 3200;
BattleConstants.SKILL_EFFECT_TYPE_3300 = 3300;
BattleConstants.SKILL_EFFECT_TYPE_3400 = 3400;

-- BattleConstants.BATTLE_ATTACK_RESULT_TYPE_2 = 2;
-- BattleConstants.BATTLE_ATTACK_RESULT_TYPE_3 = 3;
-- BattleConstants.BATTLE_ATTACK_RESULT_TYPE_4 = 4;
-- BattleConstants.BATTLE_ATTACK_RESULT_TYPE_5 = 5;
-- BattleConstants.BATTLE_ATTACK_RESULT_TYPE_6 = 6;

BattleConstants.Zero = 0
BattleConstants.PetIntell = 35;--宠物灵力

--/** 整型ing **/
BattleConstants.VALUE_TYPE_INT = 1;
--/** 长整型long **/
BattleConstants.VALUE_TYPE_LONG = 2;

-- /**
--  * 武将技能范围
--  */
BattleConstants.SKILLID_WUJIANG_MIN = 10000;
BattleConstants.SKILLID_WUJIANG_MAX = 19999;
-- /**
--  * 无伤技能范围
--  */
BattleConstants.SKILLID_WUSHUAGN_MIN = 1001;
BattleConstants.SKILLID_WUSHUAGN_MAX = 1999;
--摇钱树
BattleConstants.BATTLE_FIELD_MONSTER_ID_60000 = 60000;
--挑战摇钱树
BattleConstants.BATTLE_TYPE_7 = 7;
--新手战场
BattleConstants.BATTLE_TYPE_13 = 13;
--阵营战
BattleConstants.BATTLE_TYPE_4 = 4;
--结束条件1
BattleConstants.BATTLE_OVER_CHECKER_1 = "1"
--结束条件2
BattleConstants.BATTLE_OVER_CHECKER_2 = "2"
--结束条件3
BattleConstants.BATTLE_OVER_CHECKER_3 = "3"
--结束条件4
BattleConstants.BATTLE_OVER_CHECKER_4 = "4"

-- /**
--  * 普通技能防御
--  */
BattleConstants.BATTLE_ATTACK_RESULT_TYPE_0 = 0;

-- /**
--  * 会心(暴击)
--  */
BattleConstants.BATTLE_ATTACK_RESULT_TYPE_1 = 1;

-- 闪避
BattleConstants.BATTLE_ATTACK_RESULT_TYPE_2 = 2;

-- 抵抗
BattleConstants.BATTLE_ATTACK_RESULT_TYPE_3 = 3;

-- 技能效果类型
-- 外功(物理伤害)
BattleConstants.SKILL_EFFECT_TYPE_1 = 1;
-- 内功(魔法伤害)
BattleConstants.SKILL_EFFECT_TYPE_2 = 2;
-- 治疗
BattleConstants.SKILL_EFFECT_TYPE_3 = 3;
-- 其他
BattleConstants.SKILL_EFFECT_TYPE_4 = 4;

-- 技能效果伤害类型
-- 非伤害
BattleConstants.SKILL_EFFECT_DAM_TYPE_0 = 0;
-- 外功伤害
BattleConstants.SKILL_EFFECT_DAM_TYPE_1 = 1;
-- 内功伤害
BattleConstants.SKILL_EFFECT_DAM_TYPE_2 = 2;

BattleConstants.EffectMoveSpeed = 500

-- /***********
--  * 技能相关
--  ***********/
-- /** 进入无双状态触发技能ID **/
BattleConstants.SkillIdWushuangStatus = 10000;
--/** 进入无状态击飞范围 **/
BattleConstants.JifeiRange = 200;
-- /**
--  * 施法类型
--  */
BattleConstants.SKILL_PLAY_TYPE_1 = 1;

-- /**
--  * 武将技能范围
--  */
BattleConstants.SKILLID_WUJIANG_MIN = 10000;
BattleConstants.SKILLID_WUJIANG_MAX = 19999;
-- /**
--  * 无伤技能范围
--  */
BattleConstants.SKILLID_WUSHUAGN_MIN = 1001;
BattleConstants.SKILLID_WUSHUAGN_MAX = 1999;

-- -- 冰
-- BattleConstants.SKILL_TYPE_1 = 1;
-- -- 火
-- BattleConstants.SKILL_TYPE_2 = 2;
-- -- 毒
-- BattleConstants.SKILL_TYPE_3 = 3;
-- -- 内功
-- BattleConstants.SKILL_TYPE_4 = 4;
-- -- 外功
-- BattleConstants.SKILL_TYPE_5 = 5;
-- -- 增益型
-- BattleConstants.SKILL_TYPE_6 = 6;
-- 技能附加伤害类型
-- 冰
BattleConstants.SKILL_ADDITION_HURT_TYPE_1 = 1;
-- 火
BattleConstants.SKILL_ADDITION_HURT_TYPE_2 = 2;
-- 毒
BattleConstants.SKILL_ADDITION_HURT_TYPE_3 = 3;
-- 普通(内功 外功)
BattleConstants.SKILL_ADDITION_HURT_TYPE_4 = 4;

BattleConstants.GENERAL_GRADE_SKILL_ADDITION_TYPE_1 = 1;
BattleConstants.GENERAL_GRADE_SKILL_ADDITION_TYPE_2 = 2;

BattleConstants.SKILL_EFFECT_LAST_TYPE_1 = 1;
BattleConstants.SKILL_EFFECT_LAST_TYPE_2 = 2;
BattleConstants.SKILL_EFFECT_LAST_TYPE_3 = 3;

-- 星级对技能的加成 1、技能百分比2、技能数值；3、技能效果数值；4、技能持续时间；5、技能发生概率
BattleConstants.GENERAL_GRADE_SKILL_ADDITION_TYPE_1 = 1;
BattleConstants.GENERAL_GRADE_SKILL_ADDITION_TYPE_2 = 2;
BattleConstants.GENERAL_GRADE_SKILL_ADDITION_TYPE_3 = 3;
BattleConstants.GENERAL_GRADE_SKILL_ADDITION_TYPE_4 = 4;
BattleConstants.GENERAL_GRADE_SKILL_ADDITION_TYPE_5 = 5;

BattleConstants.INTEGER_MAX_VALUE = 2147483647;

BattleConstants.BATTLE_PAUSE_TEAM1 = 1;--为第一队暂停
BattleConstants.BATTLE_PAUSE_TEAM2 = 2;--为第二队暂停
-- BattleConstants.BATTLE_PAUSE_NUM3 = 3;--为第三队暂停

-- BattleConstants.BATTLE_PAUSE_STATE1 = 1;--为战斗中暂停
-- BattleConstants.BATTLE_PAUSE_STATE2 = 2;--为下一波暂停

-- 普通攻击
BattleConstants.SKILL_TYPE_1 = 1;
-- 技能
BattleConstants.SKILL_TYPE_2 = 2;
-- 大招
BattleConstants.SKILL_TYPE_3 = 3;

-- 怪物类型
-- 小怪
BattleConstants.MONSTER_TYPE_1 = 1;
--精英
BattleConstants.MONSTER_TYPE_2 = 2;
--BOSS
BattleConstants.MONSTER_TYPE_3 = 3;
--世界BOSS
BattleConstants.MONSTER_TYPE_4 = 4;

BattleConstants.IS_DISTANCE_RANDOM = true;
BattleConstants.Stop_Skill_Time = 1000;

BattleConstants.SectorDis_Num = 50

BattleConstants.Keep_Attack_Distance = 0.4