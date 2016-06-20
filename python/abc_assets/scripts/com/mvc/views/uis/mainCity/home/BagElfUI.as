package com.mvc.views.uis.mainCity.home
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class BagElfUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var mySpr:SwfSprite;
      
      public var putComputerBtn:Button;
      
      public var lockBtn:Button;
      
      public var bagContainVec:Vector.<com.mvc.views.uis.mainCity.home.ElfBgUnitUI>;
      
      public function BagElfUI()
      {
         bagContainVec = new Vector.<com.mvc.views.uis.mainCity.home.ElfBgUnitUI>([]);
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc1_:* = null;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("home");
         mySpr = swf.createSprite("spr_bag_s");
         putComputerBtn = mySpr.getButton("putComputerBtn");
         lockBtn = mySpr.getButton("lockBtn");
         bagContainVec = Vector.<com.mvc.views.uis.mainCity.home.ElfBgUnitUI>([]);
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               _loc1_ = new com.mvc.views.uis.mainCity.home.ElfBgUnitUI();
               _loc1_.identify = "背包";
               _loc1_.x = 120 * _loc3_ + 35;
               _loc1_.y = 120 * _loc2_ + 80;
               _loc1_.name = "bag" + (_loc2_ * 2 + _loc3_);
               _loc1_.switchContain(false);
               mySpr.addChild(_loc1_);
               bagContainVec.push(_loc1_);
               _loc3_++;
            }
            _loc2_++;
         }
         addChild(mySpr);
      }
   }
}
