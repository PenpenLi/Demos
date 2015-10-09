require "main.common.transform.BitmapCacher"
require "core.controls.ProgressBar"
require "core.display.Layer";
require "core.controls.LoadingShowLayer";

LoadingPopup=class(TouchLayer);

function LoadingPopup:ctor()
  self.class=LoadingPopup;
  self.totalCount = nil;
  self.hasLoadCount = 0;
  self.artsToLoad = nil;
  self.loadingUpdateID = -1;
  self.hasLoadPercent = 0;
  self.isTips = false
end

function LoadingPopup:dispose()
--   -- log("--------------------------------------LoadingPopup:dispose")
--   self.loadingEffect = nil
--   self:removeAllEventListeners();
--   self:removeChildren();
--   LoadingPopup.superclass.dispose(self);
--   -- self.armature:dispose()
--   BitmapCacher:removeUnused();
--   self:removeLoadingUpdateID()
end


function LoadingPopup:initialize(skeleton)
  self:initLayer();

  self.loadingShowLayer = LoadingShowLayer:static_create(nil, nil);
  self.loadingShowLayer.touchEnabled = true
  self:setTouchEnabled(true)
  self:addChild(self.loadingShowLayer);
end

function LoadingPopup:initLoadData(data)

  self.artsToDelete = data["artsToDelete"]
  self.artsToLoad = data["artsToLoad"]

  local deleteCount
  local loadCount
  if self.artsToDelete then
    deleteCount = #self.artsToDelete
  else
    deleteCount = 0
  end

  if self.artsToLoad then
    loadCount = #self.artsToLoad
  else
    loadCount = 0
  end

  self.totalCount = deleteCount + loadCount 

  print("artstoLoad count", self.totalCount);

  self.hasLoadCount = 0; 

  self.loadingShowLayer:setProgress(self.hasLoadPercent);

  if #self.artsToDelete ~= 0 then
    BitmapCacher:deleteCallBackTextureMap(self.artsToDelete, self, self.deleteLoadCallBack);
  else
    self:deleteLoadCallBack(0, true);
  end

  
  if self.isTips then
	  local tipsTableCount = 0
	  local tipsTable = analysis("Tishi_Xiaotieshi")
	  if tipsTable then
  		for k,v in pairs(tipsTable) do
  		  tipsTableCount = tipsTableCount + 1
  		end 
	  end

	  local randomNO = math.random(1,tipsTableCount - 1)
	  local tishiTips = analysis("Tishi_Xiaotieshi",randomNO,"description");
  end
end
function LoadingPopup:resetLoadData(count)
    if self.hasLoadPercent then
      log(self.hasLoadPercent);
    else
      log("self.hasLoadPercent is nil");
    end
    self.hasLoadPercent = self.hasLoadPercent + count / 100;
    if self.hasLoadPercent then
      log(self.hasLoadPercent);
    else
      log("self.hasLoadPercent is nil");
    end

    self.loadingShowLayer:setProgress(self.hasLoadPercent);
    -- log("setProgress success");
end
function LoadingPopup:loadCallBack()
    if self.isDisposed then
      return;
    end
    
    self.hasLoadCount = self.hasLoadCount + 1;
    
    local percent = self.hasLoadCount / self.totalCount;
    if percent < self.hasLoadPercent then
      percent = self.hasLoadPercent + .005;
      if percent > 1 then
           percent = 1;
      end
      self.hasLoadPercent = percent
    end
    if percent>1 then
      percent=1;
    end

    self.loadingShowLayer:setProgress(percent);

    if self.hasLoadCount == self.totalCount then
        log("self.hasLoadCount == self.totalCount")
        self.hasLoadPercent = 0;
        local loadEvent = Event.new("ON_LOAD_COMPLETE", nil, self);
        self:dispatchEvent(loadEvent); 
    end

end

function LoadingPopup:deleteLoadCallBack(removeCount, isComplete)

    self.hasLoadCount = self.hasLoadCount + removeCount;

    local tempLoadPercent = (self.hasLoadCount / self.totalCount)-- * self.coefficient;
    if tempLoadPercent > self.hasLoadPercent then
      self.hasLoadPercent = tempLoadPercent;
    else
      self.hasLoadPercent = self.hasLoadPercent + 0.01
    end
   
    self.loadingShowLayer:setProgress(self.hasLoadPercent);

    if isComplete then

      if #self.artsToLoad ~= 0 then
        BitmapCacher:animationCacheByArray(self.artsToLoad, self, self.loadCallBack);
      else
        log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! loadComplete  !!!!!!")
        self.hasLoadPercent = 0;
        
        local loadEvent = Event.new("ON_LOAD_COMPLETE", nil, self);
        self:dispatchEvent(loadEvent); 
      end      
    end

end

function LoadingPopup:addLoadImage()

	if self.logImage and self.logandNameDO:contains(self.logImage) then
		self.logandNameDO:removeChild(self.logImage)
		self.logImage = nil
	end
end


function LoadingPopup:removeLoadingUpdateID()
    if self.loadingUpdateID then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.loadingUpdateID);
        self.loadingUpdateID = nil
    end
end