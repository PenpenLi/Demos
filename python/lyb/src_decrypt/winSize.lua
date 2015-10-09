-- add ui back gournd
-- do this after layer init
-- zhangke
-- @layer parentlayer
-- @backGroudImageID imageID
-- @hasnotBackLayer no frame
-- @isAllSceenBack  adept all sceen  means 1280*960

function AddUIBackGround(layer,backGroudImageID,hasnotBackLayer,isAllSceenBack)

	if layer then
		-- add 统一背景层
		local winSize = Director:sharedDirector():getWinSize()
		local uiSize = layer:getGroupBounds(false).size
		local offsetX,offsetY = (winSize.width - uiSize.width) / 2,(winSize.height - uiSize.height) / 2
  		-- layer:setPositionXY(offsetX - GameData.uiOffsetX,offsetY - GameData.uiOffsetY)

		if backGroudImageID then  -- 有背景图就加载图片
			local uiBackImage = Image.new()
			uiBackImage:loadByArtID(backGroudImageID)
			-- if scale then uiBackImage:setScale(scale); end

			if uiBackImage then
				if isAllSceenBack then
					uiBackImage.sprite:setAnchorPoint(CCPointMake(0.5, 0.5))
					uiBackImage:setPositionXY(winSize.width / 2 - GameData.uiOffsetX,winSize.height / 2 - GameData.uiOffsetY)
				end

				uiBackImage.touchEnabled = true;
				uiBackImage.touchChildren = false;
				layer:addChildAt(uiBackImage,0)
			end
		end

		-- if backGroudImageID and (GameData.uiOffsetX ~= 0 or GameData.uiOffsetY ~= 0) then
		-- 	-- local backImage = Image.new()
		-- 	-- backImage:loadByArtID(StaticArtsConfig.BACKGROUD_COMMON_BACK_BG)
		-- 	-- backImage.sprite:setAnchorPoint(CCPointMake(0.5, 0.5))
		-- 	-- backImage:setPositionXY(winSize.width / 2 + -1 * GameData.uiOffsetX,winSize.height / 2 + -1 * GameData.uiOffsetY)
		-- 	-- backImage.touchEnabled = true;
		-- 	-- backImage.touchChildren = false;			
		-- 	-- layer:addChildAt(backImage,0)	
		-- else
	 --  		local backHalfAlphaLayer = LayerColorBackGround:getBackGround()
	 --  		backHalfAlphaLayer:setPositionXY(-1 * GameData.uiOffsetX, -1 * GameData.uiOffsetY)
		-- 	layer:addChildAt(backHalfAlphaLayer,0)				
		-- end	
	end
end

-- 统一添加到UI上层的边框
function AddUIFrame(layer)
	-- if GameData.uiOffsetX ~= 0 or GameData.uiOffsetY ~= 0 then
	-- 	local winSize = Director:sharedDirector():getWinSize()
	-- 	local uiFrameImage = Image.new()
	-- 	uiFrameImage:loadByArtID(StaticArtsConfig.BACKGROUD_COMMON_FRAME)
	-- 	uiFrameImage.sprite:setAnchorPoint(CCPointMake(0.5, 0.5))
	-- 	uiFrameImage:setPositionXY(winSize.width / 2 + -1 * GameData.uiOffsetX,winSize.height / 2 + -1 * GameData.uiOffsetY)
	-- 	uiFrameImage.touchEnabled = false;
	--     uiFrameImage.touchChildren = false;
	-- 	layer:addChild(uiFrameImage)
	-- end
end