
Handler_7_4 = class(MacroCommand)

--中毒掉血
function Handler_7_4:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    local souceUnitID
    local battleUnitID
    local currentHP
    local changeValue
    local currentRage
    local changeValue1
    local sanBi;--1 闪避 2 抵抗
    local isBaoJi;
    local isZhuDang;
    local zhuDangZhi;
    local skillID;

    if not battleProxy.handlerType then
        battleUnitID = recvTable["BattleUnitID"];
        changeValue = recvTable["ChangeValue"];
        changeValue1 = recvTable["ChangeValue1"];
        skillID = recvTable["SkillID"];
        sanBi = recvTable["SanBi"];
        isBaoJi = recvTable["isBaoJi"];
        isZhuDang = recvTable["isZhuDang"];
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        battleUnitID = handlerData.BattleUnitID
        changeValue = handlerData.ChangeValue
        changeValue1 = handlerData.ChangeValue1
        skillID =handlerData.SkillID;
        sanBi = handlerData.SanBi;
        isBaoJi = handlerData.isBaoJi;
        isZhuDang = handlerData.isZhuDang;
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
        package.loaded["main.controller.handler.Handler_7_4"] = nil
    end
    local battleGeneralVO = battleProxy.battleGeneralArray[battleUnitID];
    if not battleGeneralVO then return;end
    if battleGeneralVO:getCurrHp() <=0 then return end
    if sanBi then
        battleGeneralVO:onSanBi(sanBi);
    else
        if isBaoJi == 1 then
            battleGeneralVO:changeHP(changeValue);
            battleGeneralVO:onBaoJi(isBaoJi,changeValue,skillID)
        elseif isZhuDang == 1 then
            battleGeneralVO:changeHP(changeValue);
            battleGeneralVO:onZhuDang(isZhuDang,changeValue,skillID)
        else
            battleGeneralVO:changeHP(changeValue,true,skillID);
        end  
    end
    battleGeneralVO:changeRange(changeValue1);
    local battleMediator = self:retrieveMediator(BattleSceneMediator.name)
    battleMediator:refreshRangeData(battleGeneralVO)
    if battleGeneralVO:getCurrHp() <= 0 then
        battleMediator:refreshDeadHeadImgGray(battleUnitID)
        -- battleGeneralVO.actionManager:playDeadAnimation()
    end
end

Handler_7_4.new():execute();