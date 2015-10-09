-- open xunbao

Handler_8_6=class(MacroCommand);
 
function Handler_8_6:ctor()
	self.class=Handler_8_6;
end

function Handler_8_6:execute()

	local xunbaoProxy = self:retrieveProxy(XunbaoProxy.name)
	if xunbaoProxy.isPop then
		return
	end

	hecDC(3,27,1)
	-- refresh data
	local dataTable = {}
	dataTable.place = recvTable["Place"]
	dataTable.state = recvTable["State"]
	dataTable.rollCount = recvTable["Count"]
	dataTable.hunkTaskArray = recvTable["HunkTaskArray"]
	xunbaoProxy:setData(dataTable)

	-- call ui
	require "main.view.xunbao.XunbaoMediator";
	require "main.controller.command.xunbao.CloseXunbaoCommand";
  
	local xunbaoMediator = self:retrieveMediator(XunbaoMediator.name);  
	if not xunbaoMediator then
		xunbaoMediator = XunbaoMediator.new();
		self:registerMediator(xunbaoMediator:getMediatorName(),xunbaoMediator);
		self:registerCommand(XunbaoNotifications.CLOSE_XUNBAO, CloseXunbaoCommand);
	end
	self:observe(CloseXunbaoCommand);
	
	xunbaoProxy.isPop = true
	LayerManager:addLayerPopable(xunbaoMediator:getViewComponent());

	if GameVar.tutorStage == TutorConfig.STAGE_1020 then--1020是寻宝
		openTutorUI({x=547, y=200, width = 192, height = 52});
	end

end
Handler_8_6.new():execute();