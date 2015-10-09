--脚本中POP对话
TextAnimationDialog = class(Layer);
function TextAnimationDialog:ctor()
  self.class = TextAnimationDialog;  
  self.index = 0;
  self.name = "TextAnimationDialog";
  self.textTable = {};
end

function TextAnimationDialog:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  if self.armature then
      self.armature:dispose()
      self.armature = nil
  end
  TextAnimationDialog.superclass.dispose(self);
end

function TextAnimationDialog:initAnimation()
  self.touchChildren = false;
  self.touchEnabled = false;
end

function TextAnimationDialog:textAnimation(dialogString,faceDirect,roleVO,isNeedRemove)
  self:hanZiText(dialogString)
  -- self:setScale(0);
  self:oneAnimation(roleVO);
  self.isNeedRemove = isNeedRemove
end

function TextAnimationDialog:setVisibleDialog(bool)
  self:stopAllActions()
  self:setVisible(bool)
  self:setPositionXY(0,0,true)
end

function TextAnimationDialog:oneAnimation(roleVO)
        ----------------
        -- two animation Complete
        ----------------
        local function twoAnimationComplete()
          if not self.isNeedRemove then
            self:setVisible(false)
            roleVO.isPopDialogIng = nil
          else
            self.parent:removeChild(self)
          end
        end
        ----------------
        -- two animation
        ----------------
        -- local function twoAnimation()
        --         local upCallBack = CCCallFunc:create(twoAnimationComplete);
        --         local fadeOut = CCFadeTo:create(0.2, 1);
        --         local arr = CCArray:create();
        --         -- local delay = CCDelayTime:create(0.5);
        --         -- arr:addObject(delay);
        --         arr:addObject(fadeOut)
        --         arr:addObject(upCallBack);
        --         self:runAction(CCSequence:create(arr));
        -- end
        ----------------
        -- one animation
        ---------------- 
        -- local timeOne = 0.1
        local array = CCArray:create();
        local callBack = CCCallFunc:create(twoAnimationComplete);
        local upDelay = CCDelayTime:create(1.5);
        -- local fadeTo1 = CCFadeTo:create(0, 0);
        -- local fadeTo2 = CCFadeTo:create(1, timeOne);
        -- local moveUp = CCMoveBy:create(timeOne, ccp(0,180));
        -- local scale1 = CCScaleTo:create(timeOne,1);
        --local scale1EaseOut = CCEaseElasticOut:create(scale1,timeOne);
        
        -- array:addObject(fadeTo1);
        -- array:addObject(fadeTo2);
        array:addObject(upDelay);
        array:addObject(callBack);
        self:runAction(CCSequence:create(array));
end

----------------
--hanZi
----------------
function TextAnimationDialog:hanZiText(dialogString)
    if not self.nameText then
        local imageBg = getImageByArtId(1572)
        self:addChild(imageBg)
        local text_data={x=0,y=0,width=200,height=128,size=22,alignment=0,color=0xffffff};
        self.nameText = createTextFieldWithTextData(text_data,"");
        self.nameText:setPositionXY(28,-30)
        self:addChild(self.nameText);
    end
    self.nameText:setString(dialogString)
end
