HeroPropConstConfig={};

--生命 攻击 内功防御 外功防御 会心抵抗 冰系伤害 冰系防御 火系伤害 火系防御 毒系伤害 毒系防御
--7    8    20       22       28       10       24       11       25       12       26

HeroPropConstConfig.SHENG_MING = 1001;
HeroPropConstConfig.SHENG_MING_PER = 1002;

HeroPropConstConfig.GONG_JI = 1003;
HeroPropConstConfig.GONG_JI_PER = 1004;

HeroPropConstConfig.NEI_GONG_JI = 1005;
HeroPropConstConfig.NEI_GONG_JI_PER = 1006;

HeroPropConstConfig.FANG_YU = 1007;
HeroPropConstConfig.FANG_YU_PER = 1008;

HeroPropConstConfig.NEI_FANG_YU = 1009;
HeroPropConstConfig.NEI_FANG_YU_PER = 1010;

HeroPropConstConfig.HUI_XIN = 1101;

HeroPropConstConfig.PO_FANG = 1104;

HeroPropConstConfig.LIAO_SHANG = 1105;

HeroPropConstConfig.SHAN_BI = 1106;
HeroPropConstConfig.SHAN_BI_PER = 1107;

HeroPropConstConfig.YU_JIN = 1108;
HeroPropConstConfig.YU_JIN_PER = 1109;

HeroPropConstConfig.ZHAO_JIA = 1110;
HeroPropConstConfig.ZHAO_JIA_PER = 1111;

HeroPropConstConfig.XI_XUE = 1113;
HeroPropConstConfig.XI_XUE_PER = 1114;



-- HeroPropConstConfig.JIAN_SHANG = 1103;
-- HeroPropConstConfig.JIAN_SHANG_PER = 29;

-- HeroPropConstConfig.HUI_XIN_PER = 1102;

-- HeroPropConstConfig.HUI_XIN_DI_KANG = 27;
-- HeroPropConstConfig.HUI_XIN_DI_KANG_PER = 28;

-- HeroPropConstConfig.HUI_XIN_JI_LV = 2 + 9999;
-- HeroPropConstConfig.HUI_XIN_JI_LV_PER = 13;

function HeroPropConstConfig:getKEY_PER(key)
	if HeroPropConstConfig.SHENG_MING == key then
		return HeroPropConstConfig.SHENG_MING_PER;

	elseif HeroPropConstConfig.GONG_JI == key then
		return HeroPropConstConfig.GONG_JI_PER;

	elseif HeroPropConstConfig.NEI_GONG_JI == key then
		return HeroPropConstConfig.NEI_GONG_JI_PER;

	elseif HeroPropConstConfig.FANG_YU == key then
		return HeroPropConstConfig.FANG_YU_PER;

	elseif HeroPropConstConfig.NEI_FANG_YU == key then
		return HeroPropConstConfig.NEI_FANG_YU_PER;

	elseif HeroPropConstConfig.SHAN_BI == key then
		return HeroPropConstConfig.SHAN_BI_PER;

	elseif HeroPropConstConfig.YU_JIN == key then
		return HeroPropConstConfig.YU_JIN_PER;

	elseif HeroPropConstConfig.ZHAO_JIA == key then
		return HeroPropConstConfig.ZHAO_JIA_PER;

	elseif HeroPropConstConfig.XI_XUE == key then
		return HeroPropConstConfig.XI_XUE_PER;
	end

	return 0;
end

function HeroPropConstConfig:getIsPER(propID)
	return 1 == analysis("Shuxing_Shuju",propID,"percentage");
end

local xishu_tb = analysisTotalTable("Xishuhuizong_Gongshicanshubiao");

HeroPropConstConfig.XI_SHU_STAR_LEVEL_M1 = xishu_tb["key" .. 22]["number"];
HeroPropConstConfig.XI_SHU_STAR_LEVEL_M2 = xishu_tb["key" .. 23]["number"];

HeroPropConstConfig.XI_SHU_STAR_CHENG_ZHANG_LV_0 = HeroPropConstConfig.XI_SHU_STAR_LEVEL_M1 + 0 * HeroPropConstConfig.XI_SHU_STAR_LEVEL_M2;
HeroPropConstConfig.XI_SHU_STAR_CHENG_ZHANG_LV_1 = HeroPropConstConfig.XI_SHU_STAR_LEVEL_M1 + 1 * HeroPropConstConfig.XI_SHU_STAR_LEVEL_M2;
HeroPropConstConfig.XI_SHU_STAR_CHENG_ZHANG_LV_2 = HeroPropConstConfig.XI_SHU_STAR_LEVEL_M1 + 2 * HeroPropConstConfig.XI_SHU_STAR_LEVEL_M2;
HeroPropConstConfig.XI_SHU_STAR_CHENG_ZHANG_LV_3 = HeroPropConstConfig.XI_SHU_STAR_LEVEL_M1 + 3 * HeroPropConstConfig.XI_SHU_STAR_LEVEL_M2;
HeroPropConstConfig.XI_SHU_STAR_CHENG_ZHANG_LV_4 = HeroPropConstConfig.XI_SHU_STAR_LEVEL_M1 + 4 * HeroPropConstConfig.XI_SHU_STAR_LEVEL_M2;
HeroPropConstConfig.XI_SHU_STAR_CHENG_ZHANG_LV_5 = HeroPropConstConfig.XI_SHU_STAR_LEVEL_M1 + 5 * HeroPropConstConfig.XI_SHU_STAR_LEVEL_M2;

HeroPropConstConfig.XI_SHU_HERO_LEVEL_M1 = xishu_tb["key" .. 24]["number"];
HeroPropConstConfig.XI_SHU_HERO_LEVEL_M2 = xishu_tb["key" .. 25]["number"];
HeroPropConstConfig.XI_SHU_HERO_LEVEL_M3 = xishu_tb["key" .. 26]["number"];
HeroPropConstConfig.XI_SHU_HERO_LEVEL_M4 = xishu_tb["key" .. 27]["number"];
HeroPropConstConfig.XI_SHU_HERO_LEVEL_M5 = xishu_tb["key" .. 28]["number"];

HeroPropConstConfig.XI_SHU_HERO_GRADE_M1 = xishu_tb["key" .. 29]["number"];
HeroPropConstConfig.XI_SHU_HERO_GRADE_M2 = xishu_tb["key" .. 31]["number"];
HeroPropConstConfig.XI_SHU_HERO_GRADE_M3 = xishu_tb["key" .. 33]["number"];
HeroPropConstConfig.XI_SHU_HERO_GRADE_M4 = xishu_tb["key" .. 35]["number"];

HeroPropConstConfig.XI_SHU_HERO_GRADE_N1 = xishu_tb["key" .. 30]["number"];
HeroPropConstConfig.XI_SHU_HERO_GRADE_N2 = xishu_tb["key" .. 32]["number"];
HeroPropConstConfig.XI_SHU_HERO_GRADE_N3 = xishu_tb["key" .. 34]["number"];
HeroPropConstConfig.XI_SHU_HERO_GRADE_N4 = xishu_tb["key" .. 36]["number"];
HeroPropConstConfig.XI_SHU_HERO_GRADE_N5 = xishu_tb["key" .. 37]["number"];

HeroPropConstConfig.XI_SHU_ZHUANG_BEI_LEVEL_M1 = xishu_tb["key" .. 38]["number"];
HeroPropConstConfig.XI_SHU_ZHUANG_BEI_LEVEL_M2 = xishu_tb["key" .. 39]["number"];
HeroPropConstConfig.XI_SHU_ZHUANG_BEI_LEVEL_M3 = xishu_tb["key" .. 40]["number"];
HeroPropConstConfig.XI_SHU_ZHUANG_BEI_LEVEL_M4 = xishu_tb["key" .. 41]["number"];
HeroPropConstConfig.XI_SHU_ZHUANG_BEI_LEVEL_M5 = xishu_tb["key" .. 42]["number"];

HeroPropConstConfig.XI_SHU_PO_FANG = xishu_tb["key" .. 1]["number"];

HeroPropConstConfig.XI_SHU_ZHAN_LI_GONG_JI = xishu_tb["key" .. 43]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_NEI_GONG_JI = xishu_tb["key" .. 45]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_FANG_YU = xishu_tb["key" .. 44]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_NEI_FANG_YU = xishu_tb["key" .. 46]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_SHENG_MING = xishu_tb["key" .. 47]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_HUI_XIN = xishu_tb["key" .. 48]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_SHAN_BI = xishu_tb["key" .. 49]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_ZHAO_JIA = xishu_tb["key" .. 50]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_YU_JIN = xishu_tb["key" .. 51]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_LIAO_SHANG = xishu_tb["key" .. 52]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_ZHU_DONG = xishu_tb["key" .. 53]["number"] / 10;
HeroPropConstConfig.XI_SHU_ZHAN_LI_BEI_DONG = xishu_tb["key" .. 54]["number"] / 10;