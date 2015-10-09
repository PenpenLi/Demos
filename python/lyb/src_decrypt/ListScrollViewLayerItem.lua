ListScrollViewLayerItem=class(Layer);

function ListScrollViewLayerItem:ctor()
  self.class=ListScrollViewLayerItem;
  self.isInitialized = false;
end

function ListScrollViewLayerItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ListScrollViewLayerItem.superclass.dispose(self);
end

function ListScrollViewLayerItem:onInitialize()
  
end