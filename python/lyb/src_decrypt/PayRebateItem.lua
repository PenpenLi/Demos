
PayRebateItem=class(Layer);

function PayRebateItem:ctor()
    self.class=PayRebateItem;
end

function PayRebateItem:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    PayRebateItem.superclass.dispose(self);
end

function PayRebateItem:initializeItem()
    self:initLayer();
    if self.stateType == "state1" then
    		self:initialize1UI()
	  elseif self.stateType == "state2" then
			self:initialize2UI()
    elseif self.stateType == "state3" then
      self:initialize3UI()
    end
end

function PayRebateItem:initialize1UI()
        local lockBtnNormal = CommonSkeleton.textureAtlasData:getSubTextureData("common_box_close");
        local btnNormal = CommonSkeleton:getBoneTextureDisplay("common_box_close");
        local graySprite = Sprite.new(getGraySprite(btnNormal.sprite,lockBtnNormal.x,lockBtnNormal.y));
        self:addChild(graySprite);
end

function PayRebateItem:initialize2UI()
        local box1Button=CommonButton.new();
        box1Button:initialize("common_box_close","common_box_open",CommonButtonTouchable.BUTTON);
        box1Button:addEventListener(DisplayEvents.kTouchTap,self.onBox1Button,self);
        self:addChild(box1Button);
        self.box1Button = box1Button;
end

function PayRebateItem:initialize3UI()
        local lockBtnNormal = CommonSkeleton.textureAtlasData:getSubTextureData("common_box_open");
        local btnNormal = CommonSkeleton:getBoneTextureDisplay("common_box_open");
        local graySprite = Sprite.new(getGraySprite(btnNormal.sprite,lockBtnNormal.x,lockBtnNormal.y));
        self:addChild(graySprite);
end

function PayRebateItem:onBox1Button(event)
        local table = {Level = self.itemId}
        sendMessage(3, 18, table);
end

