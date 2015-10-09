-----------
--ScreenScale
-----------

ScreenScale = {};

function ScreenScale:initScreen()
      -- self.battleScene = sharedBattleLayerManager().layer;
      -- if self.battleScene and self.battleScene.sprite then
      --     self.battleScene:setContentSize(CCSizeMake(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT));
      --     self.battleScene:setAnchorPoint(CCPointMake(0.5,0.2));
      --     --self.battleScene:setScale(1.25)
      -- end
end
  
function ScreenScale:scaleByNumber(number)
	-- if self.battleScene and self.battleScene.sprite then
 --      self:stopActions();
 --      local scale = CCScaleTo:create(0.4,number);
 --      local scaleEaseOut = CCEaseSineOut:create(scale);
 --      self.battleScene:runAction(scaleEaseOut);
 --  end
end

function ScreenScale:stopActions()
      -- self.battleScene:stopAllActions();
end

function ScreenScale:dispose()
    -- if self.battleScene and self.battleScene.sprite then
    --     self:stopActions();
    -- end
  
    -- self.battleScene = nil;
end
