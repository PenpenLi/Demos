
MopUpResultRender=class(TouchLayer);

function MopUpResultRender:ctor()
  self.class=MopUpResultRender;
end

function MopUpResultRender:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	MopUpResultRender.superclass.dispose(self);
	BitmapCacher:removeUnused();
end
function MopUpResultRender:initializeUI(context, data, index)
  
  self:initLayer();

  self.skeleton = context.storyLineProxy:getSkeleton();
  local armature=self.skeleton:buildArmature("result_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  
  armature_d.touchEnabled=true;

  self:addChild(armature_d);

  local times_txtTextData = armature:getBone("times_txt").textData;
  self.times_txt =  createTextFieldWithTextData(times_txtTextData, "第" .. index .."次");
  armature_d:addChild(self.times_txt);   

  local obtain_txtTextData = armature:getBone("obtain_txt").textData;
  self.obtain_txt =  createTextFieldWithTextData(obtain_txtTextData, "获得：");
  armature_d:addChild(self.obtain_txt);   

  local exp_txtTextData = armature:getBone("exp_txt").textData;
  self.exp_txt =  createTextFieldWithTextData(exp_txtTextData, "");
  armature_d:addChild(self.exp_txt);   


  local silver_txtTextData = armature:getBone("silver_txt").textData;
  self.silver_txt =  createTextFieldWithTextData(silver_txtTextData, "");
  armature_d:addChild(self.silver_txt); 



  local function sortFun(a, b)

    local category1 = math.floor(a.ItemId/1000);
    local category2 = math.floor(b.ItemId/1000);
    local color1 = analysis("Daoju_Daojubiao", a.ItemId, "color")
    local color2 = analysis("Daoju_Daojubiao", b.ItemId, "color")
   
    if a.ItemId == 1 and b.ItemId ~= 1  then
      return true;
    elseif a.ItemId ~= 1 and b.ItemId == 1  then
      return false; 
    elseif a.ItemId == 2 and b.ItemId ~= 2  then
      return true;     
    elseif a.ItemId ~= 2 and b.ItemId == 2  then
      return false; 
    elseif category1 == 8000 and category2 ~= 8000 then
      return true;
    elseif category1 ~= 8000 and category2 == 8000 then
      return false;
    elseif category1 == 8000 and category2 == 8000 then
      return a.ItemId < b.ItemId;
    elseif color1 > color2 then
      return true;
    elseif color1 < color2 then
      return false;
    else
      if category1 == 1013 and category2 ~= 1013  then
        return true;
      elseif category2 == 1013 and  category1 ~= 1013 then
        return false;
      elseif category1 == 1013 and category2 == 1013  then
        return a.ItemId < b.ItemId;
      else
        return false;            
      end
    end
  end
  table.sort(data.ItemIdArray, sortFun);
  local xPos = 33
  local yPos = 28
  local tempIndex = 0
  local count = 1;
  for k, v in ipairs(data.ItemIdArray) do
    if count > 4 then 
      break;
    end
    if v.ItemId == 1 then
      self.exp_txt:setString("经验：" .. v.Count)
    elseif v.ItemId == 2 then
      self.silver_txt:setString("银两：" .. v.Count)
    else
      local itemPo = analysis("Daoju_Daojubiao", v.ItemId);
      sharedTextAnimateReward():animateStartByString("获得道具:" .. itemPo.name .. "x" .. v.Count); 

      print("MopUpResultRender v.Count", v.Count)
      local itemImage = BagItem.new(); 
      itemImage:initialize({ItemId = v.ItemId, Count = tonumber(v.Count)});

      itemImage:setBackgroundVisible(true)
      itemImage:setPositionXY(xPos + tempIndex * 104, yPos);
      armature_d:addChild(itemImage);
      tempIndex = tempIndex + 1;
      count = count + 1;
    end
  end
end


