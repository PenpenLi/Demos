--=====================================================
-- 通用分页视图，管理多个Page
-- by zhehua.ou
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- filename:   CommonPageView.lua
-- author:     zhehua.ou
-- e-mail:     zhehua.ou@happyelements.com
-- created:    2014/03/22
-- descrip:    最多生成三页
--=====================================================

require "core.controls.page.PageView"
require "core.controls.page.CommonPage"
require "core.controls.page.PageViewControl"

CommonPageView = class(PageView)

--构造
function CommonPageView:ctor()
	self.pageSlotsMax = nil;	--每页的slot数量
	self.dataList = nil;		--原始数据
	self.pages = {};			--管理的pages
	self.maxPageNum = 0;		--dataList需要的page数目
	self.curPageNum = 0;		--当前创建的page数目
	
	self.CurrentPagePointer = nil;	--指向当前页page的指针
	self.LeftPagePointer = nil;		--指向当前页左页page的指针
	self.RightPagePointer = nil;	--指向当前页右页page的指针

	self.hideNilSlot = nil;
end

--参数含义：
	-- createSlotCallback 创建单元格回调函数，单元格需要继承自CommonSlot
	-- rowNum	每一页的slot行数
	-- colNum	每一页的slot列数
	-- marginH	slot间隙大小(横向)
	-- marginV  slot间隙大小(纵向)
	-- slotSize slot的大小
	-- bPageControl 是否显示下面的pageViewControl
	-- offset 上下坐标偏移值，如有需要可以设置
	-- hideNilSlot 对于翻页中的空格子，是否要隐藏，true则隐藏整个显示对象，false则显示无内容的样式
	-- pageControlStyle 这个变量加得晚，只能放在最后，是页码显示样式风格设置
function CommonPageView:initialize(createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, bPageControl, offset, hideNilSlot, pageControlStyle,pageFreshCallBack)
	if not createSlotCallback then return end;
	self.pageFreshCallBack = pageFreshCallBack;
	--参数默认值
	rowNum = rowNum or 4;
	colNum = colNum or 4;
	marginH = marginH or 4;
	marginV = marginV or 4;
	slotSize = slotSize or CCSizeMake(100, 101);
	bPageControl = bPageControl or true;
	pageControlStyle = pageControlStyle or 1;
	offset = offset or 0;

	--记录下来数据，供以后更新数据使用
	local dataList = {};
	self.pageSlotsMax = rowNum * colNum;
	self.rowNum = rowNum;
	self.colNum = colNum;
	self.marginH = marginH;
	self.marginV = marginV;
	self.slotSize = slotSize;
	self.createSlotCallback = createSlotCallback;
	self.offset = offset;
	self.hideNilSlot = hideNilSlot;

	--创建PageViewControl
	self.pageWidth = (marginH + slotSize.width) * colNum;
	self.pageHeight = (marginV + slotSize.height) * rowNum + offset * 2;

	-- print("self.pageWidth, self.pageHeight:",self.pageWidth, self.pageHeight)

	local size = CCSizeMake(self.pageWidth, self.pageHeight+slotSize.height);--todo by jiasq

	--初始化pageViewControl
	if bPageControl then
		-- if pageControlStyle == 1 then
			self.pageViewControl = PageIndexDotStyle:create(size);
		-- elseif pageControlStyle == 2 then
		-- 	self.pageViewControl = PageIndexNumberStyle:create(size);
		-- end
	end

	--创建hitArea
	-- local node = DisplayNode.new(CCSprite:create());
	-- node.name = "hit_area";
	-- node.touchEnabled = false;
	-- node.touchChildren = false;

	-- self.hitArea = node;
	-- self:addChild(node);

	-- local hitAreaSize = CCSizeMake(self.pageWidth, self.pageHeight);
	-- self:setHitAreaSize(hitAreaSize)

	--大小和方向
	self:setViewSize(size);
	self:setDirection(kCCScrollViewDirectionHorizontal);
	--注册翻页回调
	local function onPageViewScrollStoped()
		log("@@@@@@@@@@@@@@@@@@@onPageViewScrollStoped")
		self:onPageViewScrollStoped();
		if self.pageFreshCallBack then
			self:pageFreshCallBack();
		end
	end
	self:registerScrollStopedScriptHandler(onPageViewScrollStoped);
	
	if GameVar.tutorStage ~= 0 and GameVar.tutorStage ~= TutorConfig.STAGE_99999 and GameVar.tutorStage ~= TutorConfig.STAGE_1027 then
		self.sprite:setMoveEnabled(false)
	end

	--设置数据
	self:updateData(dataList);
end

function CommonPageView:setDirection(direction)
	self.sprite:setDirection(direction);
end

function CommonPageView:setViewSize(size)
	self.sprite:setViewSize(size);
end

--根据self.dataList，设置页数、页码、点击区域
--在数据变更的时候一定要调用
function CommonPageView:checkPageCreated()
	self.maxPageNum = math.max(1, math.ceil(#self.dataList/self.pageSlotsMax));
	-- self.maxPageNum = math.min(self.maxPageNum, 3);
	self:setMaxPageCount(self.maxPageNum);

	if not self.oldPageNum then
		self.oldPageNum = 0;
	end

	-- self.pages里最多三页
	if self.maxPageNum ~= self.oldPageNum then
		self.oldPageNum = self.maxPageNum;
		--设置大小
		local contentSize = CCSizeMake(self.pageWidth * self.maxPageNum, self.pageHeight);
		self:setContainerSize(contentSize);

		if self.pageViewControl then
			self:initializePageViewControl();
		end

		if self.maxPageNum > #self.pages and #self.pages < 3 then
			local repeatTime = math.min(self.maxPageNum, 3) - #self.pages;
			for i=1,repeatTime do
				self:createNewPage();
			end
		end
	end
end

--设置更新数据
--第二个参数可以不传，不传就刷新数据然后留着原来页
function CommonPageView:updateData(dataList,Pageindex,notset)
	self.dataList = dataList or {};
	self:checkPageCreated();

	-- 将页标志清除
	for i,v in ipairs(self.pages) do
		v.pageIndex = 0;
	end

	if notset then

	else
		if Pageindex then
			self:setCurrentPage(Pageindex);
		else
			self:setCurrentPage(self:getCurrentPage());
		end
	end
end

-- 翻到该页
-- 设置成 0 就是想设置到末页
function CommonPageView:setCurrentPage(currentPageIndex)
	-- 页码容错
	if currentPageIndex <= 0 then
		currentPageIndex = 1;
	elseif currentPageIndex > self.maxPageNum then
		currentPageIndex = self.maxPageNum;
	end

	PageView.setCurrentPage(self, currentPageIndex);
end

-- 设置页数据
function CommonPageView:setPageData(currentPageIndex)
	local pageIndexTable = {};
	if currentPageIndex == 1 then -- 设置到第一页
		pageIndexTable[1] = 1;
		pageIndexTable[2] = 2;
		pageIndexTable[3] = 3;
	elseif currentPageIndex == self.maxPageNum then -- 设置到末页
		pageIndexTable[1] = currentPageIndex;
		pageIndexTable[2] = currentPageIndex - 1;
		pageIndexTable[3] = currentPageIndex - 2;
	else
		pageIndexTable[1] = currentPageIndex;
		pageIndexTable[2] = currentPageIndex + 1;
		pageIndexTable[3] = currentPageIndex - 1;
	end
	-- for k, v in pairs(pageIndexTable) do
	-- 	print("k, v ", k, v)		
	-- end
	-- 排除阶段
	local tempPages = {};
	for page_i,page_v in ipairs(self.pages) do
		local switch = true;
		if page_v.pageIndex ~= 0 then
			for index_i,index_v in ipairs(pageIndexTable) do
				if page_v.pageIndex == index_v then
					pageIndexTable[index_i] = 0;
					switch = false;
					break;
				end
			end
		end

		if switch then
			table.insert(tempPages, page_v);
		end
	end
	-- 赋值阶段
	for page_i,page_v in ipairs(tempPages) do
		for index_i,index_v in ipairs(pageIndexTable) do
			if index_v > 0 then
				self:setPosAndData(page_v,index_v);
				pageIndexTable[index_i] = 0;
				break;
			end
		end
	end

	for page_i,page_v in ipairs(self.pages) do
		local offSet = (currentPageIndex - 1) * (self.pageWidth)
		if math.abs(page_v:getPositionX() - offSet) < 10 then
			page_v:setVisible(true, true)
		else
			page_v:setVisible(false, true)
		end
	end

	-- local visibleCount = 0;
	-- for page_i,page_v in ipairs(self.pages) do
	-- 	if page_v:isVisible() then
	-- 		visibleCount = visibleCount + 1;
	-- 	end
	-- end
	-- print("++++++++++++++++++++++++++--------------------------------visibleCount", visibleCount)
	-- 调整点击区域
	--self.hitArea:setPositionX((currentPageIndex - 1) * (self.pageWidth));
end

-- 通过页码给页设置坐标和数据
function CommonPageView:setPosAndData(page,index)
	if page and page.pageIndex ~= index then
		page.pageIndex = index;
		self:setPagePositionByIndex(page,index);
		self:setPageDataByIndex(page,index);
	end
end

-- 通过页码给页设置坐标
function CommonPageView:setPagePositionByIndex(page,index)
	-- print("abcd$$$$$$$$$$$$$$$$$$$$$$$$$$index", index)
	if page then
		-- print("page setPositionX:", (index - 1) * (self.pageWidth))
		page:setPositionX((index - 1) * (self.pageWidth));
	end
end
-- 通过页码给页设置数据
function CommonPageView:setPageDataByIndex(page,index)
	if page then
		-- 添加数据到page中
		local beginIndex = (index-1) * self.pageSlotsMax;

		for i=1,self.pageSlotsMax do
			local data = self.dataList[beginIndex+i];
			if data then
				page:setSlotData(data, i);
			else
				print("page:removeSlotData(i);", index)
				page:removeSlotData(i);
			end
		end
	end
end

-- 创建页
function CommonPageView:createNewPage()
	local page = CommonPage:create(self.slotSize, self.rowNum, self.colNum, self.marginH, self.marginV, self);
	page.name = "page"..(#self.pages + 1); -- 这个没什么用，就是个名字
	page.pageIndex = 0;
	page.hideNilSlot = self.hideNilSlot;
	page:setAnchorPoint(ccp(0,0));
	self:addChild(page);
	table.insert(self.pages, page);

	return page;
end

--重置选中状态
-- function CommonPageView:resetSlotsSelected()
-- 	for i, v in ipairs(self.pages) do
-- 		v:resetSlotsSelected();
-- 	end
-- end

--slot选中的函数调用(子类重写该方法)
function CommonPageView:onSlotTouch(slot, page, globalPos)

end

--CommonPageView翻页回调函数
function CommonPageView:onPageViewScrollStoped()
	local currentPage = self:getCurrentPage();
	-- log("currentPage".. currentPage)
	--处理翻页后数据
	self:setPageData(currentPage);

	--更新页码指示
	if self.pageViewControl then
		self.pageViewControl:update();
	end
end

--添加一条记录到最后,然后还跳到末页
function CommonPageView:addOneDataToLast(data)
	if not data then return end

	table.insert(self.dataList,data);
	self:checkPageCreated();

	-- 缓存里就有需要刷新的页
	local tempPage = nil;
	for i,v in ipairs(self.pages) do
		if v.pageIndex == self.maxPageNum then
			tempPage = v;
			break;
		end
	end

	if tempPage then
		local mod = math.mod(#self.dataList, self.pageSlotsMax);
		if mod == 0 then
			tempPage:setSlotData(data, self.pageSlotsMax);
		else
			tempPage:setSlotData(data, mod);
		end
	end
	
	self:setCurrentPage(#self.dataList);
end

--更新一个格子的数据，不翻页，不可超出范围
function CommonPageView:updateOneDataByIndex(data,index)
	if not data then print("CommonPageView:updateOneDataByIndex  没数据"); return; end
	local pageIndex = math.max(1, math.ceil(index/self.pageSlotsMax));
	if pageIndex > self.maxPageNum then print("CommonPageView:updateOneDataByIndex  超范围"); return; end

	--先把数据放进来
	self.dataList[index] = data;

	-- 缓存里就有需要刷新的页
	local tempPage = nil;
	for i,v in ipairs(self.pages) do
		if v.pageIndex == pageIndex then
			tempPage = v;
			break;
		end
	end

	if tempPage then
		local mod = math.mod(index, self.pageSlotsMax);
		if mod == 0 then
			tempPage:setSlotData(data, self.pageSlotsMax);
		else
			tempPage:setSlotData(data, mod);
		end
	end
end
