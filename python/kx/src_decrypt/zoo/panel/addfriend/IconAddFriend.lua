IconAnimationType = table.const{
	kTypeShader = 1,
	kTypeScale = 2
}

local IconAddFriend = class()

local shader = {0, -0.209, -0.172, -0.038}

function IconAddFriend:create(ui, onTapped, animtionType)
	local icon = IconAddFriend.new()
	icon:init(ui, onTapped, animtionType)

	return icon
end

local function playScaleAnimation(icon, endCallback)
	local scale = 0.5
	local seqArr = CCArray:create()
	seqArr:addObject(CCScaleTo:create(2/24 * scale, 1.15))
	seqArr:addObject(CCScaleTo:create(2/24 * scale, 1.1))
	seqArr:addObject(CCScaleTo:create(2/24 * scale, 0.8))
	seqArr:addObject(CCScaleTo:create(3/24 * scale, 1.1))
	seqArr:addObject(CCScaleTo:create(3/24 * scale, 0.95))
	seqArr:addObject(CCScaleTo:create(3/24 * scale, 1))
	seqArr:addObject(CCCallFunc:create(function ()
		if endCallback then 
			endCallback()
		end
	end))
	icon:runAction(CCSequence:create(seqArr))
end

function IconAddFriend:init(ui, onTapped, animtionType)
	self.ui = ui
	self.onTapped = onTapped
	self.animtionType = animtionType or IconAnimationType.kTypeShader

	self.ui:setTouchEnabled(true, 0, true)
	self.ui:ad(DisplayEvents.kTouchTap, function(event)

			local content = self.ui:getChildByName("icon"):getChildByName("content")
			if self.animtionType == IconAnimationType.kTypeShader then
				content:clearAdjustColorShader()
				if self.onTapped then
					self.onTapped(event)
				end
			else
				if self.isPlayingAnimation then
					return 
				end
				playScaleAnimation(self.ui:getChildByName("icon"), 
									function()
										self.isPlayingAnimation = false 
										if self.onTapped then
											self.onTapped(event)
										end
									end)
				self.isPlayingAnimation = true
			end
		end)


	self.ui:ad(DisplayEvents.kTouchBegin, function() 
		if self.animtionType == IconAnimationType.kTypeShader then
			local content = self.ui:getChildByName("icon"):getChildByName("content")
			content:adjustColor(shader[1], shader[2], shader[3], shader[4])
			content:applyAdjustColorShader()
		else
			--playScaleAnimation(self.ui:getChildByName("icon"))
		end
	end)

	self.ui:ad(DisplayEvents.kTouchMove, function(event) 
		if self.animtionType == IconAnimationType.kTypeShader then
			local content = self.ui:getChildByName("icon"):getChildByName("content")
			
			print("world pos: "..table.tostring(event.globalPosition))
			local hit = content:hitTestPoint(event.globalPosition, true) 
			print("hit: "..tostring(hit))
			if not hit then
				content:clearAdjustColorShader()
			end
		end
	end)
end

return IconAddFriend