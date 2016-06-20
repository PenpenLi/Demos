package com.mvc.views.uis.mainCity.backPack
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import com.mvc.models.vos.elf.SkillVO;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class SkillUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_skill2:SwfSprite;
      
      private var skillName:TextField;
      
      private var skillPP:TextField;
      
      public var index:int;
      
      public function SkillUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         spr_skill2 = swf.createSprite("spr_skill2");
         skillName = spr_skill2.getTextField("skillName");
         skillName.autoScale = true;
         skillPP = spr_skill2.getTextField("skillPP");
         addChild(spr_skill2);
      }
      
      public function set mySkillVo(param1:SkillVO) : void
      {
         skillName.text = " [" + param1.property + "]" + param1.name;
         skillPP.text = "PP " + param1.currentPP + "/" + param1.totalPP;
      }
   }
}
