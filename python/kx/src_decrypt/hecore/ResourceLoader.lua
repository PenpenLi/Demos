require "hecore.utils"

ResCallbackEvent = table.const {
  onSuccess = "onSucess",
  onError = "onError",
  onProcess = "onProcess",
  onPrompt = "onPrompt"
}

ResourceLoader = { }

function ResourceLoader.init()
  return ResManager:getInstance():initStaticConfig();
end

function ResourceLoader.getCurVersion()
  return ResManager:getInstance():getCurVersion()
end

function ResourceLoader.getFileSize(virtualPath)
  return ResManager:getInstance():getFileSize(virtualPath)
end 

function ResourceLoader.loadRequiredRes(callback)
  local function onSuccess(data)
    callback(ResCallbackEvent.onSuccess, { items = data })
  end
  local function onError(errorCode, item)
    callback(ResCallbackEvent.onError, { errorCode = errorCode, item = item })
  end
  local function onProcess(process)
    callback(ResCallbackEvent.onProcess, process)
  end
  ResManager:getInstance():loadRequiredRes(onSuccess, onError, onProcess)
end

function ResourceLoader.loadRequiredResWithPrompt(callback, isNeedSpeedLimit)
  isNeedSpeedLimit = isNeedSpeedLimit or false
  print("ResourceLoader.loadRequiredResWithPrompt(callback)")
  local function onSuccess(data)
    print("ResourceLoader.loadRequiredResWithPrompt(callback):onSuccess")
    callback(ResCallbackEvent.onSuccess, { items = data })
  end
  local function onError(errorCode, item)
    print("ResourceLoader.loadRequiredResWithPrompt(callback):onError")
    callback(ResCallbackEvent.onError, { errorCode = errorCode, item = item })
  end
  local function onProcess(process)
    print("ResourceLoader.loadRequiredResWithPrompt(callback):onProcess")
    callback(ResCallbackEvent.onProcess, process)
  end
  local function onPrompt(data)
    print("ResourceLoader.loadRequiredResWithPrompt(callback):onPrompt")
    callback(ResCallbackEvent.onPrompt, { status = data, resultHandler = function(r) 
            ResManager:getInstance():notifyPromptResult(r)
          end })
  end
  ResManager:getInstance():loadRequiredResWithPrompt(onSuccess, onError, onProcess, onPrompt, isNeedSpeedLimit)
  print("~ResourceLoader.loadRequiredResWithPrompt(callback)")
end

function ResourceLoader.loadSpecifiedRes(virtualPaths, callback)
  local function onSuccess(data)
    callback(ResCallbackEvent.onSuccess, data)
  end
  local function onError(errorCode, item)
    callback(ResCallbackEvent.onError, { errorCode = errorCode, item = item })
  end
  local function onProcess(process)
    callback(ResCallbackEvent.onProcess, process)
  end
  ResManager:getInstance():loadSpecifiedRes(virtualPaths, onSuccess, onError, onProcess)
end

function ResourceLoader.loadThirdPartyRes(urls, callback)
  local function onSuccess(data)
    callback(ResCallbackEvent.onSuccess, data)
  end
  local function onError(errorCode, item)
    callback(ResCallbackEvent.onError, { errorCode = errorCode, item = item })
  end
  ResManager:getInstance():loadThirdPartyRes(urls, onSuccess, onError)
end


