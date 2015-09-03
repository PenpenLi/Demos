require 'zoo.panel.basePanel.BasePanel'
require 'zoo.panel.quickselect.QuickTableView'
require 'zoo.panel.quickselect.QuickTableRender'

QuickSelectLevelPanel = class(BasePanel)

function QuickSelectLevelPanel:create(areaId)
	local panel = QuickSelectLevelPanel.new()
	panel:init(areaId)
	return panel
end

function QuickSelectLevelPanel:init(areaId)

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
	tableView:updateData(dataList)
	tableView:setPositionY(-wSize.height + origin.y)
	tableView:setTouchEnabled(true)

	local cur_areaId = HomeScene:sharedInstance().worldScene:getCurrentAreaId()
	-- print(cur_areaId) debug.debug()
	tableView:initArea(self.areaId or cur_areaId)
	local function onTabTaped( evt )
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