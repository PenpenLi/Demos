package com.mvc.views.uis.mainCity.firstRecharge
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import feathers.controls.Label;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.util.xmlVOHandler.GetpropImage;
   
   public class FirstRchUnit extends Sprite
   {
       
      public var spr_rewardBg_s:SwfSprite;
      
      private var numTf:TextField;
      
      private var message:Label;
      
      private var _propVO:PropVO;
      
      public function FirstRchUnit()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("firstRecharge");
         spr_rewardBg_s = _loc1_.createSprite("spr_rewardBg_s");
         addChild(spr_rewardBg_s);
         numTf = spr_rewardBg_s.getChildByName("numTf") as TextField;
         numTf.touchable = false;
         this.addEventListener("touch",touchHandler);
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(spr_rewardBg_s);
         if(_loc2_ && _loc2_.phase == "began")
         {
            FirstRchRewardTips.getInstance().showPropTips(propVO,this);
         }
         if(_loc2_ && _loc2_.phase == "ended")
         {
            FirstRchRewardTips.getInstance().removePropTips();
         }
      }
      
      public function get propVO() : PropVO
      {
         return _propVO;
      }
      
      public function set propVO(param1:PropVO) : void
      {
         _propVO = param1;
         addPropImg();
      }
      
      private function addPropImg() : void
      {
         var _loc1_:Sprite = GetpropImage.getPropSpr(propVO,true,0.9);
         spr_rewardBg_s.addChildAt(_loc1_,1);
      }
      
      public function setNumTf(param1:String) : void
      {
         numTf.text = param1;
      }
   }
}
