--=====================================================
-- 名称：     Global
-- @authors： 赵新
-- @mail：    xianxin.zhao@happyelements.com
-- @website： http://www.cnblogs.com/tinytiny/
-- @date：    2014-01-17 14:53:05
-- @descrip： 全局方法调用	  
-- All Rights Reserved. 
--=====================================================

-- 通过artid获取一个显示对象
function getImageByArtId(artId)
	local image = Image.new();
	image:loadByArtID(tonumber(artId))
	image.touchEnabled=false;
	image.touchChildren=false;
	return image;
end

-- 通过fla元件名称获取一个显示对象
function getImageByFlaObjName(skeleton,groupName,objName)
	local armature= skeleton:buildArmature(groupName);
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	local armature_d = armature.display;
	local image = armature_d:getChildByName(objName);
	return image;
end


-- -- 通过fla元件名称获取一个显示对象
-- function getImageByFlaObjName(skeleton,groupName,objName)
-- 	local armature= skeleton:buildArmature(groupName);
-- 	armature.animation:gotoAndPlay("f1");
-- 	armature:updateBonesZ();
-- 	armature:update();
-- 	local armature_d = armature.display;
-- 	local image = armature_d:getChildByName(objName);
-- 	return image;
-- end

local skeletons = {};
--龙骨
function getSkeletonByName(name)
	if not skeletons[name] then
		local skeleton = SkeletonFactory.new();
		skeleton:parseDataFromFile(name);
		skeletons[name] = skeleton;
	end
	return skeletons[name];
end

--通过img名称获得img[非九宫格]
function getImgByName(skeleton,name,left_top_boolean)
	return skeleton:getBoneTextureDisplay("commonNumbers/"..name, left_top_boolean);
end

--通过img名称获得img[九宫格]
function getBoneTexture9Display(name,left_top_boolean,size)
	return SkeletonFactory:getBoneTexture9DisplayBySize("commonNumbers/"..name, left_top_boolean,size);
end

--获取全局的宽高
function getGameSize()
	return  Director:sharedDirector():getWinSize();
end;

--获取全局的宽高
function getExcelData(name)
	local function sortFun(a, b)
		if a.id < b.id then	return true; end
		return false;
	end
	local returnValue = {};
	local rechargePoTable = analysisTotalTable(name); 
	if not rechargePoTable then return nil; end;
	table.remove(rechargePoTable,1);
	for i_k, i_v in pairs(rechargePoTable) do
		table.insert(returnValue, i_v)
	end
	table.sort( returnValue, sortFun )
	return returnValue;
end;

--- @brief 调试时打印变量的值
--- @param data 要打印的字符串
--- @param [max_level] table要展开打印的计数，默认nil表示全部展开
--- @param [prefix] 用于在递归时传递缩进，该参数不供用户使用于
--- @ref http://dearymz.blog.163.com/blog/static/205657420089251655186/
function dump(data, max_level, prefix)
    if type(prefix) ~= "string" then
        prefix = ""
    end
    if type(data) ~= "table" then
        print(prefix .. tostring(data))
    else
        print(data)
        if max_level ~= 0 then
            local prefix_next = prefix .. "    "
            print(prefix .. "{")
            for k,v in pairs(data) do
                io.stdout:write(prefix_next .. k .. " = ")
                if type(v) ~= "table" or (type(max_level) == "number" and max_level <= 1) then
                    print(v)
                else
                    if max_level == nil then
                        var_dump(v, nil, prefix_next)
                    else
                        var_dump(v, max_level - 1, prefix_next)
                    end
                end
            end
            print(prefix .. "}")
        end
    end
end

--分隔数字
function splitNum(num)
	local str = "" .. num;
	local numTb = {};
	local basicNum = 10;
	for i=1,#str do
		local yuNum = num%10;
		num = math.floor(num/10);
		table.insert(numTb, yuNum);
		
	end

	return numTb;

end;

--消息提示
function showNotice(str)
	sharedTextAnimateReward():animateStartByString(str);
end;