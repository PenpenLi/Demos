

local visibleOrigin = Director.sharedDirector():getVisibleOrigin()
local visibleSize = Director.sharedDirector():getVisibleSize()
local pageSize = 20

ConsumeHistoryPanel = class(BasePanel)

function ConsumeHistoryPanel.isShowCustomerPhone( ... )
	if MaintenanceManager:getInstance():isEnabled("CustomerServicePhone") then
		return true
	end
	-- local province = Cookie.getInstance():read(CookieKey.kLocationProvince)
	-- if table.includes({"河北","山东","辽宁","湖北"},province) then
	-- 	return true
	-- end
	return false 
end

function ConsumeHistoryPanel:create( ... )
	local panel = ConsumeHistoryPanel.new()
	panel:loadRequiredResource("ui/consume_history.json")
	panel:init()
	return panel
end

function ConsumeHistoryPanel:ctor( ... )
	self.isLoading = false
	self.isLoadComplete = false --服务端数据是否加载完 
	self.hasError = false
	self.isFirstLoad = true

	self.dataList = {} --tableView 显示的数据
	self.logList = {} -- 服务端给的数据
end

function ConsumeHistoryPanel:dispose( ... )
	self.itemLoading:dispose()

	BasePanel.dispose(self)
end

function ConsumeHistoryPanel:init( ... )

	self.ui = self:buildInterfaceGroup("consumeHistory/panel")
	BasePanel.init(self, self.ui)

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true,0,true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap, function() self:onKeyBackClicked() end)

	local title = self.ui:getChildByName("title")
	-- local desc = self.ui:getChildByName("desc")
	local desc2 = self.ui:getChildByName("desc2")
	local tableViewTitleBg = self.ui:getChildByName("tableViewTitleBg")

	-- "我的消费记录"
	title:setText(Localization:getInstance():getText("consume.history.panel.title"))
	local titleSize = title:getContentSize()
	local titleScale = 65 / titleSize.height
	title:setScale(titleScale)
	local size = self.ui:getGroupBounds().size
	title:setPositionX((size.width - titleSize.width) / 2)

	self.clearBtn = self:createTouchButton("btnClearLogs", function(...) self:clearLogs() end)
	--self.clearBtn:setPositionY(-visibleSize.height + 75)
	self:setClearState(false)
	-- "仅显示最近两个月消费记录"
	-- desc:setString(Localization:getInstance():getText("consume.history.panel.desc"))	
	
	if self.isShowCustomerPhone() then 
		desc2:setString(Localization:getInstance():getText("consume.history.panel.desc1",{n="\n"}))	
		local height = desc2:getDimensions().height
		desc2:setDimensions(CCSizeMake(desc2:getDimensions().width,0))
		tableViewTitleBg:setPositionY(tableViewTitleBg:getPositionY() - desc2:getContentSize().height + height)
	else
		tableViewTitleBg:setPositionY(tableViewTitleBg:getPositionY() + desc2:getDimensions().height)
	end	

	local tableViewTitleBgBounds = tableViewTitleBg:boundingBox()

	-- "购买项目","交易时间","价格"
	for i=1,2 do
		local colTitle = self.ui:getChildByName("column" .. i)
		colTitle:setString(Localization:getInstance():getText("consume.history.panel.header." .. i))
		colTitle:setDimensions(CCSizeMake(colTitle:getDimensions().width,0))
		colTitle:setAnchorPoint(ccp(0,0.5))
		colTitle:setPositionY(tableViewTitleBgBounds:getMidY())
	end

	local bg = self.ui:getChildByName("bg")
	bg:setScaleY(visibleSize.height/bg:getContentSize().height + 0.1)

	self.itemLoading = self:buildItemLoading()

	self.tableView = self:buildTableView(
		visibleSize.width,
		visibleSize.height - math.abs(tableViewTitleBgBounds:getMinY() - 150)
	)
	self.tableView:ignoreAnchorPointForPosition(false)
	self.tableView:setAnchorPoint(ccp(0,1))
	self.tableView:setPositionX(0)
	self.tableView:setPositionY(tableViewTitleBgBounds:getMinY())
	self.ui:addChild(CocosObject.new(self.tableView))

	print("tableView height: ", self.tableView:getViewSize().height)
	print("tableView posY: ", tableViewTitleBgBounds:getMinY())

	local bottomHeight = visibleSize.height - math.abs(tableViewTitleBgBounds:getMinY() - self.tableView:getViewSize().height)
	print("bottom height: ", bottomHeight)
	self.clearBtn:setPositionY(bottomHeight/2 - visibleSize.height)
end

function ConsumeHistoryPanel:setClearState(isEnabled)
	self.clearBtn:setVisible(isEnabled)
	self.clearBtn:setTouchEnabled(isEnabled)
end

function ConsumeHistoryPanel:clearLogs()

	local function onSuccess(evt)
		if self.isDisposed then
			return
		end

		self.dataList = {}
		self.logList = {}
		self.tableView:reloadData()
	end

	local function onFailed(evt)
		if not self.isDisposed then
			CommonTip:showTip("请稍后再尝试~", "negative")
			self:setClearState(true)
			return
		end
	end

	self:setClearState(false)
	local http = DeleteCashLogsHttp.new(true)
	http.timeout = 0.5
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFailed)
	http:syncLoad()
end

function ConsumeHistoryPanel:buildItemLoading( ... )

	local cellItem = self:buildInterfaceGroup("consumeHistory/itemLoading")
	local icon = cellItem:getChildByName("icon")
	local iconBounds = icon:boundingBox()

	icon:setAnchorPoint(ccp(0.5,0.5))
	icon:setPositionX(iconBounds:getMidX())
	icon:setPositionY(iconBounds:getMidY())

	local text = cellItem:getChildByName("text")
	text:setDimensions(CCSizeMake(text:getDimensions().width,0))
	text:setAnchorPoint(ccp(0,0.5))
	text:setPositionY(iconBounds:getMidY())
	text:setDimensions(CCSizeMake(0,0))

	local bounds = cellItem:getGroupBounds()
	cellItem:setPositionX(self:cellSize(#self.dataList).width/2 - bounds.size.width/2)
	cellItem:setPositionY(self:cellSize(#self.dataList).height/2 + bounds.size.height/2)

	return cellItem
end

function ConsumeHistoryPanel:buildTableView(width,height)

	function tableViewDelegate(eventType,tableView,a1,a2)
		if eventType == "cellSize" then
			local idx = a1
			return self:cellSize(idx)
		elseif eventType == "cellAtIndex" then
			local idx = a1
			return self:cellAtIndex(idx)
		elseif eventType == "numberOfCells" then 
			return self:numberOfCells()
		elseif eventType == "scroll" then 

			self:onScrolled(tableView)
		end
	end

	local luaTableView = LuaTableView:createWithHandler(
		LuaEventHandler:create(tableViewDelegate), 
		CCSizeMake(width,height)
	)
	luaTableView:setVerticalFillOrder(kCCTableViewFillTopDown)

	return luaTableView
end

function ConsumeHistoryPanel:numberOfCells()
	if self.isLoading or self.isLoadComplete then
		return #self.dataList + 1
	else
		return #self.dataList
	end
end

function ConsumeHistoryPanel:cellSize(idx)
	if idx >= #self.dataList then 
		return CCSizeMake(visibleSize.width,100)
	elseif self.dataList[idx + 1].isTitle then 
		return CCSizeMake(visibleSize.width,52)
	else
		return CCSizeMake(visibleSize.width,80)
	end
end

function ConsumeHistoryPanel:getBuyItemText( data )

	-- 1短代,2应用包
	if data.type == 1 or data.type == 2 then 
		--wp8 只能购买风车币
		if __WP8 then
			return Localization:getInstance():getText("consume.history.panel.gold.text",{n = data.price})
		end
		
		if data.goodsId then 
			local goodsName = Localization:getInstance():getText("goods.name.text"..tostring(data.goodsId))
			return goodsName
		else
			-- test
			-- return tostring(data.type)
		end
	-- 3APPLE
	elseif data.type == 3 then 
		-- {n}风车币
		return Localization:getInstance():getText("consume.history.panel.gold.text",{n = data.price})
	else 
		return ""
	end

end

function ConsumeHistoryPanel:getMoneyText( data )

	if data.type == 1 or data.type == 2 then 
		local price = data.price
		if price <= 0 then 
			local goodPayCode = MetaManager.getInstance():getGoodPayCodeMeta(data.goodsId)
			price = (goodPayCode or {price=""}).price
		end
		if data.type == 1 then 
			return Localization:getInstance():getText("consume.history.panel.normal.price",{n=price})
			-- return "￥" .. price
		else
			return Localization:getInstance():getText("consume.history.panel.qq.price",{n=price})
			-- return price .. "Q点"
		end
	elseif data.type == 3 then
		for k,v in pairs(MetaManager.getInstance().product) do
			if v.cash == data.price then 
				return Localization:getInstance():getText("consume.history.panel.normal.price",{n=v.price})
				-- return "￥" .. v.price
			end
		end

		return ""
	else 
		return ""
	end 

end



function ConsumeHistoryPanel:cellAtIndex(idx)
	local cell = CCTableViewCell:create()

	if idx == #self.dataList then 
		self.itemLoading.refCocosObj:removeFromParentAndCleanup(false)
		cell:addChild(self.itemLoading.refCocosObj)

		local icon = self.itemLoading:getChildByName("icon")
		icon:stopAllActions()
		if self.isLoadComplete then	
			icon:setVisible(false)

			--print("!!!!!!!!!!!!!!!show loading text!!!!!!!!!!!!!!!!!", self.isFirstLoad)
			if self.isFirstLoad then
				local text = #self.dataList>0 and "" or Localization:getInstance():getText("consume.history.panel.loading.text.1")
				self.itemLoading:getChildByName("text"):setString(text)
			elseif #self.dataList>0 then
				setTimeOut(function() 
						if not self.isDisposed then
							self.itemLoading:getChildByName("text"):setString("")
						end
					end, 5)
			end
			-- self.itemLoading:getChildByName("text"):setString("已经没有更早的消费记录了")
		else
			self.itemLoading:getChildByName("text"):setString(
				Localization:getInstance():getText("consume.history.panel.loading.text.2")
			)			
			-- self.itemLoading:getChildByName("text"):setString("正在加载更早的消费记录...")
			icon:setVisible(true)
			icon:runAction(CCRepeatForever:create(CCRotateBy:create(1.0,360)))
		end
		local bounds = self.itemLoading:getGroupBounds()
		self.itemLoading:setPositionX(self:cellSize(#self.dataList).width/2 - bounds.size.width/2)
		if not icon:isVisible() then
			self.itemLoading:setPositionX(self.itemLoading:getPositionX() - icon:getGroupBounds().size.width/2)
		end

	-- elseif self.dataList[idx + 1].isTitle then 
	-- 	local cellItem = self:buildInterfaceGroup("consumeHistory/itemSubTitle")
	-- 	local title = cellItem:getChildByName("title")

	-- 	title:setDimensions(CCSizeMake(0,0))
	-- 	title:setAnchorPoint(ccp(0,0.5))
	-- 	title:setPositionY(cellItem:getChildByName("bg"):boundingBox():getMidY())
	-- 	title:setString(self.dataList[idx + 1].text .. "年")

	-- 	cellItem:setPositionY(self:cellSize(idx).height)

	-- 	cell:addChild(cellItem.refCocosObj)
	-- 	cellItem:dispose()
	else
		local cellItem = self:buildInterfaceGroup("consumeHistory/item")

		local data = self.dataList[idx + 1]

		if data.num > 1 then 
			cellItem:getChildByName("column1"):setString(self:getBuyItemText(data) .. " x" .. data.num)
		else
			cellItem:getChildByName("column1"):setString(self:getBuyItemText(data))
		end

		cellItem:getChildByName("column2"):setString(os.date(
			Localization:getInstance():getText("consume.history.panel.date.text"),
			data.time/1000
		))
		-- cellItem:getChildByName("column2"):setString(os.date("%m月%d日 %H:%M:%S",data.time/1000))
		-- cellItem:getChildByName("column3"):setString(self:getMoneyText(data))

		cellItem:setPositionY(self:cellSize(idx).height - 18)

		cell:addChild(cellItem.refCocosObj)
		cellItem:dispose()
	end

	return cell
end

function ConsumeHistoryPanel:onScrolled( tableView )
	if self.isLoading or self.isLoadComplete or self.hasError then 
		return 
	end

	local offset = tableView:getContentOffset()
	-- print(offset.y)
	if offset.y < 0 then 
		return
	end
	
	local contentSize1 = tableView:getContentSize()

	self.isLoading = true
	tableView:reloadData()
	tableView:setContentOffset(ccp(
		offset.x,
		offset.y - self:cellSize(#self.dataList).height
	))

	local function reloadData( ... )
		
		local offset2 = tableView:getContentOffset()
		tableView:reloadData()
		local contentSize2 = tableView:getContentSize()

		tableView:setContentOffset(ccp(
			offset2.x,
			offset2.y - contentSize2.height + contentSize1.height + self:cellSize(#self.dataList).height
		))

		self.isFirstLoad = false
	end

	print("loading")

	self:loadDataAsync(function( logs )

		print("logs " .. #logs)

		if #logs > 0 then 
			table.append(self.logList,logs)
			-- local group = table.groupBy(self.logList,function(v) return os.date("%Y",v.time/1000) end)

			-- self.dataList = {}
			-- for k,v in pairs(group) do
			-- 	-- if k ~= os.date("%y",os.time()) then 
			-- 	-- end
			-- 	self.dataList[#self.dataList + 1] = { isTitle = true ,text = k }
			-- 	table.append(self.dataList,v)
			-- end
			self.dataList = self.logList

		else
			-- 
			self.isLoadComplete = true
		end

		self.isLoading = false
		reloadData()
	end,function( ... )
		self.hasError = true

		self.isLoading = false
		reloadData()
	end)
end

function ConsumeHistoryPanel:loadDataAsync( successCallback,failCallback )

	local function onSuccess( evt )
		if self.isDisposed then 
			return 
		end

		successCallback(evt.data.logs)
		self:setClearState(#self.logList > 0)
	end

	local function onFail( evt )
		if self.isDisposed then 
			return 
		end
		self:runAction(CCCallFunc:create(function( ... )
			local panel = CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative", 
				function () 
					self:setClearState(#self.logList > 0) 
				end)
			local wSize = Director:sharedDirector():getWinSize()

			panel:setPositionY((wSize.height - panel:getGroupBounds().size.height)/2 - wSize.height)
		end))
		failCallback()
	end

	-- do
	-- 	self:runAction(CCSequence:createWithTwoActions(
	-- 		CCDelayTime:create(2),
	-- 		CCCallFunc:create(function( ... )

	-- 			local data = {}
	-- 			for i=1,20 do
	-- 				data[#data + 1] = { time = os.time({year=2013, month=09, day=12, hour=23, min=59, sec=59,}) * 1000 }
	-- 			end
	-- 			successCallback(data)
	-- 		end)
	-- 	))
	-- 	return 
	-- end

	self:setClearState(false)

	local http = GetCashLogsHttp.new()
	http.timeout = 0.5
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFail)
	http:syncLoad(#self.logList,#self.logList + pageSize - 1)
end

function ConsumeHistoryPanel:onKeyBackClicked()
	Director.sharedDirector():popScene()
end

function ConsumeHistoryPanel:popout( ... )

	local scene = Scene:create()
	-- scene:setPosition(visibleOrigin)
	function scene.onKeyBackClicked( ... )
		self:onKeyBackClicked()
	end

	self:setPositionY(visibleSize.height + visibleOrigin.y)
	self:setPositionX(visibleOrigin.x)
	scene:addChild(self)
	
	Director.sharedDirector():pushScene(scene)
end



