-- Filename: DB_Npc_name.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Npc_name", package.seeall)

keys = {
	"id", "surname", "girl_name", "boy_name", 
}

Npc_name = {
	id_1 = {1, "蒙布朗", "黛碧", "亚当", },
	id_2 = {2, "卡彭", "艾米丽", "艾伯特", },
	id_3 = {3, "贾斯汀", "尤朵拉", "克林", },
	id_4 = {4, "布兰特", "珍妮特", "寇里", },
	id_5 = {5, "佛里", "贾思琳", "戴纳", },
	id_6 = {6, "威尔", "罗伦", "迪福", },
	id_7 = {7, "丹尼尔", "塞尔达", "达伦", },
	id_8 = {8, "阿普顿", "玛德琳", "多明戈", },
	id_9 = {9, "加里", "玛姬", "邓肯", },
	id_10 = {10, "阿尔瓦", "麦格", "唐恩", },
	id_11 = {11, "莱特", "米兰达", "迪伦", },
	id_12 = {12, "布兰登", "南茜", "埃尔登", },
	id_13 = {13, "尤里", "妮可", "尤金", },
	id_14 = {14, "克里斯", "佩格", "伊夫力", },
	id_15 = {15, "维克", "波利", "霍尔", },
	id_16 = {16, "爱德华", "莉娃", "艾维斯", },
	id_17 = {17, "伊罗", "莎莉", "利奥", },
	id_18 = {18, "托尼", "苏菲亚", "麦尔肯", },
	id_19 = {19, "波雅", "优娜", "莫尔", },
	id_20 = {20, "达兹", "温蒂", "纽曼", },
	id_21 = {21, "乔艾莉", "瓦妮莎", "杰森", },
	id_22 = {22, "哥尔", "瓦勒莉", "杰勒米", },
	id_23 = {23, "贝拉", "乌苏拉", "马里奥", },
	id_24 = {24, "里奇", "泰贝莎", "摩西", },
	id_25 = {25, "特伦斯", "玛瑞", "奥利佛", },
	id_26 = {26, "奈菲鲁", "雷思丽", "菲力浦", },
	id_27 = {27, "安德鲁", "朱恩", "罗德", },
	id_28 = {28, "汉克", "何蒙莎", "史考特", },
	id_29 = {29, "弗瑞德", "迪丽雅", "托马斯", },
	id_30 = {30, "亚伦", "阿芙拉", "华纳", },
	id_31 = {31, "爱博", "碧翠", "耶鲁", },
	id_32 = {32, "波特卡", "贝芙", "文森", },
	id_33 = {33, "托尼", "克莱拉", "摩帝马", },
	id_34 = {34, "雅各布", "辛西亚", "勒斯", },
	id_35 = {35, "乌索", nil, nil, },
	id_36 = {36, "迪奇", nil, nil, },
	id_37 = {37, "尼古拉", nil, nil, },
	id_38 = {38, "奥利弗", nil, nil, },
	id_39 = {39, "菲比", nil, nil, },
	id_40 = {40, "诺亚", nil, nil, },
	id_41 = {41, "诺德", nil, nil, },
	id_42 = {42, "雷尔", nil, nil, },
	id_43 = {43, "吉彼", nil, nil, },
	id_44 = {44, "拉里", nil, nil, },
	id_45 = {45, "斯摩格", nil, nil, },
	id_46 = {46, "古蕾", nil, nil, },
	id_47 = {47, "安黎", nil, nil, },
	id_48 = {48, "迪布", nil, nil, },
	id_49 = {49, "唐吉诃", nil, nil, },
	id_50 = {50, "马歇尔", nil, nil, },
	id_51 = {51, "山迪亚", nil, nil, },
	id_52 = {52, "卡库", nil, nil, },
	id_53 = {53, "霍迪", nil, nil, },
	id_54 = {54, "米兹塔", nil, nil, },
	id_55 = {55, "巴兹尔", nil, nil, },
	id_56 = {56, "海恩", nil, nil, },
	id_57 = {57, "艾比", nil, nil, },
	id_58 = {58, "尼尔", nil, nil, },
	id_59 = {59, "宝亚", nil, nil, },
	id_60 = {60, "海恩", nil, nil, },
	id_61 = {61, "伊维", nil, nil, },
	id_62 = {62, "罗洛亚", nil, nil, },
	id_63 = {63, "桑吉", nil, nil, },
	id_64 = {64, "妮歌", nil, nil, },
	id_65 = {65, "碧克曼", nil, nil, },
	id_66 = {66, "赖吉", nil, nil, },
	id_67 = {67, "玛琪诺", nil, nil, },
	id_68 = {68, "希古马", nil, nil, },
	id_69 = {69, "亚比达", nil, nil, },
	id_70 = {70, "莉嘉", nil, nil, },
	id_71 = {71, "古伊娜", nil, nil, },
	id_72 = {72, "卡柏斯", nil, nil, },
	id_73 = {73, "布托路", nil, nil, },
	id_74 = {74, "艾门", nil, nil, },
	id_75 = {75, "嘉雅", nil, nil, },
	id_76 = {76, "马里", nil, nil, },
	id_77 = {77, "赞高", nil, nil, },
	id_78 = {78, "山姆", nil, nil, },
	id_79 = {79, "约瑟夫", nil, nil, },
	id_80 = {80, "霍波迪", nil, nil, },
	id_81 = {81, "卓夫", nil, nil, },
	id_82 = {82, "路斯高", nil, nil, },
	id_83 = {83, "贝玛尔", nil, nil, },
	id_84 = {84, "布利", nil, nil, },
	id_85 = {85, "史莫卡", nil, nil, },
	id_86 = {86, "卡美", nil, nil, },
	id_87 = {87, "阿碧斯", nil, nil, },
	id_88 = {88, "波古丹", nil, nil, },
	id_89 = {89, "尼尔森", nil, nil, },
	id_90 = {90, "艾力克", nil, nil, },
	id_91 = {91, "古洛卡", nil, nil, },
	id_92 = {92, "娜芙亚", nil, nil, },
	id_93 = {93, "卡鲁", nil, nil, },
	id_94 = {94, "宾治", nil, nil, },
	id_95 = {95, "布洛基", nil, nil, },
	id_96 = {96, "捷斯", nil, nil, },
	id_97 = {97, "玛利亚", nil, nil, },
	id_98 = {98, "库蕾", nil, nil, },
	id_99 = {99, "波德", nil, nil, },
	id_100 = {100, "比尔", nil, nil, },
	id_101 = {101, "卓加", nil, nil, },
	id_102 = {102, "迪布", nil, nil, },
	id_103 = {103, "奇布", nil, nil, },
	id_104 = {104, "拉苏", nil, nil, },
	id_105 = {105, "露西", nil, nil, },
	id_106 = {106, "拉丝", nil, nil, },
	id_107 = {107, "文布拉", nil, nil, },
	id_108 = {108, "玛斯拉", nil, nil, },
	id_109 = {109, "比拿", nil, nil, },
	id_110 = {110, "马沙尔", nil, nil, },
	id_111 = {111, "拉非特", nil, nil, },
	id_112 = {112, "歌妮斯", nil, nil, },
	id_113 = {113, "皮雅尔", nil, nil, },
	id_114 = {114, "帕加雅", nil, nil, },
	id_115 = {115, "艾尼", nil, nil, },
	id_116 = {116, "爱莎", nil, nil, },
	id_117 = {117, "兰琪", nil, nil, },
	id_118 = {118, "姆丝", nil, nil, },
	id_119 = {119, "茱丽", nil, nil, },
	id_120 = {120, "东吉特", nil, nil, },
	id_121 = {121, "波尔雪", nil, nil, },
	id_122 = {122, "霍斯", nil, nil, },
	id_123 = {123, "碧宾", nil, nil, },
	id_124 = {124, "加保提", nil, nil, },
	id_125 = {125, "可可罗", nil, nil, },
	id_126 = {126, "琪姆妮", nil, nil, },
	id_127 = {127, "伊卡莉", nil, nil, },
	id_128 = {128, "路奇", nil, nil, },
	id_129 = {129, "卢梭", nil, nil, },
	id_130 = {130, "布朗尼", nil, nil, },
	id_131 = {131, "克里斯蒂安", nil, nil, },
	id_132 = {132, "亚伦", nil, nil, },
	id_133 = {133, "安迪", nil, nil, },
	id_134 = {134, "艾德里", nil, nil, },
	id_135 = {135, "凯里", nil, nil, },
	id_136 = {136, "吉米", nil, nil, },
	id_137 = {137, "卢克", nil, nil, },
	id_138 = {138, "艾达", nil, nil, },
	id_139 = {139, "艾娜", nil, nil, },
	id_140 = {140, "英格丽", nil, nil, },
	id_141 = {141, "爱莉丝", nil, nil, },
	id_142 = {142, "伊莎蓓尔", nil, nil, },
	id_143 = {143, "艾薇", nil, nil, },
	id_144 = {144, "阿加莎", nil, nil, },
	id_145 = {145, "爱葛妮丝", nil, nil, },
	id_146 = {146, "艾丽斯", nil, nil, },
	id_147 = {147, "爱玛", nil, nil, },
	id_148 = {148, "奥尔瑟雅", nil, nil, },
	id_149 = {149, "阿尔娃", nil, nil, },
	id_150 = {150, "阿娜丝塔", nil, nil, },
	id_151 = {151, "安妮", nil, nil, },
	id_152 = {152, "安东妮", nil, nil, },
	id_153 = {153, "艾琳娜", nil, nil, },
	id_154 = {154, "芭芭拉", nil, nil, },
	id_155 = {155, "贝丝", nil, nil, },
	id_156 = {156, "柏莎", nil, nil, },
	id_157 = {157, "贝蒂", nil, nil, },
	id_158 = {158, "布兰琪", nil, nil, },
	id_159 = {159, "卡米拉", nil, nil, },
	id_160 = {160, "卡萝", nil, nil, },
	id_161 = {161, "卡罗琳", nil, nil, },
	id_162 = {162, "凯丝", nil, nil, },
	id_163 = {163, "绮莉", nil, nil, },
	id_164 = {164, "夏洛特", nil, nil, },
	id_165 = {165, "克莱儿", nil, nil, },
	id_166 = {166, "黛西", nil, nil, },
	id_167 = {167, "黛娜", nil, nil, },
	id_168 = {168, "黛芙妮", nil, nil, },
	id_169 = {169, "达莲娜", nil, nil, },
	id_170 = {170, "丹尼丝", nil, nil, },
	id_171 = {171, "黛安娜", nil, nil, },
	id_172 = {172, "洛夫", nil, nil, },
	id_173 = {173, "唐娜", nil, nil, },
	id_174 = {174, "尔莎", nil, nil, },
	id_175 = {175, "伊迪丝", nil, nil, },
	id_176 = {176, "艾丽莎", nil, nil, },
	id_177 = {177, "艾伦", nil, nil, },
	id_178 = {178, "尤妮斯", nil, nil, },
	id_179 = {179, "梵妮", nil, nil, },
	id_180 = {180, "弗莉达", nil, nil, },
	id_181 = {181, "姬玛", nil, nil, },
	id_182 = {182, "珍妮芙", nil, nil, },
	id_183 = {183, "葛瑞丝", nil, nil, },
	id_184 = {184, "海伦", nil, nil, },
	id_185 = {185, "赫蒂", nil, nil, },
	id_186 = {186, "汉妮", nil, nil, },
	id_187 = {187, "琴", nil, nil, },
	id_188 = {188, "朱蒂斯", nil, nil, },
	id_189 = {189, "朱莉娅", nil, nil, },
	id_190 = {190, "布蒂克", nil, nil, },
	id_191 = {191, "德乌姆", nil, nil, },
	id_192 = {192, "多梅特", nil, nil, },
	id_193 = {193, "费萨南", nil, nil, },
	id_194 = {194, "吉米克", nil, nil, },
	id_195 = {195, "迪安", nil, nil, },
	id_196 = {196, "扎尔登", nil, nil, },
	id_197 = {197, "亚古", nil, nil, },
	id_198 = {198, "兰德", nil, nil, },
	id_199 = {199, "齐亚特", nil, nil, },
	id_200 = {200, "苏克尔", nil, nil, },
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
	local id_data = Npc_name["id_" .. key_id]
	assert(id_data, "Npc_name not found " ..  key_id)
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
	for k, v in pairs(Npc_name) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Npc_name"] = nil
	package.loaded["DB_Npc_name"] = nil
	package.loaded["db/DB_Npc_name"] = nil
end

