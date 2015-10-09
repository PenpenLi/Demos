--=====================================================
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- filename:  HeroTeamPageView.lua
--=====================================================
require "core.controls.page.CommonPageView"
require "main.view.hero.heroTeam.ui.HeroTeamSlot"

HeroTeamPageView = class(CommonPageView);

-- 初始化
function HeroTeamPageView:initialize(createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, bPageControl, hideNilSlot,pageFreshCallBack)
	CommonPageView.initialize(self, createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, bPageControl, nil, hideNilSlot,pageFreshCallBack);
	self:update();
end

-- 更新界面显示
function HeroTeamPageView:update(list)
	if not list then
		return;
	end
	self:updateData(list);
end

-- 初始化翻页控制指示器
function HeroTeamPageView:initializePageViewControl(dotHeight)
	PageView.initializePageViewControl(self, dotHeight);

	if self.pageViewControl then
		local position = self.pageViewControl:getPosition();
		self.pageViewControl:setPositionXY(position.x + 30, position.y);
	end
end

function HeroTeamPageView:pageFreshCallBack()
	-- local currentPage = self:getCurrentPage();
	-- self.pageTF:setString("<"..currentPage.."/"..self.maxPageNum..">")
	-- -- print("fresh");
	self.context.descb:setString(self:getCurrentPage() .. "/" .. self.maxPageNum);
	self:setIsPlayImg();
end;
function HeroTeamPageView:dispose()
	-- log("----------------------HeroTeamPageView:dispose()")
	self:removeChildren()
	HeroTeamPageView.superclass.dispose(self);
end
function HeroTeamPageView:create(context,onCardTap,type)
	-- self.pageTF = pageTF;
	-- local use_type = useType or 1;
	local heroHouseSprite = CCPageView:create();
	local pageView = HeroTeamPageView.new(heroHouseSprite);
	pageView.heroTeamSlots = {};
	local slotSize = CCSizeMake(450, 525); --slot尺寸
	local rowNum = 1;
	local colNum = 1;
	local marginH = 0;
	local marginV = 0;
	
    local curIndex = 1;
    local datas;
    if 3 == type then--派遣佣兵
    	datas = math.ceil(table.getn(context.familyProxy:getYongbingData4Paiqian())/9);
    elseif 2 == type then--编队佣兵
    	if context.notificationData and context.notificationData.funcType == "TenCountry" then
	    	datas = math.ceil(table.getn(context.familyProxy:getYongbingData4BianduiOnShiguo())/9);
	    else
    		datas = math.ceil(table.getn(context.familyProxy:getYongbingData4Biandui())/9);
    	end
    elseif 1 == type then
    	if context.notificationData and context.notificationData.funcType == "TenCountry" then
	    	datas = math.ceil(table.getn(context.heroHouseProxy:getTenCountryLeftGeneral(context.tenCountryProxy))/9);
	    else
	    	datas = math.ceil(table.getn(context.heroHouseProxy:getGeneralArrayWithPlayer())/9);
	    end
    end
    local temp = {};
    for i=1,datas do
    	table.insert(temp, i);
    end
	local function createSlotCallback()
		-- if items[curIndex] then
	 --        curIndex = curIndex + 1;
		-- 	return HeroTeamSlot:create(context,items[curIndex],onCardTap);
		-- end;
		curIndex = curIndex + 1;
		local slot = HeroTeamSlot.new();
		slot:initialize(context,onCardTap,type);
		table.insert(pageView.heroTeamSlots, slot);
		return slot;
	end
	pageView.context = context;
	pageView:initialize(createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, true, true,nil,self.pageFreshCallBack);
	pageView:update(temp);
	return pageView;
end

function HeroTeamPageView:setIsPlayImg()
	for k,v in pairs(self.heroTeamSlots) do
		v:setIsPlayImg();
	end
end