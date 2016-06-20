package com.mvc.views.uis.mainCity.firstRecharge
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   
   public class FirstRechargeUI extends Sprite
   {
       
      public var firstRchargeSpr:SwfSprite;
      
      public var closeBtn:Button;
      
      public var rechargeBtn:Button;
      
      public function FirstRechargeUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.8;
         addChild(_loc1_);
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("firstRecharge");
         firstRchargeSpr = _loc2_.createSprite("spr_bg_s");
         firstRchargeSpr.x = (1136 - firstRchargeSpr.width >> 1) + 80;
         firstRchargeSpr.y = 640 - firstRchargeSpr.height >> 1;
         addChild(firstRchargeSpr);
         closeBtn = firstRchargeSpr.getChildByName("closeBtn") as SwfButton;
         rechargeBtn = firstRchargeSpr.getChildByName("rechargeBtn") as SwfButton;
         addReward([{
            "id":114000,
            "num":5
         },{
            "id":116000,
            "num":5
         },{
            "id":102000,
            "num":1
         },{
            "id":113000,
            "num":2
         }]);
      }
      
      private function addReward(param1:Array) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = GetPropFactor.getPropVO(param1[_loc3_].id);
            _loc2_.rewardCount = param1[_loc3_].num;
            _loc4_ = new FirstRchUnit();
            _loc4_.propVO = _loc2_;
            _loc4_.setNumTf(param1[_loc3_].num);
            _loc4_.x = _loc3_ * 110 + 33;
            _loc4_.y = 225;
            firstRchargeSpr.addChild(_loc4_);
            _loc3_++;
         }
      }
   }
}
