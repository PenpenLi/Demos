--[[
    点击主界面按钮按开启功能顺序列出
    @zhangke
]]

ClickMenuCommand=class(Command);

function ClickMenuCommand:ctor()
	self.class=ClickMenuCommand;
end

function ClickMenuCommand:execute(notification)
 
	local userProxy = self:retrieveProxy(UserProxy.name)
	local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
    local isClose
    if notification.data then
        isClose = notification.data.isClose
    end
    
	-- 判断都开启了哪些功能 todo
	--local displayHMenuTable1 = {6,5,4,3,2,1}
	--local displayMenuVTable = {2,1}
	local displayHMenuTable1 = openFunctionProxy:getOpenedHMenu1()
	local displayMenuVTable = openFunctionProxy:getOpenedVMenu()
	local displayMenuUpTable = openFunctionProxy:getOpenedLeftMenu()
	local everydayTaskMenu = openFunctionProxy:getOpenedEverydayTaskMenu()
		
	local mainMediator = self:retrieveMediator(MainSceneMediator.name)
	mainMediator:openMenu(displayHMenuTable1,displayHMenuTable2,displayMenuVTable,displayMenuUpTable,everydayTaskMenu, isClose,userProxy.sceneType)
  
	-- local mainType = 2
	-- local subType = 1
	-- local content = "<content><font color='#ffffff'>今日还可吞食</font><font color=".."\'".."#00ff00".."\'"..">"..mainType.."</font><font color='#ffffff'> 颗英雄胆</font></content>"
	
	-- if not mainMediator then
		-- return
	-- end
	-- if mainType == 2 then
		-- if subType == 1 then
			-- mainMediator:playGuangbo(content)
		-- elseif subType == 2 then
		
		-- end
	-- elseif mainType == 3 then
		-- if subType == 1 then
		
		-- else
		
		-- end
	-- end  
end