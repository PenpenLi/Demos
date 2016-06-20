require 'zoo.panel.quickselect.QuickTableView2'
require 'zoo.panel.quickselect.QuickTableRender2'

---------------------------------------------------
---------------------------------------------------
-------------- TabLevelArea
---------------------------------------------------
---------------------------------------------------

assert(not TabLevelArea)
assert(BaseUI)
TabLevelArea = class(BaseUI)

function TabLevelArea:create(ui,hostPanel)
	local panel = TabLevelArea.new()
	panel:init(ui,hostPanel)
	return panel
end

function TabLevelArea:init(ui,hostPanel)
	-- StarAchievenmentPanel
	self.hostPanel = hostPanel
	BaseUI.init(self, ui)

	self:initData()

	self:initUI()
end

function TabLevelArea:initData()
end

function TabLevelArea:initUI()
	FrameLoader:loadImageWithPlist("flash/quick_select_level.plist")
	FrameLoader:loadImageWithPlist("flash/quick_select_animation.plist")

	local wSize = Director:sharedDirector():getWinSize()
	
	local visibleRectSize = self.ui:getGroupBounds(self.ui:getParent()).size
	-- local visibleRectSize = self.ui:getContentSize()
	-- local visibleRectSize = {width=584,height=540}
	print(">>>>>>> level area size",visibleRectSize.width , visibleRectSize.height)
	self.visibleWidth = visibleRectSize.width
	self.visibleHeight = visibleRectSize.height
end

function TabLevelArea:setVisible(value)
	BaseUI.setVisible(self,value)

	if (value == true) then 
		self:initContent()
	else
		self:removeContent()
	end
end

function TabLevelArea:initContent()
	self.ui:removeChildren()
	self.hostPanel.title_full_four_star:setVisible(false)
	self.hostPanel.title_full_hidden:setVisible(false)

	
	self.hostPanel.txtDesc:setString(Localization:getInstance():getText("mystar_tag_1.1"))

	self:addTableView()

	DcUtil:UserTrack({
		category = "ui",
		sub_category = "click_level_chooselevel",
	},true)
end

function TabLevelArea:removeContent()
 	self.ui:removeChildren()
end

function TabLevelArea:addTableView( ... )
	-- body
	local wSize = Director:sharedDirector():getWinSize()
	local vSize = Director:sharedDirector():getVisibleSize()
	local origin = Director:sharedDirector():getVisibleOrigin()

	-- local tabWidth = 585
	-- local tabHeight = 538

	local tabWidth = self.visibleWidth
	local tabHeight = self.visibleHeight

	-- clipping 
	-- local rect = {size = {width = tabWidth, height = tabHeight}}
	-- local clipping = ClippingNode:create(rect)
	-- clipping:setPositionY(-tabHeight)
	-- self.ui:addChild(clipping)

	-- simple clipping
	local clipping = SimpleClippingNode:create()
	clipping:setContentSize(CCSizeMake(tabWidth,tabHeight))
	-- clipping:setPositionX(9)
	-- clipping:setPositionY(-tabHeight-6)
	clipping:setPositionX(0)
	clipping:setPositionY(-tabHeight)
	clipping:setRecalcPosition(true)
	self.ui:addChild(clipping)

	local tableView = QuickTableView:create( tabWidth,tabHeight, QuickTableRender)
	tableView:setPositionX(0)
	tableView:setPositionY(0)
	clipping:addChild(tableView)
	-- self.ui:addChild(tableView)

	local scores = UserManager:getInstance():getScoreRef()
	local areaStars = {}
	local max_unlock_area = math.ceil(UserManager.getInstance().user:getTopLevelId() / 15)

	for k = 1, kMaxLevels/15 do 
		 areaStars[k] = 0
	end

	for k, v in ipairs(scores) do
		local levelId = tonumber(v.levelId)
		if levelId < 10000 and levelId <= kMaxLevels then
			local areaId = math.ceil(levelId / 15)
			areaStars[areaId] = areaStars[areaId] + v.star
		end 
	end

	local dataList = {}
	for k = 1 , kMaxLevels/15 do 
		local data = {}
		data.index = k
		data.star_amount = areaStars[k]
		data.total_amount = LevelMapManager.getInstance():getTotalStarNumberByAreaId(k)
		data.isUnlock = k <= max_unlock_area
		dataList[k] = data
	end

	-- 掩藏关卡星星数
	for k,v in pairs(dataList) do
		local endLevelId = k * 15
		local branchId = MetaModel:sharedInstance():getHiddenBranchIdByNormalLevelId(endLevelId)
		if branchId and not MetaModel:sharedInstance():isHiddenBranchDesign(branchId) then
			
			local branchData = MetaModel:sharedInstance():getHiddenBranchDataByBranchId(branchId)
			if branchData and branchData.endNormalLevel == endLevelId then
				for levelId=branchData.startHiddenLevel,branchData.endHiddenLevel do
					local score = UserManager:getInstance():getUserScore(levelId)
					if score and score.star > 0 then
						v.star_amount = v.star_amount + score.star
					end 
				end
				v.total_amount = v.total_amount + 9
			end
		end
	end

	tableView:updateData(dataList)
	-- print("~~~~~~ setPositionY",wSize.width,wSize.height,origin.x,origin.y)
	-- tableView:setPositionY(-wSize.height + origin.y) -- @TBD
	-- tableView:setPositionY(-tabHeight)
	tableView:setTouchEnabled(true)

	local cur_areaId = HomeScene:sharedInstance().worldScene:getCurrentAreaId()
	print("cur_areaId--->",cur_areaId)
	tableView:initArea(self.areaId or cur_areaId)

	local function onTabTaped( evt )
		DcUtil:UserTrack({
			category = "ui",
			sub_category = "click_star_chooselevel",
		})

		-- 如果index == nil，则不关闭
		local index = evt.data.index
		print(">>>>>>>>> quick table tap >>>>>>>>>>",index)
		if index then
			HomeScene:sharedInstance().worldScene:moveNodeToCenter(index  *  15 - 8, false)
			self:onCloseBtnTapped()
		end
		
	end
	tableView:ad(QuickTableViewEventType.kTapTableView, onTabTaped)

end


function TabLevelArea:onCloseBtnTapped()
	self.hostPanel:onCloseBtnTapped()
end

function TabLevelArea:dispose( ... )
	BaseUI.dispose(self)
	-- FrameLoader:unloadImageWithPlists(
	-- 	{
	-- 	"flash/quick_select_level.plist",
	--  	"flash/quick_select_animation.plist"
	--  	}, true)
end

