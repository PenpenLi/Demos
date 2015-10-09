--决战
Handler_16_1 = class(Command);

-- local function sortOnIndex(a, b) return a.Ranking < b.Ranking end
function Handler_16_1:execute()
    
    -- local arenaProxy = self:retrieveProxy(ArenaProxy.name)
    -- arenaProxy.ranking = recvTable["Ranking"];
    -- arenaProxy.userArenaArray = recvTable["UserArenaArray"];
    -- table.sort( arenaProxy.userArenaArray, sortOnIndex )
    -- arenaProxy.generalIdArray = recvTable["GeneralIdArray"]
    -- arenaProxy.generalIdArray2 = recvTable["GeneralIdArray2"]

    print("Handler_16_1",recvTable["Season"],recvTable["RemainSeconds"],recvTable["Ranking"],recvTable["Score"],recvTable["Count"]);
    for k,v in pairs(recvTable["UserArenaArray"]) do
        print("Handler_16_1.");
        for k_,v_ in pairs(v) do
            print("Handler_16_1..",k_,v_);
        end
    end

    local data = {};
    data.Season=recvTable["Season"];
    data.RemainSeconds=recvTable["RemainSeconds"];
    data.Ranking=recvTable["Ranking"];
    data.Score=recvTable["Score"];
    data.Count=recvTable["Count"];
    data.UserArenaArray=recvTable["UserArenaArray"];
    -- data.UserArenaArray={{ConfigId=2,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=0},
    -- {ConfigId=2,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=1},
    -- {ConfigId=2,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=1},
    -- {ConfigId=2,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=0},
    -- {ConfigId=2,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=0},
    -- {ConfigId=2,UserId=0,UserName="名字六个吱吱",Level=100,Score=99999,BooleanValue=0}};
    
    local jingjichangMediator=self:retrieveMediator(JingjichangMediator.name);
    if jingjichangMediator then
        jingjichangMediator:getViewComponent():refreshData(data);
    end

    if GameVar.tutorStage == TutorConfig.STAGE_1016 then
        local arenaProxy = self:retrieveProxy(ArenaProxy.name);
        if arenaProxy.afterBattle then

        else
          local index = 1;
          for k,v in ipairs(recvTable["UserArenaArray"]) do
            if v.BooleanValue == 0 then
                break;
            end
            index = index + 1;
          end
          print("index index index index index index",  index)
          if index == 1 then

          else
            GameVar.tutorSmallStep = 101601;
            openTutorUI({x=954, y=469-(index-1)*108, width = 130, height = 51, alpha = 125});
          end
        end
    end


end

Handler_16_1.new():execute();