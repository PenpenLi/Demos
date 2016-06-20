
-- 黑背景字幕播放
local BAForShowTitleWithBlackBG = class("BAForShowTitleWithBlackBG",require(BATTLE_CLASS_NAME.BaseAction))
-- title id for text
BAForShowTitleWithBlackBG.titleid  		= nil 

-- 延迟时间
BAForShowTitleWithBlackBG.delayTime 	= nil 


BAForShowTitleWithBlackBG.blackLayer 	= nil


BAForShowTitleWithBlackBG.textLabel		= nil 



function BAForShowTitleWithBlackBG:start( ... )
	-- 创建黑layer
	self.blackLayer =  CCLayerColor:create(ccc4(0, 0, 0, 255))
	-- CCSprite:create(BATTLE_CONST.RAGE_MASK_ALL_BLACK_URL)
	

	self.titleid  = self.data[1]
	self.delayTime  = self.data[2] or 1.5

 	-- print(" BAForShowTitleWithBlackBG start:",self.titleid)

	-- 获取国际化
	local words  =  tostring(gi18nString(tonumber(self.titleid)))
	-- 经测试有的系统label \x20 显示不正确,所以我们把它直接替成空格
	words = string.gsub(words, "\x20", " ")
	-- 创建文字
	self.textLabel = CCLabelTTF:create(tostring(words),g_sFontPangWa,24)
	self.textLabel:setFontFillColor(ccc3(255,255,255))
	self.textLabel:setAnchorPoint(CCP_HALF)
	self.textLabel:enableStroke(ccc3(0,0,0),2)
	self.textLabel:enableShadow(CCSizeMake(2, -2), 255, 0)
 

	self.textLabel:setPositionX(g_winSize.width/2)
	self.textLabel:setPositionY(g_winSize.height/2)

	if(BattleLayerManager and BattleLayerManager.battleUILayer ~= nil) then
 		BattleLayerManager.battleUILayer:addChild(self.blackLayer)
 		BattleLayerManager.battleUILayer:addChild(self.textLabel)
 	end

 	-- 文字action
 	-- 淡出
	local actionArray = CCArray:create()
    actionArray:addObject(CCFadeIn:create(0.2))
    actionArray:addObject(CCDelayTime:create(self.delayTime)) -- 1
	actionArray:addObject(CCFadeOut:create(0.2))
    actionArray:addObject(CCCallFuncN:create(function ( ... )
		-- print(" BAForShowTitleWithBlackBG complete 1")
		if(self.disposed == true) then
			return 
		end
		-- print(" BAForShowTitleWithBlackBG complete 2")
		self:complete()
		self:release()
	end))
    self.textLabel:runAction(CCSequence:create(actionArray))

 

end


function BAForShowTitleWithBlackBG:release()

	-- print(" BAForShowTitleWithBlackBG release 1")
 		-- --print(" BAForTargetsPlayMoveInTimeAction:release:",self.targets)
 		self:removeFromRender()					 
		self.calllerBacker:clearAll()
 		self.data = nil
 		
 		ObjectTool.removeObject(self.blackLayer)
 		ObjectTool.removeObject(self.textLabel)
 		self.blackLayer = nil
 		self.textLabel  = nil 

end

-- function BAForShowTitleWithBlackBG:onActionsComplete( ... )
	
-- end



return BAForShowTitleWithBlackBG