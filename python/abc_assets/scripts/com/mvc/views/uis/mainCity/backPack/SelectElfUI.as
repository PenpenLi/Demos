package com.mvc.views.uis.mainCity.backPack
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.display.Quad;
   
   public class SelectElfUI extends Sprite
   {
      
      private static var intance:com.mvc.views.uis.mainCity.backPack.SelectElfUI;
       
      private var swf:Swf;
      
      public var spr_elfSelete:SwfSprite;
      
      public var btn_selectClose:SwfButton;
      
      public var seleElfContainVec:Vector.<com.mvc.views.uis.mainCity.backPack.SelectElfUnitUI>;
      
      public var title:TextField;
      
      public function SelectElfUI()
      {
         seleElfContainVec = new Vector.<com.mvc.views.uis.mainCity.backPack.SelectElfUnitUI>([]);
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addElfUnit();
      }
      
      public static function getIntance() : com.mvc.views.uis.mainCity.backPack.SelectElfUI
      {
         if(intance == null)
         {
            intance = new com.mvc.views.uis.mainCity.backPack.SelectElfUI();
         }
         return intance;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         spr_elfSelete = swf.createSprite("spr_elfSelete_s");
         btn_selectClose = spr_elfSelete.getButton("btn_selectClose");
         title = spr_elfSelete.getTextField("title");
         spr_elfSelete.x = 1136 - spr_elfSelete.width >> 1;
         spr_elfSelete.y = 100;
         addChild(spr_elfSelete);
         btn_selectClose.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler() : void
      {
         WinTweens.closeWin(spr_elfSelete,remove);
      }
      
      private function remove() : void
      {
         removeFromParent();
      }
      
      public function addElfUnit() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc1_:* = null;
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               _loc1_ = new com.mvc.views.uis.mainCity.backPack.SelectElfUnitUI();
               _loc1_.x = 120 * _loc3_ + 100;
               _loc1_.y = 140 * _loc2_ + 150;
               _loc1_.name = "selectElfUnitUI" + _loc2_;
               spr_elfSelete.addChild(_loc1_);
               seleElfContainVec.push(_loc1_);
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function createSeleElf() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               seleElfContainVec[_loc1_].myElfVo = PlayerVO.bagElfVec[_loc1_];
               seleElfContainVec[_loc1_].switchContain(true);
            }
            else
            {
               seleElfContainVec[_loc1_].hideImg();
               seleElfContainVec[_loc1_].switchContain(false);
            }
            _loc1_++;
         }
      }
   }
}
