
BackGroundLayer = class(Layer);

function BackGroundLayer:ctor()
  self.class = BackGroundLayer;
end

function BackGroundLayer:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	BackGroundLayer.superclass.dispose(self);
end

function BackGroundLayer:onInit()    
  	self:initLayer();
end

function BackGroundLayer:setData(artId)
	if artId then
		self.artId = artId;    
	end

	
	self.bgImage = Image.new()
	self.bgImage:loadByArtID(self.artId)
	self:addChild(self.bgImage)

	local image1Size = self.bgImage:getContentSize();

    GameVar.mapWidth = image1Size.width
    GameVar.mapHeight = image1Size.height
    self:setContentSize(makeSize(GameVar.mapWidth , GameVar.mapHeight));
end
function BackGroundLayer:clean()
  	self:removeChildren();
end
