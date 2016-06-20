require 'zoo.panel.basePanel.BasePanel'
require 'zoo.panel.quickselect.QuickTableView'
require 'zoo.panel.quickselect.QuickTableRender'
require 'zoo.panel.quickselect.FourStarGuideIcon'

QuickSelectLevelPanel = class(BasePanel)
function QuickSelectLevelPanel:create(areaId)
	local panel = QuickSelectLevelPanel.new()
	panel:init(areaId)
	return panel
end

function QuickSelectLevelPanel:init(areaId)
	FrameLoader:loadImageWithPlist("flash/quick_select_level.plist")
	FrameLoader:loadImageWithPlist("flash/quick_select_animation.plist")

	local wSize = Director:sharedDirector():getWinSize()
	self.ui = Sprite:createEmpty()
	self.areaId = areaId
	local function touchddLayer( evt )
		-- body
		self:onCloseBtnTapped()
	end
	local layer = LayerColor:create()
	layer:changeWidthAndHeight(wSize.width, wSize.height)
	layer:setColor(ccc3(0,0,0))
	layer:setOpacity(200)
	layer:setPositionY(-wSize.height)
	self.ui:addChild(layer)
	BasePanel.init(self, self.ui)

	self:addTableView()
	self:addFourStarIcon()
end

function QuickSelectLevelPanel:addTableView( ... )
	-- body
	local wSize = Director:sharedDirector():getWinSize()
	local vSize = Director:sharedDirector():getVisibleSize()
	local origin = Director:sharedDirector():getVisibleOrigin()
	local tableView = QuickTableView:create( wSize.width, wSize.height, QuickTableRender)
	self.ui:addChild(tableView)
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
	tableView:setPositionY(-wSize.height + origin.y)
	tableView:setTouchEnabled(true)

	local cur_areaId = HomeScene:sharedInstance().worldScene:getCurrentAreaId()
	-- print(cur_areaId) debug.debug()
	tableView:initArea(self.areaId or cur_areaId)
	local function onTabTaped( evt )
		DcUtil:UserTrack({
			category = "ui",
			sub_category = "click_star_chooselevel",
		})
		-- body
		local index = evt.data.index
		if index then
			HomeScene:sharedInstance().worldScene:moveNodeToCenter(index  *  15 - 8, false)
		end
		self:onCloseBtnTapped()
	end
	tableView:ad(QuickTableViewEventType.kTapTableView, onTabTaped)

end

function QuickSelectLevelPanel:popout()
	self.allowBackKeyTap = true
	PopoutManager:sharedInstance():add(self, false, false)
end

function QuickSelectLevelPanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():removeWithBgFadeOut(self, false)
	self.allowBackKeyTap = false
end

function QuickSelectLevelPanel:dispose( ... )
	-- body
	BasePanel.dispose(self)
	-- FrameLoader:unloadImageWithPlists(
	-- 	{
	-- 	"flash/quick_select_level.plist",
	--  	"flash/quick_select_animation.plist"
	--  	}, true)
end

function QuickSelectLevelPanel:addFourStarIcon( ... )
	-- body
	local wSize = Director:sharedDirector():getWinSize()
	local vSize = Director:sharedDirector():getVisibleSize()

	local icon = FourStarGuideIcon:create(self)
	local offset_X = 3 * icon:getGroupBounds().size.width/5
	icon:setPosition(ccp(vSize.width - offset_X , 0))
	self.ui:addChild(icon)
end