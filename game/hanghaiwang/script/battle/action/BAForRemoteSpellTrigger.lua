

-- 远程弹道的触发 暂时只是一个计时器
require (BATTLE_CLASS_NAME.class)
local BAForRemoteSpellTrigger = class("BAForRemoteSpellTrigger",require(BATTLE_CLASS_NAME.BaseAction))

return BAForRemoteSpellTrigger