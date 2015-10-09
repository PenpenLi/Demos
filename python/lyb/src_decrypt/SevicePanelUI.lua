
SevicePanelUI = class(Layer)

function SevicePanelUI:ctor()
	-- body
	self.class = SevicePanelUI

end

function SevicePanelUI:dispose()
	-- body
  self:removeAllEventListeners();
  -- self:removeChildren();
  -- SevicePanelUI.superclass.dispose(self);	
end

function SevicePanelUI:onInit()
	self:initLayer()
	-- self:addChildAt(LayerColorBackGround:getBackGround(),0)
	-- body
    local movieClip = MovieClip.new()
    movieClip:initFromFile("main_ui", "fuwuPanel")
    movieClip:gotoAndPlay("f1")
    self:addChild(movieClip.layer)
    movieClip:update()

	-- local winSize = Director:sharedDirector():getWinSize()
	-- local uiSize = movieClip.layer:getGroupBounds(false).size
	-- local offsetX,offsetY = (winSize.width - uiSize.width) / 2,(winSize.height - uiSize.height) / 2
 --    movieClip.layer:setPositionXY(offsetX,offsetY - 20)


    -- 公告
    self.gonggaoButton = movieClip.armature:findChildArmature("fuwuSmallBackGround_1"):getBone("functionImage"):getDisplay()
    local gonggaoImage = Image.new()
    gonggaoImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_132,"icon"))
    -- gonggaoImage:loadByArtID(2589)
    self.gonggaoButton:addChild(gonggaoImage)

    -- 客服
    self.gmButton = movieClip.armature:findChildArmature("fuwuSmallBackGround_2"):getBone("functionImage"):getDisplay()
    local gmImage = Image.new()
    gmImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_151,"icon"))
    -- gmImage:loadByArtID(2589)
    self.gmButton:addChild(gmImage)
    -- 设置
    self.shezhiButton = movieClip.armature:findChildArmature("fuwuSmallBackGround_3"):getBone("functionImage"):getDisplay()
    local shezhiImage = Image.new()
    shezhiImage:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_131,"icon"))
    -- shezhiImage:loadByArtID(2589)
    self.shezhiButton:addChild(shezhiImage)

    -- 备胎
    self.beitaiButton = movieClip.armature:getBone("fuwuSmallBackGround_4"):getDisplay()
    self.beitaiButton:setVisible(false)

	-- 切换账户
	local common_copy_bluelonground_button = movieClip.armature:getBone("common_copy_bluelonground_button").displayBridge.display
	self.selectButtonData = movieClip.armature:findChildArmature("common_copy_bluelonground_button"):getBone("common_bluelonground_button").textData
	
	common_copy_bluelonground_button:setVisible(false)
	-- movieClip.layer:removeChild(common_copy_bluelonground_button)
	self.confirmButton = CommonButton.new();
	self.confirmButton:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
	self.confirmButton:initializeText(self.selectButtonData,"切换账号");
	self.confirmButton:setPositionXY(common_copy_bluelonground_button:getPositionX(),common_copy_bluelonground_button:getPositionY() - common_copy_bluelonground_button:getGroupBounds(false).size.height);
	self:addChild(self.confirmButton);
	
	-- 关闭按钮
	local common_copy_close_button = movieClip.armature:getBone("common_copy_close_button").displayBridge.display
	local closeButtonData = movieClip.armature:findChildArmature("common_copy_close_button"):getBone("common_close_button").textData	
	-- movieClip.layer:removeChild(common_copy_close_button)
	common_copy_close_button:setVisible(false)
	self.closeButton = CommonButton.new();
	self.closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
	self.closeButton:setPositionXY(common_copy_close_button:getPositionX(),common_copy_close_button:getPositionY() - common_copy_close_button:getGroupBounds(false).size.height);
	self:addChild(self.closeButton); 

	if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
		local str=StringUtils:lua_string_split(GameData.userAccount,"#")[1];

		local defaultContent = getLuaCodeTranslated("您的遊戲ID: " )

		self.textField=TextField.new(CCLabelTTF:create(defaultContent.. GameConfig.PLATFORM_CODE_GOOGLE .. "_" .. str,FontConstConfig.OUR_FONT,24));
    	self.textField:setPositionXY(30,130);
    	self:addChild(self.textField);
	end

	AddUIBackGround(self);

end