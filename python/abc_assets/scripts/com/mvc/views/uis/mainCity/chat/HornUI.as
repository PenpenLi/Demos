package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.core.ITextEditor;
   import feathers.controls.text.StageTextTextEditor;
   import starling.display.Quad;
   
   public class HornUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_horn:SwfSprite;
      
      public var btn_hornClose:SwfButton;
      
      public var btn_send:SwfButton;
      
      public var input_horn:FeathersTextInput;
      
      public function HornUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_horn = swf.createSprite("spr_horn");
         btn_hornClose = spr_horn.getButton("btn_hornClose");
         btn_send = spr_horn.getButton("btn_ok");
         input_horn = spr_horn.getChildByName("input_horn") as FeathersTextInput;
         spr_horn.x = 1136 - spr_horn.width >> 1;
         spr_horn.y = 640 - spr_horn.height >> 1;
         addChild(spr_horn);
         input_horn.paddingLeft = 10;
         input_horn.paddingTop = 5;
         input_horn.paddingRight = 10;
         input_horn.maxChars = 52;
         addChild(spr_horn);
         input_horn.width = 471;
         input_horn.height = 190;
         input_horn.textEditorFactory = textFactory;
      }
      
      private function textFactory() : ITextEditor
      {
         var _loc1_:StageTextTextEditor = new StageTextTextEditor();
         _loc1_.multiline = true;
         _loc1_.color = 5715237;
         _loc1_.fontSize = 25;
         _loc1_.fontFamily = "FZCuYuan-M03S";
         return _loc1_;
      }
   }
}
