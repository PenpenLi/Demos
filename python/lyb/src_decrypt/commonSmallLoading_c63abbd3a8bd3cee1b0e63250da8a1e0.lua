--

require "core.display.ccTypes";
require "core.controls.CommonTextField";
require "main.config.ConstConfig";
require "main.config.FontConstConfig";
require "main.managers.GameData";

local commonSmallLoading=nil;
local effect_on_main_scene_icon={};
local menu_opened=false;
local effect_function_id={};
local maskLayer = nil;
local tempMaskLayer = nil;
local removeTempMaskTick = nil;
local time_server = nil;

function fullPath(v, isMd5)
  local ret = CCFileUtils:fullPathFromRelativePath(v, isMd5)
  return ret;
end

function convertBone2LB(bone)
  local a=bone:getPosition();
  local b=makePoint(a.x,a.y);
  b.y=-bone:getContentSize().height+b.y;
  return b;
end

function convertBone2LB4Button(bone)
  local a=bone:getPosition();
  local b=makePoint(a.x,a.y);
  b.y=-bone:getChildAt(0):getContentSize().height+b.y;
  return b;
end

function copyTable(t)
  local a={};
  for k,v in pairs(t) do
    a[k]=v;
  end
  return a;
end


function copyTable2(t)
  local a={};
  for k,v in pairs(t) do
    a[k]=v;
  end
  return a;
end


function createTextFieldWithTextData(textData, string, stroke_bool, strokeColor, stroke_size)
  local fontName=FontConstConfig.OUR_FONT;
  local text = textData;
  if text then
      local str = string and string or "";
        
      local label = nil;
      local isSupportTextChange = true;

      if str ~= "" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then--
        local translatedStr = getLuaCodeTranslated(str)
        if translatedStr then
          str = translatedStr
        end
      end

      if stroke_bool then
        local sc=strokeColor and strokeColor or ccc3(0,0,0);
        local ss=stroke_size and stroke_size or 2;
        label = CCLabelTTFStroke:create(str, fontName, text.size, ss, sc, CCSizeMake(text.width, text.height), text.alignment,kCCVerticalTextAlignmentCenter);
      else
        label = CCLabelTTF:create(str, fontName, text.size, CCSizeMake(text.width, text.height), text.alignment);
      end
      
      local ret = TextField.new(label, true);
      ret.textData = text;
      ret:setColor(CommonUtils:ccc3FromUInt(text.color));
      ret:setPositionXY(text.x, text.y);

      return ret;
  end
  return nil
end

function getLuaCodeTranslated(sourceStr)
    local returnValue = nil
    local beginIndex = string.find(sourceStr, "_@_")
    local endIndex = string.find(sourceStr, "_#_")
    if beginIndex and endIndex then
       returnValue = ""
       local stringTab = StringUtils:lua_string_split(sourceStr, "_@_", 3)
       for k2, v2 in ipairs(stringTab)do

            local endIndex2 = string.find(v2, "_#_")
            if endIndex2 then
                local langId = string.sub(v2, 1, endIndex2 - 1);
                local content  --=, "zhongwenfanti"
                if not analysisHas("Yuyanbao_Yuyanbao", tonumber(langId)) then
                    returnValue = nil
                    break;
                else
                    content = analysis("Yuyanbao_Yuyanbao", tonumber(langId))
                    local len2 = string.len(sourceStr)
                    if len2 > endIndex2 + 3 then
                        local content2
                        content2 = string.sub(v2, endIndex2 + 3, len2);
                        content = content.zhongwenfanti .. content2
                    end
                    returnValue = returnValue .. content
                end
              
            else
                returnValue = returnValue .. v2
            end
       end
    end
    return returnValue;
end

-- 加描边 不要用这个了用上边那个 createTextFieldWithTextData
function createStrokeTextFieldWithTextData(textData, string, isCommon ,stroke_size, strokeColor)
  local fontName=FontConstConfig.OUR_FONT;
  local text = textData;
  if text then
      local str = (not string or isCommon) and "" or string;
      fontName = fontName or FontConstConfig.OUR_FONT;
        
      local label = nil;
      local isSupportTextChange = true;

      if str ~= ""  and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then--
        local translatedStr = getLuaCodeTranslated(str)
        if translatedStr then
          str = translatedStr
        end
      end
      local sc=strokeColor and strokeColor or ccc3(0,0,0);
      local ss=stroke_size and stroke_size or 1;
      --label = CCLabelTTFStroke:create(str, GameConfig.DEFAULT_FONT_NAME, text.size, stroke_size, strokeColor, CCSizeMake(text.width, text.height), kCCTextAlignmentCenter,  text.alignment);
      label = CCLabelTTFStroke:create(str, fontName, text.size, ss, sc, CCSizeMake(text.width, text.height), text.alignment,kCCVerticalTextAlignmentCenter);
           
      local ret;
      if isCommon then
        ret = CommonTextField.new(label, isSupportTextChange);
        ret.textData = text;
        ret:setString(string or str);
      else
        ret = TextField.new(label, isSupportTextChange);
        ret.textData = text;
        ret:setColor(CommonUtils:ccc3FromUInt(text.color));
      end
      ret:setPositionXY(text.x, text.y);

      return ret;
  end
  return nil
end

function createTextFieldWithTextDataTest(textData, string)
  local fontName=FontConstConfig.OUR_FONT;
  local text=textData;
  local label=CCLabelTTF:create(string,fontName,text.size);
  return label:getContentSize().width;
end

--MultiColoredLabel
--MultiColoredLabel.new('<content><font color="#00FF00">进入</font><font color="#FF0000">游戏</font></content>', "fonts/FZY4JW.ttf", 40);
function createMultiColoredLabelWithTextData(textData, string)
  local fontName=FontConstConfig.OUR_FONT;
  local text = textData;
  if text then
      string = string or "";

      if string ~= "" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE  then--
        local translatedStr = getLuaCodeTranslated(string)
        if translatedStr then
          string = translatedStr
        end
      end
      fontName = fontName or FontConstConfig.OUR_FONT;
      local ret = MultiColoredLabel.new(string, fontName, text.size,  CCSizeMake(text.width, text.height), text.alignment);
      ret:setPositionXY(text.x, text.y);
      return ret;
  end
  return nil
end

function createRichMultiColoredLabelWithTextData(textData, string)
  local fontName=FontConstConfig.OUR_FONT;
  local text = textData;
  if text then
      string = string or "";

      if string ~= "" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE  then--
        local translatedStr = getLuaCodeTranslated(string)
        if translatedStr then
          string = translatedStr
        end
      end
      fontName = fontName or FontConstConfig.OUR_FONT;
      local ret = RichLabelTTF.new(string, fontName, text.size,  CCSizeMake(text.width, text.height), text.alignment);
      ret.textData = textData;
      ret:setAutoMaxContentSize(false);
      ret:setPositionXY(text.x, text.y);
      return ret;
  end
  return nil
end

function createAutosizeMultiColoredLabelWithTextData(textData, string)
  local fontName=FontConstConfig.OUR_FONT;
  local text = textData;
  if text then
      string = string or "";
      
      if string ~= ""  and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then--
        local translatedStr = getLuaCodeTranslated(string)
        if translatedStr then
          string = translatedStr
        end
      end
      fontName = fontName or FontConstConfig.OUR_FONT;
      local ret = RichLabelTTF.new(string, fontName, text.size,  CCSizeMake(text.width, 0), text.alignment);
      ret.textData = textData;
      ret:setPositionXY(text.x, text.y);
      return ret;
  end
  return nil
end

function createTextFieldWithQualityID(qualityID, textData, string, stroke_bool)
  textData.color=getColorByQuality(qualityID);
  return createTextFieldWithTextData(textData,string,stroke_bool);
end

function initializeCommonUtil()
  commonSmallLoading=nil;
  effect_on_main_scene_icon={};
  menu_opened=false;
  effect_function_id={};
  maskLayer = nil;
end

-- 根据品质取颜色
-- qualityID 品质ID
-- hexadecimal 是否是十六进制
function getColorByQuality(qualityID,hexadecimal)
	if hexadecimal then
		local color = "#FFFFFF"
		if qualityID == 1 then
			color = GameConfig.QUALITY_COLOR_WHITE
		elseif qualityID == 2 then
			color = GameConfig.QUALITY_COLOR_GREEN	
		elseif qualityID == 3 then
			color = GameConfig.QUALITY_COLOR_BLUE	
		elseif qualityID == 4 then
			color = GameConfig.QUALITY_COLOR_PURPLE	
		elseif qualityID == 5 then
			color = GameConfig.QUALITY_COLOR_ORANGE	
		elseif qualityID == 6 then
			color = GameConfig.QUALITY_COLOR_RED	
		else
		
		end
		return color
	else
		if 1==qualityID then--白
			return 16777215;
		elseif 2==qualityID then--绿
			return 65280;
		elseif 3==qualityID then--蓝
			return 65535;
		elseif 4==qualityID then--紫
			return 0xff4cf0;
		elseif 5==qualityID then--橙
			return 16752640;
		elseif 6==qualityID then--红
			return 16711680;
		else
			return 16777215
		end
	end
end

function getHexColorByMainTypeAndSubType(mainType, subType, isUser)
  if isUser then
    return "#FFFFFF";
  end
  if ConstConfig.MAIN_TYPE_CHAT==mainType then
    if ConstConfig.SUB_TYPE_WORLD==subType then
      return "#E1D2A0";
    elseif ConstConfig.SUB_TYPE_PRIVATE==subType then
      return "#FDEE03";
    elseif ConstConfig.SUB_TYPE_INFLUENCE==subType then
      return "#FFA200";
    elseif ConstConfig.SUB_TYPE_GROUP==subType then
      return "#00FFB4";
    elseif ConstConfig.SUB_TYPE_FACTION==subType then
      return "#FF00F6";
    elseif ConstConfig.SUB_TYPE_NEAR==subType then
      return "#00A2FF";
    elseif ConstConfig.SUB_TYPE_BROAD==subType then
      return "#FFFC00";
    end
  elseif ConstConfig.MAIN_TYPE_BUDDY==mainType then
    return "#00FFFF";
  end
  return "#FFFFFF";
end

function getColorByMainTypeAndSubType(mainType, subType, isUser)
  if isUser then
    return 16777215;
  end
  if ConstConfig.MAIN_TYPE_CHAT==mainType then
    if ConstConfig.SUB_TYPE_WORLD==subType then
      return 14799520;
    elseif ConstConfig.SUB_TYPE_PRIVATE==subType then
      return 65535;
    elseif ConstConfig.SUB_TYPE_INFLUENCE==subType then
      return 65535;
    elseif ConstConfig.SUB_TYPE_GROUP==subType then
      return 65535;
    elseif ConstConfig.SUB_TYPE_FACTION==subType then
      return 65535;
    end
  elseif ConstConfig.MAIN_TYPE_BUDDY==mainType then
    return 65535;
  end
  return 16777215;
end

function getTipPosition(tip, position, rect)
  local size=rect and rect or Director:sharedDirector():getWinSize();
  local size_tip=tip:getGroupBounds(false);
  local p=CCPointMake(position.x,-size_tip.size.height+position.y);
  if size.width<size_tip.size.width+p.x then
    p.x=-size_tip.size.width+p.x;
  end
  if 0>p.y then
    p.y=0;
  end
  return p;
end

function getTipPosition4Family(tip, position, rect)
  local size=rect and rect or Director:sharedDirector():getWinSize();
  local size_tip=tip:getChildAt(0):getContentSize();
  local p=CCPointMake(position.x,-size_tip.height+position.y);
  if size.width<size_tip.width+p.x then
    p.x=-size_tip.width+p.x;
  end
  if 0>p.y then
    p.y=0;
  end
  return p;
end

function getGraySprite(sprite, x, y, notRelease)
  if nil==x then x=0; end
  if nil==y then y=0; end
  local size=sprite:getContentSize();
  if not notRelease then
	  sprite:release();
  end
  return CommonUtils:applyGreyFilter(sprite,makeRect(x,y,size.width,size.height));
end

function getGrayTexture(uri_string)
  return CCGrayscaleSprite:create(uri_string);
end

function getGrayRole(modelId)
        local ccspt = CCSprite:createWithSpriteFrameName(modelId.."_"..BattleConfig.HOLD..".swf/0000")
        local rect = ccspt:getTextureRect()
        local rotation = ccspt.rotation
        local width = rect.size.width;
        local height = rect.size.height;
        local x = rect.origin.x
        local y = rect.origin.y
        local rot = 1
        local spliteSprite = CommonUtils:applyGreyFilter(ccspt,makeRect(x,y,width,height));
        local graySprite = Sprite.new(spliteSprite);
        return graySprite;
end

function getGrayRoleByArtId(artId)
        local ccspt = CCSprite:createWithSpriteFrameName(artId..".swf/0000")
        local rect = ccspt:getTextureRect()
        local width = rect.size.width;
        local height = rect.size.height;

        local x = rect.origin.x
        local y = rect.origin.y
        local spliteSprite = CommonUtils:applyGreyFilter(ccspt,makeRect(x,y,width,height));
        local graySprite = Sprite.new(spliteSprite);
        return graySprite;
end
function getCompositeAllPart(artId)
    local plistKey = "key_" .. artId;
    local plistItem = plistData[plistKey];
    BitmapCacher:animationCache(plistItem.source);
    local compositeActionAllPart1  = CompositeActionAllPart.new();
    compositeActionAllPart1:initLayer();
    local compsiteTable1 = {
      [1] = {["type"] = BattleConfig.TRANSFORM_BODY, ["sourceName"] = artId}
    };

    compositeActionAllPart1:transformPartCompose(compsiteTable1);
    return compositeActionAllPart1;
end
function makeScale9Sprite(artID)
  local path = artData[tonumber(artID)].source;
  local texture = CCTextureCache:sharedTextureCache():addImage(path);
  local w = texture:getPixelsWide();
  local h = texture:getPixelsHigh();
  local frame = CCSpriteFrame:createWithTexture(texture, CCRectMake(0 ,0, w, h));
  local rectCap = CCRectMake(w*0.5-0.5 ,h*0.5-0.5, 1, 1);
  local sp = CCScale9Sprite:createWithSpriteFrame(frame, rectCap);
  local s9sp = Common9GridSprite.new(sp);
  return s9sp;
end
-- 动画播放
-- artId素材ID 如:256_1001
-- position位置
-- callBackFun回调函数 永久循环的就不要设置回调函数了，不起作用
-- playCount 播放类型 一次:1，n次循环:n，永久循环:0
-- scaleValue 缩放比例
-- isBlendFunc 是否要进行动画融合
-- directPram 是否反转

function cartoonPlayer(artId,positionX,positionY,playCount,callBackFun,scaleValue,directPram,isBlendFunc)

	--默认播放一次
	if not playCount then
		playCount = 1
	end

  local function judgeCartoonType()
    return artData[tonumber(artId)].type
  end

  local cartoonType = judgeCartoonType()
  if cartoonType == 4 then -- spritestudio 
    log("isBoneEffect==true"..artId)
    local boneEffect = BoneCartoon.new()
    boneEffect.isBoneEffect = isBoneEffect;
    boneEffect:create(artId,playCount,callBackFun)
    if isBlendFunc then
      boneEffect:setMyBlendFunc()
    end    
    boneEffect.sprite:setAnchorPoint(CCPointMake(0.5, 0.5));    
    boneEffect:setPositionXY(positionX,positionY)

    if scaleValue then
      directPram = directPram or 1
      boneEffect:setScaleY(scaleValue)
      boneEffect:setScaleX(scaleValue*directPram)
    end    
    return boneEffect
  elseif cartoonType == 5 then -- spine
    log("isSpineEffect==true"..artId)
    require "core.utils.SpineCartoon"
    local spineCartoon = SpineCartoon.new()
    spineCartoon:create(artId,callBackFun,1)
    spineCartoon:setPositionXY(positionX,positionY)
    spineCartoon:setAnchorPoint(CCPointMake(0.5, 0.5));    
    if scaleValue then
      directPram = directPram or 1
      spineCartoon:setScaleY(scaleValue)
      spineCartoon:setScaleX(scaleValue*directPram)
    end  
    return spineCartoon
  elseif cartoonType == 1 then
    log("isFrameEffect==true"..artId)

    artId = artId.."_1001"
    -- 缓存
    local animCachEffect = CCAnimationCache:sharedAnimationCache();
    local standAnimationEffect = animCachEffect:animationByName(artId);

    if not standAnimationEffect then
      local plistKey = "key_" .. artId;
      local plistItem = plistData[plistKey];
      BitmapCacher:animationCache(plistItem.source);
      standAnimationEffect = animCachEffect:animationByName(artId);
    end

    local arrayEffect = CCArray:create();
    local animateEffect = CCAnimate:create(standAnimationEffect);

    local effectSprite = CCSprite:create();
    -- 是否要进行动画融合
    if isBlendFunc then
      effectSprite:setMyBlendFunc()
    end

    local effectIcon = Sprite.new(effectSprite);

    -- 默认不允许触摸操作
    effectIcon.touchEnabled = false;
    effectIcon.touchChildren = false;

    if scaleValue then
      effectIcon:setScale(scaleValue)
    end
    if directPram == -1 then
      effectIcon.sprite:setFlipX(true);
    end
    effectIcon:setAnchorPoint(CCPointMake(0.5,0.5));
    effectIcon:setPositionXY(positionX,positionY)

    if playCount ~= 0 then
      arrayEffect:addObject(CCRepeat:create(animateEffect,playCount));
      if callBackFun then
        arrayEffect:addObject(CCCallFunc:create(callBackFun)) 
      end   
    else
      arrayEffect:addObject(CCRepeatForever:create(animateEffect))  
    end

    effectIcon:runAction(CCSequence:create(arrayEffect));
    return  effectIcon    
  end

  log("effect is null xxxxxxxxxxxxxxxxxxxxxxxxxx---"..artId)
 
end

-- 检测是否点中
function checkTouched(display,position)
	local isTouched = CommonUtils:isObjPixelTouched(display.sprite, position);
	return isTouched
end
local isSmallLoadingPopUp = false;
local removeDelaySmallLoadingTick = nil;
function delayInitializeSmallLoading(second)
  if removeDelaySmallLoadingTick then return end

  if not second then
     second = 2;
  end
  addTickMaskLayer(2);
  local function delayTick(dt)
     if removeDelaySmallLoadingTick then
          CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(removeDelaySmallLoadingTick);
          removeDelaySmallLoadingTick = nil;
     end
     if isSmallLoadingPopUp then
        initializeSmallLoading();
     end
  end
  isSmallLoadingPopUp = false;
  if not removeDelaySmallLoadingTick then
    removeDelaySmallLoadingTick = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(delayTick, second, false);  
  end

end

function initializeSmallLoading(id, key)
  -- log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  if commonSmallLoading then uninitializeSmallLoading(); end
  commonSmallLoading=CommonSmallLoading.new();
  commonSmallLoading:initialize(id,key);
  isSmallLoadingPopUp = true;
end

function uninitializeSmallLoading(key)
  -- log("--------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  if commonSmallLoading then 
    if commonSmallLoading.key == key then
      commonSmallLoading:uninitialize(key);
      commonSmallLoading=nil;
    else
      return;
    end
  end
  if removeDelaySmallLoadingTick then
     removeTickMaskLayer();
  end
  isSmallLoadingPopUp = false;
end

function getMenuOpened()
  return menu_opened;
end

function setMenuOpened(bool)
  menu_opened=bool;
end
function removeTickMaskLayer()
    if removeTempMaskTick then
      CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(removeTempMaskTick);
      if tempMaskLayer and tempMaskLayer.parent then
        tempMaskLayer.parent:removeChild(tempMaskLayer)
      end
      tempMaskLayer = nil;
      removeTempMaskTick = nil;
    end
end
function addTickMaskLayer(second)

  if removeTempMaskTick then return end;

  if not second then
     second = 2;
  end

  local function tick2(dt)
     removeTickMaskLayer();
  end
  if not removeTempMaskTick then
    removeTempMaskTick = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick2, second, false);  
  end
  if sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS) then
    if not tempMaskLayer then
        tempMaskLayer = LayerColor.new();
        tempMaskLayer:initLayer();
        tempMaskLayer:setColor(ccc3(0,0,0));
        tempMaskLayer:setOpacity(0);
        local mainSize = Director:sharedDirector():getWinSize();
        tempMaskLayer:changeWidthAndHeight(mainSize.width, mainSize.height)
    end
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(tempMaskLayer);
  end
  print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>addTempMaskLayer>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
end

function addMaskLayer(second)

  if not maskLayer then
      maskLayer = LayerColor.new();
      maskLayer:initLayer();
      maskLayer:setColor(ccc3(0,0,0));
      maskLayer:setOpacity(0);
      local mainSize = Director:sharedDirector():getWinSize();
      maskLayer:changeWidthAndHeight(mainSize.width, mainSize.height)
  end
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(maskLayer);
  --print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>addMaskLayer>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
end

function removeMaskLayer()
   if maskLayer and maskLayer.parent then
     maskLayer.parent:removeChild(maskLayer)
   end
   maskLayer = nil;
   --print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>removeMaskLayer>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
end

--artIdWithFrameId形如:1234_1001
function getFrameContentSize(artIdWithFrameId)
	local ccspt = CCSprite:createWithSpriteFrameName(artIdWithFrameId..".swf/0000")
	local rect = ccspt:getTextureRect()
	local width = rect.size.width;
	local height = rect.size.height;
  ccspt:release();
	return {height = height, width = width};
end

--artID:705
function getImageContentSize(artID)
  local ccspt = CCSprite:create(artData[tonumber(artID)].source);
  local size = ccspt:getContentSize()
  return {height = size.height, width = size.width};
end

function createActionManager()
    return CommonUtils:createActionManager()
end

function createScheduler()
    return CommonUtils:createScheduler()
end
  
function setEffectActionScale(effect,number)
  local defaultScheduler = Director.sharedDirector():getScheduler();
    local actionManager = createActionManager();
    local scheduler = createScheduler();
    defaultScheduler:scheduleUpdateForTarget(scheduler, 0, false);
    scheduler:scheduleUpdateForTarget(actionManager, 0, false);
    scheduler:setTimeScale(number);
    effect:setActionManager(actionManager);
end

function analyticalTime(num)
      local strOne;
      if num == 0 then 
        strOne = "00" ;
        return strOne;
      end
      
      if 10 > num and num > 0 then 
        strOne = "0" .. num;
        return strOne;
      end
      if num > 9 then 
        strOne = num;
        return strOne;
      end
      return num;
end

function convertTime(totalTime, timeType)
  local tempTime = totalTime;
      local maxTime = 0;
      local midTime = 0;
      local minTime = 0;
      
      if tempTime >= 60 * 60 then
        maxTime = math.floor(tempTime / (60 * 60));
        local num1 = tempTime - maxTime * 60 * 60;
        tempTime = num1;
      end
      if tempTime >= 60 then
        midTime = math.floor(tempTime / 60);
        local num2 = tempTime - midTime * 60;
        tempTime = num2;
      end
      minTime = tempTime;

      if not timeType then timeType = 2 end;
      if minTime >= 0 then
        local timeString;
        if timeType == 1 then
           timeString = analyticalTime(maxTime) .. " : " .. analyticalTime(midTime) .. " : " .. analyticalTime(minTime);
        elseif timeType == 2 then
           timeString = analyticalTime(maxTime) .. ":" .. analyticalTime(midTime) .. ":" .. analyticalTime(minTime);
        elseif timeType == 3 then
           timeString = analyticalTime(midTime) .. ":" .. analyticalTime(minTime);
        end
        return timeString;
      else
        return "00:00:00";
      end
     
end

--将table的形式存储进文件中
--tblName --下次读取后table的名字
function table.save(tbl,tblName,fileName)
  local file,err = io.open(fileName,"w+");
  if err then 
    error(err);
    return
  end;
  local cEnd,cTab = "\n","  ";
  file:write(tblName.." = {"..cEnd);
  for k,v in pairs(tbl) do
    file:write(cTab..k..' = "'..tostring(v)..'",'..cEnd);
  end
  file:write("}"..cEnd);
  file:close();
end

function  readFileData( fileName )
  -- body
  
  local path = CCFileUtils:sharedFileUtils():fullPathFromRelativePath(fileName)  
  --------------------------------------------lua io  change to cocos2d-x read file
  local file = io.open(path, "r")
  if not file then
    log("file not exist: "..path)
    return nil;
  end
  local t = file:read("*all")
  io.close(file)
  return t;
    ---------------------------------------------------
    -- local t  =  CCFileUtils:getFileData(fileName,"rb");

    -- local  size = string.len(t);
    -- return t;
end

-- 不知道add在哪个层上的，需要add到scene上的
--parent 直截add到父
--index add到父的层级
function commonAddToScene(addDisplay,isMiddle,parent,index)
  local winSize = Director:sharedDirector():getWinSize();
  addDisplay:setScale(GameData.gameUIScaleRate)
  if isMiddle then 
    addDisplay:setPositionXY(0,0)
    
    -- log("GameData.uiOffsetX / 2=="..GameData.uiOffsetX / 2)
    -- log("GameData.uiOffsetY / 2=="..GameData.uiOffsetY / 2)
  
  end
  if parent and addDisplay then
    if not index then
      parent:addChild(addDisplay)
    else
      parent:addChildAt(addDisplay,index)
    end
  else
    local scene = Director.sharedDirector():getRunningScene();  
    -- log("commonAddToScene----1")
    if scene and addDisplay then
      -- log("commonAddToScene----2")
      if not index then
        -- log("commonAddToScene----3")
        scene:addChild(addDisplay)
      else
        -- log("commonAddToScene----4")
        scene:addChildAt(addDisplay,index)
      end
    end
  end
end


function openFade(parent,time)
   time = time or 0.3
   for k1,v1 in pairs(parent:getChildren()) do
     v1:runAction(CCFadeIn:create(time))
   end
end

function closeFade(parent,time)
   time = time or 0.3
   for k1,v1 in pairs(parent:getChildren()) do
     v1:runAction(CCFadeOut:create(time))
   end
end
--parent1为去掉loading中间时候出现Fadein和FadeOut
--parent2为add到父
function blackFadeIn(backFun,time,parent1,parent2,visible)
    if parent1 then 
      backFun()
      return 
    end
    if visible == GameConfig.SCENE_TYPE_6 then
        backFun()
        return
    end
    local time = time or 0.3
    local blackBg = LayerColorBackGround:getBlackBackGround()
    local array = CCArray:create();
    array:addObject(CCFadeIn:create(time))
    local function localFun()
      backFun()
      if blackBg.parent then
          blackBg.parent:removeChild(blackBg);
      end
    end

    array:addObject(CCCallFunc:create(localFun)) 
    blackBg:runAction(CCSequence:create(array))
    blackBg:setPositionY(-GameData.uiOffsetY)
    if not parent2 then
        commonAddToScene(blackBg,nil,nil,10000)
    else
        parent2:addChild(blackBg)
    end
    blackBg:setOpacity(0)
end
--parent1为去掉loading中间时候出现Fadein和FadeOut
--parent2为add到父
function blackFadeOut(backFun,time,parent1,parent2,visible)
    if parent1 then return end
    if visible == GameConfig.SCENE_TYPE_6 then
        if backFun then
          backFun()
        end
        return
    end
    local time = time or 0.3
    local blackBg = LayerColorBackGround:getBlackBackGround()
    local array = CCArray:create();
    array:addObject(CCFadeOut:create(time))
    local function localFun()
      if backFun then
          backFun()
      end
      if blackBg.parent then
          blackBg.parent:removeChild(blackBg);
      end
    end
    array:addObject(CCCallFunc:create(localFun)) 
    blackBg:setPositionY(-GameData.uiOffsetY)
    blackBg:runAction(CCSequence:create(array))
    if not parent2 then
        commonAddToScene(blackBg,nil,nil,10000)
    else
        parent2:addChild(blackBg)
    end
end
function checkAddTutorEffect()
  local userProxy = Facade.getInstance():retrieveProxy(UserProxy.name);
  if userProxy:getLevel() < 20 then
      local hBttonGroupMediator = Facade.getInstance():retrieveMediator(HButtonGroupMediator.name);
      print("mainGeneralLevel < 20")
      if hBttonGroupMediator then
        hBttonGroupMediator:addTutorEffect()
      end
  end
end
function getCurrentBgArtId()
  local storyLineProxy = Facade.getInstance():retrieveProxy(StoryLineProxy.name);
  if 1 == storyLineProxy:getStrongPointState(10001004) then
    return StaticArtsConfig.MAIN_SCENE_BACK_BG_4
  elseif 1 == storyLineProxy:getStrongPointState(10001002) then
    return StaticArtsConfig.MAIN_SCENE_BACK_BG_3
  elseif 1 == storyLineProxy:getStrongPointState(10001001) then
    return StaticArtsConfig.MAIN_SCENE_BACK_BG_2 
  else
    return StaticArtsConfig.MAIN_SCENE_BACK_BG
  end
end


function sendServerTutorMsg(data)
	local BooleanValue = data.BooleanValue and data.BooleanValue or 1;
	local BooleanValue2 = data.BooleanValue2 and data.BooleanValue2 or 0;
	local Stage = data.Stage and data.Stage or analysis("Xinshouyindao_Xinshou", GameVar.tutorStage*100+1, "next")
  local Step = data.Step and data.Step or 0;
	sendMessage(3, 23, {Stage = Stage, Step = Step, BooleanValue = BooleanValue,BooleanValue2=BooleanValue2})
end
function openTutorUI(data)
  OpenTutorUICommand.new():execute(data)
end
function closeTutorUI(bool)
  TutorCloseCommand.new():execute(bool);
end

-- xx:xx:xx
function getTimeFormat1String(remainSecond)
  --print("getTimeFormat1String>>>>>>:"..remainSecond);
  local returnValue = "";
  local tempTime = remainSecond;
  local hourTime = nil;
  local minuteTime = nil;
  local secondTime = 0;
  
  hourTime = math.floor(tempTime/(60*60));
  minuteTime = math.floor((tempTime-hourTime*60*60)/60);
  secondTime = math.floor(tempTime-hourTime*60*60-minuteTime*60);

  if hourTime>100 and hourTime<1000 then
    hourTime = string.sub((1000+hourTime),-3,-1);
  elseif hourTime>1000 and hourTime<10000 then
    hourTime = string.sub((10000+hourTime),-4,-1);
  else
    hourTime = string.sub((100+hourTime),-2,-1);
  end

  minuteTime = string.sub((100+minuteTime),-2,-1);
  secondTime = string.sub((100+secondTime),-2,-1);
 
  returnValue = hourTime..":"..minuteTime..":"..secondTime;
  return returnValue;
end

function getTimeFormat2String(remainSecond)
  --print("getTimeFormat1String>>>>>>:"..remainSecond);
  local returnValue = "";
  local tempTime = remainSecond;
  local hourTime = nil;
  local minuteTime = nil;
  local secondTime = 0;
  
  hourTime = math.floor(tempTime/(60*60));
  minuteTime = math.floor((tempTime-hourTime*60*60)/60);
  secondTime = math.floor(tempTime-hourTime*60*60-minuteTime*60);

  hourTime = string.sub((100+hourTime),-2,-1);
  minuteTime = string.sub((100+minuteTime),-2,-1);
  secondTime = string.sub((100+secondTime),-2,-1);
 
  returnValue = hourTime..":"..minuteTime..":"..secondTime;
  return returnValue;
end


function getHTMLText(itemId,count)
  local str="";
  local vo = analysis("Daoju_Daojubiao",itemId);

  print("debug:>>",itemId)
  if count==nil then
    str = "<font color='"..getColorByQuality(vo.color,true).."'>"..vo.name.."</font>";
  else
    str = "<font color='"..getColorByQuality(vo.color,true).."'>"..vo.name.."x"..count.."</font>";
  end
  
  return str;
end

--调用这个方法来显示隐藏左边的按钮
function setButtonGroupVisible(visible)

  ToAddButtonGroupCommand.new():execute(visible);
  ToAddLeftButtonGroupCommand.new():execute(visible);
end
function setCurrencyGroupVisible(visible)

  ToAddCurrencyGroupCommand.new():execute(visible);

end
function setHButtonGroupVisible(visible)

  ToAddHButtonGroupCommand.new():execute(visible);

end
function setFactionCurrencyVisible(visible)
  if visible then
    OpenFactionCurrencyCommand.new():execute();
  else
    FactionCurrencyCloseCommand.new():execute();
  end
end
-- function setFactionCurrencyBTNVisible(visible)
--   local btn = Facade:getInstance():retrieveMediator(FactionCurrencyMediator.name):getViewComponent().shengguanDO;
--   btn:setVisible(visible);
--   local boneLightCartoon = Facade:getInstance():retrieveMediator(FactionCurrencyMediator.name):getViewComponent().boneLightCartoon;
--   boneLightCartoon:setVisible(visible);
-- end
function onHandleAddTili(data)
  require "main.controller.command.mainScene.ToHandleAddTiliCommand"
  ToHandleAddTiliCommand.new():execute(data);
end


function getFrameNameByGrade(grade)
  local tb = {"commonGrids/common_grid_1",
        "commonGrids/common_grid_2",
        "commonGrids/common_grid_2",--"commonGrids/common_big_grid_3",
        "commonGrids/common_grid_3",
        "commonGrids/common_grid_3",--"commonGrids/common_big_grid_5",
        "commonGrids/common_grid_3",--"commonGrids/common_big_grid_6",
        "commonGrids/common_grid_4",
        "commonGrids/common_grid_4",--"commonGrids/common_big_grid_8",
        "commonGrids/common_grid_4",--"commonGrids/common_big_grid_9",
        "commonGrids/common_grid_4",
        "commonGrids/common_grid_5"};
  return tb[grade];
end

function getSimpleGrade(grade)
  local tb = {1,
        2,
        2,
        3,
        3,
        3,
        4,
        4,
        4,
        4,
        5};
  return tb[grade];
end

function getGradeName(grade)
  local tb = {"",
        "",
        "+1",
        "",
        "+1",
        "+2",
        "",
        "+1",
        "+2",
        "+3",
        ""};
  return tb[grade];
end

function getColorStringByDaojuGrade(grade)
  local str = {"白色","绿色","蓝色","紫色","橙色","红色"};
  return str[grade];
end

function getHeroColorStringByGrade(grade)
  local str = {"白","绿","绿+1","蓝","蓝+1","蓝+2","紫","紫+1","紫+2","紫+3","橙","红"};
  return str[grade];
end

-- 读本地文件
function getLocalInfo(key)
  local returnValue = ""
  if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID then
    returnValue = userInfoSaver:getString(key)
  elseif CommonUtils:getCurrentPlatform() == CC_PLATFORM_WIN32 then
    local accountFile,appDir = nil,"";
    accountFile = io.open(appDir.."Account","r");
    if nil ~= accountFile and nil ~= accountFile:read() then
      dofile(appDir.."Account");
      returnValue = AccountTable[key]
    end
  elseif CommonUtils:getCurrentPlatform() == CC_PLATFORM_IOS then
    returnValue = userInfoSaver:getString(key)

  end

  return returnValue
end

-- 存本地文件
function saveLocalInfo(key,value)
  
  log("saveLocalInfo--key--"..key)
  log("saveLocalInfo--value--"..value)

  if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID then
    userInfoSaver:setString(key,value.."");
    log("saveLocalInfo--key-2-"..key)
    log("saveLocalInfo--value-2-"..value)

  elseif CommonUtils:getCurrentPlatform() == CC_PLATFORM_WIN32 then
    local accountFile,appDir = nil,"";
    accountFile = io.open(appDir.."Account","r");
    if nil ~= accountFile and nil ~= accountFile:read() then
      dofile(appDir.."Account");
      AccountTable[key] = value
      table.save(AccountTable,"AccountTable",appDir.."Account");
    end
  elseif CommonUtils:getCurrentPlatform() == CC_PLATFORM_IOS then
    userInfoSaver:setString(key,value.."");
  end

  -- 读本地文件的设置信息
  if key == "account" then
    GameData.local_account = value
  elseif key == "passWord" then
    GameData.local_passWord = value
  elseif key == "serverId" then
    GameData.local_serverId = value
  elseif key == "serverId2" then
    GameData.local_serverId2 = value
  elseif key == "serverId3"  then
    GameData.local_serverId3 = value
  elseif key == "serverId4"  then
    GameData.local_serverId4 = value
  elseif key == "sound"  then
    GameData.local_sound  = value
  elseif key == "autoButton"  then
    GameData.local_autoButton  = value
  else
    log("key not exist==="..value)
  end

end

 --lua的第1次random数不靠谱，取第3次的靠谱
function getRadomValue()
  local ret=0
  math.randomseed(tostring(os.time()):reverse():sub(1, 6));
  for i=1,3 do
    local n = math.random()
    ret=n
  end
  return ret
end

function getCompositeMainRole(career)
    local po = analysis("Zhujiao_Zhujiaozhiye",career);
    
    local key = "key_"..po.shenti.."_"..BattleConfig.HOLD;
    local url = plistData[key]["source"];
    BitmapCacher:animationCache(url);

    
    -- local key = "key_"..po.shenti.."_"..5;
    -- local url = plistData[key]["source"];
    -- BitmapCacher:animationCache(url);

      
    -- local key = "key_"..po.shenti.."_"..6;
    -- local url = plistData[key]["source"];
    -- BitmapCacher:animationCache(url);


    -- local key = "key_"..po.shenti.."_"..7;
    -- local url = plistData[key]["source"];
    -- BitmapCacher:animationCache(url);  
    local compositeArr = {
          [1] = {["type"] = BattleConfig.TRANSFORM_BODY, ["sourceName"] = po.shenti .. "_" .. BattleConfig.HOLD}
            };

    local roleComposite = CompositeActionAllPart.new();
    roleComposite:initLayer();
    roleComposite:transformPartCompose(compositeArr);
    -- roleComposite:setPositionXY(self.guangbgP.x,self.guangbgP.y-20);
    return roleComposite
end
--bool 是否加载别的动作位图
function getCompositeRole(modelId,bool,isHighLight)
    --local po = analysis("Zhujiao_Zhujiaozhiye",career);
    
    local key = "key_"..modelId.."_"..BattleConfig.HOLD;
    local url = plistData[key]["source"];
    BitmapCacher:animationCache(url);
      
    if bool then
      local totalMemoryOk = true;
      if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID or  CommonUtils:getCurrentPlatform() == CC_PLATFORM_IOS then
        if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID and MetaInfo:getInstance():getTotalMemory() < 800000 then
          totalMemoryOk = false;
        end
      end
      if totalMemoryOk then
        -- local key = "key_"..modelId.."_"..5;
        -- local url = plistData[key]["source"];
        -- BitmapCacher:animationCache(url);    
        -- local key = "key_"..modelId.."_"..6;
        -- local url = plistData[key]["source"];
        -- BitmapCacher:animationCache(url);    

        -- print("+++++++++++++++++++++++++++modelId", modelId)
        -- local key = "key_"..modelId.."_"..7;
        -- local url = plistData[key]["source"];
        -- BitmapCacher:animationCache(url);  
      end
    end
    local compositeArr = {
          [1] = {["type"] = BattleConfig.TRANSFORM_BODY, ["sourceName"] = modelId .. "_" .. BattleConfig.HOLD}};

    local roleComposite = CompositeActionAllPart.new();
    roleComposite:initLayer();
    roleComposite:transformPartCompose(compositeArr,isHighLight);
    -- roleComposite:setPositionXY(self.guangbgP.x,self.guangbgP.y-20);
    return roleComposite
end
function getMeetingOfficer(officerId)
    --local po = analysis("Zhujiao_Zhujiaozhiye",career);
    
    local key = "key_"..officerId;
    local url = plistData[key]["source"];
    BitmapCacher:animationCache(url);
    
    local compositeArr = {
          [1] = {["type"] = BattleConfig.TRANSFORM_BODY, ["sourceName"] = officerId}
            };

    local roleComposite = CompositeActionAllPart.new();
    roleComposite:initLayer();
    roleComposite:transformPartCompose(compositeArr);
    -- roleComposite:setPositionXY(self.guangbgP.x,self.guangbgP.y-20);
    return roleComposite,url
end

function isFileExist(filePath)

  
  if CommonUtils:getCurrentPlatform() ~= CC_PLATFORM_WIN32 then
    filePath = fullPath(filePath,true)
  end

  -- log("filePath========"..filePath)
  return CCFileUtils:sharedFileUtils():isFileExist(filePath)

end


GrowProgressUtil = class();
function GrowProgressUtil:ctor(bar)
  self.bar = bar;
  self.barX = self.bar:getPositionX()
  self.barRect = self.bar:getTextureRect();
  self.barTW = self.barRect.size.width;
end
function GrowProgressUtil:init(rate,step,cycleFunc,context,stopFunc,context1,isNotCycle)
  rate = rate and rate or 1;
  rate = rate>0 and rate or 0.01;
  self.starR = rate;
  self.step = step and step or 0.01;
  self.barW = rate * self.barTW;
  self.isNotCycle = isNotCycle;
  if self.step < 0 then
    self.bar:setTextureRect(CCRectMake(self.barRect.origin.x+self.barRect.size.width-self.barW, self.barRect.origin.y, self.barW, self.barRect.size.height));
    self.bar:setPositionX(self.barX + self.barRect.size.width-self.barW)
  else
    self.bar:setTextureRect(CCRectMake(self.barRect.origin.x, self.barRect.origin.y, self.barW, self.barRect.size.height));
  end
  self.cycleFunc = cycleFunc;
  self.context = context;
  self.stopFunc = stopFunc;
  self.context1 = context1;
end
function GrowProgressUtil:setRate(rate)
  if not self.starR then return end
  if not self.isNotCycle then
    if math.abs(self.starR-rate)<math.abs(self.step) then
      self.starR = self.starR + self.step;
    end
  end
  self:removeLoopTime()
  local function loopFun()
    if not self.isNotCycle then
      if math.abs(self.starR-rate)<math.abs(self.step) then
        self:removeLoopTime()
        if self.stopFunc then
          self.stopFunc(self.context1);
        end
        return;
      end
    else
      if self.starR < rate then
        self.starR = rate;
        self:removeLoopTime()
        if self.stopFunc then
          self.stopFunc(self.context1);
        end
        return;
      end
    end
    self.starR = self.starR + self.step;
    if not self.isNotCycle then
      if self.starR<=0 then
        self.starR = 1;
        if self.cycleFunc then
          self.cycleFunc(self.context);
        end
      elseif self.starR>=1 then
        self.starR = 0;
        if self.cycleFunc then
          self.cycleFunc(self.context);
        end
      end
    end
    self.barW = self.starR * self.barTW;
    if not self.barW or self.barW <=0 then
      self.barW = 1;
    end
    if self.step < 0 then
      self.bar:setTextureRect(CCRectMake(self.barRect.origin.x+self.barRect.size.width-self.barW, self.barRect.origin.y, self.barW, self.barRect.size.height));
      self.bar:setPositionX(self.barX + self.barRect.size.width-self.barW)
    else
      self.bar:setTextureRect(CCRectMake(self.barRect.origin.x, self.barRect.origin.y, self.barW, self.barRect.size.height));
    end
  end
  self.loopFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(loopFun, 0, false)
end
function GrowProgressUtil:dispose()
  self:removeLoopTime()
  self.bar = nil;
  self.barRect = nil;
end

function GrowProgressUtil:removeLoopTime()
  if self.loopFunction then
    Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.loopFunction);
    self.loopFunction = nil;
  end
end

function getMD5()
  return "ce43678c4f0d1cd78bf8ace0aa57d8b9"
end

function setTimeServer(time)
  time_server = os.time() - time;
end

function getTimeServer()
  return os.time() - time_server;
end

function openUrl(url)
  if CommonUtils:getCurrentPlatform() == GameConfig.CC_PLATFORM_WIN32 or GameData.simulator == "1" then -- pc 和模拟器

  else  
    local staticPath = "com/happyelements/langyabang/MainApplication"
    if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID then
      if GameData.platFormID == GameConfig.PLATFORM_CODE_WAN then

      elseif GameData.platFormID == GameConfig.PLATFORM_CODE_LAN then
        staticPath = "com/happyelements/yanhuang/MainApplication"
      end
    end
    openLuaUrl(url,staticPath)
  end 
end

function convertMoney(money)
  money = tonumber(money);
  if 10000 < money then
    local n = money%10000;
    return math.ceil(money/10000) .. "万" .. (0 == n and "" or n);
  end
  return money;
end

function getBuddyValid(userID, userName)
  local userProxy = Facade:getInstance():retrieveProxy(UserProxy.name);
  local buddyListProxy = Facade:getInstance():retrieveProxy(BuddyListProxy.name);
  userID = tonumber(userID);
  if nil == userID and nil == userName then
    sharedTextAnimateReward():animateStartByString("信息为空哦 ~");
    return false;
  end
  if userID == userProxy:getUserID() or userName == userProxy:getUserName() then
    sharedTextAnimateReward():animateStartByString("知道你会加自己的,O(∩_∩)O哈哈 ~!");
    return false;
  end
  if buddyListProxy:getIsHaoyou(userID) or buddyListProxy:getBuddyData(userName) then
    sharedTextAnimateReward():animateStartByString("已经是您的好友了哦 ~");
    return false;
  end
  if buddyListProxy:getBuddyNumFull() then
    sharedTextAnimateReward():animateStartByString("好友数量已达上限哦 ~");
    return false;
  end
  return true;
end

function getUserButtonsSelector(userID, userName, pos, parent)
  require "main.view.chat.ui.chatPopup.ButtonsSelector";
  local userProxy = Facade:getInstance():retrieveProxy(UserProxy.name);
  local buddyListProxy = Facade:getInstance():retrieveProxy(BuddyListProxy.name);
  userID = tonumber(userID);
  local function onLookIntoUser()
    initializeSmallLoading();
    sendMessage(3,11,{UserId=userID,UserName=userName});
  end
  local function onAddBuddy()
    if getBuddyValid(userID, userName) then
      sendMessage(21,4,{UserId=userID,UserName=userName});
      -- sharedTextAnimateReward():animateStartByString("加为好友请求已发出 ~");
    end
  end
  local function onDeleteBuddyConfirm()
    initializeSmallLoading();
    sendMessage(21,3,{UserId=userID,UserName=userName});
  end
  local function onDeleteBuddy()
    local tips=CommonPopup.new();
    tips:initialize("确定删除好友吗?",nil,onDeleteBuddyConfirm,nil,nil,nil,nil,nil,nil,true);
    commonAddToScene(tips, true)
  end
  local buttonsSelector=ButtonsSelector.new();
  local functions;
  local texts;
  if buddyListProxy:getIsHaoyou(userID) then
    functions={onLookIntoUser,onDeleteBuddy};
    texts={"查看","删好友"};
  else
    functions={onLookIntoUser,onAddBuddy};
    texts={"查看","加好友"};
  end
  buttonsSelector:initialize(functions,texts);
  buttonsSelector:setPos(pos);
  parent:addChild(buttonsSelector);
end

function isNeedRemoveMainScript()
  if mainSceneScript then
    mainSceneScript:onTiaoGuoTap()
    return true
  end
end

function getVIPImgMainUI(vipLevel)
  vipLevel = tonumber(vipLevel);
  if 0 == vipLevel then

  else
    if nil == vipLevel or 99 < vipLevel or 0 > vipLevel then
      vipLevel = 0;
    end
    local layer = Layer.new();
    layer:initLayer();
    local img = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_mainui_vip");
    layer:addChild(img);
    local width = -5 + img:getContentSize().width;
    if 10 <= vipLevel then
      local low = vipLevel%10;
      local high = math.floor(vipLevel/10);
      local highVipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_mainui_vip" .. high);
      highVipLevelIcon:setPositionXY(width,14);
      width = highVipLevelIcon:getContentSize().width+width;
      layer:addChild(highVipLevelIcon);

      local vipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_mainui_vip" .. low);
      vipLevelIcon:setPositionXY(width,14);
      layer:addChild(vipLevelIcon);
    else
      local vipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_mainui_vip" .. vipLevel);
      vipLevelIcon:setPositionXY(width,14);
      layer:addChild(vipLevelIcon);
    end
    return layer;
  end
end

function getVIPImg(vipLevel)
  vipLevel = tonumber(vipLevel);
  if 0 == vipLevel then

  else
    if nil == vipLevel or 99 < vipLevel or 0 > vipLevel then
      vipLevel = 0;
    end
    local layer = Layer.new();
    layer:initLayer();
    local img = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_mainui_vip_normal");
    layer:addChild(img);
    local width = 3+img:getContentSize().width;
    if 10 <= vipLevel then
      local low = vipLevel%10;
      local high = math.floor(vipLevel/10);
      local highVipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_vip" .. high);
      highVipLevelIcon:setPositionX(width);
      width = highVipLevelIcon:getContentSize().width+width;
      layer:addChild(highVipLevelIcon);

      local vipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_vip" .. low);
      vipLevelIcon:setPositionX(width)
      layer:addChild(vipLevelIcon);
    else
      local vipLevelIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonNumbers/common_vip" .. vipLevel);
      vipLevelIcon:setPositionX(width);
      layer:addChild(vipLevelIcon);
    end
    return layer;
  end
end

function getGongnengkaiqiWithTishi(function_id)
  local data = analysis("Gongnengkaiqi_Gongnengkaiqi",function_id);
  local openFunctionProxy = Facade:getInstance():retrieveProxy(OpenFunctionProxy.name);
  if openFunctionProxy:checkIsOpenFunction(function_id) then
    return true;
  else
    if 0 ~= data.generals then
      sharedTextAnimateReward():animateStartByString("主角达到" .. data.generals .. "级开启 ~");
      return false;
    end
    if 0 ~= data.guanqiaid then
      sharedTextAnimateReward():animateStartByString("通关《" .. analysis("Juqing_Guanka",data.guanqiaid,"scenarioName") .. "》关卡后开启 ~");
      return false;
    end
  end
end

function popItemDetailLayer(bagItem, parent)
  require "core.utils.LayerColorBackGround";
  require "main.view.bag.ui.bagPopup.DetailLayer";
  local bagProxy = Facade:getInstance():retrieveProxy(BagProxy.name);
  local tipBg=LayerColorBackGround:getOpacityBackGround();
  local layer=DetailLayer.new();
  local function closeTip(event)
    if tipBg.parent then
      tipBg.parent:removeChild(tipBg);
    end
    if layer.parent then
      layer.parent:removeChild(layer);
    end
  end
  tipBg:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  tipBg:addEventListener(DisplayEvents.kTouchTap,closeTip);
  parent:addChild(tipBg);
  layer:initialize(bagProxy:getSkeleton(),bagItem,true,DetailLayerType.KUAI_SU_SUO_YIN,closeTip);
  local size=makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT);
  local popupSize=layer.armature.display:getChildByName("common_background_1"):getContentSize();
  layer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2)-20);
  parent:addChild(layer);
end