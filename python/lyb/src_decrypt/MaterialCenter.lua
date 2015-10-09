require "core.net.HttpClient"
require "main.managers.MaterialObserver"
MaterialCenter = {
  downloadingSet = {},
  observerMap = {},
  loadedResource = {},
  curObserver = nil
};

function MaterialCenter:registerMaterial(artsToLoad, target, loadCallBack)
--  local key = "k_" .. tostring(target);
--  local observer = MaterialObserver.new(artsToLoad, target, loadCallBack);
--  self.observerMap[key] = observer;
 
--    local observer = MaterialObserver.new(artsToLoad, target, loadCallBack);
--    table.insert(self.observerMap, 1, observer);
--    self:beginLoad();

    self.curObserver = MaterialObserver.new(artsToLoad, target, loadCallBack);
    self:loadArts(self.curObserver.artsToLoad);
end

function MaterialCenter:beginLoad()
  local len = table.getn(self.observerMap);
  if len > 0 then
    self.curObserver =  self.observerMap[1];
    self:loadArts(self.curObserver.artsToLoad);
  end
 
end
--if isArtId is true we need to get value from file arts.lua
function MaterialCenter:loadArts(artsToLoad, isArtId)
--  if CommonUtils:getCurrentPlatform() == GameConfig.CC_PLATFORM_WIN32 then
--    print("win32 platform");
--    self:handleWinPlatform(artsToLoad);
--  else
--    print("android platform");
    for i_k, i_v in pairs(artsToLoad) do
    
      if not Utils:contain(self.loadedResource,i_v) then
          local relativePath;
          if isArtId then
            relativePath = artData[i_v].source;
          else
            relativePath = i_v;
          end
         
          local request = URLRequest.new("http://www.script.com/".. relativePath);
          request.relativePath = relativePath;
          request.method = HttpRequestMethods.kDownload;
          local httpClent = HttpClient.new();
          httpClent:load(request);
          httpClent:addEventListener(Events.kComplete, self.onLoadOneArtComplete, self);
      end
    end
--  end
end
function MaterialCenter:onLoadOneArtComplete(e)
    local client = e.target;
   
    local artSource;-- todo jiasq
    if client then
       artSource = client.request.relativePath;
    else
       artSource = e;
    end
 
    table.insert(self.loadedResource, artSource);
    self.curObserver.target:loadCallBack(artSource);
end

function MaterialCenter:handleWinPlatform(artsToLoad)
    local len = #artsToLoad;
    while len > 0 do
      self:onLoadOneArtComplete(artsToLoad[len]);
      len = len -1;
    end
end