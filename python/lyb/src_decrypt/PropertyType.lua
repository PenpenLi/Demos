PropertyType = {}

-- 属性
--空值
PropertyType.zero = 0;

-- 怒气
PropertyType.CURRENT_RAGE = 104;
--// 战力
PropertyType.ZHANLI = 105;
--// 技能战力(表里面没配)
PropertyType.SKILL_ZHANLI = 200;
-- // 战场移动速度
PropertyType.MOVE_SPEED = 203;
--// 生命值
PropertyType.MAX_HP = 1001;
--// 生命值 百分比
PropertyType.MAX_HP_PER = 1002;
--// 外功攻击
PropertyType.WAI_ATTACK = 1003;
--// 外功攻击百分比
PropertyType.WAI_ATTACK_PER = 1004;
--// 内功攻击
PropertyType.NEI_ATTACK = 1005;
--// 内功攻击百分比
PropertyType.NEI_ATTACK_PER = 1006;
--// 外功防御
PropertyType.WAI_DEFENSE = 1007;
--// 外功防御百分比
PropertyType.WAI_DEFENSE_PER = 1008;
--// 内功防御数值
PropertyType.NEI_DEFENSE = 1009;
--// 内功防御百分比
PropertyType.NEI_DEFENSE_PER = 1010;
--// 当前血量
PropertyType.CURR_HP = 1011;
--// 暴击
PropertyType.BAOJI = 1101;
--// 暴击率
PropertyType.BAOJI_PER = 1102;
--// 减伤
PropertyType.HURT_REDUCE = 1103;
--// 破防(穿透)
PropertyType.POFANG = 1104;
--// 治疗值(疗伤)
PropertyType.ZHILIAOZHI = 1105;
--// 闪避
PropertyType.SHANBI = 1106;
--// 闪避 百分比
PropertyType.SHANBI_PER = 1107;
--// 抵抗(御劲)
PropertyType.DIKANG = 1108;
--// 抵抗(御劲) 百分比
PropertyType.DIKANG_PER = 1109;
--// 阻挡(招架)
PropertyType.ZUDANG = 1110;
--// 阻挡(招架) 百分比
PropertyType.ZUDANG_PER = 1111;
--// 阻挡 触发几率
PropertyType.ZUDANG_RATE = 1112;
--// 吸血值
PropertyType.XIXUE = 1113;
--// 吸血百分比
PropertyType.XIXUE_PER = 1114;
--// 用于修改战斗公式的数值加成部分
PropertyType.SHUZHI_JIACHENG = 1211;
--// 用于修改战斗公式的百分比加成部分
PropertyType.BAIFENBI_JIACHENG = 1212;
--// 技能伤害结果+该数值
PropertyType.YISHANG_SHUZHI_JIACHENG = 1213;
--// 技能伤害结果*（1+该百分比）
PropertyType.YISHANG_BAIFENBI_JIACHENG = 1214;

-- 星级对技能的加成 1、技能百分比2、技能数值；3、技能效果数值；4、技能持续时间；5、技能发生概率
PropertyType.GENERAL_GRADE_SKILL_ADDITION_TYPE_1 = 1;
PropertyType.GENERAL_GRADE_SKILL_ADDITION_TYPE_2 = 2;
PropertyType.GENERAL_GRADE_SKILL_ADDITION_TYPE_3 = 3;
PropertyType.GENERAL_GRADE_SKILL_ADDITION_TYPE_4 = 4;
PropertyType.GENERAL_GRADE_SKILL_ADDITION_TYPE_5 = 5;

-- battleUnit type
-- 君主武将
PropertyType.BATTLE_UNIT_TYPE_1 = 1;
-- 普通武将
PropertyType.BATTLE_UNIT_TYPE_2 = 2;
-- 怪物-- 
PropertyType.BATTLE_UNIT_TYPE_3 = 3;
-- 火球
PropertyType.BATTLE_UNIT_TYPE_4 = 4;
-- 战宠
PropertyType.BATTLE_UNIT_TYPE_5 = 5;

-- 
PropertyType.HUNDRED_THOUSAND = 100000;

-- 冰
PropertyType.SKILL_TYPE_1 = 1;
-- 火
PropertyType.SKILL_TYPE_2 = 2;
-- 毒
PropertyType.SKILL_TYPE_3 = 3;
-- 内功
PropertyType.SKILL_TYPE_4 = 4;
-- 外功
PropertyType.SKILL_TYPE_5 = 5;
-- 增益型
PropertyType.SKILL_TYPE_6 = 6;

-- 会心(暴击)
BATTLE_ATTACK_RESULT_TYPE_1 = 1;