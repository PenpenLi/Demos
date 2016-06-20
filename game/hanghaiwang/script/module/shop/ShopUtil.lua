-- Filename：	ShopUtil.lua
-- Author：		Cheng Liang
-- Date：		2013-8-23
-- Purpose：		Util

module ("ShopUtil", package.seeall)

require "script/model/DataCache"

-- 获取本地的数据
function getAllShopInfo()

	require "db/DB_Goods"

	local tData = {}
	for k, v in pairs(DB_Goods.Goods) do
		table.insert(tData, v)
	end
	local allGoods = {}
	for k,v in pairs(tData) do
		table.insert(allGoods, DB_Goods.getDataById(v[1]))
	end
	tData = nil


	local function keySort ( goods_1, goods_2 )
		return tonumber(goods_1.type) < tonumber(goods_2.type)
	end
	table.sort( allGoods, keySort )

	return allGoods
end

-- 获取某个物品的当前购买次数
function getBuyNumBy( goods_id )
	goods_id = tonumber(goods_id)
	local cacheInfo = DataCache.getShopCache()
	local number = 0
	-- logger:debug(goods_id)
	-- logger:debug(cacheInfo)
	-- logger:debug(goods_id)
	if(not table.isEmpty(cacheInfo.goods)) then
		for k_id, v in pairs(cacheInfo.goods) do
			if(tonumber(k_id) == goods_id) then
				number = tonumber(v.num)
				break
			end
		end
	end
	return number
end

-- vip购买某个物品增加的次数
function getAddBuyTimeBy( vip_level, i_tid )
	i_tid = tonumber(i_tid)
	logger:debug("i_tid" .. i_tid .. "vip_level" .. vip_level )
	require "db/DB_Vip"
	local vipArr = DB_Vip.getArrDataByField("level",vip_level)
	--logger:debug(vipArr)
	local vipInfo = vipArr[1]
	-- logger:debug(vipInfo)

	local addTimes = 0

	local item_str = vipInfo.day_buy_goods
	logger:debug(item_str)
	item_str = string.gsub(item_str, " ", "")

	local item_arr = string.split(item_str, ",")

	for k,item_u in pairs(item_arr) do
		local item_info = string.split(item_u, "|")

		if(tonumber(item_info[1]) == i_tid) then
			addTimes = tonumber(item_info[2])
			break
		end
	end

	logger:debug("vip_level = " .. vip_level .. "i_tid==" .. i_tid  .. "  number==" .. addTimes)
	return addTimes
end


--[[desc:计算第n次购买某物品的价格 liweidong
    arg1: goodsData：DB_Goods某一行的物品 buyTimes 第几次购买
    return: 价格  
—]]
function getPriceByTimes(goodsData,buyTimes)
	local c_price = 0
	if goodsData.cost_gold_add_siliver then
		local per_arr = string.split(goodsData.cost_gold_add_siliver, ",")
		local tmp1 = string.split(per_arr[1],"|")
		local prekey,preval = tonumber(tmp1[1]),tonumber(tmp1[2])
		for _,val in pairs(per_arr) do
			local tmp = string.split(val,"|")
			if (tonumber(buyTimes)<tonumber(tmp[1]) and tonumber(buyTimes)>=prekey) then
				c_price = preval
				break
			end
			prekey,preval = tonumber(tmp[1]),tonumber(tmp[2])
			c_price = preval --大于等于最大次数情况 和 只填写第一次的情况
		end
	end
	-- logger:debug("price : info")
	-- logger:debug(buyTimes)
	-- logger:debug(c_price)
	-- logger:debug(goodsData.current_price)

	return tonumber(c_price)+goodsData.current_price
end
-- 某次购买贝里的价格
function getSiliverPriceBy( buyTimes )
	require "db/DB_Goods"
	local goodsData = DB_Goods.getDataById(11)
	return getPriceByTimes(goodsData,buyTimes)
end

-- 从某次开始购买多少个
function getBuySiliverTotalPriceBy( s_times, d_length )
	local totalPrice = 0
	for i=1,d_length do
		totalPrice = totalPrice + getSiliverPriceBy(s_times+i-1)
	end

	return totalPrice
end
--购买贝利系数
function getBuySiliverProperty()
	local goodsData = DB_Goods.getDataById(11)
	local per_arr = string.split(goodsData.factor, ",")
	return per_arr[1],per_arr[2],per_arr[3]
end
-- 某次购买将魂的价格
function getSoulPriceBy( buyTimes )
	require "db/DB_Goods"
	local goodsData = DB_Goods.getDataById(10)

	-- local per_arr = string.split( string.gsub(goodsData.cost_gold_add_siliver, " ", ""), "|")
	-- local c_price = (buyTimes -1) * tonumber(per_arr[1]) + goodsData.current_price
	-- if(c_price  > tonumber(per_arr[2])) then
	-- 	c_price = tonumber(per_arr[2])
	-- end

	-- return c_price
	return getPriceByTimes(goodsData,buyTimes)
end

-- 从某次开始购买多少个
function getBuySoulTotalPriceBy( s_times, d_length )
	local totalPrice = 0
	for i=1,d_length do
		totalPrice = totalPrice + getSoulPriceBy(s_times+i-1)
	end

	return totalPrice
end

-- 某次购买某物品所需金币
function getNeedGoldByGoodsAndTimes(goods_id, buy_times)
	require "db/DB_Goods"
	logger:debug(goods_id)
	local goodsData = DB_Goods.getDataById(goods_id)

	-- local c_price = goodsData.current_price

	-- if(goodsData.cost_gold_add_siliver)then
	-- 	local per_arr = string.split( string.gsub(goodsData.cost_gold_add_siliver, " ", ""), "|")
	-- 	c_price = (buy_times -1) * tonumber(per_arr[1]) + goodsData.current_price
	-- 	if(c_price  > tonumber(per_arr[2])) then
	-- 		c_price = tonumber(per_arr[2])
	-- 	end
	-- end

	-- return c_price
	return getPriceByTimes(goodsData,buy_times)
end

-- 某次购买某商品多个
function getNeedGoldByMoreGoods( goods_id, s_times, d_length )
	d_length = tonumber(d_length)
	local totalPrice = 0
	for i=1,d_length do
		

		totalPrice = totalPrice + getNeedGoldByGoodsAndTimes(goods_id, s_times+i-1)
		
	end
	return totalPrice
end



