

local const_power_1=256;
local const_power_2=65536;
local const_power_3=16777216;
local stringReaded=nil;
local index=0;

local function getUnsignedByte()
	local a=string.byte(stringReaded,index,index);
	index=1+index;
	return a;
end

local function getUnsignedShort()
	local a,b=string.byte(stringReaded,index,1+index);
	index=2+index;
	return const_power_1*a+b;
end

local function getUnsignedInt()
	local a,b,c,d=string.byte(stringReaded,index,3+index);
	index=4+index;
	return const_power_3*a+const_power_2*b+const_power_1*c+d;
end

local function getString()
	local len=getUnsignedInt();
	local str=string.sub(stringReaded,index,-1+len+index);
	index=len+index;
	return str;
end

local function split(str, pattern)
    local subTable = {};
    while (true) do
        local pos = string.find(str, pattern);
        if (not pos) then
            subTable[#subTable+1] = str;
            break;
        end
        local subString = string.sub(str, 1, pos-1);
        subTable[#subTable + 1] = subString;
        str = string.sub(str, pos+1, #str);
    end

    return subTable;
end

function configTableDecoder(uri)
	--[[
	local file=io.open(uri);

	stringReaded=file:read("*a");
	index=1;
	file:close();
	file=nil;]]--waver change
	stringReaded = readFileData(uri);
	index = 1;

	local version=getUnsignedByte();
	local dataLength=getUnsignedShort();
	local typeTable=split(getString(),",");
	local items={};

	for i=1,dataLength do
		local item={};
		for k,v in pairs(typeTable) do
			if 	"int"==v then
				table.insert(item,getUnsignedInt());
			elseif "byte"==v then
				table.insert(item,getUnsignedByte());
			elseif "short"==v then
				table.insert(item,getUnsignedShort());
			elseif "string"==v then
				table.insert(item,getString());
			else
				error("invalid type");
			end
		end
		table.insert(items,item);
	end
	stringReaded=nil;
	index=0;
	return items;
end
