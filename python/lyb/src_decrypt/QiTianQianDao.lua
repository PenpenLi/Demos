require "main.view.huoDong.ui.render.QiandaoItem"

QiTianQianDao=class(TouchLayer);

function QiTianQianDao:ctor()
  self.class=QiTianQianDao;
end

function QiTianQianDao:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  QiTianQianDao.superclass.dispose(self);
  self.armature:dispose()
end

function QiTianQianDao:initialize(context,id)
  self.context=context
  self.id = id;
  self:initLayer();
  self.skeleton = context.skeleton
  local armature= self.skeleton:buildArmature("qitianqiandao_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);
  
  local item1=armature_d:getChildByName("item1");
  local item2=armature_d:getChildByName("item2");
  local item3=armature_d:getChildByName("item3");
  
  self.item_width=item1:getGroupBounds().size.width
  self.item_height=item1:getGroupBounds().size.height

  self.item_pos = item1:getPosition();

  self.item_distanceX = item2:getPositionX()-item1:getPositionX()
  self.item_distanceY = item1:getPositionY()-item3:getPositionY()

  armature_d:removeChild(item1);
  armature_d:removeChild(item2);
  armature_d:removeChild(item3);

  self.itemTable = {};

  for i=1,7 do
    local qiandaoItem = QiandaoItem.new();
    qiandaoItem:initialize(self, i)
    local x = self.item_pos.x + (i-1)%4*self.item_distanceX;
    local y = self.item_pos.y - (math.ceil(i/4)-1)*self.item_distanceY;
    qiandaoItem:setPosition(ccp(x, y))
    self:addChild(qiandaoItem)
    table.insert(self.itemTable, qiandaoItem);
  end
  
end

function QiTianQianDao:refreshData()
  self.tab=self.context.huodongProxy:getData2()
  for i,v in ipairs(self.tab) do 
   
    if #v.ActivityConditionArray == 7 then
       for i,v1 in ipairs(v.ActivityConditionArray) do
          if #self.itemTable >=1 then
              self.itemTable[i]:refreshImageAndNumber(v1.ItemIdArray);
              self.itemTable[i]:refreshState(v1.Count,v1.MaxCount,v1.ConditionID, tonumber(v1.BooleanValue));
          end
        end
    elseif  #v.ActivityConditionArray == 1 then
      v1 = v.ActivityConditionArray[1];
      
      for k2,v2 in pairs(v1) do
        print(k2,v2)
      end
      self.itemTable[tonumber(v1.MaxCount)]:refreshState(v1.Count,v1.MaxCount,v1.ConditionID, tonumber(v1.BooleanValue));
      print("function QiTianQianDao:refreshData()")   
      self.context.huodongProxy:setReddotDataByID(3, 0);   
      self.context:renderDotVisible(3, false);
    end
    

  end
end
function QiTianQianDao:takeAward(conditionID)
  self.context.huodongProxy:takeAward(self.id, conditionID) 
end

function QiTianQianDao:onButtonGo(event) 
    sendMessage(24,32,{CDKey=self.textInput:getString()})
end