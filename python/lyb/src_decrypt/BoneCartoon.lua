-- spritstudoi骨骼动画

BoneCartoon = class(DisplayNode);

function BoneCartoon:ctor()
    self.sprite = nil;
end

-- 创建骨骼动画 返回动画
-- artsID:动画ID 
-- loopCount 0是无限播放，其他时候就是播放次数
-- endcallBackFunc:播放完毕的回调
-- 自定义帧回调 返回描述str
function BoneCartoon:create(artsID,loopCount,endcallBackFunc,userDataFunc)

    local spriteStudio = SpriteStudio:create()
    spriteStudio:setEndCallBackFunc(endcallBackFunc);
    spriteStudio:setUserDataFunc(userDataFunc);

    if not loopCount then
        loopCount = 1
    end
    
    local boneNode = spriteStudio:createBoneAnimateBatch("resource/image/arts/",artsID..".ssba",loopCount);  

    self.sprite = CCSprite:create()
    self.sprite:retain();
	self.sprite:addChild(boneNode)

    self.touchEnabled = false
    self.touchChildren = false
end
-- 融合
function BoneCartoon:setMyBlendFunc()
    self.sprite:setMyBlendFunc();
end

-- 销毁
function BoneCartoon:dispose()
    if self.sprite then
        self.sprite:release();
        self.sprite = nil;
    end

    -- 调用父类的dispose方法
    Image.superclass.dispose(self);
end