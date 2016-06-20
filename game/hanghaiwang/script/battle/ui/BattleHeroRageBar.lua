



local BattleHeroRageBar = class("BattleHeroRageBar",function () return CCLayerRGBA:create() end)
  
 	------------------ properties ----------------------
 BattleHeroRageBar.isBig      = nil
 BattleHeroRageBar.isSuper    = nil
 BattleHeroRageBar.isOutline    = nil
 BattleHeroRageBar.value      = nil
 BattleHeroRageBar.uimode     = nil
 BattleHeroRageBar.ui         = nil

 BattleHeroRageBar.LESS_FOUR    = 1
 BattleHeroRageBar.EQUAL_FOUR   = 2
 BattleHeroRageBar.BIG_FOUR     = 3
 BattleHeroRageBar.psize        = nil
 	------------------ functions -----------------------
  
  function BattleHeroRageBar:releaseUI()
    if(self.ui ~= nil and not tolua.isnull(self.ui)) then
            self.ui:releaseUI()
    end
    self.ui = nil
  end
 
  
 	function BattleHeroRageBar:ctor( isBig , isSuper ,isOutline)
    self.isSuper    = isSuper or false
    self.isBig      = isBig or false
    self.isOutline  = isOutline or false
    self.value    = 0
    self.uimode   = 0
    print("==== BattleHeroRageBar isOutline 1",self.isOutline)
    -- self:setCascadeOpacityEnabled(true)
    -- self:setCascadeColorEnabled(true)
    -- self:set
 	end
 
  function BattleHeroRageBar:generateUI( mode )
      if(self.uimode ~= mode) then
         self.uimode = mode
         self:releaseUI()

         if(self.uimode == self.LESS_FOUR) then
            self.ui = require("script/battle/ui/BattleHeroRageImageBar").new()
             -- self.ui = require("script/battle/ui/BattleHeroRageImageBarFour").new()
            -- Logger.debug("generateUI: < 4")
         elseif(self.uimode == self.BIG_FOUR) then
            self.ui = require("script/battle/ui/BattleHeroRageImageBarFour").new()
            -- self.ui = require("script/battle/ui/BattleHeroRageImageBar").new()
             -- self.ui = require("script/battle/ui/BattleHeroRageImageBarFour").new()
             -- Logger.debug("generateUI: > 4")
         elseif(self.uimode == self.EQUAL_FOUR and g_system_type == kBT_PLATFORM_IOS) then
            self.ui = require("script/battle/ui/BattleHeroRageAnimationBar").new()
             -- self.ui = require("script/battle/ui/BattleHeroRageImageBarFour").new()
            -- Logger.debug("generateUI: == 4")
         else
            self.ui = require("script/battle/ui/BattleHeroRageImageBar").new()
              -- Logger.debug("generateUI: < 4")
            -- self.ui = require("script/battle/ui/BattleHeroRageImageBarFour").new()
         end
         print("==== BattleHeroRageBar isOutline 2",self.isOutline)
         self.ui:reset(self.isBig,self.psize,self.isSuper,self.isOutline)

         self:addChild(self.ui)

         -- self.ui:setPosition(12,24)
      end
  end
   function BattleHeroRageBar:setDisplayVisible( value )
    -- Logger.debug("--- BattlPlayerDisplay:setVisible 2")
       if(value == false) then
        -- Logger.debug("--- BattlPlayerDisplay:setVisible 3")
            self.ui:releaseUI()
        end
   end
 	function BattleHeroRageBar:setValue(value)
 		-- if(value < 0) then value 	= 0 end
 		-- if(value > 4) then value 	= 5 end
    -- --print("BattleHeroRageBar:setValue:from->",self.value," to->",value)
    -- if(self.value == 4 and value == 2) then
    --   error("BattleHeroRageBar:setValue error push")
    -- end
    -- Logger.debug("BattleHeroRageBar:setValue " .. value)
    -- value = 5
 	if(self.value == value or self:getParent() == nil) then
      return 
    end
     
    self.value 					= value
    local  nextmode
    if(self.value < 4) then
        nextmode = self.LESS_FOUR
        -- nextmode = self.BIG_FOUR
        -- nextmode = self.BIG_FOUR
    elseif self.value == 4 then
        if(g_system_type ~= kBT_PLATFORM_IOS) then
            nextmode = self.LESS_FOUR
        else
            nextmode = self.EQUAL_FOUR
        end
        -- nextmode = self.BIG_FOUR
    else
        nextmode = self.BIG_FOUR
    end

    self:generateUI(nextmode)
    self.ui:setValue(self.value)
 
  end
 
 return BattleHeroRageBar