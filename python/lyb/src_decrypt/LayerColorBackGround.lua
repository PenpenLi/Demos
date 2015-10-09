-----------
--LayerColorBackGround
-----------

LayerColorBackGround = {};
--全局UI半透背景
function LayerColorBackGround:getBackGround()
    local winsize = Director:sharedDirector():getWinSize()
    local layerColor = LayerColor.new();
    if nil==opacity then opacity=255; end
    layerColor:initLayer();
    layerColor:changeWidthAndHeight(winsize.width,winsize.height + 20);
    layerColor:setColor(ccc3(0,0,0));
    layerColor:setOpacity(opacity);
    return layerColor,winsize.width,winsize.height + 20;
end

function LayerColorBackGround:getBlackBackGround()
    local winsize = CCDirector:sharedDirector():getWinSize()
    local layerColor = LayerColor.new();
    layerColor:initLayer();
    layerColor:changeWidthAndHeight(winsize.width*2,winsize.height*2);
    layerColor:setColor(ccc3(0,0,0));
    layerColor:setOpacity(255);
    return layerColor;
end

function LayerColorBackGround:getWhiteBackGround()
    local winsize = CCDirector:sharedDirector():getWinSize()
    local layerColor = LayerColor.new();
    layerColor:initLayer();
    layerColor:changeWidthAndHeight(winsize.width,winsize.height);
    layerColor:setColor(ccc3(255,255,255));
    layerColor:setOpacity(255);
    return layerColor;
end

function LayerColorBackGround:getTransBackGround()
    local winsize = Director:sharedDirector():getWinSize()
    local layerColor = LayerColor.new();
    layerColor:initLayer();
    layerColor:changeWidthAndHeight(winsize.width,winsize.height);
    layerColor:setColor(ccc3(0,0,0));
    layerColor:setOpacity(125);
    return layerColor;
end

function LayerColorBackGround:getOpacityBackGround()
    local winsize = Director:sharedDirector():getWinSize()
    local layerColor = LayerColor.new();
    layerColor:initLayer();
    layerColor:changeWidthAndHeight(winsize.width,winsize.height);
    layerColor:setColor(ccc3(0,0,0));
    layerColor:setOpacity(0);
    return layerColor;
end

function LayerColorBackGround:getCustomBackGround(w, h, opacity)
    local layerColor = LayerColor.new();
    layerColor:initLayer();
    layerColor:changeWidthAndHeight(w,h);
    layerColor:setColor(ccc3(0,0,0));
    layerColor:setOpacity(opacity);
    return layerColor;
end