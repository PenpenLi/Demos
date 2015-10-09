AvatarUtil = {
};


--actionId动作编号，2是跑
function AvatarUtil:cacheCompositeRoleTable(itemIdBody, itemIdWeapon, actionId)
  
  
  local sourceTable = {[1] = plistData["key_" .. itemIdBody .. "_" .. actionId].source
                        };
  for k,v in ipairs(sourceTable) do
      BitmapCacher:animationCache(v);
      GameData.deleteAllMainSceneTextureMap[v] = v;
  end
end
--actionId动作编号，2是跑
function AvatarUtil:getCompositeRoleTable(itemIdBody, itemIdWeapon, actionId)
  
  
  local sourceTable = {[1] = plistData["key_" .. itemIdBody .. "_" .. actionId].source
                        };
  for k,v in ipairs(sourceTable) do
      BitmapCacher:animationCache(v);
      GameData.deleteAllMainSceneTextureMap[v] = v;
  end
  
  return {[1] = {["type"] = BattleConfig.TRANSFORM_BODY, ["sourceName"] = itemIdBody .. "_" .. actionId}
          };
end