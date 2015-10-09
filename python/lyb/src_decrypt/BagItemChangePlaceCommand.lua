BagItemChangePlaceCommand=class(Command);

function BagItemChangePlaceCommand:ctor()
	self.class=BagItemChangePlaceCommand;
end

function BagItemChangePlaceCommand:execute(notification)
  local data=notification:getData();
	print("请求 移动物品位置","SrcPlace",data.SrcPlace,"TargetPlace",data.TargetPlace);
  if(connectBoo) then
    sendMessage(9,3,data);
  end
end