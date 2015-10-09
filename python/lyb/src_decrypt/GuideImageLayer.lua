GuideImageLayer = class(Layer);

function GuideImageLayer:ctor()
  self.class = GuideImageLayer;  
end

function GuideImageLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  GuideImageLayer.superclass.dispose(self);
end

function GuideImageLayer:initLayerData1(heroID,descriptString,px,py,customX)
  self:initLayer()

  local art1 = analysis("Kapai_Kapaiku", heroID, "art1");

  self.imageBg = getImageByArtId(art1);
  self.imageBg:setScale(0.4)
  self:addChild(self.imageBg);

  local text_data={x=0,y=0,width=200,height=0,size=26,alignment=0,color=0xffffff};
  self.textField = MultiColoredLabel.new(descriptString, FontConstConfig.OUR_FONT, 22,  CCSizeMake(200, 70), kCCTextAlignmentLeft);
  local size = self.textField:getContentSize()
  self.textField:setPositionXY(240,(122-size.height)/2);
  self:addChild(self.textField)

  local width = self.imageBg:getContentSize().width
  self:setPositionXY(-width,py)
  self.imageWidth = width
  self.imageX = (not customX) and px or customX
end


function GuideImageLayer:initLayerData2(xinshouId,customX)
  local xinshouPO = analysis("Xinshouyindao_Xinshou",xinshouId)
  self:initLayerData1(xinshouPO.heroID,xinshouPO.Dialogue,xinshouPO.X,xinshouPO.Y,customX)
end

function GuideImageLayer:startAnimation()
  self:setVisible(true)
  self:setPositionXY(-self.imageWidth,self:getPositionY())
  local function backFun1()
      local array = CCArray:create()
      local moveTo = CCEaseSineInOut:create(CCMoveBy:create(0.8, ccp(15, 0)))
      local moveBack = CCEaseSineInOut:create(CCMoveBy:create(0.8, ccp(-15, 0)))
      local callBack2 = CCCallFunc:create(backFun2);
      array:addObject(moveBack)
      array:addObject(moveTo)
      self:runAction(CCRepeatForever:create(CCSequence:create(array)));
  end
  local ccArray = CCArray:create();
  ccArray:addObject(CCEaseSineOut:create(CCMoveTo:create((self.imageX+self.imageWidth)/1000, ccp(self.imageX, self:getPositionY()))));
  ccArray:addObject(CCCallFunc:create(backFun1));
  self:runAction(CCSequence:create(ccArray));
end

function GuideImageLayer:stopAndVisible(bool)
  self:stopAllActions()
  self:setVisible(bool)
  self:setPositionXY(-self.imageWidth,self:getPositionY(),true)
end

