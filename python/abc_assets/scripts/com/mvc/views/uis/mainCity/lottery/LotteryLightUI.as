package com.mvc.views.uis.mainCity.lottery
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.mainCity.lottery.LotteryVO;
   import lzm.starling.swf.display.SwfMovieClip;
   
   public class LotteryLightUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_roundLight:SwfSprite;
      
      public var spr_roundPointer:SwfSprite;
      
      public var btn_start:SwfButton;
      
      public var img_diamond:SwfImage;
      
      public var img_Lottery:SwfImage;
      
      public var count:TextField;
      
      private var dataIndex:int = 1;
      
      public function LotteryLightUI(param1:int)
      {
         super();
         dataIndex = param1;
         dataIndex = dataIndex - 1;
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("lottery");
         spr_roundLight = swf.createSprite("spr_round" + dataIndex);
         spr_roundPointer = spr_roundLight.getSprite("spr_roundPointer");
         btn_start = spr_roundLight.getButton("btn_start");
         img_diamond = spr_roundLight.getImage("diamondImg");
         img_Lottery = spr_roundLight.getImage("lotteryImg");
         count = spr_roundLight.getTextField("diamondText");
         addChild(spr_roundLight);
         setDiamondText();
         img_diamond.touchable = false;
         img_Lottery.touchable = false;
      }
      
      private function setDiamondText() : void
      {
         count.text = LotteryVO.costDiamond;
         count.touchable = false;
      }
      
      public function setLight() : void
      {
         var _loc4_:* = 0;
         var _loc7_:* = 0;
         var _loc2_:int = LotteryVO.rewardList.length;
         var _loc5_:* = 360;
         var _loc1_:Number = spr_roundPointer.rotation * 180 / 3.141592653589793;
         var _loc3_:int = _loc5_ / _loc2_;
         var _loc6_:* = 7;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc7_ = 0;
            if(_loc1_ < 0)
            {
               _loc7_ = _loc1_ + _loc5_;
            }
            else
            {
               _loc7_ = _loc1_;
            }
            if(_loc4_ * _loc3_ - _loc6_ <= _loc7_ && _loc4_ * _loc3_ + _loc6_ >= _loc7_)
            {
               getLightInfo(_loc4_ + 1).gotoAndStop(1);
            }
            else
            {
               getLightInfo(_loc4_ + 1).gotoAndStop(0);
            }
            _loc4_++;
         }
      }
      
      public function getLightInfo(param1:int) : SwfMovieClip
      {
         return spr_roundLight.getMovie("mc_colour" + param1);
      }
   }
}
