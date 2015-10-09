StringUtils = {
};

--string split
function StringUtils:lua_string_split(str, split_char, length)
    if not str then
      error("str is nil")
    end
    local len = length and length or 1;
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + len, #str);
    end
    return sub_str_tab;
end

--string split
function StringUtils:stuff_string_split(str)
    if not str then
      error("str is nil")
    end
    local tab={};
    local sub_str_tab=self:lua_string_split(str,";");
    for k,v in pairs(sub_str_tab) do
        local a=self:lua_string_split(v,",");
        table.insert(tab,a);
    end
    return tab;
end
--string split
function StringUtils:broad_string_split(str)
    local tab={};
    local sub_str_tab=self:lua_string_split(str,";");
    for k,v in pairs(sub_str_tab) do
        local a=self:lua_string_split(v,"#");
        table.insert(tab,a);
    end
    return tab;
end
--
function StringUtils:string_insert(str,char)
     print("!!!!!!!!!!!!!!!!!!!!!!!!*****")
    local strTemp = ""
    local sub_str_tab=self:lua_string_split(str,"");
    print("!!!!!!!!!!!!!!!!!!!!!!!!*****", #sub_str_tab)
    for k,v in pairs(sub_str_tab) do
        strTemp = strTemp .. char.. v;
    end
    return strTemp;
end
--由1替换成2
function StringUtils:stuff_string_replace(str,rep1,rep2,length)
    local strArr = StringUtils:lua_string_split(str,rep1,length)
    local leng = table.getn(strArr);
    local strTemp = ""
    for k,v in pairs(strArr) do
        if leng == k then
            strTemp = strTemp..v;
        else
            strTemp = strTemp..v..rep2;
        end
    end
    return strTemp;
end

function StringUtils:substr(your_string)
  if 5<CommonUtils:calcCharCount(your_string) then
    local s_len=string.len(your_string);
    local i=0;
    while s_len>i do
      i=1+i;
      local s=CommonUtils:substr(your_string,0,i);
      if 4==CommonUtils:calcCharCount(s) then
        return  s .. "...";
      end
    end
  end
  return your_string;
end

function StringUtils:getString4Popup(id, args)
    local str=analysis("Tishi_Wenzitishi",id,"id1");
    str=analysis("Tishi_Tishineirong",str,"captions");
    local rep={};
    local function cf(sstr, sc, i)
        local a=string.find(sstr,sc,i);
        if a then
            local k="#"==sc and "0" or string.sub(sstr,1+a,1+a);
            local v=a;
            table.insert(rep,{k=k,v=v});
            cf(sstr,sc,"#"==sc and 1+a or 2+a);
        end
    end
    local function sf(a, b)
        if a.v<b.v then
            return true;
        end
        return false;
    end
    local function gn(t)
        local a=0;
        for k,v in pairs(t) do
            if "0"~=v.k then
                a=1+a;
            end
        end
        return a;
    end
    local function ht(k, arg)
        local a='<font color="';
        local b='';
        local data;
        if "0"==k then
            b=getColorByQuality(nil,true) ..'">' .. arg;
        elseif "1"==k then
            data=analysis("Daoju_Daojubiao",arg);
            b=getColorByQuality(data.color,true) ..'">' .. data.name;
        elseif "2"==k then
            data=analysis("Chongwu_Chongwu",arg);
            b=getColorByQuality(data.quality,true) ..'">' .. data.name;
        elseif "3"==k then
            data=analysis("Guanxing_Xingshuxing",arg);
            b=getColorByQuality(data.quality,true) ..'">' .. data.name;
        elseif "4"==k then
            data=analysis("Yinghun_Yinghunku",arg);
            b=getColorByQuality(data.quality,true) ..'">' .. data.name;
        else
            error("error : invalid data");
        end
        return a .. b .. '</font>';
    end
    if not args then args={}; end
    cf(str,"#",1);
    cf(str,"@",1);
    table.sort(rep,sf);
    if #args~=#rep then
        error("error : invalid data");
    elseif 0==#rep then
        return str;
    elseif 0==gn(rep) then
        local a='';
        local b=1;
        for k,v in pairs(rep) do
            a=a .. string.sub(str,b,-1+v.v) .. args[k];
            b=1+v.v;
        end
        return a .. string.sub(str,b,#str);
    else
        local a='<content>';
        local b=1;
        local c;
        for k,v in pairs(rep) do
            c=string.sub(str,b,-1+v.v);
            if ''==c then

            else
                c='<font color="#FFFFFF">' .. c .. '</font>';
            end
            a=a .. c .. ht(v.k,args[k]);
            b=("0"==v.k and 1 or 2)+v.v;
        end
        c=string.sub(str,b,#str);
        if ''==c then

        else
            c='<font color="#FFFFFF">' .. string.sub(str,b,#str) .. '</font>';
        end
        return a .. c .. '</content>';
    end
end

function StringUtils:getButtonString4Popup(id)
    local a=analysis("Tishi_Wenzitishi",id,"id1");
    return {analysis("Tishi_Tishineirong",a,"blue"),analysis("Tishi_Tishineirong",a,"brown")};
end

function StringUtils:getContentData(str)
  local repl={};
  local repr={};
  local function cf(sstr, sc, i, t)
    local a=string.find(sstr,sc,i);
    if a then
      table.insert(t,a);
      cf(sstr,sc,1+a,t);
    end
  end
  cf(str,"<",1,repl);
  cf(str,">",1,repr);
  if #repl~=#repr then
    error("error : invalid data");
  end
  if 0==#repl%2 then

  else
    error("error : invalid data");
  end
  for k,v in pairs(repl) do
    if v<repr[k] then
      if repl[1+k] then
        if repl[1+k]>repr[k] then

        else
          error("error : invalid data"); 
        end
      end
    else
      error("error : invalid data");  
    end
  end
  local a=1;
  local b=#repl;
  local ds={};
  while a<=b do
    local s=string.sub(str,repl[a],repr[a]);
    local type=0;
    local paramStr1="";
    local paramStr2="";
    local paramStr3="";
    local paramStr4="";
    if string.find(s,"font") then
      type=ConstConfig.CHAT_CONTENT_ARRAY_TYPE_FONT;
      local ics=string.find(s,'"');
      local ice=string.find(s,'"',1+ics);
      paramStr1=string.sub(s,2+ics,-1+ice);
      local ils=string.find(s,'"',1+ice);
      local ile;
      if ils then
        ile=string.find(s,'"',1+ils);
        paramStr2=string.sub(s,1+ils,-1+ile);
      end
      if ils then
        local ihs=string.find(s,'"',1+ile);
        local ihe;
        if ihs then
          ihe=string.find(s,'"',1+ihs);
          paramStr3=string.sub(s,1+ihs,-1+ihe);
        end
      end
      if repr[a]<-1+repl[1+a] then
        paramStr4=string.sub(str,1+repr[a],-1+repl[1+a]);
      end
    elseif string.find(s,"image") then
      type=ConstConfig.CHAT_CONTENT_ARRAY_TYPE_IMG;
      local ils=string.find(s,'"');
      local ile;
      if ils then
        ile=string.find(s,'"',1+ils);
        paramStr1=string.sub(s,1+ils,-1+ile);
      end
      if repr[a]<-1+repl[1+a] then
        paramStr2=string.sub(str,1+repr[a],-1+repl[1+a]);
        paramStr2=StringUtils:lua_string_split(paramStr2,"/");
        paramStr2=paramStr2[table.getn(paramStr2)];
        local ii=string.find(paramStr2,"p");
        paramStr2=string.sub(paramStr2,1,-2+ii);
      end
    else
      error("error : invalid data");
    end
    table.insert(ds,{Type=type,ParamStr1=paramStr1,ParamStr2=paramStr2,ParamStr3=paramStr3,ParamStr4=paramStr4});
    a=2+a;
  end
  return ds;
end

function StringUtils:setContentData(arr)
  local str='';
  for k,v in pairs(arr) do
    if ConstConfig.CHAT_CONTENT_ARRAY_TYPE_FONT==v.Type then
      str=str .. '<font color="#' .. v.ParamStr1 .. '"';
      local isChatName=false;
      if ''~=v.ParamStr2 then
        local a=StringUtils:lua_string_split(v.ParamStr2,",");
        a[1]=tonumber(a[1]);
        if ConstConfig.CHAT_NAME==a[1] and ConstConfig.USER_NAME==a[2] then
          isChatName=true;
        else
          str=str .. ' link="' .. v.ParamStr2 .. '"';
        end
      end
      if ''~=v.ParamStr3 then
        if isChatName then

        else
          str=str .. ' ref="' .. v.ParamStr3 .. '"';
        end
      end
      str=str .. '>' .. v.ParamStr4 .. '</font>';
    elseif ConstConfig.CHAT_CONTENT_ARRAY_TYPE_IMG==v.Type then
      str=str .. '<image' .. (''~=v.ParamStr1 and ' link=' .. v.ParamStr1 or '') .. '>resource/faces/' .. v.ParamStr2 .. '.png</image>';
    end
  end
  return str;
end

function StringUtils:setContentData4GM(arr)
  local str='';
  for k,v in pairs(arr) do
    if ConstConfig.CHAT_CONTENT_ARRAY_TYPE_FONT==v.Type then
      str=str .. '<font color="#' .. v.ParamStr1 .. '"';
      local isChatName=false;
      if ''~=v.ParamStr2 then
        local a=StringUtils:lua_string_split(v.ParamStr2,",");
        a[1]=tonumber(a[1]);
        if ConstConfig.CHAT_NAME==a[1] and ConstConfig.USER_NAME==a[2] then
          isChatName=true;
        else
          str=str .. ' link="' .. v.ParamStr2 .. '"';
        end
      end
      if ''~=v.ParamStr3 then
        if isChatName then

        else
          str=str .. ' ref="' .. v.ParamStr3 .. '"';
        end
      end
      str=str .. '>' .. v.ParamStr4 .. '</font>';
    end
  end
  return str;
end

function StringUtils:getCountByContent(content)
  local a=0;
  for k,v in pairs(content) do
    if ConstConfig.CHAT_CONTENT_ARRAY_TYPE_IMG==v.Type then
      a=1+a;
    end
  end
  return a;
end

function StringUtils:getBroadData(id, paramStr1, paramStr2, paramStr3, paramStr4, content)
  local str=analysis("Tishi_Xiaoxibiao",id,"txt");
  if ""==str then
    return;
  end
  local sarr=StringUtils:broad_string_split(str);
  local chat={};
  for k,v in pairs(sarr) do
    local data={};
    data.Type=ConstConfig.CHAT_CONTENT_ARRAY_TYPE_FONT;
    if 8==id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr1;
      elseif "@2"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=analysis("Kapai_Kapaiku",paramStr2, "name")
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
    elseif 9==id or 10==id or 11==id or 12==id or 13==id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr1
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
    elseif 14==id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr1;
      elseif "@2"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=analysis("Shili_Guanzhi",paramStr2, "title");
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
    elseif 17 == id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr1;
      elseif "@2"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr3;
      elseif 5 == k then
        data.ParamStr1=v[1];
        data.ParamStr2=ConstConfig.CHAT_BANG_PAI_JIA_RU .. "," .. paramStr4;
        data.ParamStr3="1";
        data.ParamStr4=v[2];
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
      --1.颜色 2.link:自定义CONfig 3.ref = "1" 4.内容
      --k为提示中第几段段
    -- Type,ParamStr1,ParamStr2,ParamStr3,ParamStr4
    elseif 19 == id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr1;
      elseif "@2"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=analysis("Bangpai_Bangpaijiuyan",paramStr2,"name");
      elseif 6 == k then
        data.ParamStr1=v[1];
        data.ParamStr2=ConstConfig.CHAT_BANG_PAI_JIA_RU_JIU_YAN .. "," .. paramStr2.. "," .. paramStr3;
        data.ParamStr3="1";
        data.ParamStr4=v[2];
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
    elseif 20 == id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr1;
      elseif "@2"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=analysis("Bangpai_Bangpaijiuyan",paramStr2,"name");
      elseif 5 == k then
        data.ParamStr1=v[1];
        data.ParamStr2=ConstConfig.CHAT_BANG_PAI_JIA_RU_JIU_YAN .. "," .. paramStr2.. "," .. paramStr3;
        data.ParamStr3="1";
        data.ParamStr4=v[2];
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
    elseif 21 == id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr1;
      elseif "@2"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr3;
      elseif 5 == k then
        data.ParamStr1=v[1];
        data.ParamStr2=ConstConfig.CHAT_BANG_PAI_JIA_RU .. "," .. paramStr4;
        data.ParamStr3="1";
        data.ParamStr4=v[2];
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
    elseif 22 == id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4 = paramStr1;
      elseif "@2"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr2;
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
    elseif 9999==id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr1;
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
    else
      data.ParamStr1=v[1];
      data.ParamStr2="";
      data.ParamStr3="";
      data.ParamStr4=v[2];
    end
    table.insert(chat,data);
  end
  return chat;
end