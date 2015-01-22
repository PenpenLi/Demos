require "hecore.display.Director"

local kCharacterAnimationTime = 1/24

LinkedItemAnimation = class()

function LinkedItemAnimation:buildPortalEnter()
	local sprite = Sprite:createWithSpriteFrameName("portal_enter0000")
	local frames = SpriteUtil:buildFrames("portal_enter%04d", 0, 59)
  	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
    sprite:play(animate)
  	
  	return sprite
end

function LinkedItemAnimation:buildPortalExit()
	local sprite = Sprite:createWithSpriteFrameName("portal_exit0000") 
	local frames = SpriteUtil:buildFrames("portal_exit%04d", 0, 60)
  	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
  	sprite:play(animate)

  	local sprite2 = Sprite:createWithSpriteFrameName("portal_effect0000")
  	animate = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("portal_effect%04d", 0, 64), kCharacterAnimationTime)
  	sprite2:play(animate)
  	sprite2:setPositionXY(0, 50)
  	sprite:addChild(sprite2)
  	return sprite
end

function LinkedItemAnimation:buildPortalBoth()
	local sprite2 = self:buildPortalEnter()
	local sprite1 = self:buildPortalExit()
	sprite2:setPositionXY(37, -65)
	sprite1:addChild(sprite2)
	return sprite1;
end
