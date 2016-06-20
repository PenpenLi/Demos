package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import com.mvc.models.vos.elf.SkillVO;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import starling.display.Image;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class SkillUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_skillBg:SwfSprite;
      
      private var skillName:TextField;
      
      private var spr_noSkillBg:SwfSprite;
      
      private var skillName2:TextField;
      
      private var skillOpenLv:TextField;
      
      public var _skillVO:SkillVO;
      
      public var skillIndex:int;
      
      private var property:TextField;
      
      private var pp:TextField;
      
      private var iconBg:SwfImage;
      
      public function SkillUnit(param1:Boolean)
      {
         super();
         init(param1);
      }
      
      private function init(param1:Boolean) : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_skillBg = swf.createSprite("spr_skillPan");
         skillName = spr_skillBg.getTextField("skillNameTf");
         property = spr_skillBg.getTextField("propertyTF");
         pp = spr_skillBg.getTextField("ppTf");
         iconBg = spr_skillBg.getImage("iconBg");
         spr_noSkillBg = swf.createSprite("spr_noSkillBg");
         skillName2 = spr_noSkillBg.getTextField("skillName2");
         skillOpenLv = spr_noSkillBg.getTextField("skillOpenLv");
         skillName2.text = "";
         skillOpenLv.text = "";
         if(param1)
         {
            addChild(spr_skillBg);
         }
         else
         {
            addChild(spr_noSkillBg);
         }
      }
      
      public function set haveSkill(param1:SkillVO) : void
      {
         _skillVO = param1;
         skillName.text = param1.name;
         property.text = param1.property;
         pp.text = "PP " + param1.currentPP + "/" + param1.totalPP;
         var _loc2_:int = CalculatorFactor.natureArr.indexOf(param1.property);
         var _loc3_:Image = swf.createImage("img_nature" + _loc2_);
         _loc3_.alignPivot();
         _loc3_.x = 332;
         _loc3_.y = 45;
         iconBg.color = CalculatorFactor.natureColor[_loc2_];
         spr_skillBg.addChild(_loc3_);
         spr_skillBg.addEventListener("touch",skillBg_touchHandler);
      }
      
      public function set noSkill(param1:SkillVO) : void
      {
         _skillVO = param1;
         if(param1)
         {
            skillName2.text = param1.name;
            skillOpenLv.text = "等级达到" + param1.lvNeed + "开启";
         }
         else
         {
            skillName2.text = "";
            skillOpenLv.text = "";
         }
      }
      
      private function skillBg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(spr_skillBg);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               LogUtil("target: " + param1.target);
               SkillInfoTipsUI.getInstance().showSkillTips(_skillVO,this);
            }
            else if(_loc2_.phase == "ended")
            {
               SkillInfoTipsUI.getInstance().removeSkillTips();
            }
         }
      }
   }
}
