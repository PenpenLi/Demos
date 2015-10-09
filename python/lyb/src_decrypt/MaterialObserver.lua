require "core.utils.class"

MaterialObserver = class();

function MaterialObserver:ctor(artsToLoad, target, loadCallBack)
    self.artsToLoad = artsToLoad;
    self.target = target;
    self.loadCallBack = loadCallBack;

end
