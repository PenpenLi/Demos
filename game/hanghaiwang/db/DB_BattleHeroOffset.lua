-- Filename: DB_BattleHeroOffset.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_BattleHeroOffset", package.seeall)

keys = {
	"id", "imageName", "offsetX", "offsetY", "cardType", 
}

BattleHeroOffset = {
	id_1 = {1, "fight_hj_shenhaichushi.png", 0, -8, 1, },
	id_2 = {2, "fight_elite_wusuopu.png", 0, -18, 1, },
	id_3 = {3, "fight_elite_namei.png", 0, -34, 1, },
	id_4 = {4, "fight_elite_simoge.png", 0, -9, 1, },
	id_5 = {5, "fight_elite_luobin.png", 0, -20, 1, },
	id_6 = {6, "fight_elite_buluke.png", 0, -22, 1, },
	id_7 = {7, "fight_elite_peiluona.png", 0, -33, 1, },
	id_8 = {8, "fight_elite_lufei.png", 0, -8, 1, },
	id_9 = {9, "fight_elite_xiangjishi.png", 0, -16, 1, },
	id_10 = {10, "fight_elite_dasiqi.png", 0, -30, 1, },
	id_11 = {11, "fight_elite_kaku.png", 0, -31, 1, },
	id_12 = {12, "fight_elite_jianhaolongma.png", 0, -7, 1, },
	id_13 = {13, "fight_elite_huojinsi.png", 0, -4, 1, },
	id_14 = {14, "fight_elite_apu.png", 0, -8, 1, },
	id_15 = {15, "fight_elite_morenaozi.png", 0, -15, 1, },
	id_16 = {16, "fight_elite_mr2.png", 0, -21, 1, },
	id_17 = {17, "fight_elite_baji.png", 0, -5, 1, },
	id_18 = {18, "fight_elite_mr1.png", 0, -8, 1, },
	id_19 = {19, "fight_elite_bulu.png", 0, -26, 1, },
	id_20 = {20, "fight_elite_glw.png", 0, -2, 1, },
	id_21 = {21, "fight_elite_mr3.png", 0, -13, 1, },
	id_22 = {22, "fight_elite_yaerlitada.png", 0, -24, 1, },
	id_23 = {23, "fight_elite_yaerlita.png", 0, -26, 1, },
	id_24 = {24, "fight_elite_zhantaowan.png", 0, -13, 1, },
	id_25 = {25, "fight_elite_aisi.png", 0, -25, 1, },
	id_26 = {26, "fight_elite_maerke.png", 0, -41, 1, },
	id_27 = {27, "fight_elite_renyaowang.png", 0, -6, 1, },
	id_28 = {28, "fight_elite_luqi.png", 0, -11, 1, },
	id_29 = {29, "fight_elite_baihuzi.png", 0, -34, 1, },
	id_30 = {30, "fight_elite_zhanguo.png", 0, -7, 1, },
	id_31 = {31, "fight_elite_leili.png", 0, -33, 1, },
	id_32 = {32, "fight_elite_heihuzi.png", 0, -39, 1, },
	id_33 = {33, "fight_elite_huangyuan.png", 0, -12, 1, },
	id_34 = {34, "fight_elite_maizhelun.png", 0, -34, 1, },
	id_35 = {35, "fight_elite_kapu.png", 0, -6, 1, },
	id_36 = {36, "fight_elite_joker.png", 0, -14, 1, },
	id_37 = {37, "fight_elite_youshuzhongjiang.png", 0, -24, 1, },
	id_38 = {38, "fight_elite_daermeixiya.png", 0, -22, 1, },
	id_39 = {39, "fight_elite_spdmu.png", 0, -26, 1, },
	id_40 = {40, "fight_elite_jbl.png", 0, -9, 1, },
	id_41 = {41, "fight_elite_gfe.png", 0, -27, 1, },
	id_42 = {42, "fight_elite_xiula.png", 0, -83, 1, },
	id_43 = {43, "fight_elite_gdz.png", 0, -15, 1, },
	id_44 = {44, "fight_elite_double.png", 0, -18, 1, },
	id_45 = {45, "fight_elite_4.png", 0, -11, 1, },
	id_46 = {46, "fight_elite_shengdan.png", 0, -14, 1, },
	id_47 = {47, "fight_elite_qingren.png", 0, -5, 1, },
	id_48 = {48, "fight_elite_zhefu.png", 0, -31, 1, },
	id_49 = {49, "fight_elite_kousha.png", 0, -4, 1, },
	id_50 = {50, "fight_elite_bali.png", 0, -16, 1, },
	id_51 = {51, "fight_elite_lulu.png", 0, -37, 1, },
	id_52 = {52, "fight_elite_hgbk.png", 0, -28, 1, },
	id_53 = {53, "fight_elite_sdb.png", 0, -50, 1, },
	id_54 = {54, "fight_elite_mglt.png", 0, -10, 1, },
	id_55 = {55, "fight_elite_tgu.png", 0, -4, 1, },
	id_56 = {56, "fight_elite_xiaoba.png", 0, -12, 1, },
	id_57 = {57, "fight_elite_kamaqili.png", 0, -42, 1, },
	id_58 = {58, "fight_elite_lufeilan.png", 0, -9, 1, },
	id_59 = {59, "fight_elite_kaxi.png", 0, -16, 1, },
	id_60 = {60, "fight_elite_mengka.png", 0, -28, 1, },
	id_61 = {61, "fight_elite_dongli.png", 0, -16, 1, },
	id_62 = {62, "fight_elite_xingxing.png", 0, -5, 1, },
	id_63 = {63, "fight_elite_kabaji.png", 0, -28, 1, },
	id_64 = {64, "fight_elite_wajie.png", 0, -8, 1, },
	id_65 = {65, "fight_elite_liji.png", 0, -6, 1, },
	id_66 = {66, "fight_elite_padi.png", 0, -14, 1, },
	id_67 = {67, "fight_elite_jingyan_xiongmao4.png", 0, -20, 1, },
	id_68 = {68, "fight_elite_jingyan_xiongmao1.png", 0, -20, 1, },
	id_69 = {69, "fight_elite_jingyan_xiongmao2.png", 0, -20, 1, },
	id_70 = {70, "fight_elite_jingyan_xiongmao3.png", 0, -20, 1, },
	id_71 = {71, "fight_hz_xujiudafu.png", 0, -4, 1, },
	id_72 = {72, "fight_hz_tiebangwuniang.png", 0, -13, 1, },
	id_73 = {73, "fight_hz_xibuhanghaishi.png", 0, -10, 1, },
	id_74 = {74, "fight_hj_haijunzhongpaoshou.png", 0, -20, 1, },
	id_75 = {75, "fight_hj_huoshanmichu.png", 0, -17, 1, },
	id_76 = {76, "fight_elite_baji.png", 0, -6, 2, },
	id_77 = {77, "fight_elite_bulu.png", 0, -38, 2, },
	id_78 = {78, "fight_elite_liji.png", 0, -8, 2, },
	id_79 = {79, "fight_elite_luobin.png", 0, -26, 2, },
	id_80 = {80, "fight_elite_luqi.png", 0, -22, 2, },
	id_81 = {81, "fight_elite_mengka.png", 0, -40, 2, },
	id_82 = {82, "fight_elite_yaerlitada.png", 0, -35, 2, },
	id_83 = {83, "fight_elite_wyp.png", 0, -48, 2, },
	id_84 = {84, "fight_elite_simoge.png", 0, -15, 2, },
	id_85 = {85, "fight_elite_spdmu.png", 0, -38, 2, },
	id_86 = {86, "body_elite_labu.png", -75, -70, 4, },
	id_87 = {87, "fight_elite_along.png", 0, -4, 2, },
	id_88 = {88, "fight_elite_jg.png", 0, -23, 1, },
	id_89 = {89, "fight_elite_dongli.png", 0, -38, 3, },
	id_90 = {90, "fight_elite_xingqiyi.png", 0, -26, 1, },
	id_91 = {91, "fight_hz_heizhangquanshi.png", 0, -10, 1, },
	id_92 = {92, "fight_elite_maizhelun.png", 0, -51, 2, },
	id_93 = {93, "fight_elite_aisi.png", 0, -47, 2, },
	id_94 = {94, "fight_elite_renyaowang.png", 0, -8, 2, },
	id_95 = {95, "fight_elite_youshuzhongjiang.png", 0, -40, 2, },
	id_96 = {96, "fight_elite_daermeixiya.png", 0, -35, 2, },
	id_97 = {97, "fight_elite_dasiqi.png", 0, -46, 2, },
	id_98 = {98, "fight_elite_kaku.png", 0, -52, 2, },
	id_99 = {99, "fight_elite_mr2.png", 0, -29, 2, },
	id_100 = {100, "fight_elite_mr1.png", 0, -14, 2, },
	id_101 = {101, "fight_elite_glw.png", 0, -4, 2, },
	id_102 = {102, "fight_elite_yaerlita.png", 0, -38, 2, },
	id_103 = {103, "fight_elite_jbl.png", 0, -12, 2, },
	id_104 = {104, "fight_elite_gfe.png", 0, -42, 2, },
	id_105 = {105, "fight_elite_xiula.png", 0, -128, 2, },
	id_106 = {106, "fight_elite_gdz.png", 0, -21, 2, },
	id_107 = {107, "fight_elite_double.png", 0, -26, 2, },
	id_108 = {108, "fight_elite_4.png", 0, -17, 2, },
	id_109 = {109, "fight_elite_shengdan.png", 0, -21, 2, },
	id_110 = {110, "fight_elite_qingren.png", 0, -5, 2, },
	id_111 = {111, "fight_elite_zhefu.png", 0, -45, 2, },
	id_112 = {112, "fight_elite_kousha.png", 0, -7, 2, },
	id_113 = {113, "fight_elite_bali.png", 0, -21, 2, },
	id_114 = {114, "fight_elite_tgu.png", 0, -5, 2, },
	id_115 = {115, "fight_elite_xiaoba.png", 0, -18, 2, },
	id_116 = {116, "fight_elite_kamaqili.png", 0, -60, 2, },
	id_117 = {117, "fight_elite_xingqiyi.png", 0, -40, 2, },
	id_118 = {118, "fight_elite_kabaji.png", 0, -42, 2, },
	id_119 = {119, "fight_elite_wajie.png", 0, -11, 2, },
}

local mt = {}
mt.__index = function (table, key)
	for i = 1, #keys do
		if (keys[i] == key) then
			return table[i]
		end
	end
end

function getDataById(key_id)
	local id_data = BattleHeroOffset["id_" .. key_id]
	assert(id_data, "BattleHeroOffset not found " ..  key_id)
	if id_data == nil then
		return nil
	end
	if getmetatable(id_data) ~= nil then
		return id_data
	end
	setmetatable(id_data, mt)

	return id_data
end

function getArrDataByField(fieldName, fieldValue)
	local arrData = {}
	local fieldNo = 1
	for i=1, #keys do
		if keys[i] == fieldName then
			fieldNo = i
			break
		end
	end
	for k, v in pairs(BattleHeroOffset) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_BattleHeroOffset"] = nil
	package.loaded["DB_BattleHeroOffset"] = nil
	package.loaded["db/DB_BattleHeroOffset"] = nil
end

