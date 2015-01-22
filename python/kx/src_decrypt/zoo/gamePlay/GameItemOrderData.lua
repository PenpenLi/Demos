
require "zoo.util.MemClass"

GameItemOrderData = memory_class()

GameItemOrderType = table.const
{
	kNone = 0,
	kAnimal = 1,
	kSpecialBomb = 2,
	kSpecialSwap = 3,
	kSpecialTarget = 4,
	kOthers = 5,
	kSeaAnimal = 6,
}

GameItemOrderType_SB = table.const -- Special Bomb
{
	kLine = 1,
	kWrap = 2,
	kColor = 3,
}

GameItemOrderType_SS = table.const -- Special Swap
{
	kLineLine = 1,
	kWrapLine = 2,
	kColorLine = 3,
	kWrapWrap = 4,
	kColorWrap = 5,
	kColorColor = 6
}

GameItemOrderType_ST = table.const -- Special Target
{
	kSnowFlower = 1,
	kCoin = 2,
	kVenom = 3,
	kSnail = 4,
	kGreyCuteBall = 5,
	kBrownCuteBall = 6,
}

GameItemOrderType_Others = table.const
{
	kBalloon = 1, 
	kBlackCuteBall = 2,
	kHoney = 3,
}

GameItemOrderType_SeaAnimal = table.const
{
	kPenguin = 1,
	kSeal 	 = 2,
	kSeaBear = 3,
}

local currGameItemOrderDataClassID = 0
function GameItemOrderData:ctor()
	currGameItemOrderDataClassID = currGameItemOrderDataClassID + 1
	self.__class_id = currGameItemOrderDataClassID
	self.encryptValueKey = "Game."..self.__class_id

	self.key1 = 0;
	self.key2 = 0;
	self.v1 = 0;
	self.f1 = 0;
end


function GameItemOrderData:encryptionFunc( key, value )
	if key == "f1" then
		encrypt_integer_f(self.encryptValueKey, value)
		return true
	end
	return false
end
function GameItemOrderData:decryptionFunc( key )
	if key == "f1" then
		return decrypt_integer_f(self.encryptValueKey)
	end
	return nil
end

function GameItemOrderData:dispose()
	--HeMemDataHolder:deleteByKey(self.encryptValueKey)
	mem_deleteByKey(self.encryptValueKey)
end

-- k1 = GameItemOrderType, k2 = GameItemOrderType_**, v1 = 目标数 , f1 = finished(完成的)
function GameItemOrderData:create(k1,k2,v1)
	local v = GameItemOrderData.new()
	v.key1 = k1
	v.key2 = k2
	v.v1 = v1;
	return v
end

function GameItemOrderData:copy()
	local r = GameItemOrderData.new()
	r.key1 = self.key1
	r.key2 = self.key2
	r.v1 = self.v1
	r.f1 = self.f1
	return r
end