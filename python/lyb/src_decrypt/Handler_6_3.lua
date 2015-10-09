
Handler_6_3 = class(Command);

function Handler_6_3:execute()
  local generalIdArray = recvTable["ItemIdArray"]

  local dataTable = {}
  local sameHeroTable = {}  -- 可能的相同英魂
  local index = 1
  for k,v in pairs(generalIdArray) do
    local sTable = {}
    local itemPO = analysis("Daoju_Daojubiao", v.ItemId)
    log("v.ItemId=="..v.ItemId)
    if itemPO.functionID == 4 then -- 英魂的话
      local hasSame = false
      if sameHeroTable[itemPO.parameter1] then
        hasSame = true
      else
        sameHeroTable[itemPO.parameter1] = itemPO.parameter1
      end 
      
      local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name)
      local heroData = heroHouseProxy:getGeneralDataByConfigID(itemPO.parameter1)
      local cardTable = analysis("Kapai_Kapaiku", itemPO.parameter1)

      sTable["isCard"] = 1
      sTable["ConfigId"] = itemPO.parameter1
      sTable["StarLevel"] = 0
      sTable["Grade"] = cardTable.quality
      sTable["Level"] = 1
      sTable["ItemId"] = v.ItemId
      sTable["count"] = v.Count
      
      if heroData ~= nil or hasSame then -- has this hero
        local soulTable = StringUtils:lua_string_split(cardTable.soul,",")
        local itemPO1 = analysis("Daoju_Daojubiao", soulTable[1])
        local heroSoulCount = soulTable[2]
        sTable["ItemId"] = itemPO1.id
        sTable["count"] = heroSoulCount and tonumber(heroSoulCount) or 1
        sTable["art"] = itemPO1.art
        sTable["name"] = itemPO1.name
        sTable["color"] = itemPO1.color
        sTable["functionID"] = itemPO1.functionID
      end
    else -- 其他道具
      sTable["isCard"] = 0
      sTable["ItemId"] = v.ItemId
      sTable["count"] = v.Count
      sTable["art"] = itemPO.art
      sTable["name"] = itemPO.name
      sTable["color"] = itemPO.color
      sTable["functionID"] = itemPO.functionID
    end

    table.insert(dataTable,sTable)
    
  end

  local langyalingMediator = self:retrieveMediator(LangyalingMediator.name)
  if langyalingMediator then
    langyalingMediator:popCard(dataTable)                
  end
end

Handler_6_3.new():execute();