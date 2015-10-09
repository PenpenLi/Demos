

BattleChangeHPCommand=class(Command);

function BattleChangeHPCommand:ctor()
	self.class=BattleChangeHPCommand;
  self.battleProxy = nil;
  self.battleMediator  = nil
end

function BattleChangeHPCommand:execute(notification)
	require "main.config.BattleConfig"
	require "main.view.battleScene.BattleLayerManager"
    --战场数据
    self.battleProxy = self:retrieveProxy(BattleProxy.name);
    self:changeHPAction(notification.battleUnitID)
end
    --所有人都会飘字
function BattleChangeHPCommand:changeHPAction(playerUnitID)
    local roleVO = self.battleProxy.battleGeneralArray[playerUnitID];
    if roleVO.isMyHero then
        local battleMediator = self:retrieveMediator(BattleSceneMediator.name);
        local currentHP = roleVO:getCurrHp() <= 0 and 0 or roleVO:getCurrHp()
        battleMediator:refreshHpData(roleVO,currentHP/roleVO:getMaxHP())
    end
end
