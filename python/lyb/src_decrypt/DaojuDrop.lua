
DaojuDrop = class();

function DaojuDrop:ctor()
    self.class = DaojuDrop;
    self.iconArray = {}
    self.itemQueueID = 1
    require "main.view.battleScene.function.DaojuDropItem"
end

function DaojuDrop:removeSelf()
    self.class = nil;
end

function DaojuDrop:dispose()
    self:removeSelf();
    self.fightUI = nil
    self.effectLayer = nil
end

function DaojuDrop:initDropDaoju(dropDaojuArray,position,fightUI)
	self.effectLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS)
	for key,itemVO in pairs(dropDaojuArray) do
		local daojuPO = analysis("Daoju_Daojubiao",itemVO.ItemId);
		if itemVO.ItemId == 2 then--银两
			self:dropSilverIcon(itemVO.Count,position,fightUI,"silver")
		elseif daojuPO.functionID == 4 then--卡牌
			self:daoju_Icon(itemVO.Count,position,fightUI,"daoju",itemVO.ItemId)
		elseif daojuPO.functionID ~= 0 then--道具
			self:daoju_Icon(itemVO.Count,position,fightUI,"daoju",itemVO.ItemId)
		end
	end
	self.fightUI = fightUI
end

function DaojuDrop:daoju_Icon(count,position,fightUI,itemType,ItemId)
	for i=1,count do
		self:addDaojuIcon(1060,1,position,i,fightUI,itemType,ItemId)
	end
end

function DaojuDrop:dropSilverIcon(count,position,fightUI,itemType)
	local itemNumber = math.random(2,3)
	local average = count/itemNumber
	local yu = count%itemNumber
	local imageID = 1062
	for i=1,itemNumber do
		if i ~= itemNumber then
			self:addDaojuIcon(imageID,average,position,i,fightUI,itemType)
		else
			self:addDaojuIcon(imageID,average+yu,position,i,fightUI,itemType)
		end
	end
end

function DaojuDrop:addDaojuIcon(imageID,itemCount,position,place,fightUI,itemType,ItemId)
	self.itemQueueID = self.itemQueueID + 1
	local imageIcon = DaojuDropItem.new();
	imageIcon:initLayer()
	imageIcon:loadByArtID(imageID,itemType,ItemId)
	imageIcon:setPosition(position)
	imageIcon:initIconData(self,itemCount,place,self.itemQueueID,fightUI,itemType)
	imageIcon.name = BattleConfig.Is_Daoju_Drop
	self.effectLayer:addChild(imageIcon)
	table.insert(self.iconArray,imageIcon)
end

function DaojuDrop:clickBackFun(itemQueueID)
	for key,icon in pairs(self.iconArray) do
		if icon.itemQueueID == itemQueueID then
			if icon.itemType == "silver" then
				self.fightUI:addYinliang(icon.itemCount)
			else
				self.fightUI:addBaoxiang(icon.itemCount)
			end
			self.fightUI:removeChild(icon)
			table.remove(self.iconArray,key)
		end
	end
end

local function sortOnIndex(a, b) 
	if a.targetX and b.targetX then
		return a.targetX < b.targetX 
	else
		return false
	end
end
function DaojuDrop:forceToMove()
	local number = 0
	table.sort(self.iconArray,sortOnIndex)
	for key,vlaue in pairs(self.iconArray) do
		vlaue:forceToMove(number)
		number = number + 1
	end
end
