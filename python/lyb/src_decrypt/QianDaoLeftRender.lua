
QianDaoLeftRender=class(TouchLayer);

function QianDaoLeftRender:ctor()
  self.class=QianDaoLeftRender;
end

function QianDaoLeftRender:dispose()
  self:removeAllEventListeners();
  QianDaoLeftRender.superclass.dispose(self);
end

function QianDaoLeftRender:initialize(context,leiji)
  self.context=context
  self:initLayer();
  self.skeleton = context.skeleton
  local armature= self.skeleton:buildArmature("leftrender");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);
  

  local item1=armature_d:getChildByName("item1");
  local item2=armature_d:getChildByName("item2");
  local item3=armature_d:getChildByName("item2");
  self.item1_pos=convertBone2LB(item1)
  self.item2_pos=convertBone2LB(item2)
  self.item3_pos=convertBone2LB(item3)

  local leijiqiandaolibao_txtTextData = self.armature:getBone("word2").textData;
  self.leijiqiandaolibao =  createTextFieldWithTextData(leijiqiandaolibao_txtTextData, "累计签到礼包");
  self.armature_d:addChild(self.leijiqiandaolibao);

  local totaltab=analysisTotalTableArray("Huodong_Lishileijiqiandao")
  local function sortFun(v1, v2)
    if(v1.Adddays < v2.Adddays) then
      return true;
    elseif v1.Adddays > v2.Adddays then
      return false
    else
      return false;
    end
  end
  table.sort(totaltab, sortFun)
  local nextday;
  for i,v in ipairs(totaltab) do
    if(v.Adddays>leiji) then
      nextday=v.Adddays
      break;
    end
  end
  self.leiji = leiji;
  self.nextday = nextday;

  local perPo
  local tab=analysisByName("Huodong_Lishileijiqiandao","Adddays",nextday)
  for k,v in pairs(tab) do
    perPo=v
  end
  data2=StringUtils:stuff_string_split(perPo.awards)

  local leijiqiandao_txtTextData = self.armature:getBone("word3").textData;
  self.leijiqiandao =  createTextFieldWithTextData(leijiqiandao_txtTextData, leiji.."/"..nextday.."天");
  self.armature.display:addChild(self.leijiqiandao);
  local itemIndex = 1;
  for i,v in ipairs(data2) do
    if v[1] ~= "" then
      self.itemImage = BagItem.new(); 
      self.itemImage:initialize({ItemId = v[1], Count = tonumber(v[2])});
      self.itemImage:setPositionXY(self.item1_pos.x+6,self.item1_pos.y-(itemIndex-1)*(self.item1_pos.y-self.item2_pos.y)+10)
      self.armature_d:addChild(self.itemImage)
      self.itemImage:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self);  

      self.itemImage.touchEnabled=true
      self.itemImage.touchChildren=true
      itemIndex = itemIndex + 1;
    end
  end
  
end
function QianDaoLeftRender:checkPopUpTip()
  return self.leiji + 1 == self.nextday 
end
function QianDaoLeftRender:onItemTip(event)
  self.context:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target,nil,nil,count=event.target.userItem.Count},self))
end
