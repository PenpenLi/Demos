

ArenaTeamItem=class(Layer);

function ArenaTeamItem:ctor()
    self.class=ArenaTeamItem;
    self.armature = nil;
    self.armature_d = nil;
end

function ArenaTeamItem:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    ArenaTeamItem.superclass.dispose(self);
end

function ArenaTeamItem:initializeItem(popUp,generalVO,flag) 

    -- self:initViewUI(popUp)

    self:initHeroData(popUp,generalVO,flag)

    -- self:setProgressData(popUp,generalVO)
end

function ArenaTeamItem:setProgressData(popUp,generalVO)
    local VO = self:getStateVO(popUp,generalVO)
    if VO then
        self.bloodProgress = ProgressBar.new(self.armature,"hp_pro");
        self.bloodProgress:setProgress(VO.CurrentHP/100000)
        self.powerProgress = ProgressBar.new(self.armature,"power_pro");
        self.powerProgress:setProgress(VO.CurrentMP/100000)
    end
end

function ArenaTeamItem:getStateVO(popUp,generalVO)
    for key,VO in pairs(popUp.tenCountryProxy.generalStateArray) do
        if generalVO.GeneralId == VO.GeneralId then
            return VO
        end
    end
end

function ArenaTeamItem:initHeroData(popUp,generalVO,flag)
    self.generalId = generalVO.generalId;
    require "main.view.hero.heroTeam.ui.HeroTeamSlot";
    self.heroTeamSlot = HeroTeamSlot:create();
    self.heroTeamSlot:initialize();
    self.heroTeamSlot:setSlotData(generalVO);
    self.heroTeamSlot:setPositionY(240);
    self.heroTeamSlot:removeArmatureListener()
    self:addChild(self.heroTeamSlot);

    if not flag then
        self.heroTeamSlot:initScaleAnimation()
        self.heroTeamSlot:setContentSize(CCSizeMake(180,210));
        self.heroTeamSlot:setAnchorPoint(CCPointMake(0.5,-0.5));
    end
end

function ArenaTeamItem:initViewUI(popUp)

    local armature=popUp.skeleton:buildArmature("blood_ui");
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();
    self.armature = armature;
    
    local armature_d=armature.display;
    self.armature_d = armature_d;
    self:addChild(armature_d);
end

function ArenaTeamItem:onCloseButtonTap()
    self.popUp:onUIClose()
end

function ArenaTeamItem:onFightButtonTap()
    self.popUp:onUIClose()
end
