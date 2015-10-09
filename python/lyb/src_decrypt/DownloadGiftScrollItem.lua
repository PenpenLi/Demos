--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.bag.ui.bagPopup.BagItem";
require "core.utils.CommonUtil";
require "core.utils.UserInfoUtil";

DownloadGiftScrollItem=class(TouchLayer);

function DownloadGiftScrollItem:ctor()
  self.class=DownloadGiftScrollItem;
end

function DownloadGiftScrollItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	DownloadGiftScrollItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function DownloadGiftScrollItem:initialize(skeleton, activityProxy, generalListProxy, parent_container, id)
  self:initLayer();
  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.generalListProxy=generalListProxy;
  self.parent_container=parent_container;
  self.id=id;
  self.lv=analysis("Huodongbiao_Xiazaijiangli",self.id,"lv");
  self.gift=analysis("Huodongbiao_Xiazaijiangli",self.id,"gift");
  self.gift=StringUtils:stuff_string_split(self.gift);
  self.bag_count=0;
  
  
  --骨骼
  local armature=skeleton:buildArmature("download_gift_scroll_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local image=self.armature:getChildByName("common_copy_grid");
  self.image_pos=convertBone2LB(image);
  self.armature:removeChild(image);
  local image_1=self.armature:getChildByName("common_copy_grid_1");
  self.image_1_pos=convertBone2LB(image_1);
  self.armature:removeChild(image_1);
  self.image_skew_x=self.image_1_pos.x-self.image_pos.x;

  --[[self.box=self.armature:getChildByName("common_copy_box");
  self.box_pos=convertBone2LB(self.box);
  self.armature:removeChild(self.box);]]

  self.img=self.armature:getChildByName("img");
  self.img_text_data=armature:findChildArmature("img"):getBone("common_copy_blueround_button").textData;
  self.img_pos=convertBone2LB4Button(self.img);
  self.armature:removeChild(self.img);

  self.unfetched_img=self.armature:getChildByName("unfetched_img");
  self.unfetched_img_pos=convertBone2LB(self.unfetched_img);
  self.armature:removeChild(self.unfetched_img);

  --common_copy_box
  local text=1==self.id and "安装游戏" or (self.lv .. "级更新包");
  local text_data=armature:getBone("common_copy_box_3_normal").textData;
  self.scroll_item_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.scroll_item_descb);

  local items=self:getItems();
  for k,v in pairs(items) do
    self.armature:addChild(v);
  end
end

--领取
function DownloadGiftScrollItem:onFetchTap(event, data)
  if "download" == data then
    log("-------------------------------->ClickLoad:" .. self.id);
    local function cb()
      -- hecDC(4);
      UserInfoUtil:public_setDownLoadGiftSign(self.id);
      MainIsRestart=true;
      self:onClickConfirmButton();
    end
    local tips=CommonPopup.new();
    tips:initialize("下载会重启游戏，确定吗？",nil,cb);
    commonAddToScene(tips,true);
    GameData.forceToUpdate = false
    return;
  end
  if self.parent_container:getIsBagFull(self.bag_count) then
    return;
  end
  self.img:removeEventListener(DisplayEvents.kTouchTap,self.onFetchTap,self);
  self.parent_container:dispatchEvent(Event.new(ActivityNotifications.DOWNLOAD_GIFT_GET_BONUS,{Level=self.lv},self.parent_container));
end

function DownloadGiftScrollItem:onItemTap(event)
  self.parent_container:popTip(event.target:getChildAt(0):getItemData().ItemId,event.target:getChildAt(0):getItemData().Count,event.globalPosition);
end

function DownloadGiftScrollItem:refresh()
  local a=self.activityProxy:hasDownloadGiftData(self.lv);
  self:remove();

  -- 如果强制下载  不管领没领过  都显示下载
  if GameData.forceToUpdate and 1~=self.id then
    self.img=CommonButton.new();
    self.img:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
    self.img:initializeText(self.img_text_data,"下载");
    self.img:setPosition(self.img_pos);
    self.img:addEventListener(DisplayEvents.kTouchTap,self.onFetchTap,self,"download");
    self.armature:addChild(self.img);
    return
  end  

  if a then
    self.img=self.skeleton:getCommonBoneTextureDisplay("common_yiwancheng");
    self.img:setPosition(self.img_pos);
    self.img:setPositionY(-7+self.img:getPositionY());
    self.armature:addChild(self.img);
  elseif 1==self.id or tostring(self.id)==UserInfoUtil:public_getDownLoadGiftSign(self.id) then
    self.img=CommonButton.new();
    self.img:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
    self.img:initializeText(self.img_text_data,"领取");
    self.img:setPosition(self.img_pos);
    self.img:addEventListener(DisplayEvents.kTouchTap,self.onFetchTap,self,"fetch");
    self.armature:addChild(self.img);
  else
    self.img=CommonButton.new();
    self.img:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
    self.img:initializeText(self.img_text_data,"下载");
    self.img:setPosition(self.img_pos);
    self.img:addEventListener(DisplayEvents.kTouchTap,self.onFetchTap,self,"download");
    self.armature:addChild(self.img);
  end
  -- if self.generalListProxy:getLevel()>=self.lv then
  --   if a then
  --     --[[self.box=self.skeleton:getCommonBoneTextureDisplay("common_box_open");
  --     self.box:setPosition(self.box_pos);
  --     self.armature:addChild(self.box);]]
  --     self.img=self.skeleton:getBoneTextureDisplay("finished_img");
  --     self.img:setPosition(self.img_pos);
  --     self.armature:addChild(self.img);
  --   else
  --     --[[self.box=self.skeleton:getCommonBoneTextureDisplay("common_box_close");
  --     self.box:setPosition(self.box_pos);
  --     self.armature:addChild(self.box);]]
  --     self.img=CommonButton.new();
  --     self.img:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  --     self.img:initializeText(self.img_text_data,"领取");
  --     self.img:setPosition(self.img_pos);
  --     self.img:addEventListener(DisplayEvents.kTouchTap,self.onFetchTap,self,"领取");
  --     self.armature:addChild(self.img);
  --   end
  -- else
  --   --[[self.box=self.skeleton:getCommonBoneTextureDisplay("common_box_close");
  --   self.box:setPosition(self.box_pos);
  --   self.armature:addChild(self.box);]]
  --   --[[self.img=self.skeleton:getBoneTextureDisplay("unfinished_img");
  --   self.img:setPosition(self.img_pos);
  --   self.armature:addChild(self.img);]]
  --   self.img=CommonButton.new();
  --   self.img:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  --   self.img:initializeText(self.img_text_data,"下载");
  --   self.img:setPosition(self.img_pos);
  --   self.img:addEventListener(DisplayEvents.kTouchTap,self.onFetchTap,self,"下载");
  --   self.armature:addChild(self.img);
  -- end
end

function DownloadGiftScrollItem:remove()
  --self.armature:removeChild(self.box);
  self.armature:removeChild(self.img);
end

function DownloadGiftScrollItem:getItems()
  local items={};
  for k,v in pairs(self.gift) do
    local a={};
    a.UserItemId=0;
    a.ItemId=tonumber(v[1]);
    a.Count=tonumber(v[2]);
    a.IsBanding=0;
    a.IsUsing=0;
    a.Place=0;

    if 1000000<a.ItemId then
      self.bag_count=math.ceil(a.Count/analysis("Daoju_Daojubiao",a.ItemId,"overlap"))+self.bag_count;
    end

    local b=BagItem.new();
    b:initialize(a);
    b:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X,ConstConfig.CONST_GRID_ITEM_SKEW_Y);
    local c=self.skeleton:getCommonBoneTextureDisplay("common_grid");
    c:setPositionXY(self.image_skew_x*(-1+k)+self.image_pos.x,self.image_pos.y);
    c:addChild(b);
    c:addEventListener(DisplayEvents.kTouchTap,self.onItemTap,self);
    table.insert(items,c);
  end
  return items;
end

function DownloadGiftScrollItem:onClickConfirmButton()
  --   -- 清理mvc    
    gameStart:stop()
    -- 清理全局性的数据
    if gameSceneIns then
      if gameSceneIns.parent then
        gameSceneIns.parent:removeChild(gameSceneIns);
      end
    end
    gameSceneIns = nil
    GameVar:dispose()

    if  BetterEquipManager then
      BetterEquipManager.betterEquips={}
    end

    if ParticleSystem then 
      ParticleSystem:dispose()
    end
    if ScreenShake then
      ScreenShake:dispose()
    end
    if ScreenScale then
      ScreenScale:dispose()
    end
    local scene = Director.sharedDirector():getRunningScene();
    if scene then
      if scene.name == GameConfig.MAIN_SCENE then
        if sharedMainLayerManager() then
          sharedMainLayerManager():disposeMainLayerManager()
        end
        if sharedTextAnimateReward() then
          sharedTextAnimateReward():disposeTextAnimateReward()
        end
      elseif scene.name == GameConfig.BATTLE_SCENE then
        if sharedBattleLayerManager() then
          sharedBattleLayerManager():disposeBattleLayerManager()
        end
        if sharedTextAnimateReward() then
          sharedTextAnimateReward():disposeTextAnimateReward()
        end
      end
    end


    disposeAllScheduler()

    GameData.connectType = 0

    BitmapCacher:dispose()

    package.loaded["RunGame"] = nil
    -- MainIsRestart=false;
    MainForRestart();
end