
TopZhuanLayer=class(Layer);

function TopZhuanLayer:ctor()
  self.class=TopZhuanLayer;
end

function TopZhuanLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	TopZhuanLayer.superclass.dispose(self);
	BitmapCacher:removeUnused();
end

function TopZhuanLayer:initialize()
  self:initLayer();

  self.mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(self.mainSize.width, self.mainSize.height));
  self.touchEnabled = false
  self.touchChildren = false

  self:onUIInit();
end

function TopZhuanLayer:onUIInit()


  local layerColor1 = LayerColor.new();
  layerColor1:initLayer();
  layerColor1:changeWidthAndHeight(self.mainSize.height, 76);
  layerColor1:setColor(ccc3(0,0,0));
  layerColor1:setOpacity(170);
  layerColor1:setPositionXY(0,0)
  self:addChild(layerColor1)   


  self.preTextField = TextField.new(CCLabelTTFStroke:create("上一章", FontConstConfig.OUR_FONT, 46, 2, ccc3(0,0,0), CCSizeMake(260, 75)));
  self:addChild(self.preTextField)
  self.preTextField:setVisible(false)
  -- preTextField:addEventListener(DisplayEvents.kTouchTap, self.onPre, self)
  self.preTextField:setPositionXY(10,0)

  local returnTextField = TextField.new(CCLabelTTFStroke:create("返回", FontConstConfig.OUR_FONT, 46, 2, ccc3(0,0,0), CCSizeMake(260, 75)));
  returnTextField:setPositionXY(620,0)
  self:addChild(returnTextField)
  -- returnTextField:addEventListener(DisplayEvents.kTouchTap, self.onReturn, self)

  self.pageTextField = TextField.new(CCLabelTTFStroke:create("第一章", FontConstConfig.OUR_FONT, 46, 2, ccc3(0,0,0), CCSizeMake(260, 75)));
  self:addChild(self.pageTextField)
  self.pageTextField:setPositionXY(291,0)




end

-- function TopZhuanLayer:onReturn(event)
--   print("onReturn")

-- end

-- function TopZhuanLayer:onPre(event)
--   print("onPre")

-- end
function TopZhuanLayer:setPageCount(count)
  local content
  if count == 1 then
    content = "第一章"
  elseif count == 2 then
    content = "第二章"
  elseif count == 3 then
    content = "第三章"
  else
    content = "第四章"
  end
  self.pageTextField:setString(content);
  if count == 1 then
    self.preTextField:setVisible(false)
  else
    self.preTextField:setVisible(true) 
  end

end





BottomZhuanLayer=class(Layer);

function BottomZhuanLayer:ctor()
  self.class=BottomZhuanLayer;
end

function BottomZhuanLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BottomZhuanLayer.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

function BottomZhuanLayer:initialize()
  self:initLayer();

  self.mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(self.mainSize.width, self.mainSize.height));

  self.touchEnabled = false
  self.touchChildren = false
  self:onUIInit();
end

function BottomZhuanLayer:onUIInit()


  local layerColor1 = LayerColor.new();
  layerColor1:initLayer();
  layerColor1:changeWidthAndHeight(self.mainSize.height, 76);
  layerColor1:setColor(ccc3(0,0,0));
  layerColor1:setOpacity(170);
  layerColor1:setPositionXY(0,0)
  self:addChild(layerColor1)   

  self.nextTextField = TextField.new(CCLabelTTFStroke:create("下一章", FontConstConfig.OUR_FONT, 46, 2, ccc3(0,0,0), CCSizeMake(260, 75)));
  self.nextTextField:setPositionXY(291,0);
  self:addChild(self.nextTextField)

  self.passDescTextField = TextField.new(CCLabelTTFStroke:create("阅读下一章需通关次数:", FontConstConfig.OUR_FONT, 28, 2, ccc3(0,0,0), CCSizeMake(260, 75)));
  self.passDescTextField:setPositionXY(10,-18);
  self:addChild(self.passDescTextField)


  self.passTextField = TextField.new(CCLabelTTFStroke:create("1/1", FontConstConfig.OUR_FONT, 28, 2, ccc3(0,0,0), CCSizeMake(260, 75)));
  self.passTextField:setPositionXY(303,-18);
  self:addChild(self.passTextField)
end

function BottomZhuanLayer:setData(count, needCount)
  self.passTextField:setString(count .. "/" .. needCount);
  if count >= needCount then
    self.passTextField:setColor(ccc3(0,0,0))
    self.passTextField:setVisible(false)
    self.passDescTextField:setVisible(false)

    self.nextTextField:setVisible(true)
  else
    self.passTextField:setColor(ccc3(255,0,0))
    self.passTextField:setVisible(true)
    self.passDescTextField:setVisible(true)

    self.nextTextField:setVisible(false)
  end  
end
