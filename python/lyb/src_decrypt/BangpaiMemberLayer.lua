BangpaiMemberLayer=class(TouchLayer);

function BangpaiMemberLayer:ctor()
  self.class=BangpaiMemberLayer;
end

function BangpaiMemberLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	BangpaiMemberLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
end

--
function BangpaiMemberLayer:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  
  --骨骼
  local armature=self.skeleton:buildArmature("chengyuan_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);


  --title_1
  local text_data=self.armature4dispose:getBone("title_1").textData;
  self.title_1=createTextFieldWithTextData(text_data,"帮众名字");
  self.armature:addChild(self.title_1);

  text_data=self.armature4dispose:getBone("title_2").textData;
  self.title_2=createTextFieldWithTextData(text_data,"职位");
  self.armature:addChild(self.title_2);

  text_data=self.armature4dispose:getBone("title_3").textData;
  self.title_3=createTextFieldWithTextData(text_data,"总活跃");
  self.armature:addChild(self.title_3);

  text_data=self.armature4dispose:getBone("title_4").textData;
  self.title_4=createTextFieldWithTextData(text_data,"战力");
  self.armature:addChild(self.title_4);

  text_data=self.armature4dispose:getBone("title_5").textData;
  self.title_5=createTextFieldWithTextData(text_data,"上次登录");
  self.armature:addChild(self.title_5);
end

function BangpaiMemberLayer:refreshFamilyInfo(familyInfo)
  self.familyInfo = familyInfo;

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(403,60));
  self.item_layer:setViewSize(makeSize(770,400));
  self.item_layer:setItemSize(makeSize(770,97));
  self.armature:addChild(self.item_layer);

  self.items={};
  local function sf(a, b)
    if a.FamilyPositionId < b.FamilyPositionId then
      return true;
    elseif a.FamilyPositionId > b.FamilyPositionId then
      return false;
    elseif a.Huoyuedu > b.Huoyuedu then
      return true;
    elseif a.Huoyuedu < b.Huoyuedu then
      return false;
    elseif a.Time > b.Time then
      return true;
    elseif a.Time < b.Time then
      return false;
    end
    return false;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  end
  table.sort(self.familyInfo.MemberArray,sf);
  for k,v in pairs(self.familyInfo.MemberArray) do
    local item=BangPaiMemberItemLayer.new();
    item:initialize(self.context,v);
    self.item_layer:addItem(item);
    table.insert(self.items,item);
  end
end

function BangpaiMemberLayer:refreshFamilyMemberKaichu(userID)
  print(userID);
  for k,v in pairs(self.items) do
    print("->",v.data.UserId);
    if userID == v.data.UserId then
      self.item_layer:removeItemAt(-1+k,true);
      table.remove(self.items,k);
      break;
    end
  end
  for k,v in pairs(self.familyInfo.MemberArray) do
    print("-->>",v.UserId);
    if userID == v.UserId then
      table.remove(self.familyInfo.MemberArray,k);
      break;
    end
  end
  self.item_layer:scrollToItemByIndex(0);
end

function BangpaiMemberLayer:refreshFamilyMemeberPositionID(userID, positionID)
  for k,v in pairs(self.items) do
    if userID == v.data.UserId then
      v:refreshFamilyMemeberPositionID(userID,positionID);
      break;
    end
  end
  self:sortMemberItem();
end

function BangpaiMemberLayer:refreshFamilyMemeberPositionIDs(changeMemberArray)
  local tb = {};
  for k,v in pairs(changeMemberArray) do
    self:refreshFamilyMemeberPositionID(v.UserId,v.FamilyPositionId);
    tb[v.UserId] = v.UserId;
  end
  for k,v in pairs(self.items) do
    if not tb[v.data.UserId] then
      self:refreshFamilyMemeberPositionID(v.data.UserId,v.data.FamilyPositionId);
    end
  end
end

function BangpaiMemberLayer:refreshFamilyMemberIncrease(data)
  for k,v in pairs(data.MemberArray) do
    table.insert(self.familyInfo.MemberArray, v);
  end
  -- local function sf(a, b)
  --   if a.FamilyPositionId < b.FamilyPositionId then
  --     return true;
  --   elseif a.FamilyPositionId > b.FamilyPositionId then
  --     return false;
  --   elseif a.Time > b.Time then
  --     return true;
  --   elseif a.Time < b.Time then
  --     return false;
  --   end
  --   return false;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  -- end
  -- table.sort(self.familyInfo.MemberArray,sf);
  -- for k,v in pairs(self.familyInfo.MemberArray) do
    for k_,v_ in pairs(data.MemberArray) do
      --if v.UserId == v_.UserId thenr
        local item=BangPaiMemberItemLayer.new();
        item:initialize(self.context,v_);
        -- self.item_layer:addItemAt(item,-1+k);
        self.item_layer:addItem(item);
        table.insert(self.items,item);
        --break;
      --end
    end
  -- end
end

function BangpaiMemberLayer:sortMemberItem()
  for k,v in pairs(self.items) do
    if 1 == v.data.FamilyPositionId then
      if 1 ~= k then
        self.item_layer:removeItemAt(-1+k,false);
        self.item_layer:addItemAt(v,0);
        table.remove(self.items,k);
        table.insert(self.items,1,v);
      end
      break;
    end
  end
  for k,v in pairs(self.familyInfo.MemberArray) do
    if 1 == v.FamilyPositionId then
      if 1 ~= k then
        table.remove(self.familyInfo.MemberArray,k);
        table.insert(self.familyInfo.MemberArray,1,v);
      end
      break;
    end
  end
end