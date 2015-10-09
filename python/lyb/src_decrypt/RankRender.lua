RankRender=class(TouchLayer);

function RankRender:ctor()
  self.class=RankRender;
end

function RankRender:dispose()
  self:removeAllEventListeners();
	self:removeChildren();
  RankRender.superclass.dispose(self);

end

function RankRender:initializeUI(skeleton,ActivityEmployRankingArray,index)
  self:initLayer();

  self.skeleton=skeleton;
  self.ActivityEmployRankingArray=ActivityEmployRankingArray;
  self.index = index;
  self.data = ActivityEmployRankingArray[index];
  
  local armature=skeleton:buildArmature("rankRender");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature.display;
  self.armatureDefault=armature;
  self:addChild(self.armature);

  
	local text=self.data.ActivityEmployScore;
	local text_data=armature:getBone("text_score").textData;
	self.text_score=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_score);

	local text=self.data.UserName;
	local text_data=armature:getBone("text_myRank").textData;
	self.text_myRank=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_myRank);

	local text=self.data.Ranking..".";
	local text_data=armature:getBone("text_index").textData;
	self.text_index=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_index);


end

function RankRender:setData()
  
end

function RankRender:refresh()
  
end


function RankRender:remove()
  
end

