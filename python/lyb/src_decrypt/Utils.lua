
Utils = {};

function Utils:clearTables(...)
	for k1,v1 in ipairs(arg) do
        if type(v1) == "table" then
            for k2,v2 in pairs(v1) do
                v1[k2] = nil;
            end
        end
    end
end

function Utils:contain(tb,item)
    if tb == nil then return false; end
    for k,v in pairs(tb) do
        if v == item then  return true; end
    end
    return false;
end

function Utils:remove(tb,item)
    if tb == nil then return false; end
    for k,v in pairs(tb) do
        if v == item then  
            tb[k] = nil;
            return true;
        end
    end
    return false;
end
function Utils:getItemCount(tb)
    local returnValue = 0;
    for k,v in pairs(tb) do
        returnValue = returnValue + 1;
    end
    return returnValue;
end

--tb必须是个数组
function Utils:indexOf(tb,item)
    for k,v in ipairs(tb) do
       if item == v then
         return k;
       end
    end
    return nil;
end


--tabel排序
function Utils:pairsByKeys(t,f)
    local a={};
    for i,n in pairs(t) do
      a[#a+1] = n
    end
    table.sort(a,f)
    return a;
end




--根据数字返回对应数字的图片
function Utils:getNumImg(numStr,scaleNum,style,gap)
    if not numStr or numStr=="" then return;end
    style = style and style or "common_battle_bigred";
    scaleNum = scaleNum and scaleNum or 1;
    gap = gap and gap or 0;
    
    local numImg = Layer.new();
    numImg:initLayer();
    local siteW = 0;
    local siteH = 0;
    local curSite = 0;
        
    for i=1,#numStr do
        local char = string.sub(numStr,i,i);
        local charImg = CommonSkeleton:getBoneTextureDisplay(style..char);
        local charImgSize = charImg:getContentSize();  
        siteW=siteW+charImgSize.width;
        siteH=siteH>charImgSize.height and siteH or charImgSize.height;
--        charImg:setAnchorPoint(CCPointMake(0,0)); 
        charImg:setPositionXY(curSite,0);
        curSite = siteW+i*gap;
        numImg:addChild(charImg);
    end
       
    numImg:setScale(scaleNum);    
    numImg:setContentSize(makeSize(curSite*scaleNum, siteH*scaleNum));
    
    return numImg;
end