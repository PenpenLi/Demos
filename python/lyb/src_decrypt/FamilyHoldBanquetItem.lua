
FamilyHoldBanquetItem=class(Layer);

function FamilyHoldBanquetItem:ctor()
    self.class=FamilyHoldBanquetItem;
    self.contentArray = {};
end

function FamilyHoldBanquetItem:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    FamilyHoldBanquetItem.superclass.dispose(self);
    self.context = nil
end

function FamilyHoldBanquetItem:initialize(context, data)
    self:initLayer();
    self.context = context;
    local banquetType = data.banquetType
    self.itemIndex = data.index;

    local armature=self.context.skeleton:buildArmature("hold_banquet_item_ui");
    self.armature = armature;
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();
     
    local armature_d=armature.display;
    self.armature_d = armature_d;
    self:addChild(self.armature_d)

    self.jubanButton =armature_d:getChildByName("blue_button");
    SingleButton:create(self.jubanButton);
    
    self.jubanButton:addEventListener(DisplayEvents.kTouchTap, self.entetrBanquetTap, self);
    local jiuyanPo = analysis("Bangpai_Bangpaijiuyan", self.itemIndex)
    local functionTable = StringUtils:stuff_string_split(jiuyanPo.joinGet);
    
    self.canyan_tili_huode = functionTable[1][1];

    local functionTable = StringUtils:stuff_string_split(jiuyanPo.doGet);

    self.juban_tili_value = functionTable[1][1]
    
    local functionTable = StringUtils:stuff_string_split(jiuyanPo.doGetgift);
    self.juban_baoxiang_value = functionTable[1][2]

    self.imageId = jiuyanPo.art;
    self.ItemLevel = jiuyanPo.lvup;

    self.level = self.context.familyProxy:getFamilyLevel();
    print("self.level",self.level)
    self.hasFamily = self.context.userProxy:getHasFamily();

    local functionStr = analysis("Bangpai_Bangpaijiuyan", self.itemIndex,"doPaste");
    local functionTable = StringUtils:stuff_string_split(functionStr);
     --{1:{1:2,2:1000}}
    self.xiaohao_num = functionTable[1][2];
    self.xiaohao_ID = functionTable[1][1]
    self.xiaohao_imgID = analysis("Daoju_Daojubiao",tonumber(self.xiaohao_ID),"art");

    self.xiaohao_img = Image.new();
    self.xiaohao_img:loadByArtID(self.xiaohao_imgID);
    self.xiaohao_img:setScale(0.6)

    local text_data = self.armature:getBone("yinbi_num_txt").textData;
    self.xiaohao_num_txt = createTextFieldWithTextData(text_data, self.xiaohao_num,true);
    self.xiaohao_num_txt:setPositionXY(90, 13);
    

  if banquetType == "SIREN_YANHUI"  then 
    
    self.banquetText = "4人宴会";
    self.baoxiangId = 1002001;

    local text_data = self.armature:getBone("canyanzhe_txt").textData;
    self.canyanzhe_txt = createTextFieldWithTextData(text_data,"参宴者：",true);
    self:addChild(self.canyanzhe_txt);

    self.canjia_tili =armature_d:getChildByName("canjia_tili_bg");
    self.canjia_tili:setScale(0.6,true);
    local x = self.canjia_tili:getPosition().x + 7;
    local y = self.canjia_tili:getPosition().y - 12;
    self.canjia_tili:setPositionXY(x, y);

    local text_data = self.armature:getBone("canyan_tili_num_txt").textData;
    self.canyan_tili_num = createTextFieldWithTextData(text_data,self.canyan_tili_huode,true);
    self:addChild(self.canyan_tili_num);
    
    if self.level >= self.ItemLevel then
        self.yinbi =armature_d:getChildByName("yinbi_image");
        
        local x = self.yinbi:getPositionX() -63;
        local y = self.yinbi:getPositionY() -96;
        
        self.xiaohao_img:setPositionXY(x, y);
        self.jubanButton:addChild(self.xiaohao_img);
        self.yuanbao =armature_d:getChildByName("yuanbao_bg");
        armature_d:removeChild(self.yuanbao);
        armature_d:removeChild(self.yinbi);
        self.jubanButton:addChild(self.xiaohao_num_txt)
    else
        self.yuanbao =armature_d:getChildByName("yuanbao_bg");
        self.yinbi =armature_d:getChildByName("yinbi_image");
        armature_d:removeChild(self.yuanbao)
        armature_d:removeChild(self.yinbi)
        armature_d:removeChild(self.jubanButton)

        local text_data = self.armature:getBone("dengji_txt").textData;
        self.dengjiText = createTextFieldWithTextData(text_data, "帮派"..tostring(self.ItemLevel).."级开启", true);
        self:addChild(self.dengjiText);
    end
    
    

  elseif banquetType == "LIUREN_YANHUI" then
   
    self.banquetText = "6人宴会";
    self.baoxiangId = 1002002;

    self.canjia_tili =armature_d:getChildByName("canjia_tili_bg");
    armature_d:removeChild(self.canjia_tili);

    local text_data = self.armature:getBone("canyanzhe_txt").textData;

    local textField = TextField.new(CCLabelTTFStroke:create("参宴者：体力总数"..self.canyan_tili_huode.."，\n参宴者随机分配", FontConstConfig.OUR_FONT, 24, 2, ccc3(0,0,0), CCSizeMake(260, 75)));

    textField:setAnchorPoint(ccp(0, 1));
    textField:setPositionXY(33, 217);

    self:addChild(textField);

    self.yuanbao =armature_d:getChildByName("yuanbao_bg");
    local x = self.yuanbao:getPositionX() -63;
    local y = self.yuanbao:getPositionY() -96;
    self.xiaohao_img:setPositionXY(x, y);
    
    
    self.yinbi =armature_d:getChildByName("yinbi_image");
  
     if self.level >= self.ItemLevel then
        
        armature_d:removeChild(self.yinbi);
        armature_d:removeChild(self.yuanbao);
        self.jubanButton:addChild(self.xiaohao_img);
        self.jubanButton:addChild(self.xiaohao_num_txt)
    else
        armature_d:removeChild(self.yuanbao)
        armature_d:removeChild(self.yinbi)
        armature_d:removeChild(self.jubanButton)

        local text_data = self.armature:getBone("dengji_txt").textData;
        self.dengjiText = createTextFieldWithTextData(text_data, "帮派"..tostring(self.ItemLevel).."级开启", true);
        self:addChild(self.dengjiText);
    end

  else 
    self.banquetText = "全帮大宴";
    self.baoxiangId = 1002003;

    local text_data = self.armature:getBone("canyanzhe_txt").textData;
    self.canyanzhe_txt = createTextFieldWithTextData(text_data,"全部帮众：",true);
    self:addChild(self.canyanzhe_txt);

    self.canjia_tili =armature_d:getChildByName("canjia_tili_bg");
    self.canjia_tili:setScale(0.6,true);
    local x = self.canjia_tili:getPosition().x + 32;
    local y = self.canjia_tili:getPosition().y - 12;
    self.canjia_tili:setPositionXY(x, y);

    local text_data = self.armature:getBone("canyan_tili_num_txt").textData;
    self.canyan_tili_num = createTextFieldWithTextData(text_data,self.canyan_tili_huode,true);
    self.canyan_tili_num:setPositionXY(text_data.x + 25, text_data.y)
    self:addChild(self.canyan_tili_num);

    self.yuanbao =armature_d:getChildByName("yuanbao_bg");
    
    local x = self.yuanbao:getPositionX() -63;
    local y = self.yuanbao:getPositionY() -96;
    self.xiaohao_img:setPositionXY(x, y);
    
    
    self.yinbi =armature_d:getChildByName("yinbi_image");
    
    if self.level >= self.ItemLevel then
        
        armature_d:removeChild(self.yinbi);
        armature_d:removeChild(self.yuanbao);
        self.jubanButton:addChild(self.xiaohao_img);
        self.jubanButton:addChild(self.xiaohao_num_txt)
    else

        armature_d:removeChild(self.yuanbao)
        armature_d:removeChild(self.yinbi)
        armature_d:removeChild(self.jubanButton)
        local text_data = self.armature:getBone("dengji_txt").textData;
        self.dengjiText = createTextFieldWithTextData(text_data, "帮派"..tostring(self.ItemLevel).."级开启", true);
        self:addChild(self.dengjiText);
    end
  end
    
    --加载图片
    self.item_image = Image.new();
    self.item_image:loadByArtID(self.imageId);
    self.item_image:setPositionXY(14, 272);
    self:addChild(self.item_image);
    --加载几人宴会
    self.mingzi_bg =armature_d:getChildByName("mingzi_bg");
    self:addChild(self.mingzi_bg);

    local text_data = self.armature:getBone("jiuyan_leixing_txt").textData;
    self.renshuText = createTextFieldWithTextData(text_data,self.banquetText,true);
    self:addChild(self.renshuText);
    
    local text_data = self.armature:getBone("jubanzhe_txt").textData;
    self.jubanzhe_txt = createTextFieldWithTextData(text_data,"举办者：",true);
    self:addChild(self.jubanzhe_txt);

    --120体力

    local text_data = self.armature:getBone("juban_tili_num_txt").textData;
    self.juban_tili_num_txt = createTextFieldWithTextData(text_data,self.juban_tili_value,true);
    self:addChild(self.juban_tili_num_txt);

    local text_data = self.armature:getBone("juban_baoxiang_num_txt").textData;
    self.juban_baoxiang_num_txt = createTextFieldWithTextData(text_data,self.juban_baoxiang_value,true);
    self:addChild(self.juban_baoxiang_num_txt);

    

    self.juban_tili =armature_d:getChildByName("juban_tili_bg");
    self.juban_tili:setScale(0.6,true);
    local x = self.juban_tili:getPosition().x + 7;
    local y = self.juban_tili:getPosition().y - 10;
    self.juban_tili:setPositionXY(x, y);

     

    self:addBaoxiangButton();
    

end


function FamilyHoldBanquetItem:addBaoxiangButton()
    
    self.baoxiangImage = Image.new();
    self.baoxiangImage:loadByArtID(analysis("Daoju_Daojubiao",self.baoxiangId,"art"));
    self.baoxiangImage:setScale(0.4,true);
    local x = self.juban_tili_num_txt:getPosition().x + 50;
    local y = self.juban_tili_num_txt:getPosition().y + 3;
    self.baoxiangImage:setPositionXY(x, y);
    self.baoxiangImage:addEventListener(DisplayEvents.kTouchBegin,self.onClickListenerBegin,self,0);
    self:addChild(self.baoxiangImage);

end

function FamilyHoldBanquetItem:onClickListenerBegin(event,place)
    event.target:setScale(0.48)
    event.target:setPositionX(event.target:getPositionX()-5)
    event.target:addEventListener(DisplayEvents.kTouchEnd,self.scaleToListenerNormal,self,place);
end

function FamilyHoldBanquetItem:scaleToListenerNormal(event,place)
    event.target:setScale(0.4)
    event.target:setPositionX(event.target:getPositionX()+5)
    if self.parent.parent.isMove then return end
    local functionStr = analysis("Daoju_Daojubiao",self.baoxiangId,"function");
    local nameStr = analysis("Daoju_Daojubiao",self.baoxiangId,"name");
    TipsUtil:showTips(event.target,nameStr..": "..functionStr,nil,0);
end


function FamilyHoldBanquetItem:entetrBanquetTap()
    --弹出家族温酒
    local moneyNum = self.context.userCurrencyProxy:getMoneyByItemID(tonumber(self.xiaohao_ID));
    if moneyNum >= tonumber(self.xiaohao_num) then
        self.context:entetrBanquetByNotification({Type = self.itemIndex});
    else
        if tonumber(self.xiaohao_ID) == 2 then
            sharedTextAnimateReward():animateStartByString("亲，银币不够了哦！");
        elseif tonumber(self.xiaohao_ID) == 3 then
            sharedTextAnimateReward():animateStartByString("亲，元宝不够了哦！");
        end
        self.context:gotoChongZhi();
    end
    
end

