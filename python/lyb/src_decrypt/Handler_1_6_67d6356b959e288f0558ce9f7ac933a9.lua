

-- 心跳成功
Handler_1_6 = class(Command);

function Handler_1_6:execute()
          --心跳成功
          GameData.heartHitCount = 0
end

Handler_1_6.new():execute();