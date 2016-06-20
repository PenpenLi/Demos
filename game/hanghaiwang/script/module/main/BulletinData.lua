-- Filename: BulletinData.lua
-- Author: fang
-- Date: 2013-07-03
-- Purpose: 该文件用于: 01, 通告栏

module ("BulletinData", package.seeall)

require "db/DB_Game_notice"
require "db/DB_Game_tip"
require "db/DB_Heroes"
require "script/module/public/ItemUtil"
require "script/module/partner/HeroPublicUtil"

-- require ""
local _allBulletdata = {}
local _bulletData= {}		-- 从后端传来的数据
local m_i18nString 				= gi18nString
-- 
function setMsgData( msgPara )

	_bulletData = {}

	if(tonumber(msgPara.channel)== 1) then
		table.insert(_allBulletdata, msgPara.message_text)
		--_bulletData =  msgPara.message_text
	end
end

function release( )
	_bulletData = {}
end

-- 处理bulletData中的数据，得到要显示跑马灯的内容
function getBulletNode( )
	
	local bulletInfoNode = nil 
	_bulletData= _allBulletdata[1]
	table.remove(_allBulletdata, 1)
	if(_bulletData== nil) then
		_bulletData= {}
	end

	-- template_id=16 处理 文本： 恭喜|将武将|进阶到了+|，战力得到大幅提升！
	if(tonumber(_bulletData.template_id) == 16) then
		bulletInfoNode = getHeroEvoMsg_02()

	-- template_id=17 处理 文本：恭喜|在酒馆中使用|招将时招到了|，吞食天地指日可待！
	elseif(tonumber(_bulletData.template_id) == 17) then

		bulletInfoNode = getShopRecuitMsg_02()

	-- template_id=17 处理 文本：恭喜|在酒馆中使用|招将时招到了|，吞食天地指日可待！
	elseif(tonumber(_bulletData.template_id) == 18) then
		bulletInfoNode =getTenRecuitMsg_02()

	--恭喜|在竞技场中翻牌翻到了|，小伙伴们速来围观！
	-- DB_Game_notice:19,20,21,22,24,,26 ,27
	elseif(tonumber(_bulletData.template_id) == 19) then
		--bulletInfoNode = getItemMsg_02(19)

	-- 恭喜|在比武中翻牌翻到了|，小伙伴们速来围观！
	elseif(tonumber(_bulletData.template_id) == 20) then
		--bulletInfoNode = getItemMsg_02(20)

	-- 恭喜|在夺宝中翻牌翻到了|，小伙伴们速来围观！
	elseif(tonumber(_bulletData.template_id) == 21) then
		--bulletInfoNode = getItemMsg_02(21)

	-- 恭喜|在攻打副本时获得了天降宝物|，真是太幸运了！
	elseif(tonumber(_bulletData.template_id) == 22) then
		--bulletInfoNode = getItemMsg_02(22)

	-- 恭喜|打开|获得了|，奇珍异宝尽在宝箱之中！
	elseif(tonumber(_bulletData.template_id) == 23) then
		bulletInfoNode = getBoxMsg()

	--恭喜|领取占星奖励获得了|，天下大势唯我所用！
	elseif(tonumber(_bulletData.template_id) == 24) then
		--bulletInfoNode = getItemMsg_02(24)

	--恭喜|打开首充礼包，获得了|，银币*|，瞬间变土豪！
	elseif(tonumber(_bulletData.template_id) == 25) then
		bulletInfoNode = getFirstGiftMsg()


	--	恭喜|在攻打副本时获得了|，真是太幸运了！
	elseif(tonumber(_bulletData.template_id) == 26) then
		--bulletInfoNode = getItemMsg_02(26)
	elseif(tonumber(_bulletData.template_id) == 27) then
		--bulletInfoNode = getItemMsg_02(27)
	elseif(tonumber(_bulletData.template_id)==1) then
		bulletInfoNode= getBossMsg(26)	
	elseif(tonumber(_bulletData.template_id)== 2) then
		bulletInfoNode= getBossMsg(27)
	elseif(tonumber(_bulletData.template_id)== 28) then
		if (not table.isEmpty(_bulletData.template_data.top)) then
			bulletInfoNode=getBossRankMsg()
		end
	else
		bulletInfoNode = getDefaultMsg()
	end

	release( )

	if(bulletInfoNode== nil) then
		bulletInfoNode = CCNode:create()
	end
	return bulletInfoNode

end
--把参数中的所有节点按水平方向排开，并加到一个node上
function createHorizontalwidget( node_table )
    local width = 0
    local height = 0
    for k,v in pairs(node_table) do
        width = width + v:getContentSize().width * v:getScaleX()
        if(v:getContentSize().height * v:getScaleY() > height) then
            height = v:getContentSize().height * v:getScaleY()
        end
    end

    local nodeContent = Layout:create()

    nodeContent:setSize(CCSizeMake(width, height))
    local tempWidth = 0
    for k,v in pairs(node_table) do
        v:setAnchorPoint(ccp(0, 0.5))
        v:setPosition(ccp(tempWidth, 0.5 * height))
        nodeContent:addChild(v)
        tempWidth = tempWidth + v:getContentSize().width * v:getScaleX()
    end
    return nodeContent
end
--[[
	@des 	:创建根据参数显示颜色的
	@param 	:table {
					{txt = ，color}
					}
	@retrun : node
]]
local function createTxtNode( tParam )

	local bInMainShip = TopBar.shouldShowYellow()

	local alertContent = {}
	local fColor = bInMainShip and ccc3(0x47, 0x17, 0x06) or nil -- 2015-04-15, zhangqi, 主界面跑马灯字体颜色
	for i=1,#tParam do
		--alertContent[i]= CCLabelTTF:create("" .. tParam[i].txt , g_sFontName, 18)

		alertContent[i] = Label:create()

		alertContent[i]:setFontName(g_FontCuYuan) -- zhangqi, 2015-04-22, 所有跑马灯字体用方正粗圆简体

    	alertContent[i]:setFontSize(bInMainShip and g_tbFontSize.normal or 20) -- zhangqi, 2015-04-22, 其他跑马灯字体大小 20
    	
		if(tParam[i].txt ) then
			alertContent[i]:setText("" .. tParam[i].txt or " " )
		end

		if (fColor) then
			alertContent[i]:setColor(fColor)
		elseif (tParam[i].color) then
			alertContent[i]:setColor(tParam[i].color)
		end
	end

	local nodeContent= createHorizontalwidget(alertContent)
	return nodeContent
	-- local alertContent = {}
	-- local strContent = ""
	-- local tbColor = {}
	-- for i=1,#tParam do
	-- 	strContent = strContent .. "|" .. tParam[i].txt
	-- --	alertContent[i]= CCLabelTTF:create("" .. tParam[i].txt , g_sFontName, 18)
	-- 	if(tParam[i].color ) then
	-- 		--alertContent[i]:setColor(tParam[i].color)
	-- 		table.insert(tbColor,tParam[i].color)
	-- 	else
	-- 		logger:debug("we can't find any color in DBtable")
	-- 	end
	-- end

	-- local tbRich = {strContent,tbColor}
	-- return tbRich
end

--[[
	@des 	:当后端没有推数据时，从DB_Game_tip 随机得到数据显示
	@param 	:
	@retrun : table
]]

function getDefaultMsg(  )
	local length = tonumber(table.count(DB_Game_tip.Game_tip))
	math.randomseed(os.time()) 
	local id =  math.random(1,length)
	local noticeInfo = DB_Game_tip.getDataById(tonumber(id)).game_tip
	local noticeInfo= lua_string_split(noticeInfo,"|")
	local noticeTable = {}

	local colorTable --= {255, 255, 255}
	local txt 
	for i=1,#noticeInfo,2 do
	    local templeTable = {txt="", color= nil }
	    colorTable = lua_string_split(noticeInfo[i],",")
	    templeTable.color =  ccc3(tonumber(colorTable[1]), colorTable[2],colorTable[3] )
	    templeTable.txt = noticeInfo[i+1]
	    table.insert(noticeTable, templeTable)
	end
	local nodeContent = createTxtNode(noticeTable)	
	return nodeContent

end


-- 16
 function getHeroEvoMsg(  )
	local noticeInfo = DB_Game_notice.getDataById(16).content
	noticeInfo= string.gsub(noticeInfo,"|", _bulletData.template_data[1].uname ,1)
	local htid= _bulletData.template_data[3].htid
	local heroName = DB_Heroes.getDataById(tonumber(htid)).name
	noticeInfo= string.gsub(noticeInfo,"|", heroName ,1)
	noticeInfo= string.gsub(noticeInfo,"|", _bulletData.template_data[2].evolveLv ,1)
	return noticeInfo
end

 function getHeroEvoMsg_02(  )
 	local nodeContent= nil 

	local noticeInfo = DB_Game_notice.getDataById(16).content
	noticeInfo= lua_string_split(noticeInfo,"|") --string.gsub(noticeInfo,"|", _bulletData.template_data[1].uname ,1)
	local htid= _bulletData.template_data[3].htid
	local model_id = DB_Heroes.getDataById(tonumber(htid)).model_id
	
	local heroName = DB_Heroes.getDataById(tonumber(htid)).name
	if(tonumber(model_id)== 20001 or tonumber(model_id)== 20002 ) then
		heroName = "主角"
	end
	local heroColor = HeroPublicUtil.getCCColorByStarLevel(DB_Heroes.getDataById(tonumber(htid)).star_lv)
	local noticeTable = {
					{txt=noticeInfo[1], },
					{txt= _bulletData.template_data[1].uname, },
					{txt =noticeInfo[2], },
					{txt =heroName, color = heroColor },
					{txt =noticeInfo[3], },
					{txt = "+" .. _bulletData.template_data[2].evolveLv, color = ccc3(0x00,0xFF,0x18)},
					{txt = noticeInfo[4] ,},

				}

	nodeContent = createTxtNode(noticeTable)	
	return nodeContent
end



--  DB_Game_notice 17
function getShopRecuitMsg( )
	local noticeInfo = DB_Game_notice.getDataById(17).content
	noticeInfo= string.gsub(noticeInfo,"|", _bulletData.template_data[1].uname ,1)
	noticeInfo= string.gsub(noticeInfo,"|", _bulletData.template_data[1].uname ,1)
	noticeInfo= string.gsub(noticeInfo,"|", _bulletData.template_data[2].evolveLv ,1)
	return noticeInfo
end
-- 神将、良将、战将
function getShopRecuitMsg_02()

	local nodeContent= nil 
	local noticeInfo = DB_Game_notice.getDataById(17).content
	noticeInfo= lua_string_split(noticeInfo,"|")

	local noticeTable = {
				{txt=noticeInfo[1], },
				{txt= _bulletData.template_data[1].uname, },
				{txt =noticeInfo[2], },
			}
	local tempTable = {txt=" ",color = nil }
		
	if(tonumber(_bulletData.template_data[3].mode)== 1) then
		tempTable.txt= m_i18nString(1431)
	elseif(tonumber(_bulletData.template_data[3].mode)== 2) then
		tempTable.txt= m_i18nString(1432)
	elseif(tonumber(_bulletData.template_data[3].mode)==3)	then
		tempTable.txt= m_i18nString(1433)
	end	
	table.insert(noticeTable,tempTable)	

	local tempTable2 = {txt=" ",color = nil }
	tempTable2.txt = noticeInfo[3]
	table.insert(noticeTable,tempTable2)


	local tableNum = table.count(_bulletData.template_data[2]) 
	local i=1
	for htid, num in pairs(_bulletData.template_data[2]) do
		item = {txt = " ", color = nil }
		local heroName = DB_Heroes.getDataById(tonumber(htid)).name
		local heroColor = HeroPublicUtil.getCCColorByStarLevel(DB_Heroes.getDataById(tonumber(htid)).star_lv)
		item.txt = heroName .. "*" .. num
		-- item.txt =string.gsub(item.txt,"，，", "，" ,1)
		item.color = heroColor
		table.insert(noticeTable, item)

		local commaTable = {txt = ",",}
		if(i< tableNum) then
			table.insert(noticeTable, commaTable)
		end 
		i= i+1

	end	

	local tempTable3 = {txt=" ",color = nil }
	tempTable3.txt = noticeInfo[4]
	table.insert(noticeTable,tempTable3)

	nodeContent = createTxtNode(noticeTable)	
	return nodeContent
	
end



-- DB_Game_notice 18
function getTenRecuitMsg(  )
	local noticeInfo = DB_Game_notice.getDataById(18).content
	noticeInfo= string.gsub(noticeInfo,"|", _bulletData.template_data[1].uname ,1)

	local htid= _bulletData.template_data[2].htid
	local heroName = DB_Heroes.getDataById(tonumber(htid)).name
	noticeInfo= string.gsub(noticeInfo,"|", heroName ,1)

	return noticeInfo
end

function getTenRecuitMsg_02(  )
	local nodeContent= nil 

	local noticeInfo = DB_Game_notice.getDataById(18).content
	noticeInfo= lua_string_split(noticeInfo,"|")

	-- local htid= _bulletData.template_data[2].htid
	-- local heroName = DB_Heroes.getDataById(tonumber(htid)).name
	-- local heroColor = HeroPublicUtil.getCCColorByStarLevel(DB_Heroes.getDataById(tonumber(htid)).star_lv)

	local noticeTable = {
				{txt=noticeInfo[1], },
				{txt= _bulletData.template_data[1].uname, },
				{txt =noticeInfo[2], },
				-- {txt =heroName, color = heroColor },
				-- {txt =noticeInfo[3], },
			}

	local tableNum = table.count(_bulletData.template_data[2]) 
	local i=1		
	for htid, num in pairs(_bulletData.template_data[2]) do
		item = {txt = "", color = nil }
		local heroName = DB_Heroes.getDataById(tonumber(htid)).name
		local heroColor = HeroPublicUtil.getCCColorByStarLevel(DB_Heroes.getDataById(tonumber(htid)).star_lv)
		item.txt = heroName .. "*".. num
		-- item.txt =string.gsub(item.txt,"，，", "，" ,1)
		item.color = heroColor
		table.insert(noticeTable, item)

		local commaTable = {txt = ",",}
		if(i< tableNum) then
			table.insert(noticeTable, commaTable)
		end 
		i= i+1



	end		

	local tempTable= {txt =noticeInfo[3],}
	table.insert( noticeTable, tempTable)

	nodeContent = createTxtNode(noticeTable)	
	return nodeContent

end


-- DB_Game_notice:19,20,21,22,24,,26 ,27
function getItemMsg_02(  template_id)
	
	local noticeInfo = DB_Game_notice.getDataById(template_id).content
	noticeInfo= lua_string_split(noticeInfo,"|")
	-- local item_template_id = tonumber( _bulletData.template_data[2].itemtplateId)
	-- local itemTableInfo = ItemUtil.getItemById(item_template_id)
	-- local ItemColor =  HeroPublicUtil.getCCColorByStarLevel(itemTableInfo.quality)

	local noticeTable = {
			{txt=noticeInfo[1], },
			{txt= _bulletData.template_data[1].uname, },
			{txt =noticeInfo[2], },
		}

	-- 物品
	local tableNum = table.count(_bulletData.template_data[2]) 
	local i=1
	for item_template_id , num in pairs(_bulletData.template_data[2]) do
		local item = { txt = "", color= nil }
		itemTableInfo = ItemUtil.getItemById(item_template_id)
		itemColor =  HeroPublicUtil.getCCColorByStarLevel(itemTableInfo.quality)
		item.txt = itemTableInfo.name .. "*" .. num
		-- item.txt =string.gsub(item.txt,"，，", "，" ,1)
		item.color = itemColor
		table.insert(noticeTable,item)

		local commaTable = {txt = ",",}
		if(i< tableNum) then
			table.insert(noticeTable, commaTable)
		end 
		i= i+1

	end

	local tempTable = {txt = noticeInfo[3] }
	table.insert(noticeTable,tempTable)

	nodeContent = createTxtNode(noticeTable)	
	return nodeContent
end


-- DB_Game_notice: 22, 这个和前面的可以重用
function getLuckMsg( )
	local noticeInfo = DB_Game_notice.getDataById(22).content

end


--DB_Game_notice: 23  使用宝箱： |打开|获得了|，奇珍异宝尽在宝箱

-- 物品类型根据通用的奖励表类型判断：
-- 当奖励类型为6、7、14时，根据获得奖励ID判断，如果包含有奖励ID则播放公告，不包含则不播放。
-- 当奖励类型为1.3.4.5.8.11.12.16.17.18.19.20.21时，根据奖励类型和数值判断，如果玩家获得的奖励≥所填的某类型的某个数值，则播放公告。

-- 以上两条达成任意一条均需播放公告，若两条均包含，那么将奖励内容放在同一条公告里。

-- 公告中具体奖励内容的描述形式为：物品名称*数量

function getBoxMsg(  )
	logger:debug(_bulletData)
	logger:debug(noticeInfo)
	local noticeInfo = DB_Game_notice.getDataById(23).content
	noticeInfo= lua_string_split(noticeInfo,"|")

	local noticeTable = {
		{txt=noticeInfo[1], },
		{txt= _bulletData.template_data[1].uname, },
		{txt =noticeInfo[2], },
	}

	local boxTable = {txt= "", color= nil}
	local itemTableInfo  = ItemUtil.getItemById(tonumber(_bulletData.template_data[3].box))
	boxTable.txt = itemTableInfo.name
	boxTable.color = HeroPublicUtil.getCCColorByStarLevel(itemTableInfo.quality)

	table.insert(noticeTable, boxTable)

	local tempTable = {txt= noticeInfo[3] }
	table.insert(noticeTable,tempTable)

	-- 物品
	-- local tableNum = table.count(_bulletData.template_data[2]) 
	-- local i=1


	local tbAllItemInfo = {}
	local data = {}
	for itemType ,itemInfo in pairs(_bulletData.template_data[2]) do
		logger:debug(itemInfo)
		-- for i,v in ipairs(itemInfo) do
		-- 	print(i,v)
		-- end
		if(tonumber(itemType) == 1)then
			data = {type=itemType,id=0,num = tonumber(itemInfo)}
			table.insert(tbAllItemInfo,data)
		else
			for itid,num in pairs(itemInfo) do
				logger:debug(itemInfo)
				logger:debug(num)
				for k,vv in pairs(num) do
					data = {type=itemType,id=k,num = tonumber(vv)}
					table.insert(tbAllItemInfo,data)
				end
				-- data = {type=itemType,id=itid,num = tonumber(num)}
				-- table.insert(tbAllItemInfo,data)
			end
		end
	end
	local tbRewardDataTemp = RewardUtil.getItemsDataByTb(tbAllItemInfo)

	for i , info in ipairs(tbRewardDataTemp) do

		local item = { txt = "", color= nil }
		local nQuilty = info.quality or 5
		itemColor =  g_QulityColor2[nQuilty]--(itemTableInfo.quality)
		item.txt = info.name .. "*" .. info.num 
		item.color = itemColor
		table.insert(noticeTable,item)

		local commaTable = {txt = ",",}
		table.insert(noticeTable, commaTable)

	end

	local tempTable1= {txt = noticeInfo[4], }
	table.insert(noticeTable, tempTable1)
	logger:debug(noticeTable)
	local nodeContent = createTxtNode(noticeTable)	
	return nodeContent
	
end



-- DB_Game_notice: 25
function getFirstGiftMsg()
	local noticeInfo = DB_Game_notice.getDataById(25).content
	noticeInfo = lua_string_split(noticeInfo, "|")

	local silver = _bulletData.template_data[3].silver

	local noticeTable = {
		{txt=noticeInfo[1], },
		{txt= _bulletData.template_data[1].uname, },
		{txt =noticeInfo[2], },
	}

	-- 物品
	local tableNum = table.count(_bulletData.template_data[2]) 
	local i=1
	for item_template_id , num in pairs(_bulletData.template_data[2]) do
		local item = { txt = "", color= nil }
		itemTableInfo = ItemUtil.getItemById(item_template_id)
		itemColor =  HeroPublicUtil.getCCColorByStarLevel(itemTableInfo.quality)
		item.txt = itemTableInfo.name .. "*" .. num 
		-- item.txt =string.gsub(item.txt,"，，", "，" ,1)
		item.color = itemColor
		table.insert(noticeTable,item)

		local commaTable = {txt = ",",}
		if(i< tableNum) then
			table.insert(noticeTable, commaTable)
		end 
		i= i+1
	end

	local tempTable1= {txt = noticeInfo[3], }
	table.insert(noticeTable, tempTable1)

	local tempTable2 = {txt = "" .. _bulletData.template_data[3].silver, }
	table.insert(noticeTable, tempTable2)

	local tempTable3= {txt = noticeInfo[4], }
	table.insert(noticeTable, tempTable3)

	local nodeContent = createTxtNode(noticeTable)	
	return nodeContent
	
end

-- 得到世界boss 中的广播  DB_Game_notice: 26,27
function getBossMsg( template_id )
	local noticeInfo = DB_Game_notice.getDataById(template_id).content
	noticeInfo= lua_string_split(noticeInfo,"|")

	local id = tonumber(_bulletData.template_data[1].bossId)  
	require "db/DB_Worldboss"
	local bossName= DB_Worldboss.getDataById(id).name

	local noticeTable = {
		{txt=noticeInfo[1]},
		{txt=bossName , color = ccc3(0x00,0xff,0x18) },
		{txt =noticeInfo[2], },
	}
	local nodeContent = createTxtNode(noticeTable)	
	return nodeContent
end

-- 获得世界boss中的谁击杀了XXX,  DB_Game_notice: 28
function getBossKillMsg( )
	local noticeInfo = DB_Game_notice.getDataById(28).content
	noticeInfo= lua_string_split(noticeInfo,"|")

	local playName= _bulletData.template_data.killer.uname
	local id = tonumber(_bulletData.template_data.killer.bossId) 
	require "db/DB_Worldboss"
	local bossName= DB_Worldboss.getDataById(id).name

	local noticeTable = {
		{txt=noticeInfo[1]},
		{txt=playName , color = ccc3(0x00,0xff,0x18) },
		{txt =noticeInfo[2], },
		{txt = bossName,color = ccc3(0x00,0xff,0x18) },
		{txt = noticeInfo[3] },

	}

	--local nodeContent = createTxtNode(noticeTable)	
	return noticeTable

end

function getBossRankMsg(  )
	local noticeInfo = DB_Game_notice.getDataById(29).content
	noticeInfo= lua_string_split(noticeInfo,"|")

	local template_data= _bulletData.template_data.top

	local noticeTable= {
		-- {txt=noticeInfo[1]},
	}


	local function keySort(data_1, data_2 )
		return tonumber(data_1.rank)<tonumber(data_2.rank)
	end

	table.sort(template_data, keySort)
	print("template_data  is : ")
	print_t(template_data)

	if (not table.isEmpty(_bulletData.template_data.killer)) then
		noticeTable = getBossKillMsg()
	end

	for i=1, #template_data do
		local firstContent = {txt=noticeInfo[2*i-1], }
		table.insert(noticeTable, firstContent)

		local nameContent = { txt = "", color= ccc3(0x00,0xff,0x18) }
		nameContent.txt= template_data[i].uname
		table.insert(noticeTable,nameContent)

		local commaTable= { txt =noticeInfo[2*i] , color= ccc3(0x00,0xff,0x18) }
		table.insert(noticeTable, commaTable)

		local hurtContent = { txt = template_data[i].percent , color= ccc3(0x00,0xff,0x18)}
		table.insert(noticeTable, hurtContent)

	end
	local lastContent= {txt=  noticeInfo[7], }
	table.insert(noticeTable, lastContent )

	local nodeContent = createTxtNode(noticeTable)	
	return nodeContent

end



