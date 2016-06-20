-- Filename: DB_Copy_team.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Copy_team", package.seeall)

keys = {
	"id", "name", "des", "level", "winDes", "rewardDes", "model", "img", "copyType", "background", "teamLimit", "maxWin", "min", "max", "levelLimit", "armyNum", "strongHold", "exp", "silver", "soul", "items", "stamina", "needPassCopy", "needPassTeamCopy", "postfTeamCopy", "thumbnail", 
}

Copy_team = {
	id_400001 = {400001, "测试副本1", "我是描述1", 20, "击败全部部队", nil, nil, "1.png", 1, nil, "1,2,3", 9, 1, 3, 20, 3, "200005", 10, 1000, 100, "101204|一般概率,102204|一般概率,103204|一般概率,102301|一般概率,1023014|一般概率,40031|一般概率,40032|一般概率,40033|一般概率,40034|一般概率,40035|一般概率,410064|较高概率,410052|较高概率", 5, 2, nil, 400002, "copy1.jpg", },
	id_400002 = {400002, "测试副本2", "我是描述2", 30, "击败全部部队", nil, nil, "2.png", 1, nil, "1,2,3", 9, 1, 3, 30, 3, "200006", 10, 2000, 200, "101205|一般概率,102205|一般概率,103205|一般概率,103301|一般概率,1033014|一般概率,40031|一般概率,40032|一般概率,40033|一般概率,40034|一般概率,40035|一般概率,410084|较高概率,410058|较高概率", 5, 3, 400001, 400003, "copy2.jpg", },
	id_400003 = {400003, "测试副本3", "我是描述3", 40, "击败全部部队", nil, nil, "3.png", 1, nil, "1,2,3", 9, 1, 3, 40, 3, "200007", 10, 3000, 300, "102301|一般概率,103301|一般概率,1023014|一般概率,1033014|一般概率,40031|一般概率,40032|一般概率,40033|一般概率,40034|一般概率,40035|一般概率,410077|较高概率,410035|较高概率", 5, 4, 400002, 400004, "copy3.jpg", },
	id_400004 = {400004, "测试副本4", "我是描述4", 50, "击败全部部队", nil, nil, "4.png", 1, nil, "1,2,3", 9, 1, 3, 50, 3, "200008", 10, 4000, 400, "101301|一般概率,102301|一般概率,103301|一般概率,1013014|一般概率,1023014|一般概率,1033014|一般概率,40031|一般概率,40032|一般概率,40033|一般概率,40034|一般概率,40035|一般概率,410059|较高概率,410041|较高概率", 5, 5, 400003, 400005, "copy2.jpg", },
	id_400005 = {400005, "测试副本5", "我是描述5", 60, "击败全部部队", nil, nil, "5.png", 1, nil, "1,2,3", 9, 1, 3, 60, 3, "200009", 10, 5000, 500, "102302|一般概率,103302|一般概率,1023024|一般概率,1033024|一般概率,40031|一般概率,40032|一般概率,40033|一般概率,40034|一般概率,40035|一般概率,410098|较高概率,410030|较高概率", 5, 6, 400004, nil, "copy5.jpg", },
	id_400101 = {400101, "我是描述1", "我是描述1", nil, "击败全部部队", nil, nil, "1.png", 1, "zuduifuben.jpg", "3", 5, 2, 3, 1, 9, "150001", 10, 1000, 0, "101204|一般概率,102204|一般概率,103204|一般概率,102301|一般概率,1023014|一般概率,40031|一般概率,40032|一般概率,40033|一般概率,40034|一般概率,40035|一般概率,410064|较高概率,410052|较高概率", 5, 7, nil, nil, "copy5.jpg", },
	id_400102 = {400102, "下邳军团", "我是描述1", nil, "击败全部部队", nil, nil, "1.png", 1, "zuduifuben.jpg", "3", 4, 2, 2, 20, 5, "150002", 10, 5000, 0, nil, 0, 10, nil, 400103, "copy5.jpg", },
	id_400103 = {400103, "寿春军团", "我是描述2", nil, "击败全部部队", nil, nil, "2.png", 1, "zuduifuben.jpg", "3", 4, 2, 2, 25, 6, "150003", 10, 7500, 0, nil, 0, 12, 400102, 400104, "copy6.jpg", },
	id_400104 = {400104, "魔阵军团", "我是描述3", nil, "击败全部部队", nil, nil, "3.png", 1, "zuduifuben.jpg", "3", 4, 2, 2, 30, 6, "150004", 10, 10000, 0, nil, 0, 14, 400103, 400105, "copy7.jpg", },
	id_400105 = {400105, "白马军团", "我是描述4", nil, "击败全部部队", nil, nil, "4.png", 1, "zuduifuben.jpg", "3", 4, 2, 2, 35, 6, "150005", 10, 12500, 0, nil, 0, 16, 400104, 400106, "copy8.jpg", },
	id_400106 = {400106, "千里军团", "我是描述5", nil, "击败全部部队", nil, nil, "5.png", 1, "zuduifuben.jpg", "3", 4, 3, 3, 40, 10, "150006", 10, 15000, 0, nil, 0, 18, 400105, 400107, "copy9.jpg", },
	id_400107 = {400107, "官渡军团", "我是描述6", nil, "击败全部部队", nil, nil, "6.png", 1, "zuduifuben.jpg", "3", 4, 3, 3, 42, 10, "150007", 10, 17500, 0, nil, 0, 20, 400106, 400108, "copy10.jpg", },
	id_400108 = {400108, "荆州军团一", "我是描述7", nil, "击败全部部队", nil, nil, "7.png", 1, "zuduifuben.jpg", "3", 4, 3, 3, 44, 10, "150008", 10, 20000, 0, nil, 0, 21, 400107, 400109, "copy11.jpg", },
	id_400109 = {400109, "荆州军团二", "我是描述8", nil, "击败全部部队", nil, nil, "8.png", 1, "zuduifuben.jpg", "3", 4, 4, 4, 46, 14, "150009", 10, 22500, 0, nil, 0, 23, 400108, 400110, "copy11.jpg", },
	id_400110 = {400110, "江东军团一", "我是描述9", nil, "击败全部部队", nil, nil, "9.png", 1, "zuduifuben.jpg", "3", 4, 3, 3, 48, 10, "150010", 10, 25000, 0, nil, 0, 24, 400109, 400111, "copy12.jpg", },
	id_400111 = {400111, "江东军团二", "我是描述10", nil, "击败全部部队", nil, nil, "10.png", 1, "zuduifuben.jpg", "3", 4, 4, 4, 50, 14, "150011", 10, 27500, 0, nil, 0, 26, 400110, nil, "copy12.jpg", },
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
	local id_data = Copy_team["id_" .. key_id]
	assert(id_data, "Copy_team not found " ..  key_id)
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
	for k, v in pairs(Copy_team) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Copy_team"] = nil
	package.loaded["DB_Copy_team"] = nil
	package.loaded["db/DB_Copy_team"] = nil
end

