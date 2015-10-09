
MapSkyLayer = class(Layer);
function MapSkyLayer:ctor()
	self.class = MapSkyLayer;
end

function MapSkyLayer:dispose()

	self:removeAllEventListeners();
	self:removeChildren();
	MapSkyLayer.superclass.dispose(self);
end

function MapSkyLayer:onInit(artId)
    self:initLayer();

    self.bgImage = Image.new()
    self.bgImage:loadByArtID(artId)
    self:addChild(self.bgImage)

    self:setContentSize(self.bgImage:getContentSize());
    local size = Director:sharedDirector():getWinSize();
    self:setPositionXY(0,size.height - self.bgImage:getContentSize().height)
end

function MapSkyLayer:clean()

end
