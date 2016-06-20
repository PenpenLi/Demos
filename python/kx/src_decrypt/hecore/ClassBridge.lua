CCSprite = HeSprite
CCParticleBatchNode = HeParticleBatchNode
CCParticleSystem = HeParticleSystem
CCScale9Sprite = HeScale9Sprite
CCSpriteBatchNode = HeSpriteBatchNode
CCSpriteFrame = HeSpriteFrame
CCSpriteFrameCache = HeSpriteFrameCache
CCTexture = HeTexture
CCTextureAtlas = HeTextureAtlas
CCTextureCache = HeTextureCache
CCLabelBMFont = HeLabelBMFont
CCAnimate = HeAnimate
CCAnimation = HeAnimation
CCParticleSystemQuad = HeParticleSystemQuad
CCProgressTimer = HeProgressTimer
CCRenderTexture = HeRenderTexture

local forbiddenEtc = false

if __ANDROID then
	local deviceType = MetaInfo:getInstance():getMachineType() or ""
	if string.sub(deviceType,1,4) == "GT-I" then
		forbiddenEtc = true
	end
end

if forbiddenEtc then
	HeTextureCache:sharedTextureCache():disableETCHardware()
end