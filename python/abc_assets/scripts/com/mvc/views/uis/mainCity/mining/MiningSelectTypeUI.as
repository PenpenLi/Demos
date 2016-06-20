package com.mvc.views.uis.mainCity.mining
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class MiningSelectTypeUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_miningSelect:SwfSprite;
      
      public var spr_selectType:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_backBtn:SwfButton;
      
      public var btn_coin:SwfButton;
      
      public var btn_sweet:SwfButton;
      
      public var btn_doll:SwfButton;
      
      public var selectTimeSpr:SwfSprite;
      
      public function MiningSelectTypeUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mining");
         spr_miningSelect = swf.createSprite("spr_miningSelect");
         spr_miningSelect.x = 1136 - spr_miningSelect.width >> 1;
         spr_miningSelect.y = 640 - spr_miningSelect.height >> 1;
         addChild(spr_miningSelect);
         spr_selectType = spr_miningSelect.getSprite("spr_selectType");
         btn_close = spr_miningSelect.getButton("btn_close");
         btn_backBtn = spr_miningSelect.getButton("btn_backBtn");
         btn_coin = spr_selectType.getButton("btn_coin");
         btn_sweet = spr_selectType.getButton("btn_sweet");
         btn_doll = spr_selectType.getButton("btn_doll");
         switchBtn(true);
      }
      
      public function showSelectTimeSpr(param1:String) : void
      {
         spr_selectType.visible = false;
         var _loc2_:* = param1;
         if("coin" !== _loc2_)
         {
            if("sweet" !== _loc2_)
            {
               if("doll" === _loc2_)
               {
                  selectTimeSpr = swf.createSprite("spr_miningDollTime");
               }
            }
            else
            {
               selectTimeSpr = swf.createSprite("spr_selectSweetTime");
            }
         }
         else
         {
            selectTimeSpr = swf.createSprite("spr_selectCoinTime");
         }
         spr_miningSelect.addChild(selectTimeSpr);
         switchBtn(false);
      }
      
      public function switchBtn(param1:Boolean) : void
      {
         btn_backBtn.visible = !param1;
         btn_close.visible = param1;
      }
   }
}
