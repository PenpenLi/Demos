require "main.view.buddy.ui.HaoyouLayerPageView";
require "main.view.buddy.ui.HaoyouLayerItemSlot";

HaoyouLayer=class(Layer);

function HaoyouLayer:ctor()
  self.class=HaoyouLayer;
end

function HaoyouLayer:dispose()
	self.armature4dispose:dispose();
	HaoyouLayer.superclass.dispose(self);
end

function HaoyouLayer:initialize(context)
	self.context = context;
	self.buddyListProxy = self.context.buddyListProxy;

	self.skeleton = self.context.skeleton;
	self:initLayer();

	--骨骼
  local armature=self.skeleton:buildArmature("buddy_tab_1_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text="";
  self.buddy_num_descb=createTextFieldWithTextData(armature:getBone("buddy_num_descb").textData,text);
  self.armature:addChild(self.buddy_num_descb);

  text="现在还没有好友呢，是不是有点寂寞，快去添加小伙伴吧。";
  self.none_descb=createTextFieldWithTextData(armature:getBone("none_descb").textData,text);
  self.armature:addChild(self.none_descb);
  self.none_descb:setVisible(false);

  self.context:dispatchEvent(Event.new(ChatNotifications.CHAT_BUDDY_ONLINE,nil,self));
end

function HaoyouLayer:initializeBuddyData()
  local buddyData = self.buddyListProxy:getData();
  local function sortfunc(data_a, data_b)
    if data_a.Zhanli > data_b.Zhanli then
      return true;
    elseif data_a.Zhanli < data_b.Zhanli then
      return false;
    end
    return data_a.Level > data_b.Level;
  end
  table.sort(buddyData,sortfunc);
  local layer = Layer.new();
  layer:initLayer();
  self.scrollView=HaoyouLayerPageView.new(CCPageView:create());
  self.scrollView:initialize(self.context,buddyData);
  -- {{UserId=1,UserName="asdfads1",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads2",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads3",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads4",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads5",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads6",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads7",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads8",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads9",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads10",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads11",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads12",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads13",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads14",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads15",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads16",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads17",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads18",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads19",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads20",Career=1,Level=1,Zhanli=12312,BooleanValue=1},
  --                                   {UserId=1,UserName="asdfads21",Career=1,Level=1,Zhanli=12312,BooleanValue=1},}
  self.scrollView:setPositionXY(109,-125);
  local function onPageViewScrollStoped()
    self.scrollView:onPageViewScrollStoped();
    self.currentPage = self.scrollView:getCurrentPage();
  end
  self.scrollView:registerScrollStopedScriptHandler(onPageViewScrollStoped);

  local pageControl = self.scrollView.pageViewControl;
  if pageControl and 0 < table.getn(buddyData) then
    pageControl:setPositionXY(633-pageControl:getGroupBounds().size.width/2,45);
    self.armature:addChild(pageControl);
  end
  self.armature:addChild(self.scrollView);
  self:refreshBuddyNums();
end

function HaoyouLayer:refreshBuddyNums()
	self.buddy_num_descb:setString("好友数 " .. table.getn(self.buddyListProxy:getData()) .. "/" .. self.buddyListProxy:getBuddyNumMax());
  self.none_descb:setVisible(0 == table.getn(self.buddyListProxy:getData()));
end

function HaoyouLayer:refreshAddBuddys(userRelationArray)
  if self.scrollView then
    local pageControl = self.scrollView.pageViewControl;
    if pageControl and pageControl.parent then
      pageControl.parent:removeChild(pageControl);
    end
    self.scrollView.parent:removeChild(self.scrollView);
  end
  self:initializeBuddyData();
end

function HaoyouLayer:deleteBuddy(userID)
  if self.scrollView then
    local pageControl = self.scrollView.pageViewControl;
    if pageControl then
      pageControl.parent:removeChild(pageControl);
    end
    self.scrollView.parent:removeChild(self.scrollView);
  end
  self:initializeBuddyData();
end