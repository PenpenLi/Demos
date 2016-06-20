-- FileName: BuyBoxData.lua
-- Author: zhangjunwu
-- Date: 2014-08-22
-- Purpose: 精彩活动，购买宝箱数据缓冲
--[[TODO List]]

module("BuyBoxData", package.seeall)
require "db/DB_Goods"
require "db/DB_Vip"
require "db/DB_Rand_box"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_tbBoxInfo = {}

T_GOLD_BOX = 30013
T_SILVER_BOX = 30012
T_BRONZE_BOX = 30011

BoxKeyType = {GoldKey = 1,SilverKey = 2,BronzeKey = 3 }

OpenBoxType = {
	OpenGoldOnce = 1, --开启一次黄金宝箱
	OpenGoldTen = 2, --开启10次黄金宝箱
	OpenSilverOnce = 3, --开启一次白银白象
	OpenSilverTen = 4, --开启十次白银宝箱
	OpenBronzeOnce = 5,  --开启一次青铜宝箱
	OpenBronzeTen = 6  --开启十次青铜宝箱
	}
	
--钥匙在goods表中的的tid
tbBoxKeyTid = {7,9,13,}

function getItemIdByTid( Tid )
	local itemInfo  = DB_Goods.getDataById(Tid)
	return itemInfo.item_id
end


--判断使用的道具是不是箱子或者钥匙
function fnItemIsBoxOrKeyByTid( item_template_id )
	item_tid = tonumber(item_template_id)
	return item_tid == T_GOLD_BOX or item_tid == T_SILVER_BOX or item_tid ==  T_BRONZE_BOX
end

--设置宝箱的xinxi
function setBoxInfo( tbInfo )
	m_tbBoxInfo = nil 
	m_tbBoxInfo = {}
	m_tbBoxInfo = tbInfo
	logger:debug(tbInfo)
	logger:debug(m_tbBoxInfo)
end

function updateBoxInfo(n_key_tid,OpenNum,BuyNum)
	
	logger:debug("OpenNum" .. OpenNum)
	logger:debug("BuyNum" .. BuyNum)
	logger:debug(m_tbBoxInfo)
	logger:debug(m_tbBoxInfo[tostring(n_key_tid)])
	logger:debug(m_tbBoxInfo[1])

	local keyStr = tostring(n_key_tid)
	if(m_tbBoxInfo[keyStr]) then
		m_tbBoxInfo[keyStr] = m_tbBoxInfo[keyStr] + BuyNum
	else
		m_tbBoxInfo[keyStr] =  BuyNum
	end

	local goldBoxTotle = tonumber(m_tbBoxInfo["0"]) or 0
	logger:debug(goldBoxTotle)
	logger:debug(n_key_tid)
	local keyTotole = tostring(0)
	logger:debug(m_tbBoxInfo[keyTotole] )
	if(n_key_tid == T_GOLD_BOX)then
		m_tbBoxInfo[keyTotole] = goldBoxTotle + OpenNum
	end
	logger:debug(m_tbBoxInfo)
end

--已经开启的金宝箱的总个数
function getOpenedBoxNum( )
	local keyTotole = tostring(0)
	logger:debug(m_tbBoxInfo[keyTotole] )
	logger:debug(m_tbBoxInfo)
	return  tonumber(m_tbBoxInfo["0"])
end
--根据tid 获取钥匙的已经购买个数
function getKeyBoughtNumByTid(key_tid)

	logger:debug(m_tbBoxInfo)
	for k,v in pairs(m_tbBoxInfo) do
		if(tonumber(k) == key_tid) then
			return tonumber(v)
		end
	end
	return 0
end

--根据tid 获取钥匙的图片
function getKeyImgByTid(key_tid)

	if(key_tid ==T_GOLD_BOX) then
		return "images/others/buy_gold_key_icon.png" 
	elseif(key_tid == T_SILVER_BOX) then
		return "images/others/buy_silver_key_icon.png" 
	elseif(key_tid == T_BRONZE_BOX) then
		return "images/others/buy_copper_key_icon.png" 
	end
end

--根据tid 获取背包中钥匙的个数
function getKeyNumByTid( key_tid )
	-- logger:debug({getKeyNumByTid_key_tid = key_tid})

	local allBagInfo = DataCache.getBagInfo()
	local item_num = 0

	if (allBagInfo) then
		for k,item_info in pairs( allBagInfo.props or {}) do
			if (tonumber(item_info.item_template_id) == key_tid) then
				item_num = item_num + tonumber(item_info.item_num)
			end
		end
	end
	return item_num
end

--获取所有钥匙的总个数
function getAllKeyNum()
	if(not SwitchModel.getSwitchOpenState(ksSwitchBuyTreasBox,false)) then

		return 0
	end


	local ngoldKey = 0
	local isOpen,openLV,openVipLv = BuyBoxData.canOpenGoldBox()
    if( isOpen == true) then
		 ngoldKey = getKeyNumByTid(T_GOLD_BOX)
	end

	local nSilverKey = getKeyNumByTid(T_SILVER_BOX)
	return ngoldKey + nSilverKey
end

-- vip购买某个物品增加的次数
function getKeyAddBuyTimeBy( vip_level, i_tid )
	i_tid = tonumber(i_tid)
	require "db/DB_Vip"
	local vipArr = DB_Vip.getArrDataByField("level",vip_level)
	--logger:debug(vipArr)
	local vipInfo = vipArr[1]

	local addTimes = 0

	local item_str = vipInfo.key_buytimes
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



-- 某次购买某商品多个
function getNeedGoldByMoreGoods( key_tid, s_times, d_length )
	d_length = tonumber(d_length)
	local totalPrice = 0
	logger:debug(s_times)
	logger:debug(d_length)
	for i=1,d_length do

		totalPrice = totalPrice + getPriceByTimes(key_tid, s_times+i-1)
		
	end
	return totalPrice
end



--[[desc:计算第n次购买某物品的价格 zhangjunwu
    arg1: goodsData：DB_Rand_box某一行的物品 buyTimes 第几次购买
    return: 价格  
—]]
function getPriceByTimes(key_tid,buyTimes)
	local tbBoxDBInfo = DB_Rand_box.getArrDataByField("need_item",key_tid)
	logger:debug(tbBoxDBInfo)
	logger:debug(buyTimes)
	local strItemPrice = tbBoxDBInfo[1].need_gold
	local c_price = 0
	if strItemPrice then
		local per_arr = string.split(strItemPrice, ",")
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
	logger:debug(c_price)
	return tonumber(c_price)
end


-- 计算购买keynum个钥匙所需要的花费
function getPriceByNum( keyNum, key_tid )
	local tbBoxDBInfo = DB_Rand_box.getArrDataByField("need_item",key_tid)
	logger:debug(tbBoxDBInfo)
	local itemPrice = tbBoxDBInfo[1].need_gold
	logger:debug(itemPrice)
	return  itemPrice * keyNum
end

--判断用户的vip等级是否达到最大
function fnIsGetVipTop()
	return UserModel.getVipLevel() >= table.count(DB_Vip.Vip)-1
end

function create(...)

end
--根据tid获取 宝箱的id和gid
function getKeyDBId( itemTid )
	local tbBoxDBInfo = DB_Rand_box.getArrDataByField("need_item",itemTid)
	logger:debug(tbBoxDBInfo)
	local DB_ID = tbBoxDBInfo[1].id
	return  DB_ID
end


--根据 tid获取 宝箱或者钥匙的名字
function getItemNameBy( item_id )
	if(item_id) then 
		local itemInfo = ItemUtil.getItemById(item_id)
		return itemInfo.name
	else
		return " "
	end

end

local function init(...)

end

function destroy(...)
	package.loaded["BuyBoxData"] = nil
end

function moduleName()
	return "BuyBoxData"
end

function canOpenGoldBox( )
	require "db/DB_Normal_config"
	local configInfo  = DB_Normal_config.getDataById(1)
	local gold_box_switch = configInfo.gold_box_switch
	local openLv = tonumber(string.split(gold_box_switch , "|")[2])
	local openVipLv = tonumber(string.split(gold_box_switch , "|")[1])
	-- logger:debug("开启黄金宝箱需要的玩家等级为:" .. openLv)
	-- logger:debug("开启黄金宝箱需要的vip等级为:" ..openVipLv)
	local UserLv = tonumber(UserModel.getHeroLevel())
	local UserVipLv = tonumber(UserModel.getVipLevel())
	-- logger:debug("玩家等级为:" .. UserLv)
	-- logger:debug("玩家的vip等级为:" ..UserVipLv)
	return UserLv >= openLv  or UserVipLv >= openVipLv,openLv,openVipLv
end
