-- spine骨骼动画

SpineCartoon = class(DisplayNode);

function SpineCartoon:ctor()
    self.sprite = nil;
end

-- 创建骨骼动画 返回动画
-- artsID:动画ID 
-- endcallBackFunc:播放完毕的回调
-- 缩放比例
function SpineCartoon:create(artsID,endcallBackFunc,scale)

    local spinePlayer = SpinePlayer:create()
    local jsonStr = "resource/image/arts/"..artsID..".json"
    local atlasStr = "resource/image/arts/"..artsID..".atlas"
    local scaleRate = 1
    if scale then
        scaleRate = scale
    end

    local boneNode = spinePlayer:createSpineAnimate(jsonStr,atlasStr,"attack",endcallBackFunc,scaleRate);  

    self.sprite = CCSprite:create()
    self.sprite:retain();
	self.sprite:addChild(boneNode)

    self.touchEnabled = false
    self.touchChildren = false
end
-- 融合
function SpineCartoon:setMyBlendFunc()
    self.sprite:setMyBlendFunc();
end

-- 销毁
function SpineCartoon:dispose()
    if self.sprite then
        self.sprite:release();
        self.sprite = nil;
    end

    -- 调用父类的dispose方法
    Image.superclass.dispose(self);
end