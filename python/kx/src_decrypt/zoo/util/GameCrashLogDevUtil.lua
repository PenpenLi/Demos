--GameCrashLogDevUtil.lua
function showErrorLog(crashLogPath)
  if not crashLogPath or string.len(crashLogPath) == 0 then
    return false
  end

  local visiableToUser = false
  if StartupConfig:getInstance():isLocalDevelopMode() then
    visiableToUser = true
  end

  if not visiableToUser then
    local userType = UserManager and UserManager.getInstance().userType or 0
    if userType == 1 then
      visiableToUser = true
    end 
  end

  -- if not visiableToUser then
  --   if MaintenanceManager and MaintenanceManager:getInstance():isEnabled("showCrashLog") then
  --     visiableToUser = true
  --   end
  -- end

  if visiableToUser then
    local ErrorLogScene = require("zoo.scenes.ErrorLogScene")
    if not ErrorLogScene then 
      return false 
    end

    local errorLogScene = ErrorLogScene:create(crashLogPath)
    local scene = CCDirector:sharedDirector():getRunningScene()
    if scene then
      CCDirector:sharedDirector():replaceScene(errorLogScene.refCocosObj) 
    else
      CCDirector:sharedDirector():runWithScene(errorLogScene.refCocosObj)
    end
    return true
  else
    return false
  end
end

local crashHandled = false -- 防止处理时出错发生循环调用
-- params
--    string crashLogPath,崩溃日志存储路径
--    boolean isLuaError 是否是lua线程崩溃
-- return
--    boolean 返回true关闭游戏
function onAnimalCrashOccurred(crashLogPath, isLuaError)
  if crashHandled then return true end
  crashHandled = true

  -- print("crashLogPath:", crashLogPath, ",isLuaError:", isLuaError)
  local success, ret = pcall(showErrorLog, crashLogPath)
  if success then
    if type(ret) == "boolean" and ret == true then
      return false
    end
  else
    he_log_error("showErrorLog failed:"..tostring(ret))
  end
  return true
end