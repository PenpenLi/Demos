WeeklyShareUtil = {}

function WeeklyShareUtil.buildShareImage(group)
	assert(group, "group must not be nil")
	local imagePath = nil
	if group then 
		local bg_2d = Sprite:create("share/weekly_share_bg_1.png")
		bg_2d:setAnchorPoint(ccp(0, 1))
		local bg = group:getChildByName("bg")
		bg:setVisible(false)
		local size = bg:getGroupBounds().size
		local bSize = bg_2d:getGroupBounds().size
		bg_2d:setScaleX(size.width / bSize.width)
		bg_2d:setScaleY(size.height / bSize.height)
		group:addChildAt(bg_2d, group:getChildIndex(bg))

		local qr
		if __use_small_res then
			qr = Sprite:create("share/share_background_2d_small.png")
		else
			qr = Sprite:create("share/share_background_2d.png")
		end
		qr:setAnchorPoint(ccp(1, 1))
		qr:setPositionXY(size.width - 10, -10)
		group:addChildAt(qr, group:getChildIndex(bg))

		group:setPositionY(size.height)

		local filePath = HeResPathUtils:getResCachePath() .. "/share_image.jpg"
		-- print(filePath)
		local renderTexture = CCRenderTexture:create(size.width, size.height)
		renderTexture:begin()
		group:visit()
		renderTexture:endToLua()
		renderTexture:saveToFile(filePath)
		imagePath = filePath
	end
	return imagePath
end

function WeeklyShareUtil.buildShareImageWinter(group)
	assert(group, "group must not be nil")
	local imagePath = nil
	if group then 
		local bg_2d = Sprite:create("share/weekly_share_bg_2.png")
		bg_2d:setAnchorPoint(ccp(0, 1))
		local bg = group:getChildByName("bg")
		bg:setVisible(false)
		local size = bg:getGroupBounds().size
		local bSize = bg_2d:getGroupBounds().size
		bg_2d:setScaleX(size.width / bSize.width)
		bg_2d:setScaleY(size.height / bSize.height)
		group:addChildAt(bg_2d, group:getChildIndex(bg))

		local qr
		if __use_small_res then
			qr = Sprite:create("share/share_background_2d_small.png")
		else
			qr = Sprite:create("share/share_background_2d.png")
		end
		qr:setAnchorPoint(ccp(0, 1))
		local qrBg = group:getChildByName("2d_bg")
		qrBg:setOpacity(0)

		local qrPos = qrBg:getPosition()
		qr:setPositionXY(qrPos.x, qrPos.y)
		group:addChildAt(qr, group:getChildIndex(bg))

		group:setPositionY(size.height)

		local filePath = HeResPathUtils:getResCachePath() .. "/share_image.jpg"
		-- print(filePath)
		local renderTexture = CCRenderTexture:create(size.width, size.height)
		renderTexture:begin()
		group:visit()
		renderTexture:endToLua()
		renderTexture:saveToFile(filePath)
		imagePath = filePath
	end
	return imagePath
end