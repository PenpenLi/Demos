--[[

]]


OpenFactionCurrencyCommand=class(Command);

function OpenFactionCurrencyCommand:ctor()
	self.class=OpenFactionCurrencyCommand;
end

function OpenFactionCurrencyCommand:execute()
  self:require();

  self.factionCurrencyMediator=self:retrieveMediator(FactionCurrencyMediator.name);  

  if nil == self.factionCurrencyMediator then
    self.factionCurrencyMediator=FactionCurrencyMediator.new();
    self:registerMediator(self.factionCurrencyMediator:getMediatorName(),self.factionCurrencyMediator);
  end
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(self.factionCurrencyMediator:getViewComponent());

end



function OpenFactionCurrencyCommand:require()
  require "main.view.faction.FactionCurrencyMediator";
end