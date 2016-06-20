
module ("SpriteFramesManager",package.seeall)


local sprites = {}
local addAnimations = {}

function add(plist,image)
	local imgIns = CCTextureCache:sharedTextureCache():textureForKey(image)
	if(sprites[plist] == nil or imgIns == nil) then
		local plistCache = CCSpriteFrameCache:sharedSpriteFrameCache()
		-- print("SpriteFramesManager add:",plist,image)
		plistCache:addSpriteFramesWithFile(plist,image)
	 	sprites[plist] = image
	 	imgIns = CCTextureCache:sharedTextureCache():textureForKey(image)
	 	imgIns:retain()
	 	-- imgIns = CCTextureCache:sharedTextureCache():textureForKey(image)
	 	-- if(imgIns) then
	 	-- 	imgIns:retain()
	 	-- end
	end
	
end


function release( ... )

	for plist,image in pairs(sprites or {}) do

		
	 	-- Logger.debug("-- SpriteFramesManager remove:".. tostring(image) .. "  " ..tostring(plist))
	 	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plist)

	 	imgIns = CCTextureCache:sharedTextureCache():textureForKey(image)
		-- if(imgIns and )
	 	if(imgIns ~= nil and not tolua.isnull(imgIns)) then
	 		if(imgIns:retainCount() > 1) then
				imgIns:release()
				-- print("----- remove imgIns:",image)
			-- else
				-- print("----- remove imgIns not:",image)
			end
			-- end
	 		-- imgIns:release()
	 		CCTextureCache:sharedTextureCache():removeTexture(imgIns)
	 	end


	end
	sprites = {}
end

-- function addAnimation( json,plist,image )
	
-- 	local imgIns = CCTextureCache:sharedTextureCache():textureForKey(image)
-- 	if(addAnimations[json] == nil or imgIns == nil) then
-- 		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(image, plist ,json );
-- 	 	addAnimations[json] = {plist,image}
-- 	end

-- end

-- function checkPlist(plist,checkValue)
-- 	if(sprites[plist]) then
-- 		local img = sprites[plist][1]
-- 		local imgIns = CCTextureCache:sharedTextureCache():textureForKey(img)
-- 		return imgIns ~= nil
-- 	end
-- 	return false
-- end

