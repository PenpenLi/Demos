require "main.view.huoDong.ui.render.ChongJiYouLiRender"
ChongJiYouLi=class(TouchLayer);

function ChongJiYouLi:ctor()
  self.class=ChongJiYouLi;
end

function ChongJiYouLi:dispose()
  -- self:disposeRefreshTime();
  self:removeChildren();
  ChongJiYouLi.superclass.dispose(self);
  self.armature:dispose()
  -- BitmapCacher:removeUnused();
end

function ChongJiYouLi:initialize(context,id)
  self.context=context
  self.huodongProxy =  context.huodongProxy;
  self.bagProxy = context.bagProxy;
  self.id = id;
  self:initLayer();
  self.skeleton = context.skeleton
  local armature= self.skeleton:buildArmature("chongjiyouli_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);


  local render1=armature_d:getChildByName("render1");
  local render2=armature_d:getChildByName("render2");
  self.render_pos=convertBone2LB(render1);
  self.render_width=render1:getGroupBounds().size.width;
  self.render_height=render1:getPositionY()-render2:getPositionY()


  self.list_x = self.render_pos.x;
  self.list_y = self.render_pos.y + render1:getContentSize().height;

  armature_d:removeChild(render1);
  armature_d:removeChild(render2);
  
  self.listScrollViewLayer=ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setPositionXY(self.list_x, self.list_y - 560);
  self.listScrollViewLayer:setViewSize(makeSize(self.render_width, 560));
  self.listScrollViewLayer:setItemSize(makeSize(self.render_width, self.render_height));
  self.listScrollViewLayer:setDirection(kCCScrollViewDirectionVertical);
  self.armature_d:addChild(self.listScrollViewLayer)
  
end

function ChongJiYouLi:refreshData()
  
print("function ChongJiYouLi:refreshData()")
  self.tab=self.context.huodongProxy:getData2()
    print("function ChongJiYouLi:refreshData() ", #self.tab[1].ActivityConditionArray);
  if(#self.tab[1].ActivityConditionArray~=1) then
    -- 为初始化数据
    if self.listScrollViewLayer then
      self.listScrollViewLayer:removeAllItems();
    end
    local function sortFun(v1, v2)
      if(v1.MaxCount < v2.MaxCount) then
        return true;
      elseif v1.MaxCount> v2.MaxCount then
        return false
      else
        return false;
      end
    end
    table.sort(self.tab[1].ActivityConditionArray, sortFun)
    self.tab2=self.tab[1].ActivityConditionArray
    local booleanValue = 0;
    for i,v in ipairs(self.tab[1].ActivityConditionArray) do
        local render=ChongJiYouLiRender.new()
        render:initialize(self,v)
        self.listScrollViewLayer:addItem(render)
        print("addItem", i)
        if v.Count >= v.MaxCount and v.BooleanValue == 0 then
          booleanValue = 1;
        end
    end
    self.huodongProxy:setReddotDataByID(self.id, booleanValue);
    self.context:refreshMainHuoDongReddot();
    if booleanValue == 1 then
        self.context:renderDotVisible(self.id, true);
    else
        self.context:renderDotVisible(self.id, false);
    end
  else
    -- 活动确认数据
    local index
    for i,v in ipairs(self.tab2) do
      if(v.ConditionID==self.tab[1].ActivityConditionArray[1].ConditionID) then
        index=i
        self.tab2[i].BooleanValue = self.tab[1].ActivityConditionArray[1].BooleanValue;
        break
      end
    end
    self.listScrollViewLayer:removeItemAt(index-1)
    print("look here",index)
    local render=ChongJiYouLiRender.new()
    render:initialize(self,self.tab[1].ActivityConditionArray[1])
    self.listScrollViewLayer:addItemAt(render,index-1,true)

    -- 刷新活动小红点
    self.context:refreshRenderDot(self.id, self.tab2)
    self.context:refreshMainHuoDongReddot();
  end
end


function ChongJiYouLi:takeAward(conditionID)
  -- self.context.huodongProxy:takeAward(self.id, conditionID) 
end
