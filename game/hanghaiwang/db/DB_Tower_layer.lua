-- Filename: DB_Tower_layer.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Tower_layer", package.seeall)

keys = {
	"id", "fightId", "type", "name", "layerName", "monsterType", "monsterModel", "monsterSmall", "monsterQuality", "belly", "prison", "items", "nextTier", "needLevel", "stronghold", "change_bg", "star_condition", "level_type", "level_class", 
}

Tower_layer = {
	id_1 = {1, 1, 1, "红莲地狱(简单)", "第1关", 1, "head_hz_youchuanshuishou.png", nil, 1, 200, 40, nil, 2, 1, 800001, "impel_down_bg1.jpg", nil, 1, 1, },
	id_2 = {2, 2, 1, "红莲地狱(简单)", "第2关", 1, "head_hz_youchuanshuishou.png", nil, 1, 200, 40, nil, 3, 1, 800002, "impel_down_bg1.jpg", nil, 1, 1, },
	id_3 = {3, 3, 1, "红莲地狱(简单)", "第3关", 1, "head_hz_tiaowendaoshou.png", nil, 2, 200, 40, nil, 4, 1, 800003, "impel_down_bg1.jpg", nil, 1, 1, },
	id_4 = {4, 4, 1, "红莲地狱(简单)", "第4关", 1, "head_hz_tiaowendaoshou.png", nil, 2, 200, 40, nil, 5, 1, 800004, "impel_down_bg1.jpg", nil, 1, 1, },
	id_5 = {5, 5, 1, "红莲地狱(简单)", "第5关", 1, "head_elite_baji.png", 38, 3, 1000, 200, nil, 6, 1, 800005, "impel_down_bg1.jpg", nil, 1, 1, },
	id_6 = {6, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60502|4", 7, nil, nil, "impel_down_bg1.jpg", nil, 1, 1, },
	id_7 = {7, 6, 1, "红莲地狱(简单)", "第6关", 1, "head_hj_haijunqiangshou.png", nil, 1, 200, 40, nil, 8, 1, 800006, "impel_down_bg1.jpg", nil, 1, 1, },
	id_8 = {8, 7, 1, "红莲地狱(简单)", "第7关", 1, "head_hj_haijunqiangshou.png", nil, 1, 200, 40, nil, 9, 1, 800007, "impel_down_bg1.jpg", nil, 1, 1, },
	id_9 = {9, 8, 1, "红莲地狱(简单)", "第8关", 1, "head_hj_haijunliaowangyuan.png", nil, 2, 200, 40, nil, 10, 1, 800008, "impel_down_bg1.jpg", nil, 1, 1, },
	id_10 = {10, 9, 1, "红莲地狱(简单)", "第9关", 1, "head_hj_haijunliaowangyuan.png", nil, 2, 200, 40, nil, 11, 1, 800009, "impel_down_bg1.jpg", nil, 1, 1, },
	id_11 = {11, 10, 1, "红莲地狱(简单)", "第10关", 1, "head_elite_dmn.png", 38, 3, 1000, 200, nil, 12, 1, 800010, "impel_down_bg1.jpg", nil, 1, 1, },
	id_12 = {12, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60006|1,60502|4", 13, nil, nil, "impel_down_bg1.jpg", nil, 1, 1, },
	id_13 = {13, 11, 1, "红莲地狱(普通)", "第11关", 1, "head_hz_heizhangquanshi.png", nil, 1, 200, 40, nil, 14, 1, 800101, "impel_down_bg1.jpg", nil, 1, 2, },
	id_14 = {14, 12, 1, "红莲地狱(普通)", "第12关", 1, "head_hz_heizhangquanshi.png", nil, 1, 200, 40, nil, 15, 1, 800102, "impel_down_bg1.jpg", nil, 1, 2, },
	id_15 = {15, 13, 1, "红莲地狱(普通)", "第13关", 1, "head_hz_hongqiqiangshou.png", nil, 2, 200, 40, nil, 16, 1, 800103, "impel_down_bg1.jpg", nil, 1, 2, },
	id_16 = {16, 14, 1, "红莲地狱(普通)", "第14关", 1, "head_hz_hongqiqiangshou.png", nil, 2, 200, 40, nil, 17, 1, 800104, "impel_down_bg1.jpg", nil, 1, 2, },
	id_17 = {17, 15, 1, "红莲地狱(普通)", "第15关", 1, "head_elite_baji.png", 38, 3, 1000, 200, nil, 18, 1, 800105, "impel_down_bg1.jpg", nil, 1, 2, },
	id_18 = {18, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60503|2", 19, nil, nil, "impel_down_bg1.jpg", nil, 1, 2, },
	id_19 = {19, 16, 1, "红莲地狱(普通)", "第16关", 1, "head_hj_haijundaoshi.png", nil, 1, 200, 40, nil, 20, 1, 800106, "impel_down_bg1.jpg", nil, 1, 2, },
	id_20 = {20, 17, 1, "红莲地狱(普通)", "第17关", 1, "head_hj_haijundaoshi.png", nil, 1, 200, 40, nil, 21, 1, 800107, "impel_down_bg1.jpg", nil, 1, 2, },
	id_21 = {21, 18, 1, "红莲地狱(普通)", "第18关", 1, "head_hj_guanjinghanghaishi.png", nil, 2, 200, 40, nil, 22, 1, 800108, "impel_down_bg1.jpg", nil, 1, 2, },
	id_22 = {22, 19, 1, "红莲地狱(普通)", "第19关", 1, "head_hj_guanjinghanghaishi.png", nil, 2, 200, 40, nil, 23, 1, 800109, "impel_down_bg1.jpg", nil, 1, 2, },
	id_23 = {23, 20, 1, "红莲地狱(普通)", "第20关", 1, "head_elite_dmn.png", 38, 3, 1000, 200, nil, 24, 1, 800110, "impel_down_bg1.jpg", nil, 1, 2, },
	id_24 = {24, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60029|30,60503|2", 25, nil, nil, "impel_down_bg1.jpg", nil, 1, 2, },
	id_25 = {25, 21, 1, "红莲地狱(困难)", "第21关", 1, "head_hz_jintiechuijiang.png", nil, 1, 200, 40, nil, 26, 1, 800201, "impel_down_bg1.jpg", nil, 1, 3, },
	id_26 = {26, 22, 1, "红莲地狱(困难)", "第22关", 1, "head_hz_jintiechuijiang.png", nil, 1, 200, 40, nil, 27, 1, 800202, "impel_down_bg1.jpg", nil, 1, 3, },
	id_27 = {27, 23, 1, "红莲地狱(困难)", "第23关", 1, "head_hz_rexuenvgaoyin.png", nil, 2, 200, 40, nil, 28, 1, 800203, "impel_down_bg1.jpg", nil, 1, 3, },
	id_28 = {28, 24, 1, "红莲地狱(困难)", "第24关", 1, "head_hz_rexuenvgaoyin.png", nil, 2, 200, 40, nil, 29, 1, 800204, "impel_down_bg1.jpg", nil, 1, 3, },
	id_29 = {29, 25, 1, "红莲地狱(困难)", "第25关", 1, "head_elite_baji.png", 38, 3, 1000, 200, nil, 30, 1, 800205, "impel_down_bg1.jpg", nil, 1, 3, },
	id_30 = {30, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60503|2", 31, nil, nil, "impel_down_bg1.jpg", nil, 1, 3, },
	id_31 = {31, 26, 1, "红莲地狱(困难)", "第26关", 1, "head_hj_heiyingqingbaoyuan.png", nil, 1, 200, 40, nil, 32, 1, 800206, "impel_down_bg1.jpg", nil, 1, 3, },
	id_32 = {32, 27, 1, "红莲地狱(困难)", "第27关", 1, "head_hj_heiyingqingbaoyuan.png", nil, 1, 200, 40, nil, 33, 1, 800207, "impel_down_bg1.jpg", nil, 1, 3, },
	id_33 = {33, 28, 1, "红莲地狱(困难)", "第28关", 1, "head_hj_haijunxiashi.png", nil, 2, 200, 40, nil, 34, 1, 800208, "impel_down_bg1.jpg", nil, 1, 3, },
	id_34 = {34, 29, 1, "红莲地狱(困难)", "第29关", 1, "head_hj_haijunxiashi.png", nil, 2, 200, 40, nil, 35, 1, 800209, "impel_down_bg1.jpg", nil, 1, 3, },
	id_35 = {35, 30, 1, "红莲地狱(困难)", "第30关", 1, "head_elite_dmn.png", 38, 3, 1000, 200, nil, 36, 1, 800210, "impel_down_bg1.jpg", nil, 1, 3, },
	id_36 = {36, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60019|3,60503|2", 37, nil, nil, "impel_down_bg1.jpg", nil, 1, 3, },
	id_37 = {37, 31, 1, "猛兽地狱(简单)", "第31关", 1, "head_hz_kuangyedaoke.png", nil, 1, 200, 40, nil, 38, 1, 800301, "impel_down_bg2.jpg", nil, 2, 1, },
	id_38 = {38, 32, 1, "猛兽地狱(简单)", "第32关", 1, "head_hz_kuangyedaoke.png", nil, 1, 200, 40, nil, 39, 1, 800302, "impel_down_bg2.jpg", nil, 2, 1, },
	id_39 = {39, 33, 1, "猛兽地狱(简单)", "第33关", 1, "head_hz_xujiudafu.png", nil, 2, 200, 40, nil, 40, 1, 800303, "impel_down_bg2.jpg", nil, 2, 1, },
	id_40 = {40, 34, 1, "猛兽地狱(简单)", "第34关", 1, "head_hz_xujiudafu.png", nil, 2, 200, 40, nil, 41, 1, 800304, "impel_down_bg2.jpg", nil, 2, 1, },
	id_41 = {41, 35, 1, "猛兽地狱(简单)", "第35关", 1, "head_elite_mr3.png", 38, 3, 1000, 200, nil, 42, 1, 800305, "impel_down_bg2.jpg", nil, 2, 1, },
	id_42 = {42, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60503|2", 43, nil, nil, "impel_down_bg2.jpg", nil, 2, 1, },
	id_43 = {43, 36, 1, "猛兽地狱(简单)", "第36关", 1, "head_hj_jimijunshi.png", nil, 1, 200, 40, nil, 44, 1, 800306, "impel_down_bg2.jpg", nil, 2, 1, },
	id_44 = {44, 37, 1, "猛兽地狱(简单)", "第37关", 1, "head_hj_jimijunshi.png", nil, 1, 200, 40, nil, 45, 1, 800307, "impel_down_bg2.jpg", nil, 2, 1, },
	id_45 = {45, 38, 1, "猛兽地狱(简单)", "第38关", 1, "head_hj_haijundaoshi.png", nil, 2, 200, 40, nil, 46, 1, 800308, "impel_down_bg2.jpg", nil, 2, 1, },
	id_46 = {46, 39, 1, "猛兽地狱(简单)", "第39关", 1, "head_hj_haijundaoshi.png", nil, 2, 200, 40, nil, 47, 1, 800309, "impel_down_bg2.jpg", nil, 2, 1, },
	id_47 = {47, 40, 1, "猛兽地狱(简单)", "第40关", 1, "head_elite_dlst.png", 38, 3, 1000, 200, nil, 48, 1, 800310, "impel_down_bg2.jpg", nil, 2, 1, },
	id_48 = {48, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "30013|1,60503|2", 49, nil, nil, "impel_down_bg2.jpg", nil, 2, 1, },
	id_49 = {49, 41, 1, "猛兽地狱(普通)", "第41关", 1, "head_hz_ronghuopaoshou.png", nil, 1, 200, 40, nil, 50, 1, 800401, "impel_down_bg2.jpg", nil, 2, 2, },
	id_50 = {50, 42, 1, "猛兽地狱(普通)", "第42关", 1, "head_hz_ronghuopaoshou.png", nil, 1, 200, 40, nil, 51, 1, 800402, "impel_down_bg2.jpg", nil, 2, 2, },
	id_51 = {51, 43, 1, "猛兽地狱(普通)", "第43关", 1, "head_hz_xibuhanghaishi.png", nil, 2, 200, 40, nil, 52, 1, 800403, "impel_down_bg2.jpg", nil, 2, 2, },
	id_52 = {52, 44, 1, "猛兽地狱(普通)", "第44关", 1, "head_hz_xibuhanghaishi.png", nil, 2, 200, 40, nil, 53, 1, 800404, "impel_down_bg2.jpg", nil, 2, 2, },
	id_53 = {53, 45, 1, "猛兽地狱(普通)", "第45关", 1, "head_elite_mr3.png", 38, 3, 1000, 200, nil, 54, 1, 800405, "impel_down_bg2.jpg", nil, 2, 2, },
	id_54 = {54, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60503|2", 55, nil, nil, "impel_down_bg2.jpg", nil, 2, 2, },
	id_55 = {55, 46, 1, "猛兽地狱(普通)", "第46关", 1, "head_hj_haijunjuncao.png", nil, 1, 200, 40, nil, 56, 1, 800406, "impel_down_bg2.jpg", nil, 2, 2, },
	id_56 = {56, 47, 1, "猛兽地狱(普通)", "第47关", 1, "head_hj_haijunjuncao.png", nil, 1, 200, 40, nil, 57, 1, 800407, "impel_down_bg2.jpg", nil, 2, 2, },
	id_57 = {57, 48, 1, "猛兽地狱(普通)", "第48关", 1, "head_hj_qingliangquanshi.png", nil, 2, 200, 40, nil, 58, 1, 800408, "impel_down_bg2.jpg", nil, 2, 2, },
	id_58 = {58, 49, 1, "猛兽地狱(普通)", "第49关", 1, "head_hj_qingliangquanshi.png", nil, 2, 200, 40, nil, 59, 1, 800409, "impel_down_bg2.jpg", nil, 2, 2, },
	id_59 = {59, 50, 1, "猛兽地狱(普通)", "第50关", 1, "head_elite_dlst.png", 38, 3, 1000, 200, nil, 60, 1, 800410, "impel_down_bg2.jpg", nil, 2, 2, },
	id_60 = {60, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "500001|5,60503|3", 61, nil, nil, "impel_down_bg2.jpg", nil, 2, 2, },
	id_61 = {61, 51, 1, "猛兽地狱(困难)", "第51关", 1, "head_hz_rexuenvgaoyin.png", nil, 1, 200, 40, nil, 62, 1, 800501, "impel_down_bg2.jpg", nil, 2, 3, },
	id_62 = {62, 52, 1, "猛兽地狱(困难)", "第52关", 1, "head_hz_rexuenvgaoyin.png", nil, 1, 200, 40, nil, 63, 1, 800502, "impel_down_bg2.jpg", nil, 2, 3, },
	id_63 = {63, 53, 1, "猛兽地狱(困难)", "第53关", 1, "head_hz_jintiechuijiang.png", nil, 2, 200, 40, nil, 64, 1, 800503, "impel_down_bg2.jpg", nil, 2, 3, },
	id_64 = {64, 54, 1, "猛兽地狱(困难)", "第54关", 1, "head_hz_jintiechuijiang.png", nil, 2, 200, 40, nil, 65, 1, 800504, "impel_down_bg2.jpg", nil, 2, 3, },
	id_65 = {65, 55, 1, "猛兽地狱(困难)", "第55关", 1, "head_elite_mr3.png", 38, 3, 1000, 200, nil, 66, 1, 800505, "impel_down_bg2.jpg", nil, 2, 3, },
	id_66 = {66, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60503|3", 67, nil, nil, "impel_down_bg2.jpg", nil, 2, 3, },
	id_67 = {67, 56, 1, "猛兽地狱(困难)", "第56关", 1, "head_hj_anyediebaoyuan.png", nil, 1, 200, 40, nil, 68, 1, 800506, "impel_down_bg2.jpg", nil, 2, 3, },
	id_68 = {68, 57, 1, "猛兽地狱(困难)", "第57关", 1, "head_hj_anyediebaoyuan.png", nil, 1, 200, 40, nil, 69, 1, 800507, "impel_down_bg2.jpg", nil, 2, 3, },
	id_69 = {69, 58, 1, "猛兽地狱(困难)", "第58关", 1, "head_hj_haijunxiashi.png", nil, 2, 200, 40, nil, 70, 1, 800508, "impel_down_bg2.jpg", nil, 2, 3, },
	id_70 = {70, 59, 1, "猛兽地狱(困难)", "第59关", 1, "head_hj_haijunxiashi.png", nil, 2, 200, 40, nil, 71, 1, 800509, "impel_down_bg2.jpg", nil, 2, 3, },
	id_71 = {71, 60, 1, "猛兽地狱(困难)", "第60关", 1, "head_elite_dlst.png", 38, 3, 1000, 200, nil, 72, 1, 800510, "impel_down_bg2.jpg", nil, 2, 3, },
	id_72 = {72, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60008|15,60503|3", 73, nil, nil, "impel_down_bg2.jpg", nil, 2, 3, },
	id_73 = {73, 61, 1, "饥饿地狱(简单)", "第61关", 1, "head_hz_jintiechuijiang.png", nil, 1, 200, 40, nil, 74, 1, 800601, "impel_down_bg3.jpg", nil, 3, 1, },
	id_74 = {74, 62, 1, "饥饿地狱(简单)", "第62关", 1, "head_hz_jintiechuijiang.png", nil, 1, 200, 40, nil, 75, 1, 800602, "impel_down_bg3.jpg", nil, 3, 1, },
	id_75 = {75, 63, 1, "饥饿地狱(简单)", "第63关", 1, "head_hz_xibuhanghaishi.png", nil, 2, 200, 40, nil, 76, 1, 800603, "impel_down_bg3.jpg", nil, 3, 1, },
	id_76 = {76, 64, 1, "饥饿地狱(简单)", "第64关", 1, "head_hz_xibuhanghaishi.png", nil, 2, 200, 40, nil, 77, 1, 800604, "impel_down_bg3.jpg", nil, 3, 1, },
	id_77 = {77, 65, 1, "饥饿地狱(简单)", "第65关", 1, "head_elite_mr2.png", 38, 3, 1000, 200, nil, 78, 1, 800605, "impel_down_bg3.jpg", nil, 3, 1, },
	id_78 = {78, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60503|3", 79, nil, nil, "impel_down_bg3.jpg", nil, 3, 1, },
	id_79 = {79, 66, 1, "饥饿地狱(简单)", "第66关", 1, "head_hj_anyediebaoyuan.png", nil, 1, 200, 40, nil, 80, 1, 800606, "impel_down_bg3.jpg", nil, 3, 1, },
	id_80 = {80, 67, 1, "饥饿地狱(简单)", "第67关", 1, "head_hj_anyediebaoyuan.png", nil, 1, 200, 40, nil, 81, 1, 800607, "impel_down_bg3.jpg", nil, 3, 1, },
	id_81 = {81, 68, 1, "饥饿地狱(简单)", "第68关", 1, "head_hj_diebaoyuan.png", nil, 2, 200, 40, nil, 82, 1, 800608, "impel_down_bg3.jpg", nil, 3, 1, },
	id_82 = {82, 69, 1, "饥饿地狱(简单)", "第69关", 1, "head_hj_diebaoyuan.png", nil, 2, 200, 40, nil, 83, 1, 800609, "impel_down_bg3.jpg", nil, 3, 1, },
	id_83 = {83, 70, 1, "饥饿地狱(简单)", "第70关", 1, "head_elite_sadi.png", 38, 3, 1000, 200, nil, 84, 1, 800610, "impel_down_bg3.jpg", nil, 3, 1, },
	id_84 = {84, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60029|60,60503|3", 85, nil, nil, "impel_down_bg3.jpg", nil, 3, 1, },
	id_85 = {85, 71, 1, "饥饿地狱(普通)", "第71关", 1, "head_hz_tiebangwuniang.png", nil, 1, 200, 40, nil, 86, 1, 800701, "impel_down_bg3.jpg", nil, 3, 2, },
	id_86 = {86, 72, 1, "饥饿地狱(普通)", "第72关", 1, "head_hz_tiebangwuniang.png", nil, 1, 200, 40, nil, 87, 1, 800702, "impel_down_bg3.jpg", nil, 3, 2, },
	id_87 = {87, 73, 1, "饥饿地狱(普通)", "第73关", 1, "head_hz_baoliyuren.png", nil, 2, 200, 40, nil, 88, 1, 800703, "impel_down_bg3.jpg", nil, 3, 2, },
	id_88 = {88, 74, 1, "饥饿地狱(普通)", "第74关", 1, "head_hz_baoliyuren.png", nil, 2, 200, 40, nil, 89, 1, 800704, "impel_down_bg3.jpg", nil, 3, 2, },
	id_89 = {89, 75, 1, "饥饿地狱(普通)", "第75关", 1, "head_elite_mr2.png", 38, 3, 1000, 200, nil, 90, 1, 800705, "impel_down_bg3.jpg", nil, 3, 2, },
	id_90 = {90, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60503|3", 91, nil, nil, "impel_down_bg3.jpg", nil, 3, 2, },
	id_91 = {91, 76, 1, "饥饿地狱(普通)", "第76关", 1, "head_hj_jimijunshi.png", nil, 1, 200, 40, nil, 92, 1, 800706, "impel_down_bg3.jpg", nil, 3, 2, },
	id_92 = {92, 77, 1, "饥饿地狱(普通)", "第77关", 1, "head_hj_jimijunshi.png", nil, 1, 200, 40, nil, 93, 1, 800707, "impel_down_bg3.jpg", nil, 3, 2, },
	id_93 = {93, 78, 1, "饥饿地狱(普通)", "第78关", 1, "head_hj_zhikucanmou.png", nil, 2, 200, 40, nil, 94, 1, 800708, "impel_down_bg3.jpg", nil, 3, 2, },
	id_94 = {94, 79, 1, "饥饿地狱(普通)", "第79关", 1, "head_hj_zhikucanmou.png", nil, 2, 200, 40, nil, 95, 1, 800709, "impel_down_bg3.jpg", nil, 3, 2, },
	id_95 = {95, 80, 1, "饥饿地狱(普通)", "第80关", 1, "head_elite_sadi.png", 38, 3, 1000, 200, nil, 96, 1, 800710, "impel_down_bg3.jpg", nil, 3, 2, },
	id_96 = {96, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60029|60,60503|3", 97, nil, nil, "impel_down_bg3.jpg", nil, 3, 2, },
	id_97 = {97, 81, 1, "饥饿地狱(困难)", "第81关", 1, "head_hz_heizhangquanshi.png", nil, 1, 200, 40, nil, 98, 1, 800801, "impel_down_bg3.jpg", nil, 3, 3, },
	id_98 = {98, 82, 1, "饥饿地狱(困难)", "第82关", 1, "head_hz_heizhangquanshi.png", nil, 1, 200, 40, nil, 99, 1, 800802, "impel_down_bg3.jpg", nil, 3, 3, },
	id_99 = {99, 83, 1, "饥饿地狱(困难)", "第83关", 1, "head_hz_liulanggezhe.png", nil, 2, 200, 40, nil, 100, 1, 800803, "impel_down_bg3.jpg", nil, 3, 3, },
	id_100 = {100, 84, 1, "饥饿地狱(困难)", "第84关", 1, "head_hz_liulanggezhe.png", nil, 2, 200, 40, nil, 101, 1, 800804, "impel_down_bg3.jpg", nil, 3, 3, },
	id_101 = {101, 85, 1, "饥饿地狱(困难)", "第85关", 1, "head_elite_mr2.png", 38, 3, 1000, 200, nil, 102, 1, 800805, "impel_down_bg3.jpg", nil, 3, 3, },
	id_102 = {102, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60503|3", 103, nil, nil, "impel_down_bg3.jpg", nil, 3, 3, },
	id_103 = {103, 86, 1, "饥饿地狱(困难)", "第86关", 1, "head_hj_zhongweifushou.png", nil, 1, 200, 40, nil, 104, 1, 800806, "impel_down_bg3.jpg", nil, 3, 3, },
	id_104 = {104, 87, 1, "饥饿地狱(困难)", "第87关", 1, "head_hj_zhongweifushou.png", nil, 1, 200, 40, nil, 105, 1, 800807, "impel_down_bg3.jpg", nil, 3, 3, },
	id_105 = {105, 88, 1, "饥饿地狱(困难)", "第88关", 1, "head_hj_jifenghanghaishi.png", nil, 2, 200, 40, nil, 106, 1, 800808, "impel_down_bg3.jpg", nil, 3, 3, },
	id_106 = {106, 89, 1, "饥饿地狱(困难)", "第89关", 1, "head_hj_jifenghanghaishi.png", nil, 2, 200, 40, nil, 107, 1, 800809, "impel_down_bg3.jpg", nil, 3, 3, },
	id_107 = {107, 90, 1, "饥饿地狱(困难)", "第90关", 1, "head_elite_sadi.png", 38, 3, 1000, 200, nil, 108, 1, 800810, "impel_down_bg3.jpg", nil, 3, 3, },
	id_108 = {108, nil, 2, "监狱宝箱", nil, nil, nil, nil, nil, nil, nil, "60029|60,60503|3", nil, nil, nil, "impel_down_bg3.jpg", nil, 3, 3, },
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
	local id_data = Tower_layer["id_" .. key_id]
	assert(id_data, "Tower_layer not found " ..  key_id)
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
	for k, v in pairs(Tower_layer) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Tower_layer"] = nil
	package.loaded["DB_Tower_layer"] = nil
	package.loaded["db/DB_Tower_layer"] = nil
end

