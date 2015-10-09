
require "main.view.family.FamilyMediator";
require "main.view.possessionBattle.PossessionBattleMediator";

Handler_27_2 = class(Command);

function Handler_27_2:execute()
    local userProxy = self:retrieveProxy(UserProxy.name);
    local familyProxy = self:retrieveProxy(FamilyProxy.name);
    local mapSceneData = {}
    userProxy.sceneType = GameConfig.SCENE_TYPE_4
    mapSceneData["sceneType"] = userProxy.sceneType
    mapSceneData["banquetData"] = userProxy.banquetData
    mapSceneData["from"] = GameConfig.SCENE_TYPE_1
    mapSceneData["SceneMemberArray"] = recvTable["SceneMemberArray"]

    local tishi = analysis("Tishi_Tishineirong", 1013, "captions")
    
    if "" == recvTable["ParamStr1"] then
        familyProxy.gongGao = tishi;
    else
        familyProxy.gongGao = recvTable["ParamStr1"] --ParamStr1,UserName,ConfigId
    end
    familyProxy.bangZhuName = recvTable["UserName"]--ParamStr1,UserName,ConfigId
    familyProxy.bangZhuConfigId = recvTable["ConfigId"]

    print("familyProxy.gongGao, familyProxy.bangZhuConfigId:", familyProxy.gongGao, familyProxy.bangZhuConfigId)
    -- mapSceneData["SceneMemberArray"] = {[1]={UserId=1,UserName="刘虹霞",Vip=2800,ConfigId=8000,CoordinateX=700,CoordinateY=200,Level=2},[2]={UserId=2,UserName="胖子",Vip=11,ConfigId=9000,CoordinateX=900,CoordinateY=200,Level=2},[3]={UserId=3,UserName="胖子软绵绵",Vip=3,ConfigId=9000,CoordinateX=1100,CoordinateY=200,Level=2},[4]={UserId=4,UserName="胖子2",Vip=9000,ConfigId=9000,CoordinateX=1300,CoordinateY=200,Level=2},[5]={UserId=5,UserName="胖子3",Vip=9000,ConfigId=9000,CoordinateX=1400,CoordinateY=200,Level=2}};
    local data = {type = GameConfig.SCENE_TYPE_1, mapSceneData = mapSceneData};
    BeginLoadingSceneCommand.new():execute(LoadingNotification.new(LoadingNotifications.BEGIN_LOADING_SCENE, data))
end

Handler_27_2.new():execute();