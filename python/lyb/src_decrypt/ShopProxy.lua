


--杂货商人
-- local sendTable = {ID = FunctionConfig.FUNCTION_ID_156}
-- self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,sendTable));

-- 装备商人
-- local sendTable = {ID = FunctionConfig.FUNCTION_ID_142}
-- self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,sendTable));

-- 积分商城
-- local sendTable = {ID = FunctionConfig.FUNCTION_ID_129}
-- self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,sendTable));

-- 家族商城
-- local sendTable = {ID = FunctionConfig.FUNCTION_ID_130}
-- self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,sendTable));


ShopProxy=class(Proxy);

function ShopProxy:ctor()
  self.class=ShopProxy;
	self.batchUseSkeleton = nil;	--批量使用

  self.RemainSeconds = 0;--神秘商店刷新倒计时
  self.osTime=0;--神秘商店刷新倒计时osTime
  self.IDBooleanArray = nil;--神秘商店刷新道具

end

rawset(ShopProxy,"name","ShopProxy");

--龙骨
function ShopProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("shop_ui");
  end
  return self.skeleton;
end


function ShopProxy:getTypeAndPriceByItemID(itemID, leixingTable)
	local temptable=analysisTotalTable("Shangdian_Shangdianwupin");
    table.remove(temptable,1);
    for k,v in pairs(temptable) do
    	if itemID==v.itemid then
        if leixingTable then
          for k_,v_ in pairs(leixingTable) do
            if v.type==v_ then
              return v.money,v.price;
            end
          end
        else
    		  return v.money,v.price;
        end
    	end
    end
end


function ShopProxy:getItemByType(type)
  local items = analysisByName("Shangdian_Wupinbiao", "type", type)--商店.类型表

  print("!!!!!!!!!!!!!!!!!!!!!!!!!self.curIndex,",self.curIndex)
  local tbl = {};
  for k,v in pairs(items)do
    table.insert(tbl,v)
  end
  local function sortFunc(a,b)
    -- local qa = analysis("Daoju_Daojubiao",a.itemid,"color");
    -- local qb = analysis("Daoju_Daojubiao",b.itemid,"color");
    -- return qa < qb
    -- return a.id < b.id
    return a.sort < b.sort
  end
  table.sort(tbl,sortFunc);

  for k,v in pairs(tbl) do
    print("------------shop-------------:",k,v)
  end

  return tbl;
end


