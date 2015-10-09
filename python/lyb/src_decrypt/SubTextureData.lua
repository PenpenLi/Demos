-------------------------------------------------------------------------
--  Class include: SubTextureData, TextureAtlasData
-------------------------------------------------------------------------


--
-- SubTextureData ---------------------------------------------------------
--

SubTextureData = class();
function SubTextureData:ctor(x, y, width, height)
	self.x = x or 0;
	self.y = y or 0;
	self.width = width or 0;
	self.height = height or 0;

	self.pivotX = 0;
	self.pivotY = 0;
	
	self.anchorX = 0;
	self.anchorY = 0;	
	self.name = nil;
end

function SubTextureData:toString()
	return string.format("SubTextureData [%s, %.2f,%.2f,%.2f,%.2f,%.2f,%.2f]",
	self.name and self.name or "nil",
	self.x, self.y, self.width, self.height, self.pivotX, self.pivotY);
end

function SubTextureData:updateAnchor()
    self.anchorX = self.pivotX / self.width;
    self.anchorY = self.pivotY / self.height;
end

--
-- TextureAtlasData ---------------------------------------------------------
--
-- initialize

TextureAtlasData = class(Object);
function TextureAtlasData:ctor()
	self.name = nil;
	self.width = 0;
	self.height = 0;
	self.bitmap = nil;

	self.class = TextureAtlasData;

	self.subTextureDatas = {}; -- of <SubTextureData>
end

function TextureAtlasData:dispose()
	self.subTextureDatas = nil;

	self:removeSelf();
end

function TextureAtlasData:toString()
	return string.format("TextureAtlasData [%s, width=%d, height=%d]",self.name and self.name or "nil", self.width, self.height);
end

-- public methods
function TextureAtlasData:getSubTextureData(name)
	return self.subTextureDatas[name];
end

function TextureAtlasData:addSubTextureData(data)
	local texName = data.name;
	if texName then
		self.subTextureDatas[texName] = data;
	end
end
