XunbaoProxy=class(Proxy);

function XunbaoProxy:ctor()
	self.class=XunbaoProxy;
	self.skeleton = nil
	self.xunbaoData = {}
	self.isFromXunbao = false
	self.isPop = false
end

function XunbaoProxy:getSkeleton()
    if nil==self.skeleton then
      self.skeleton=SkeletonFactory.new();
      self.skeleton:parseDataFromFile("xunbao_ui");
    end
    return self.skeleton;
end
-- refresh data
function XunbaoProxy:setData(dataTable)
	self.xunbaoData = dataTable
end
-- refresh data
function XunbaoProxy:refreshData(place,state)
	self.xunbaoData.place = place
	self.xunbaoData.state = state
end
-- refresh data
function XunbaoProxy:refreshWenhaoData(wenhaoTable)
	for k,v in pairs(self.xunbaoData.hunkTaskArray) do
		if v.Place == wenhaoTable.Place then
			self.xunbaoData.hunkTaskArray[v.Place] = wenhaoTable
			break;
		end
	end
end
-- get data
function XunbaoProxy:getData()
	return self.xunbaoData
end

rawset(XunbaoProxy,"name","XunbaoProxy");
