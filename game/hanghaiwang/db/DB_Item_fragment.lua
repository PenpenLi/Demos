-- Filename: DB_Item_fragment.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_fragment", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "need_part_num", "aimItem", "dropStrongHold", "dropelite", "dropexplore", "item_getway", 
}

Item_fragment = {
	id_1013124 = {1013124, "冒险手枪", "集齐20个碎片可以合成武器【冒险手枪】", "small_lan_wuqi_T_1.png", nil, 5, 4, 1, 1, 2000, 20, nil, 0, 20, 101312, "7010|1,7010|2,9010|1,9010|2", nil, nil, "11", },
	id_1013224 = {1013224, "骑士长刀", "集齐20个碎片可以合成武器【骑士长刀】", "small_lan_wuqi_T_2.png", nil, 5, 4, 1, 1, 2000, 20, nil, 0, 20, 101322, "12009|1,12009|2,14009|1,14009|2,16009|1,16009|2,18009|1,18009|2", nil, nil, "11", },
	id_1014125 = {1014125, "武装长刀", "集齐30个碎片可以合成武器【武装长刀】", "small_zi_wuqi_T_1.png", nil, 5, 5, 1, 1, 2500, 30, nil, 0, 30, 101412, "12010|1,12010|2,16010|1,16010|2,24009|1,24009|2,26009|1,26009|2", nil, nil, "11", },
	id_1014225 = {1014225, "精钢长刀", "集齐40个碎片可以合成武器【武士长刀】", "small_zi_wuqi_T_2.png", nil, 5, 5, 1, 1, 2500, 40, nil, 0, 40, 101422, "20010|1,20010|2,24010|1,24010|2", nil, nil, "11", },
	id_1014325 = {1014325, "战斗火箭", "集齐40个碎片可以合成武器【战斗火箭】", "small_zi_wuqi_T_3.png", nil, 5, 5, 1, 1, 2500, 40, nil, 0, 40, 101432, nil, nil, nil, "11", },
	id_1015126 = {1015126, "霸王威慑刀", "集齐50个碎片可以合成武器【霸王威慑刀】", "small_cheng_wuqi_T_1.png", nil, 5, 6, 1, 1, 3000, 50, nil, 0, 50, 101512, "28010|1,28010|2,32010|1,32010|2", nil, nil, "11", },
	id_1015226 = {1015226, "英雄裁决剑", "集齐60个碎片可以合成武器【英雄裁决剑】", "small_cheng_wuqi_T_2.png", nil, 5, 6, 1, 1, 3000, 60, nil, 0, 60, 101522, nil, nil, nil, "11", },
	id_1015326 = {1015326, "统御能量剑", "集齐100个碎片可以合成武器【统御能量剑】", "small_cheng_wuqi_T_3.png", nil, 5, 6, 1, 1, 3000, 100, nil, 0, 100, 101532, nil, nil, nil, "11", },
	id_1023124 = {1023124, "冒险皮靴", "集齐20个碎片可以合成鞋子【冒险皮靴】", "small_lan_xiezi_T_1.png", nil, 5, 4, 1, 1, 2000, 20, nil, 0, 20, 102312, "8009|1,8009|2,10009|1,10009|2", nil, nil, "11", },
	id_1023224 = {1023224, "骑士长靴", "集齐20个碎片可以合成鞋子【骑士长靴】", "small_lan_xiezi_T_2.png", nil, 5, 4, 1, 1, 2000, 20, nil, 0, 20, 102322, "11006|1,11006|2,13006|1,13006|2,15006|1,15006|2,17006|1,17006|2", nil, nil, "11", },
	id_1024125 = {1024125, "武装皮靴", "集齐30个碎片可以合成鞋子【武装皮靴】", "small_zi_xiezi_T_1.png", nil, 5, 5, 1, 1, 2500, 30, nil, 0, 30, 102412, "11010|1,11010|2,15010|1,15010|2,25006|1,25006|2,27006|1,27006|2", nil, nil, "11", },
	id_1024225 = {1024225, "精钢长靴", "集齐40个碎片可以合成鞋子【武士长靴】", "small_zi_xiezi_T_2.png", nil, 5, 5, 1, 1, 2500, 40, nil, 0, 40, 102422, "19010|1,19010|2,23010|1,23010|2,27010|1,27010|2", nil, nil, "11", },
	id_1024325 = {1024325, "战斗皮靴", "集齐40个碎片可以合成鞋子【战斗皮靴】", "small_zi_xiezi_T_3.png", nil, 5, 5, 1, 1, 2500, 40, nil, 0, 40, 102432, nil, nil, nil, "11", },
	id_1025126 = {1025126, "霸王威慑靴", "集齐50个碎片可以合成鞋子【霸王威慑靴】", "small_cheng_xiezi_T_1.png", nil, 5, 6, 1, 1, 3000, 50, nil, 0, 50, 102512, "31010|1,31010|2,35010|1,35010|2", nil, nil, "11", },
	id_1025226 = {1025226, "英雄裁决靴", "集齐60个碎片可以合成鞋子【英雄裁决靴】", "small_cheng_xiezi_T_2.png", nil, 5, 6, 1, 1, 3000, 60, nil, 0, 60, 102522, nil, nil, nil, "11", },
	id_1025326 = {1025326, "统御能量鞋", "集齐100个碎片可以合成鞋子【统御能量鞋】", "small_cheng_xiezi_T_3.png", nil, 5, 6, 1, 1, 3000, 100, nil, 0, 100, 102532, nil, nil, nil, "11", },
	id_1033124 = {1033124, "冒险船帽", "集齐20个碎片可以合成头盔【冒险船帽】", "small_lan_toukui_T_1.png", nil, 5, 4, 1, 1, 2000, 20, nil, 0, 20, 103312, "7009|1,7009|2,9009|1,9009|2", nil, nil, "11", },
	id_1033224 = {1033224, "骑士头盔", "集齐20个碎片可以合成头盔【骑士头盔】", "small_lan_toukui_T_2.png", nil, 5, 4, 1, 1, 2000, 20, nil, 0, 20, 103322, "12006|1,12006|2,14006|1,14006|2,16006|1,16006|2,18006|1,18006|2", nil, nil, "11", },
	id_1034125 = {1034125, "武装钢盔", "集齐30个碎片可以合成头盔【武装钢盔】", "small_zi_toukui_T_1.png", nil, 5, 5, 1, 1, 2500, 30, nil, 0, 30, 103412, "13010|1,13010|2,17010|1,17010|2,24006|1,24006|2,26006|1,26006|2", nil, nil, "11", },
	id_1034225 = {1034225, "精钢风帽", "集齐40个碎片可以合成头盔【武士风帽】", "small_zi_toukui_T_2.png", nil, 5, 5, 1, 1, 2500, 40, nil, 0, 40, 103422, "21010|1,21010|2,25010|1,25010|2", nil, nil, "11", },
	id_1034325 = {1034325, "战斗钢盔", "集齐40个碎片可以合成头盔【战斗钢盔】", "small_zi_toukui_T_3.png", nil, 5, 5, 1, 1, 2500, 40, nil, 0, 40, 103432, nil, nil, nil, "11", },
	id_1035126 = {1035126, "霸王威慑盔", "集齐50个碎片可以合成头盔【霸王威慑盔】", "small_cheng_toukui_T_1.png", nil, 5, 6, 1, 1, 3000, 50, nil, 0, 50, 103512, "29010|1,29010|2,33010|1,33010|2", nil, nil, "11", },
	id_1035226 = {1035226, "英雄裁决盔", "集齐60个碎片可以合成头盔【英雄裁决盔】", "small_cheng_toukui_T_2.png", nil, 5, 6, 1, 1, 3000, 60, nil, 0, 60, 103522, nil, nil, nil, "11", },
	id_1035326 = {1035326, "统御能量冠", "集齐100个碎片可以合成头盔【统御能量冠】", "small_cheng_toukui_T_3.png", nil, 5, 6, 1, 1, 3000, 100, nil, 0, 100, 103532, nil, nil, nil, "11", },
	id_1043124 = {1043124, "冒险马甲", "集齐20个碎片可以合成上衣【冒险马甲】", "small_lan_shangyi_T_1.png", nil, 5, 4, 1, 1, 2000, 20, nil, 0, 20, 104312, "8010|1,8010|2,10010|1,10010|2", nil, nil, "11", },
	id_1043224 = {1043224, "骑士外套", "集齐20个碎片可以合成上衣【骑士外套】", "small_lan_shangyi_T_2.png", nil, 5, 4, 1, 1, 2000, 20, nil, 0, 20, 104322, "11009|1,11009|2,13009|1,13009|2,15009|1,15009|2,17009|1,17009|2", nil, nil, "11", },
	id_1044125 = {1044125, "武装外套", "集齐30个碎片可以合成上衣【武装外套】", "small_zi_shangyi_T_1.png", nil, 5, 5, 1, 1, 2500, 30, nil, 0, 30, 104412, "14010|1,14010|2,18010|1,18010|2,25009|1,25009|2,27009|1,27009|2", nil, nil, "11", },
	id_1044225 = {1044225, "精钢钢甲", "集齐40个碎片可以合成上衣【武士钢甲】", "small_zi_shangyi_T_2.png", nil, 5, 5, 1, 1, 2500, 40, nil, 0, 40, 104422, "22010|1,22010|2,26010|1,26010|2", nil, nil, "11", },
	id_1044325 = {1044325, "战斗夹克", "集齐40个碎片可以合成上衣【战斗夹克】", "small_zi_shangyi_T_3.png", nil, 5, 5, 1, 1, 2500, 40, nil, 0, 40, 104432, nil, nil, nil, "11", },
	id_1045126 = {1045126, "霸王威慑甲", "集齐50个碎片可以合成上衣【霸王威慑甲】", "small_cheng_shangyi_T_1.png", nil, 5, 6, 1, 1, 3000, 50, nil, 0, 50, 104512, "30010|1,30010|2,34010|1,34010|2", nil, nil, "11", },
	id_1045226 = {1045226, "英雄裁决甲", "集齐60个碎片可以合成上衣【英雄裁决甲】", "small_cheng_shangyi_T_2.png", nil, 5, 6, 1, 1, 3000, 60, nil, 0, 60, 104522, nil, nil, nil, "11", },
	id_1045326 = {1045326, "统御能量衣", "集齐100个碎片可以合成上衣【统御能量衣】", "small_cheng_shangyi_T_3.png", nil, 5, 6, 1, 1, 3000, 100, nil, 0, 100, 104532, nil, nil, nil, "11", },
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
	local id_data = Item_fragment["id_" .. key_id]
	assert(id_data, "Item_fragment not found " ..  key_id)
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
	for k, v in pairs(Item_fragment) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_fragment"] = nil
	package.loaded["DB_Item_fragment"] = nil
	package.loaded["db/DB_Item_fragment"] = nil
end

