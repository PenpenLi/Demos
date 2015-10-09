--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-17

	yanchuan.xie@happyelements.com
]]

require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.utils.CommonUtil";

CommonProgressBar=class(Layer);

function CommonProgressBar:ctor()
  self.class=CommonProgressBar;
end

function CommonProgressBar:dispose()
  self.frame=nil;
  self.frameList=nil;
  self.textField=nil;
	self:removeAllEventListeners();
	CommonProgressBar.superclass.dispose(self);
end

function CommonProgressBar:initialize(skeleton, prefix, is_short)
  self:initLayer();
  self.skeleton=skeleton;
  self.prefix=prefix;

  local armature=self.skeleton:buildArmature(is_short and "common_short_progress_bar" or "common_small_progress_bar");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  
  local armature_d=armature.display;
  self:addChild(armature_d);

  --progress_bar_blue
  self.progress_bar_blue=ProgressBar.new(armature:findChildArmature(is_short and "common_short_progress_bar_blue" or "common_small_progress_bar_blue"),is_short and "common_short_progress_bar_blue_normal" or "common_small_progress_bar_blue_normal");
  self.progress_bar_blue:setProgress(0,"left");

  --progress_bar_green
  self.progress_bar_green=ProgressBar.new(armature:findChildArmature(is_short and "common_short_progress_bar_green" or "common_small_progress_bar_green"),is_short and "common_short_progress_bar_green_normal" or "common_small_progress_bar_green_normal");
  self.progress_bar_green:setProgress(0,"left");

  local text_data=armature:findChildArmature(is_short and "common_short_progress_bar_green" or "common_small_progress_bar_green"):getBone(is_short and "common_short_progress_bar_green_normal" or "common_small_progress_bar_green_normal").textData;
  local text="";
  self.progress_bar_green_text=createTextFieldWithTextData(text_data,text);
  armature_d:getChildByName(is_short and "common_short_progress_bar_green" or "common_small_progress_bar_green"):addChild(self.progress_bar_green_text);
end

function CommonProgressBar:initializeNew(context, onExpFunc, exp, level, level_max)
  self.context=context;
  self.onExpFunc=onExpFunc;
  self.exp=exp;
  self.level=level;
  self.level_max=level_max;
  self.is_over=self.exp==self.onExpFunc(self.context,self:getIsLevelMax() and self.level or (1+self.level));

  self:private_refresh();
end

function CommonProgressBar:addExp(experience)
  local exp,level,over=self:private_getExpByAdd(experience,self.level,self.exp);
  self.exp=exp;
  self.level=over and level or (-1+level);
  self.is_over=over;
  
  self:private_refresh();
end

function CommonProgressBar:addExpTest(experience)
  local exp,level,over=self:private_getExpByAdd(experience,self.level_test,self.exp_test);
  self.exp_test=exp;
  self.level_test=over and level or (-1+level);
  self.is_over_test=over;

  local exp=self:private_getExpBySelfLevel(true);
  self.progress_bar_blue:setProgress(self.exp_test/exp,"left");
  self.progress_bar_green:setProgress(self.level_test==self.level and self.exp/self:private_getExpBySelfLevel() or 0,"left");
  self.progress_bar_green_text:setString(self.prefix .. self.exp_test .. " / " .. exp);
end

function CommonProgressBar:cancelTest()
  self:private_refresh();
end

function CommonProgressBar:startTest()
  self.exp_test=self.exp;
  self.level_test=self.level;
  self.is_over_test=self.is_over;
end

function CommonProgressBar:private_getExpBySelfLevel(isTest)
  if isTest then
    return self.onExpFunc(self.context,self.level_test==self.level_max and self.level_test or (1+self.level_test));
  end
  return self.onExpFunc(self.context,self:getIsLevelMax() and self.level or (1+self.level));
end

function CommonProgressBar:getIsLevelMax()
  return self.level==self.level_max;
end

function CommonProgressBar:private_getExpByAdd(exp, self_level, self_exp)
  local a=1;
  local lv_exp=0;
  while self.level_max>=a+self_level do
    lv_exp=self.onExpFunc(self.context,a+self_level)+lv_exp;
    if (self_exp+exp)<lv_exp then
      local b=lv_exp-self_exp-exp;
      return self.onExpFunc(self.context,a+self_level)-b,a+self_level,false;
    end
    a=1+a;
  end
  return self.onExpFunc(self.context,-1+a+self_level),-1+a+self_level,true;
end

function CommonProgressBar:private_refresh()
  local exp=self:private_getExpBySelfLevel();
  self.progress_bar_blue:setProgress(0,"left");
  self.progress_bar_green:setProgress(self:getIsLevelMax() and 1 or self.exp/exp,"left");
  self.progress_bar_green_text:setString(self.prefix .. (self:getIsLevelMax() and exp or self.exp) .. " / " .. exp);
end

function CommonProgressBar:getLevelOverTest(experience)
  local exp,level,over=self:private_getExpByAdd(experience,self.level_test,self.exp_test);
  return over;
end

function CommonProgressBar:getOverTestByLevel(experience, lev)
  local exp,level,over=self:private_getExpByAdd(experience,self.level_test,self.exp_test);
  level=over and level or (-1+level);
  return level>lev;
end

function CommonProgressBar:getLevelTest()
  return self.level_test;
end

function CommonProgressBar:getLevelMax()
  return self.level_max;
end