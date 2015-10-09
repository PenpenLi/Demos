require "core.controls.page.CommonPageView";
require "main.view.hero.heroPro.ui.heroProPageView.HeroProPageSlot";

HeroProPageView = class(CommonPageView);

-- 初始化
function HeroProPageView:initialize(context, datas)
	self.context = context;
	self.datas = datas;
	local curIndex = 1;
	local function createSlotCallback()
        log("HeroProPageView:create #items:" .. curIndex);
        curIndex = curIndex + 1;
        local item = HeroProPageSlot.new();
        item:initialize(self.context);
		return item;
	end

	local page = self:getCurrentPage();
	local function callBackFunc()
		if not self.callBackFunced then
			self.callBackFunced = true;
			return;
		end
		page = self:getCurrentPage();
		local general_data = self.context.heroHouseProxy:getGeneralData(self.datas[self:getCurrentPage()]);
		self.context:setData(general_data);
  		-- MusicUtils:stopEffect();
  		-- local id = analysis("Kapai_Kapaiku",self.datas[self:getCurrentPage()].ConfigId,"shuashuai");
		  -- id = StringUtils:lua_string_split(id,";");
		  -- local randomIndex = math.floor(getRadomValue() * table.getn(id)) + 1;
		  -- MusicUtils:playEffect(tonumber(id[randomIndex]),false);
		if GameVar.tutorStage == TutorConfig.STAGE_99999 then
			MusicUtils:playEffect4Card(general_data.ConfigId);
		end
		if not self.tutor then
			self.tutor = 1;
			return;
		end
		if self.tutor == 1 and GameVar.tutorStage == TutorConfig.STAGE_1010 then
      		openTutorUI({x=-200, y=-200, width = 20, height = 20, alpha = 125,fullScreenTouchable=true});
    	end
		self.tutor = self.tutor + 1;
	end
	CommonPageView.initialize(self, createSlotCallback, makeSize(673,720), 1, 1, 1, 1, nil, nil, nil, nil, callBackFunc);
	self:update(self.datas,nil,true);
end

-- 更新界面显示
function HeroProPageView:update(list,p1,p2)
	if not list then
		return;
	end
	self.datas = list;
	self:updateData(list,p1,p2);
end