
require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";

HeroChangeEquipePopup=class(LayerPopableDirect);

function HeroChangeEquipePopup:ctor()
  self.class=HeroChangeEquipePopup;
end

function HeroChangeEquipePopup:dispose()
	HeroChangeEquipePopup.superclass.dispose(self);
end

function HeroChangeEquipePopup:onDataInit()
  -- if self.skeleton then return; end;
  self.skeleton = getSkeletonByName("hero_ui");

  print("wowowowooowwoowowowoo");

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setArmatureInitParam(self.skeleton,"heroEquipe_ui");
  self:setLayerPopableData(layerPopableData);
end

function HeroChangeEquipePopup:initialize()
end

function HeroChangeEquipePopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  self:setContentSize(makeSize(1280,720));  
  self:setVisible(true);


end

function HeroChangeEquipePopup:onUIInit()
  

end

function HeroChangeEquipePopup:onRequestedData()

end

function HeroChangeEquipePopup:onUIClose()
	-- self:dispatchEvent(Event.new("closeNotice",nil,self));
  self.parent:removeChild(self,false);
  -- self:setVisible(false);
end