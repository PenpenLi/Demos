package com.mvc.views.uis.mainCity.playerInfo.infoPanel
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Quad;
   
   public class ChangeNameUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var changeNameSpr:SwfSprite;
      
      public var canelBtn:Button;
      
      public var randomBtn:Button;
      
      public var sureBtn:Button;
      
      public var inputNameTf:FeathersTextInput;
      
      public function ChangeNameUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         changeNameSpr = swf.createSprite("spr_Change_nickname3_s");
         changeNameSpr.x = 1136 - changeNameSpr.width >> 1;
         changeNameSpr.y = 640 - changeNameSpr.height >> 1;
         addChild(changeNameSpr);
         canelBtn = changeNameSpr.getButton("canelBtn");
         sureBtn = changeNameSpr.getButton("sureBtn");
         randomBtn = changeNameSpr.getButton("randomBtn");
         inputNameTf = changeNameSpr.getChildByName("inputNameTf") as FeathersTextInput;
         inputNameTf.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         inputNameTf.maxChars = 6;
         inputNameTf.paddingLeft = 10;
         inputNameTf.paddingTop = 4;
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         addChildAt(_loc1_,0);
      }
   }
}
