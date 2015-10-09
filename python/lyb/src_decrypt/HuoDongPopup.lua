require "core.display.LayerPopable";
require "core.controls.CommonLayer";
require "core.controls.ScrollSelectButton";
require "main.view.huoDong.ui.render.ChongJiYouLi"
require "main.view.huoDong.ui.render.LiBaoDuiHuan"
require "main.view.huoDong.ui.render.LeftRender"
require "main.view.huoDong.ui.render.QiTianQianDao"

require "main.view.huoDong.ui.render.ChongZhiFanHuan"
require "main.view.huoDong.ui.render.ChongZhiFanHuanAD"
require "main.view.huoDong.ui.render.GrowthFund"
require "main.view.huoDong.ui.render.KaifuGift"
require "main.view.huoDong.ui.render.VIPWelfare"
-- require "main.view.huoDong.ui.render.PrizeGiving.PrizeGiving" 活动取消
HuoDongPopup=class(LayerPopableDirect);

function HuoDongPopup:ctor()
  self.class=HuoDongPopup;
  self.bg_image = nil;
end
function HuoDongPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  HuoDongPopup.superclass.dispose(self);
  self.armature:dispose()
  BitmapCacher:removeUnused();
end
function HuoDongPopup:onDataInit()
  self.herohouseProxy=self:retrieveProxy(HeroHouseProxy.name)
  self.huodongProxy=self:retrieveProxy(HuoDongProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name)
  self.bagProxy = self:retrieveProxy(BagProxy.name);

  self.skeleton = self.huodongProxy:getSkeleton();
  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(true)
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton,"huodong_ui")
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData)
end


function HuoDongPopup:initialize()
  self.context=self
  self.channel=1;
  self.tabofrightrender={}
  self:initLayer();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
end

function HuoDongPopup:onPrePop()
  
  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
    
  local render1=armature_d:getChildByName("leftrender1");
  local render2=armature_d:getChildByName("leftrender2");
  
  self.render_width=render1:getGroupBounds().size.width
  self.render_height=render1:getGroupBounds().size.height
  self.render_pos=convertBone2LB(render1)
  self.render_width=render1:getContentSize().width
  self.render_height=render1:getPositionY()-render2:getPositionY()
  self.list_x = self.render_pos.x;
  self.list_y = self.render_pos.y + render1:getContentSize().height;

  armature_d:removeChild(render1);
  armature_d:removeChild(render2);

  self.rightbg_pos=convertBone2LB(armature_d:getChildByName("rightbg"));

  self.listScrollViewLayer=ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setPositionXY(self.list_x, self.list_y - 577);
  self.listScrollViewLayer:setViewSize(makeSize(175, 577));
  self.listScrollViewLayer:setItemSize(makeSize(162, 162));
  self.listScrollViewLayer:setDirection(kCCScrollViewDirectionVertical);
  self.listScrollViewLayer.touchEnabled=true;
  self.listScrollViewLayer.touchChildren=true
  self:addChild(self.listScrollViewLayer);
  self.tabofrender={}

  self:setData();

end


function HuoDongPopup:setData()
  self.tab=self.huodongProxy:getData()

  print("\n\n\n\nfunction HuoDongPopup:setData() ", self.tab);
  if #self.tabofrender ~= 0 then
    print("HuoDongPopup:setData() update Data")
    --表示更新数据，不是初始化
    for k,v in pairs(self.tabofrender) do
      for k1,v1 in pairs(self.tab) do
        if v.ID == v1.ID then
          v.BooleanValue = v1.BooleanValue;
          v.reddot:setVisible(v1.BooleanValue);
        end
      end
    end
    self:refreshData();
    return;
  end


  if self.tab then
    --对tab数组根据sortID由小到大排序
    local function sortFun(v1, v2)
      if(v1.Sort < v2.Sort) then
        return true;
      elseif v1.Sort> v2.Sort then
        return false
      else
        return false;
      end
    end
    table.sort(self.tab, sortFun)
    for k,v in pairs(self.tab) do
     print("-----HuoDongPopup:setData",k,v.ID, v.Sort, v.BooleanValue, v.Count, v.MaxCount);
    end
    for k,v in ipairs(self.tab) do
      -- 筛除开服七天乐
      if (v.ID < 6 or v.ID > 13) and v.ID ~= 17 and v.ID ~= 4 then
        if not self.refresh then
          print("ID = ", v.ID)
         
          sendMessage(29,2,{ID=v.ID})
         
          self.refresh=0;
        end
        print(" ---- ID = ", v.ID)
        if v.ID == 6 then
          for k,v1 in pairs(self.tabofrender) do
            if v1.id == 5 and v.BooleanValue == 1 then
              v1.reddot:setVisible(v.BooleanValue);
            end
          end
        else
          self.render=LeftRender.new()
          -- print("##################v.Value v.ID,v.BooleanValue",v.Value,v.ID,v.BooleanValue)
          self.render:initialize(self,v.Value,v.ID,v.BooleanValue)
          --id:3七天签到 id:1 冲级有礼 id:2 礼包兑换 id:5 成长基金
          table.insert(self.tabofrender,self.render)
          self.listScrollViewLayer:addItem(self.render)
        end
      end
    end
    if #self.tab >= 1 then

      self.channel = self.tab[1].ID;
      print("self.channel", self.channel)
    end
  end
end




function HuoDongPopup:refreshRedDot(id)
  local renderDotData = self.huodongProxy:getRenderData(id);
  for i,v in ipairs(renderDotData) do
    print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ HuoDongPopup id v.Count v.MaxCount v.BooleanValue",id, v.Count, v.MaxCount, v.BooleanValue)
  end
  for i,v in ipairs(renderDotData) do
    if id == 1 and v.Count >= v.MaxCount and v.BooleanValue == 0 then
        self:renderDotVisible(id, true);
        return;
    elseif id == 3 and v.Count == v.MaxCount and v.BooleanValue == 0 then
        self:renderDotVisible(id, true);
        return;
    elseif id == 5 and v.Count >= v.MaxCount and v.BooleanValue ==0 then
        self:renderDotVisible(id, true);
        return;
    elseif id == 14 and v.Count == v.MaxCount and v.BooleanValue == 0 then
      --开服送礼
        self:renderDotVisible(id, true);
        return;
    elseif id == 16 and v.Count == v.MaxCount and v.BooleanValue == 0 then
        self:renderDotVisible(id, true);
    end
  end

  if id == 5 then
    -- add by mohai.wu 5，6为同一个render
    local data = self.huodongProxy:getHuodongDataByID(6);

    if data == nil then
      --data为空表示第一次进入，还未获取id=6的数据，则读取29_1数据来判断
      data = self.huodongProxy:getData();
      for k,v in pairs(data) do
        if v.ID == 6 then
          if v.BooleanValue == 1 then 
            -- BooleanValue == 1 表示ID=6时有奖品未领取
            self:renderDotVisible(5, true);
            return;
          end
          break;
        end
      end
      return;
    else
      --表示已经获取了ID=6的数据，为数据刷新阶段
      for k,v in pairs(data) do
        if v.Count >= v.MaxCount and v.BooleanValue == 0 then
          self:renderDotVisible(5, true);
          return;
        end
      end
    end
  end

  -- --id = 4特殊，判定手机绑定，renderDotData里未空数组，走此判断
  -- if id == 4 and self.huodongProxy.hasBindPhone == false and self.huodongProxy.havdCharged == true then
  --   self:renderDotVisible(id, true);
  --   self.huodongProxy:setDotVisible(id, 1);
  --   return;
  -- end

  self:renderDotVisible(id, false);
  self.huodongProxy:setDotVisible(id, 0);
end

function HuoDongPopup:renderDotVisible(id ,bool)
-- 设置某个render的小红点状态
  print("renderDotVisible id,bool",id, bool)
  local reddot;
  for i,v in ipairs(self.tabofrender) do
    if v.id == id then
      print("v.reddot = ",v.id,  v.reddot);
      v.reddot:setVisible(bool);
    end
  end
end

function HuoDongPopup:refreshRedDot2(data)
  -- add by mohai.wu 通过29_4数据刷新小红点
  print("function HuoDongPopup:refreshRedDot2(id)")
  for k,v in pairs(self.tabofrender) do
    if data[v.id] == true then
      v.reddot:setVisible(true);
    else
      v.reddot:setVisible(false);
    end
  end
end

function HuoDongPopup:refreshData()
  print("function HuoDongPopup:refreshData()")
  local tem
  for i,v in ipairs(self.tabofrender) do
    -- print("----HuoDongPopup:refreshData", i, v.id, v.BooleanValue, v.Count, v.MaxCount);

    if(v.id ==self.channel) then
      v.frame:setVisible(true)
      tem=v.id
    else
      v.frame:setVisible(false)
    end
  end
  print("tem = " ,tem, self.channel)

  --"冲级有礼"
  if(tem==1) then
    local tableData={level=self.userProxy:getLevel()}
    hecDC(3,19,2, tableData)
    if not self.chongjiyouli then
     self.chongjiyouli=ChongJiYouLi.new()
     self.chongjiyouli:initialize(self,self.channel)
     self.chongjiyouli:setPosition(self.rightbg_pos)
     self:addChild(self.chongjiyouli)
     self.tabofrightrender.render1=self.chongjiyouli
    end
    print(" huoDong HuoDongPopup tem==1 ")
    self.chongjiyouli:refreshData()
    for k,v in pairs(self.tabofrightrender) do
      if(k=="render1") then 
        v:setVisible(true)
      else
        v:setVisible(false)
      end
    end
  
  --礼包兑换
  elseif(tem==2) then
    print("LiBaoDuiHuan")
    if not self.libaoduihuan then
     self.libaoduihuan=LiBaoDuiHuan.new()
     self.libaoduihuan:initialize(self,self.channel)
     self.libaoduihuan:setPosition(self.rightbg_pos)
     self:addChild(self.libaoduihuan)
     self.tabofrightrender.render2=self.libaoduihuan
    end
    self.libaoduihuan:refreshData()
    for k,v in pairs(self.tabofrightrender) do
      if(k=="render2") then
        v:setVisible(true)
      else
        v:setVisible(false)
      end
    end

  --七天签到
  elseif (tem == 3)then
    if not self.qiTianQianDao then
   self.qiTianQianDao=QiTianQianDao.new()
   self.qiTianQianDao:initialize(self,self.channel)
   self.qiTianQianDao:setPosition(self.rightbg_pos)
   self:addChild(self.qiTianQianDao)
   self.tabofrightrender.render3=self.qiTianQianDao
   end
   self.qiTianQianDao:refreshData()
    for k,v in pairs(self.tabofrightrender) do
      if(k=="render3") then
        v:setVisible(true)
      else
        v:setVisible(false)
      end
    end
  
  --绑定手机
  elseif (tem == 4)then
    if not self.chongZhiFanHuan then
     self.chongZhiFanHuan=ChongZhiFanHuan.new()
     self.chongZhiFanHuan:initialize(self,self.channel)
     self.chongZhiFanHuan:setPosition(self.rightbg_pos)
     self:addChild(self.chongZhiFanHuan)
     self.tabofrightrender.render4=self.chongZhiFanHuan
    end
      for k,v in pairs(self.tabofrightrender) do
        if(k=="render4") then
          v:setVisible(true)
        else
          v:setVisible(false)
        end
      end

  --成长基金  2015-07-13 add by mohai.wu
  elseif (tem == 5 or self.channel == 6) then
    if not self.GrowthFund then
      self.GrowthFund = GrowthFund.new();
      self.GrowthFund:initialize(self, self.channel)
      self.GrowthFund:setPosition(self.rightbg_pos)
      self:addChild(self.GrowthFund)
      self.tabofrightrender.render5 = self.GrowthFund
    
    end
    self.GrowthFund:refreshData(tem );
    for k,v in pairs(self.tabofrightrender) do
      if (k == "render5") then
        v:setVisible(true)
      else
        v:setVisible(false) 
      end
    end

  --开服送礼 add by mohai.wu
  elseif tem == 14 then
    print("kaifusongli");
    if not self.KaifuGift then
      self.KaifuGift = KaifuGift.new();
      self.KaifuGift:initialize(self, self.channel)
      self.KaifuGift:setPosition(self.rightbg_pos)
      self:addChild(self.KaifuGift)
      self.tabofrightrender.render6 = self.KaifuGift;
    
    end
    self.KaifuGift:refreshData(tem );
    for k,v in pairs(self.tabofrightrender) do
      if (k == "render6") then
        v:setVisible(true)

      else
        v:setVisible(false) 
      end
    end
  -- 充值返还广告
  elseif tem == 15 then
    print("ChongZhiFanHuanAD")
    if not self.ChongZhiFanHuanAD then
      self.ChongZhiFanHuanAD = ChongZhiFanHuanAD.new();
      self.ChongZhiFanHuanAD:initialize(self, self.channel);
      self.ChongZhiFanHuanAD:setPosition(self.rightbg_pos);
      self:addChild(self.ChongZhiFanHuanAD);
      self.tabofrightrender.render7 = self.ChongZhiFanHuanAD;
    end
    for k,v in pairs(self.tabofrightrender) do
      if k == "render7" then
        v:setVisible(true);
      else
        v:setVisible(false);
      end
    end
  -- VIP福利
  elseif tem == 16 then
    print("VIP welfare")
    if not self.VIPWelfare then
      self.VIPWelfare = VIPWelfare.new();
      self.VIPWelfare:initialize(self, self.channel);
      self.VIPWelfare:setPosition(self.rightbg_pos);
      self:addChild(self.VIPWelfare);
      self.tabofrightrender.render8 = self.VIPWelfare;
    end
    self.VIPWelfare:refreshData(tem);
    for k,v in pairs(self.tabofrightrender) do
      if k == "render8" then
        v:setVisible(true);
      else
        v:setVisible(false);
      end
    end
  --------------
  end
end

function HuoDongPopup:initReddot(data, render)
    if data.BooleanValue == 1 and data.Count >= data.MaxCount then
      render.reddot:setVisible(true);
    end
end

function HuoDongPopup:refreshBangDing(phoneNumber)
  if self.chongZhiFanHuan then
    self.chongZhiFanHuan:refreshBangDing(phoneNumber);
  end
end

function HuoDongPopup:onUIClose( )

  self:dispatchEvent(Event.new("HuoDongClose",nil,self));
  -- setCurrencyGroupVisible(true);

end


function HuoDongPopup:refreshRenderDot(id, data)
  -- 用于刷新左边render小红点 
      print(" function HuoDongPopup:refreshRenderDot(id, data) ", id);
    local BooleanValue = 0;
    for k,v in pairs(data) do
      if v.Count >= v.MaxCount and v.BooleanValue == 0 then
        BooleanValue = 1;
        break;
      end
    end

    for k,v in pairs(data) do
      print(k,v.ConditionID, v.Count, v.MaxCount, v.BooleanValue)
    end
    -- 刷新左边render小红点
    self.huodongProxy:setReddotDataByID(id, BooleanValue);
    if BooleanValue == 1 then
      self:renderDotVisible(id, true);
    else
      self:renderDotVisible(id, false);
    end
    print("BooleanValue = ", BooleanValue);
    -- self:refreshMainHuoDongReddot();
end

function HuoDongPopup:refreshMainHuoDongReddot(  )
  print("function HuoDongPopup:refreshMainHuoDongReddot(  )")
  --刷新主界面小红点， 在活动按钮中有小红点的需在这里添加id。已监测主界面活动按钮小红点
  -- 1  冲级有礼
  -- 5 成长基金
  -- 6 全民福利
  -- 14  开服送礼
  -- 16  vip福利
  local IdTable = {1, 5, 6, 14, 16};
  local booleanValue = 0;
  booleanValue = self.huodongProxy:getReddotState(nil, IdTable);
  local med = Facade.getInstance():retrieveMediator(MainSceneMediator.name);
  if booleanValue == 1 then
    med:refreshHuoDongReddot(true);
  else
    med:refreshHuoDongReddot(false);
  end
  print("booleanValue = ", booleanValue);
end

function HuoDongPopup:getBagState(num)

  print(" function HuoDongPopup:getBagState(num) ", num)
  local bagIsFull = self.bagProxy:getBagIsFull();
  if bagIsFull then 
    sharedTextAnimateReward():animateStartByString("亲，您的背包已满哦~！");
    return false;
  end
  local leftPlaceCount = self.bagProxy:getBagLeftPlaceCount();
  print(" function HuoDongPopup:getBagState(num) ", num,leftPlaceCount)

  if num > leftPlaceCount then
    sharedTextAnimateReward():animateStartByString("亲，您的背包空间不足哦~！");
    return false;
  end
  return true;
end