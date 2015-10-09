
ArenaBackItem=class(Layer);

function ArenaBackItem:ctor()
    self.class=ArenaBackItem;
end

function ArenaBackItem:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    ArenaBackItem.superclass.dispose(self);
    self.arenaLayer = nil
    self.skeleton = nil
end

function ArenaBackItem:initializeItem(arenaLayer,skeleton,userId)
    self:initLayer();
    self:initializeUI(skeleton)
    self.arenaLayer = arenaLayer
    self.userId = userId
end

function ArenaBackItem:initializeUI(skeleton)
    self.skeleton = skeleton
    self.itembackground = skeleton:getBoneTextureDisplay("itembackground")
    self:addChild(self.itembackground);

    self.itembackground:addEventListener(DisplayEvents.kTouchTap, self.onClickBackTap, self);
end

function ArenaBackItem:onClickBackTap()
    self.arenaLayer:onClickBackTap(self.userId)
end


function ArenaBackItem:refreshItemData(rankGeneralArray,userVO)
    self.rankGeneralArray = rankGeneralArray
    self:refreshHeadImage(rankGeneralArray,userVO)
end

local function sortOnBooleanValue(a, b) return a.BooleanValue > b.BooleanValue end
function ArenaBackItem:refreshHeadImage(rankGeneralArray,userVO)
    table.sort( rankGeneralArray, sortOnBooleanValue )
    local place = 0
    for key,generalVO in pairs(rankGeneralArray) do
        if generalVO.ConfigId ~= 0 then
            local arenaBackSmallItem = ArenaBackSmallItem.new()
            arenaBackSmallItem:initializeItem(self.skeleton,generalVO,userVO)
            arenaBackSmallItem:setPositionXY(15,297-place*92)
            self:addChild(arenaBackSmallItem)
            arenaBackSmallItem.touchEnabled = false;
            arenaBackSmallItem.touchChildren = false
            place = place + 1
        end
    end
    local size = self:getGroupBounds().size
    self:changeAnchorPoint(size.width/2,size.height/2)
end

-------------------------------------------------------------------------------
--class ArenaBackSmallItem
-------------------------------------------------------------------------------

ArenaBackSmallItem=class(Layer);

function ArenaBackSmallItem:ctor()
    self.class=ArenaBackSmallItem;
end

function ArenaBackSmallItem:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    ArenaBackSmallItem.superclass.dispose(self);
end

function ArenaBackSmallItem:initializeItem(skeleton,generalVO,userVO)
    self:initLayer();
    self:initializeUI(skeleton,generalVO,userVO)
end

function ArenaBackSmallItem:initializeUI(skeleton,generalVO,userVO)
    local armature=skeleton:buildArmature("itembg_ui");
    self.armature = armature;
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();

    local armature_d=armature.display;
    self:addChild(armature_d);
    self.armature_d = armature_d;

    local PO = generalVO.BooleanValue ~= 1 and analysis("Kapai_Kapaiku", generalVO.ConfigId) or analysis("Zhujiao_Zhujiaozhiye",generalVO.ConfigId);

    local wuXingImage = CommonSkeleton:getBoneTextureDisplay("commonImages/common_shuxing_"..PO.wuXing);
    wuXingImage:setScale(0.48)
    self:addChild(wuXingImage);
    wuXingImage:setPositionXY(190,6);  

    local name = generalVO.BooleanValue ~= 1 and PO.name or userVO.UserName
    local text_data = self.armature:getBone("name_num_text").textData;
    if generalVO.BooleanValue == 1 then
        text_data.size = 20
    end
    self.nameNumText = createTextFieldWithTextData(text_data,name);
    self:addChild(self.nameNumText);

    local text_data = self.armature:getBone("level_num_text").textData;
    local level = generalVO.Level or 0
    self.levelNumText = createTextFieldWithTextData(text_data,"Lv."..level);
    self:addChild(self.levelNumText);

    local heroRoundPortrait = HeroRoundPortrait.new();
    generalVO.IsMainGeneral = generalVO.BooleanValue
    generalVO.Grade = generalVO.Grade == 0 and 11 or generalVO.Grade
    heroRoundPortrait:initialize(generalVO);
    heroRoundPortrait:setScale(0.75);
    heroRoundPortrait:setPositionXY(7,-3)
    self:addChild(heroRoundPortrait)
end

function ArenaBackSmallItem:heroStars(number)
    for i=1,5 do
        local nameString;
        if i <= number then
            nameString = "commonImages/common_star_small";
        else
            nameString = "commonImages/common_star_kong_small";
        end
        local star = CommonSkeleton:getBoneTextureDisplay(nameString);
        star:setPositionXY(-14+18*i,-10)
        star:setScale(0.8)
        self:addChild(star)
    end
end