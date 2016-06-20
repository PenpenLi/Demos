
-- 播放主船开火动画
require (BATTLE_CLASS_NAME.class)
local BAForShipPlayFireAnimation = class("BAForShipPlayFireAnimation",require(BATTLE_CLASS_NAME.BaseAction))
 BAForShipPlayFireAnimation.shipid = nil
 BAForShipPlayFireAnimation.fireAnimationName = nil

return BAForShipPlayFireAnimation