
UserCurrencyProxy=class(Proxy);

function UserCurrencyProxy:ctor()
  self.class=UserCurrencyProxy;
  self.gold=0;
 
  self.silver=0;
  self.tili=0; -- 体力
  self.prestige=0;
  self.familyContribute=0;
  self.score = 0;
  self.friendPoint = 0;
  self.strongPoint = 0;
  
--不用了的。
  self.soulSpar = 0;--魂晶，神秘商店用
  self.generalEmployScore=0;  --用户积分
  self.potentialPoint = 0;
  self.vitality=0; 
  self.bindingGold=0;
  self.storyLineStar = 0;
end

rawset(UserCurrencyProxy,"name","UserCurrencyProxy");

--更新用户货币
function UserCurrencyProxy:refresh(gold, silver,  tili, prestige, score, familyContribute, storyLineStar)
  self.gold=gold;
  self.silver=silver;
  self.tili=tili;
  self.prestige=prestige;
  self.familyContribute=familyContribute;
  self.score = score;
  self.storyLineStar = storyLineStar;
  -- self.friendPoint=friendPoint;
  -- self.strongPoint=strongPoint;
end


function UserCurrencyProxy:getGold()
  return self.gold;
end

function UserCurrencyProxy:getSilver()
  return self.silver;
end

function UserCurrencyProxy:getTili()
  return self.tili;
end
function UserCurrencyProxy:getPrestige()
  return self.prestige;
end

function UserCurrencyProxy:getFamilyContribute()
  return self.familyContribute;
end

function UserCurrencyProxy:getScore()
  return self.score or 0;
end
function UserCurrencyProxy:getFriendPoint()
  return self.friendPoint;
end
function UserCurrencyProxy:getStrongPoint()
  return self.strongPoint;
end


function UserCurrencyProxy:getGeneralEmployScore()
  return self.generalEmployScore;
end

function UserCurrencyProxy:getMoneyByItemID(itemID)
  if 2==itemID then
    return self:getSilver();
  elseif 3==itemID then
    return self:getGold();
  elseif 4==itemID then
    return self:getBindingGold();
  elseif 10 == itemID then
    return self:getFamilyContribute();
  end
  return 0;
end

function UserCurrencyProxy:getPeerageID()
  local a=1;
  while analysisHas("Wujiang_Juewei",a) do
    if analysis("Wujiang_Juewei",a,"prestige")>self.prestige then
      break;
    end
    a=1+a;
  end
  return -1+a;
end



-- 1 经验
-- 2 银两
-- 3 元宝
-- 4 绑定元宝
-- 6 体力
-- 7 声望
-- 8 充值元宝
-- 9 vip点
-- 10  家族贡献
-- 11  积分
-- 12  银域币
-- 13  魂晶
-- 14  剧情星星
-- 15  资质点

function UserCurrencyProxy:getValueByMoneyType(moneyType)
  local t = {};
  t[2] = self.silver;  
  t[3] = self.gold;
  t[4] = self.bindingGold;
  t[6] = self.tili;
  t[7] = self.prestige;
  t[10] = self.familyContribute;
  t[11] = self.generalEmployScore;
  t[13] = self.soulSpar;
  t[14] = self.storyLineStar;
  t[15] = self.potentialPoint;
  t[16] = self.friendPoint;  
  return t[moneyType];
end