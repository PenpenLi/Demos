require 'zoo.panel.basePanel.BasePanel'

require 'zoo.panel.quickselect.StarAchievenmentBasicInfo'
require 'zoo.panel.quickselect.TabLevelArea'
require 'zoo.panel.quickselect.TabFourStarLevel'
require 'zoo.panel.quickselect.TabHiddenLevel'


---------------------------------------------------
---------------------------------------------------
-------------- StarAchievenmentPanel
---------------------------------------------------
---------------------------------------------------
-- ResourceManager:sharedInstance():addJsonFile("ui/star_achievement.json")

StarAchievenmentPanel = class(BasePanel)
__isQQ = PlatformConfig:isQQPlatform()
-- __isQQ = true
function StarAchievenmentPanel:create(areaId)
	local panel = StarAchievenmentPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.star_achevement)
	-- panel:loadRequiredResource(PanelConfigFiles.four_star_guid)
	panel:init(areaId)
	return panel
end

function StarAchievenmentPanel:unloadRequiredResource()
end

function StarAchievenmentPanel:init(areaId)
	self:initData()

	self:initUI()
end

function StarAchievenmentPanel:initData()
	self.fourStarDataListCount = #FourStarManager:getInstance():getAllNotToFourStarLevels()
	self.hiddenLevelDataListCount = #FourStarManager:getInstance():getAllNotPerfectHiddenLevels()
end

function StarAchievenmentPanel:initUI()
	self.ui = self:buildInterfaceGroup("lib_star_achievement_panel")

	BasePanel.init(self, self.ui)

	local function onCloseTap( ... )
		self:dispatchEvent(Event.new(FourStarGuideEvent.kReturnQuickSelectPanel))
		self:onCloseBtnTapped()
	end
	
	local vSize = CCDirector:sharedDirector():getVisibleSize()
	local wSize = CCDirector:sharedDirector():getWinSize()
	local vOrigin = CCDirector:sharedDirector():getVisibleOrigin()

	local size = self:getGroupBounds().size
	self:setScale(vSize.height/wSize.height)
	-- print("self:getGroupBounds().size",size.width,size.height,"scale",self:getScale())

	-- self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()
	-- 这个面板有点特殊，需要顶部对齐
	self:setPositionY(0 )

	-----------------------
	-- Create UI Component
	-- -------------------	
	self.head = self.ui:getChildByName("mc_head")
	self.body = self.ui:getChildByName("mc_body")

	self.basicInfoPanel = StarBasicInfoPanel:create(self.head:getChildByName("basic_info"))

	self.txtDesc = self.body:getChildByName("txtDesc")
	self.mcUndoneFourStarCount = self.body:getChildByName("mcUndoneFourStarCount")
	self.mcUndoneHiddenCount = self.body:getChildByName("mcUndoneHiddenCount")
	self.title_full_hidden = self.body:getChildByName("title_full_hidden")
	self.title_full_four_star = self.body:getChildByName("title_full_four_star")		

	self.title_full_hidden:setVisible(false)
	self.title_full_four_star:setVisible(false)

	self.mcUndoneFourStarCount:getChildByName("txtCount"):setString(self.fourStarDataListCount)
	self.mcUndoneHiddenCount:getChildByName("txtCount"):setString(self.hiddenLevelDataListCount)

	self.mcUndoneFourStarCount:setVisible(self.fourStarDataListCount > 0)
	self.mcUndoneHiddenCount:setVisible(self.hiddenLevelDataListCount > 0)

	self.tab1 = TabLevelArea:create(self.body:getChildByName("tabLevelArea"),self)
	self.tab2 = TabFourStarLevel:create(self.body:getChildByName("tabFourStarLevel"),self)
	self.tab3 = TabHiddenLevel:create(self.body:getChildByName("tabHiddenLevel"),self)
	self.tab = StarAchievenmentTab:create(self.body:getChildByName("mc_tab"))
	self.tab:bind(self.tab.tabbutton1,self.tab1)
	self.tab:bind(self.tab.tabbutton2,self.tab2)
	self.tab:bind(self.tab.tabbutton3,self.tab3)

	self:updateView()

	-- init state ---
	self.tab.tabbutton1:dispatchEvent(DisplayEvent.new(DisplayEvents.kTouchTap, self.tab.tabbutton1))

	-- 处理应用宝相关
	if (__isQQ) then
		self.closeButton = self:createTouchButtonBySprite(self.body:getChildByName("close_btn"), onCloseTap)
		self.head:getChildByName("close_btn"):setVisible(false)
		self.head:setVisible(false)
		self.body:getChildByName("leaf_l"):setVisible(false)
		self.body:getChildByName("leaf_r"):setVisible(false)
	else
		self.closeButton = self:createTouchButtonBySprite(self.head:getChildByName("close_btn"), onCloseTap)
		self.body:getChildByName("close_btn"):setVisible(false)
		self.body:getChildByName("title2"):setVisible(false)
	end
end


function StarAchievenmentPanel:updateView()
	self.basicInfoPanel:updateView()
end


function StarAchievenmentPanel:popout()
	self.allowBackKeyTap = true
	PopoutManager:sharedInstance():add(self, true, false)

	local headToY = self.head:getPositionY()

	local bodyToY = false
	if (__isQQ) then
		headToY = self.head:getPositionY() + 3000
		bodyToY = self.body:getPositionY() + 200
	else
		bodyToY = self.body:getPositionY()
	end

	self.head:setPositionY(headToY+700)
	self.body:setPositionY(bodyToY+1300)

	self.head:runAction(CCEaseElasticOut:create(CCMoveBy:create(0.6, ccp(0,-700))))
	self.body:runAction( CCSequence:createWithTwoActions(
			CCDelayTime:create(0.1),
			-- CCFadeIn:create(1),
			CCEaseElasticOut:create(CCMoveBy:create(0.8, ccp(0,-1300)),0.7)
														)
		)
	-- he_dumpGLObjectRefs()
end

function StarAchievenmentPanel:onCloseBtnTapped( ... )
	PopoutManager:sharedInstance():remove(self, true)
	if self.bgLayer then 
		self.bgLayer:removeFromParentAndCleanup(true)
	end
	self.allowBackKeyTap = false
end



---------------------------------------------------
---------------------------------------------------
-------------- StarAchievenmentTab
---------------------------------------------------
---------------------------------------------------

assert(not StarAchievenmentTab)
assert(BaseUI)
StarAchievenmentTab = class(BaseUI)

function StarAchievenmentTab:create(ui)
	local panel = StarAchievenmentTab.new()
	panel:init(ui)
	return panel
end

function StarAchievenmentTab:init(ui)
	BaseUI.init(self, ui)

	self:initData()

	self:initUI()
end

function StarAchievenmentTab:initData()
	-- mapping tab button and view
	self.mapping = {}
end

function StarAchievenmentTab:initUI()
	self.radioGroup = StarAchievenmentRadioButtonGroup:create(self)

	self.tabbutton1 = SelectableButton:create(self.ui:getChildByName("tabbutton1"))	
	self.tabbutton2 = SelectableButton:create(self.ui:getChildByName("tabbutton2"))	
	self.tabbutton3 = SelectableButton:create(self.ui:getChildByName("tabbutton3"))	

	self.radioGroup:add(self.tabbutton1)
	self.radioGroup:add(self.tabbutton2)
	self.radioGroup:add(self.tabbutton3)
end

function StarAchievenmentTab:bind(button,view)
	self.mapping[button] = view
end

---------------------------------------------------
---------------------------------------------------
-------------- StarAchievenmentRadioButtonGroup
---------------------------------------------------
---------------------------------------------------
StarAchievenmentRadioButtonGroup = class()

function StarAchievenmentRadioButtonGroup:create(tab)
	local clazz = StarAchievenmentRadioButtonGroup.new()
	clazz.tab = tab
	clazz.content = {}
	return clazz
end

function StarAchievenmentRadioButtonGroup:add(button)

	local function onButtonTapped()
		for _,v in ipairs(self.content) do
			v:setSelect(false)	
		end
		button:setSelect(true)		

		for but,view in pairs(self.tab.mapping) do
			view:setVisible(false)
		end
		self.tab.mapping[button]:setVisible(true)
	end

	table.insert(self.content,button)
	button:addEventListener(DisplayEvents.kTouchTap, onButtonTapped)
end











