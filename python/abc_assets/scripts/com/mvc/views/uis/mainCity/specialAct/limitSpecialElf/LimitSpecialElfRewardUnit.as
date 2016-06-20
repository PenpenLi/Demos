package com.mvc.views.uis.mainCity.specialAct.limitSpecialElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   
   public class LimitSpecialElfRewardUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_rewardUnit:SwfSprite;
      
      private var tf_rewardTittle:TextField;
      
      private var rewardTittleArr:Array;
      
      public function LimitSpecialElfRewardUnit()
      {
         rewardTittleArr = ["第1名","第2—5名","第6—10名","第11—25名","第26—50名","第51—100名","第101—200名"];
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("limitSpecialElf");
         spr_rewardUnit = swf.createSprite("spr_rewardUnit");
         addChild(spr_rewardUnit);
         tf_rewardTittle = spr_rewardUnit.getTextField("tf_rewardTittle");
         tf_rewardTittle.fontName = "img_limitSE";
      }
      
      public function setRewardUnit(param1:Object) : void
      {
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc2_:* = null;
         tf_rewardTittle.text = rewardTittleArr[param1.id - 1];
         if(param1.hasOwnProperty("poke"))
         {
            _loc7_ = param1.poke.length;
            _loc3_ = 0;
            while(_loc3_ < _loc7_)
            {
               _loc4_ = GetElfFactor.getElfVO(param1.poke[_loc3_].pokeId);
               _loc6_ = new DropPropUnitUI();
               _loc6_.isShowAttribute = false;
               var _loc8_:* = 0.5;
               _loc6_.scaleY = _loc8_;
               _loc6_.scaleX = _loc8_;
               _loc6_.x = _loc3_ * 70;
               _loc6_.y = 30;
               _loc6_.myElfVo = _loc4_;
               addChild(_loc6_);
               _loc3_++;
            }
         }
         if(param1.hasOwnProperty("prop"))
         {
            _loc5_ = 0;
            while(_loc5_ < param1.prop.length)
            {
               _loc2_ = GetPropFactor.getPropVO(param1.prop[_loc5_].pId);
               _loc2_.rewardCount = param1.prop[_loc5_].num;
               _loc6_ = new DropPropUnitUI();
               _loc8_ = 0.5;
               _loc6_.scaleY = _loc8_;
               _loc6_.scaleX = _loc8_;
               _loc6_.x = (_loc5_ + _loc7_) * 70;
               _loc6_.y = 30;
               _loc6_.myPropVo = _loc2_;
               addChild(_loc6_);
               _loc5_++;
            }
         }
      }
   }
}
