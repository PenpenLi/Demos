	-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
	-- Create date: 2013-2-17

	-- yanchuan.xie@happyelements.com

require "core.display.Layer";
require "core.display.BitmapTextField";
require "core.events.DisplayEvent";
require "core.utils.CommonUtil";

CommonButtonTouchable={
  BUTTON="button",
  CUSTOM="custom",
  DISABLE="disable"
};

CommonButton=class(Layer);

function CommonButton:ctor()
  self.class=CommonButton;
  self.buttonId = 0;
end

function CommonButton:dispose()
  self:removeTextures();
	self:removeAllEventListeners();
	CommonButton.superclass.dispose(self);
end

function CommonButton:initialize(normal, touch, touchable, skeleton_nil, musicID, ignoreMusic)
  self.class=CommonButton;
	self.frame={normal,touch};
	self.skeleton=skeleton_nil and skeleton_nil or CommonSkeleton;
  self.frameList={};
  self.grayFrameList={};
  self.frame_target=self.frameList;
  self.isSelected=false;
  self.isGray=false;
  if musicID then
    self.musicID = musicID;
  elseif self.frame[1]=="common_return_button_normal" or self.frame[1]=="common_close_button_normal" then
    self.musicID = 8;
  else
    self.musicID = 7;
  end
  
	if CommonButtonTouchable.BUTTON==touchable then
		self:addEventListener(DisplayEvents.kTouchBegin,self.onBegin,self);
		self:addEventListener(DisplayEvents.kTouchEnd,self.onEnd,self);
  elseif CommonButtonTouchable.DISABLE==touchable then
    self.touchEnabled=false;
    self.touchChildren=false;
	end
  
  self.ignoreMusic = ignoreMusic
  
  self:initLayer();
  self:onEnd();
end

function CommonButton:initializeText(text_data, text_string, hasStroke, useMultiColor, offset_down)
  if not self.textField and not self.bmTextField then
    if nil~=text_string then
      if self:contains(self.textField) then
         self:removeChild(self.textField,true);
      end
      text_data=copyTable(text_data);
      text_data.y=self.const+text_data.y;
      if not useMultiColor then
        self.textField=createTextFieldWithTextData(text_data,text_string, hasStroke);
        self:addChild(self.textField);
      else
        self.textField=createRichMultiColoredLabelWithTextData(text_data,text_string);
        self:addChild(self.textField);
      end
      self.offset_down=offset_down
  		self.textField.touchChildren = false;
  		self.textField.touchEnabled = false;
      self.textFieldPos=self.textField:getPosition()
    end
  end
end

function CommonButton:initializeBMText(normal_text_string, normal_file_name_string, down_text_string, down_file_name_string, normal_position_point, down_position_point)
  if not self.textField and not self.bmTextField then
    if normal_text_string and normal_file_name_string then
      self.bmTextData = {};
      self.bmTextFieldList = {};
      table.insert(self.bmTextData, {normal_text_string, normal_file_name_string, normal_position_point});
      if down_text_string and down_file_name_string then
        table.insert(self.bmTextData, {down_text_string, down_file_name_string, down_position_point});
      end
      self.bmTextField = BitmapTextField.new(self.bmTextData[1][1],self.bmTextData[1][2]);
      if self.bmTextData[1][3] then
        self.bmTextField:setPosition(self.bmTextData[1][3]);
      else
        local size = self.frame_target[1]:getContentSize();
        local bm_size = self.bmTextField:getContentSize();
        self.bmTextField:setPositionXY((size.width-bm_size.width)/2,(size.height-bm_size.height)/2);
      end
      self:addChild(self.bmTextField);
      table.insert(self.bmTextFieldList, self.bmTextField);
    end
  end
end

function CommonButton:onBegin(event)
  self:select(true);
  if GameData.isMusicOn and not self.ignoreMusic then
    MusicUtils:playEffect(self.musicID,false);
  end  
end

function CommonButton:onEnd(event)
  self:select(false);
end

function CommonButton:setString(text_string)
  self:refreshText(text_string);
end
function CommonButton:refreshText(text_string)
  if self.textField then
    self.textField:setString(text_string);
  end
  if self.bmTextField then
    self.bmTextField:setString(text_string);
  end
end

function CommonButton:removeTextures()
  for k,v in pairs(self.frameList) do
    if self:contains(v) then
      self:removeChild(v,false);
    end
    v:dispose();
  end
  for k,v in pairs(self.grayFrameList) do
    if self:contains(v) then
      self:removeChild(v,false);
    end
    v:dispose();
  end
  if self.textField then
    if self:contains(self.textField) then
      self:removeChild(self.textField,false);
    end
    self.textField:dispose();
  end
  if self.bmTextFieldList then
    for k,v in pairs(self.bmTextFieldList) do
      if self:contains(v) then
        self:removeChild(v,false);
      end
      v:dispose();
    end
  end
end

function CommonButton:select(slt, shift)
  self.isSelected=slt;

  if self:getChildAt(0) then
    self:removeChildAt(0,false);
  end
	if slt then
    -- if GameData.isMusicOn and not self.ignoreMusic then
    --   MusicUtils:playEffect(self.musicID,false);
    --   log("self.musicID=="..self.musicID)
    -- end
    if self.frame[2] then
    	if nil==self.frame_target[2] then
	      local display = self:getDisplay(self.frame[2],self.isGray);
	      --local size = display:getContentSize();
	      --display:setScale(0.9);
	      --display:setPositionXY(0.05*size.width,0.05*size.height);
	      table.insert(self.frame_target,display);
	    end
	    self:addChildAt(self.frame_target[2],0);
      if shift then
        local size1 = self.frame_target[1]:getContentSize();
        local size2 = self.frame_target[2]:getContentSize();
        self.frame_target[2]:setPositionXY((size1.width - size2.width)/2, (size1.height - size2.height)/2);
      end
  	else
  		self:addChildAt(self.frame_target[1],0);
    end

    if self.bmTextData and self.bmTextData[2] then
      if not self.bmTextFieldList[2] then
        local bmTextField = BitmapTextField.new(self.bmTextData[2][1],self.bmTextData[2][2]);
        if self.bmTextData[2][3] then
          bmTextField:setPosition(self.bmTextData[2][3]);
        else
          local size = self.frame_target[1]:getContentSize();
          local bm_size = bmTextField:getContentSize();
          bmTextField:setPositionXY((size.width-bm_size.width)/2,(size.height-bm_size.height)/2);
        end
        table.insert(self.bmTextFieldList, bmTextField);
      end
      self:removeChild(self.bmTextField,false);
      self:addChild(self.bmTextFieldList[2]);
    end
    if not self.frame[2] then
      if not self.offset_on_frame then
        self.offset_on_frame = self.frame_target[1]:getContentSize();
      end
      self.frame_target[1]:setScale(0.9);
      self.frame_target[1]:setPositionXY(0.05*self.offset_on_frame.width,0.05*self.offset_on_frame.height);
      if self.bmTextField then
        self.bmTextField:setScale(0.9);
        local size = self.frame_target[1]:getContentSize();
        local bm_size = self.bmTextField:getContentSize();
        self.bmTextField:setPositionXY((size.width-0.9*bm_size.width)/2,(size.height-0.9*bm_size.height)/2);
      end
      if self.textField then
        self.textField:setScale(0.9);
        local size = self.frame_target[1]:getContentSize();
        local bm_size = self.textField:getContentSize();
        self.textField:setPositionXY((size.width-0.9*bm_size.width)/2,(size.height-0.9*bm_size.height)/2);
      end
    end
    if self.offset_down then
        self.textField:setPositionXY(self.textFieldPos.x+self.offset_down.x,self.textFieldPos.y+self.offset_down.y);
    end

	else
    if self.offset_down then
        self.textField:setPositionXY(self.textFieldPos.x,self.textFieldPos.y);
    end
    if nil==self.frame_target[1] then

      table.insert(self.frame_target,self:getDisplay(self.frame[1],self.isGray));
      self:setContentSize(self.frame_target[1]:getContentSize());
      if not self.const then
        self.const=self.frame_target[1]:getContentSize().height;
      end
    end
		self:addChildAt(self.frame_target[1],0);
    if not self.frame[2] then
      self.frame_target[1]:setScale(1);
      self.frame_target[1]:setPositionXY(0,0);
      if self.bmTextField then
        self.bmTextField:setScale(1);
        local size = self.frame_target[1]:getContentSize();
        local bm_size = self.bmTextField:getContentSize();
        self.bmTextField:setPositionXY((size.width-bm_size.width)/2,(size.height-bm_size.height)/2);
      end
      if self.textField then
        self.textField:setScale(1);
        -- local size = self.frame_target[1]:getContentSize();
        -- local bm_size = self.textField:getContentSize();
        -- self.textField:setPositionXY((size.width-0.9*bm_size.width)/2,(size.height-0.9*bm_size.height)/2);
        self.textField:setPosition(self.textFieldPos);
      end
    end

    if self.bmTextData and self.bmTextData[2] then
      if self.bmTextFieldList[2] then
        self:removeChild(self.bmTextFieldList[2],false);
        self:addChild(self.bmTextField);
      end
    end
	end
end

function CommonButton:setGray(boolean, touchable)
  if boolean==self.isGray then
    return;
  end
  self.isGray=boolean;

  local touch;
  if touchable ~= nil then
     touch = touchable
  else
     touch = not self.isGray
  end
  self.touchEnabled=touch;
  self.touchChildren=touch;
  self.frame_target=self.isGray and self.grayFrameList or self.frameList;
	if self.textField then
		if 255 == self.textField:getColor().r and 255 == self.textField:getColor().g and 255 == self.textField:getColor().b then
			
		else
			self.textField:setGray(boolean);
		end
	end
  self:select(false);
end

function CommonButton:getDisplay(str, isGray)
  local disp=self.skeleton:getBoneTextureDisplay(str);
  if not disp then
    disp=self.skeleton:getBoneTextureDisplay("commonButtons/" .. str);
  end
  if isGray then
    local data=self.skeleton.textureAtlasData:getSubTextureData(str);
    if not data then
      data=self.skeleton.textureAtlasData:getSubTextureData("commonButtons/" .. str);
    end
    disp=Sprite.new(getGraySprite(disp.sprite,data.x,data.y));
  end
  
  return disp;
end

function CommonButton:getText()
  if self.textField then
    return self.textField:getString();
  end
end

function CommonButton:getIsSelected()
  return self.isSelected;
end