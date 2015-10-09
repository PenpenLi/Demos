--[[
		2015-07-20 add by mohai.wu 
]]

SevenDaysProxy = class(Proxy);

function SevenDaysProxy:ctor(  )
	self.class = SevenDaysProxy;
	self.SevenDaysData = {}
end

rawset(SevenDaysProxy, "name", "SevenDaysProxy");


function SevenDaysProxy:setData(tab )
	self.SevenDaysData[tab[1]["ID"]] = tab[1]["ActivityConditionArray"];
end

--龙骨
function SevenDaysProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("sevendays_ui");
  end
  return self.skeleton;
end