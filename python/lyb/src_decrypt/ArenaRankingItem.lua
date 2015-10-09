
ArenaRankingItem=class(Layer);

function ArenaRankingItem:ctor()
    self.class=ArenaRankingItem;
end

function ArenaRankingItem:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    ArenaRankingItem.superclass.dispose(self);
end

function ArenaRankingItem:initializeItem(skeleton,rankVO)
    self:initializeUI(skeleton,rankVO)
end

function ArenaRankingItem:initializeUI(skeleton,rankVO)
    local armature=skeleton:buildArmature("phbItem_ui");
    self.armature = armature;
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();

    local armature_d=armature.display;
    self:addChild(armature_d);
    self.armature_d = armature_d;

    if rankVO.Ranking == 1 then
        local oneimage = skeleton:getBoneTextureDisplay("oneimage")
        oneimage:setPositionXY(40,0)
        self:addChild(oneimage)
    elseif rankVO.Ranking == 2 then
        local twoimage = skeleton:getBoneTextureDisplay("twoimage")
        twoimage:setPositionXY(40,30)
        self:addChild(twoimage)
    elseif rankVO.Ranking == 3 then
        local threeimage = skeleton:getBoneTextureDisplay("threeimage")
        threeimage:setPositionXY(40,30)
        self:addChild(threeimage)
    else
        local text_data = self.armature:getBone("paiming_num_text").textData;
        self.paimingText = createTextFieldWithTextData(text_data,rankVO.Ranking);
        self:addChild(self.paimingText);
    end

    local text_data = self.armature:getBone("name_text").textData;
    self.nameText = createTextFieldWithTextData(text_data,rankVO.ParamStr1);
    self:addChild(self.nameText);

    local text_data = self.armature:getBone("zhanli_text").textData;
    self.zhanliText = createTextFieldWithTextData(text_data,"战力：");
    self:addChild(self.zhanliText);

    local text_data = self.armature:getBone("level_text").textData;
    self.levelText = createTextFieldWithTextData(text_data,"LV"..rankVO.ParamStr4);
    self:addChild(self.levelText);

    local text_data = self.armature:getBone("zhanli_num_text").textData;
    self.zhanliNumText = createTextFieldWithTextData(text_data,rankVO.ParamStr3);
    self:addChild(self.zhanliNumText);

    local gradeP = armature_d:getChildByName("headicon"):getPosition()
    local grade = CommonSkeleton:getBoneTextureDisplay("commonImages/common_round_grid_" .. getSimpleGrade(tonumber(rankVO.ParamStr5)));
    if not grade then
        grade = CommonSkeleton:getBoneTextureDisplay("commonImages/common_round_grid_1");
    end
    grade:setPosition(gradeP)
    self:addChild(grade)
    
    local artId = analysis("Zhujiao_Zhujiaozhiye",rankVO.ParamStr2,"art3")
    local image = getImageByArtId(artId)
    image:setPositionXY(gradeP.x+13,gradeP.y+13)
    self:addChild(image)
end