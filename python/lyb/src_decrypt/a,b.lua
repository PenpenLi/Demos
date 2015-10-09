--[[require "core.utils.class";
function readUnsignByte(file)
   return string.byte(file:read(1))
end
function readUnsignShort(file)
   local a,b = string.byte(file:read(2),1,2)
   return a * 256 + b
end
function readUnsignInt(file)
   local a,b,c,d = string.byte(file:read(4),1,4)
   return a * 16777216 + b * 65536 + c * 256 + d
end
-- MapPO
MapPO = class()
function MapPO:ctor(id, width, height, xImageNum, yImageNum, imageWidth, imageHeight, defaultWalkable, walkTilesMap, outersMap, backArtArray)
    self.class = MapPO;
    self.id = id;
    self.width = width
    self.height = height
    self.xImageNum = xImageNum
    self.yImageNum = yImageNum
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
   
    self.defaultWalkable = defaultWalkable
    
    self.walkTilesMap = walkTilesMap;
    self.outersMap = outersMap;
    self.backArtArray = backArtArray;
end
OuterVO = class()
function OuterVO:ctor(outerId,type,artId,xPos,yPos,centerX,centerY)
    self.class = OuterVO;
    self.outerId = outerId
    self.type =type;
    self.artId = artId;
    self.xPos = xPos;
    self.yPos = yPos;
    self.centerX = centerX;
    self.centerY = centerY;
end

-- manager
MapDataManager = {
    version = nil,
    mapPOMap = {}
}

function MapDataManager:loadBinFile(mapId)
   local fileName = "resource/maps/map_" ..  mapId .. ".bin"
   local file = io.open(fileName, "rb")
   if file then
      local version = readUnsignByte(file)
      local id =  readUnsignShort(file)
      local width =  readUnsignShort(file)
      local height =  readUnsignShort(file)
      local xImageNum = readUnsignByte(file)
      local yImageNum = readUnsignByte(file)
  
      local imageWidth = readUnsignShort(file)
      local imageHeight = readUnsignShort(file)
      
      local defaultWalkable = readUnsignByte(file)
      local count = readUnsignInt(file)
      local walkTilesMap = {}
      
      for i=1,count,1 do
        local tileId = readUnsignInt(file)
        walkTilesMap[i] = tileId;
      end  
      self.walkTilesMap = walkTilesMap
      
      count = readUnsignInt(file)
      local outersMap = {}
      for i=1,count,1 do
        local outerId = readUnsignInt(file)
        local type = readUnsignInt(file)
        local artIdCount = readUnsignInt(file)
        local artId = file:read(artIdCount)
        local xPos = readUnsignInt(file)
        local yPos = readUnsignInt(file)
        local centerX = readUnsignInt(file)
        local centerY = readUnsignInt(file)
        
        local outerVO = OuterVO.new(outerId, type, artId, xPos, yPos, centerX, centerY)
        outersMap[i] = outerVO;
      end  
      
      count = readUnsignInt(file)
      local backArtArray = {}
      for i=1,count,1 do
        local backartIdLen = readUnsignInt(file)
        local backartId = file:read(backartIdLen)
      
        backArtArray[i] = backartId;
      end  
      
      self.mapPOMap[id] = MapPO.new(id, width, height, xImageNum, yImageNum, imageWidth, imageHeight, defaultWalkable, walkTilesMap, outersMap, backArtArray)
   end
  
end
function MapDataManager:getMapPO(mapId)
    return self.mapPOMap[mapId]
end]]--
MapDataManager = {
    version = nil,
}
function MapDataManager:getMapPO(mapId)
    if not mapId then return end;
    
    local fileName = "resource.maps.map_"..mapId
    if GameData.connectType ~= 0 then
        package.loaded[fileName] = nil
    end
    require(fileName)    
    --require("resource.maps.map_"..mapId)
  
    local maptable = MapLua["map_" .. mapId]
    
    return maptable;
end

function MapDataManager:getCanStand(mapId, xIndex, yIndex)

    return true
    -- local mappo =  MapLua["map_" .. mapId]
    -- local key = "k" .. xIndex .. "_" .. yIndex;
    -- local walkable = mappo.walkTilesTable[key];
    
    -- if 1 == walkable    then
    --     return true
    -- else
    --   return false;



     -- local deltaX = {-1,1,0,0};
--      local deltaY = {0,0,-1,1};
--      local i = 1;
--      while i <= 4 do
--        local x = deltaX[i] + xIndex;
--        local y = deltaY[i] + yIndex;
--        key = "k" .. x .. "_" .. y;
--        if mappo.walkTilesTable[key] then 
--          return true 
--        end;
--      end
--      return false;
    -- end
end