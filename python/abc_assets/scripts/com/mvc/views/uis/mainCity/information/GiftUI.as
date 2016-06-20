package com.mvc.views.uis.mainCity.information
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.components.feathers.FeathersButton;
   import starling.text.TextField;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.swf.display.SwfButton;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class GiftUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var input_down:FeathersButton;
      
      public var input_up:FeathersButton;
      
      public var listSpr:Sprite;
      
      public var giftText:TextField;
      
      public var giftIdInput:FeathersTextInput;
      
      public var giftIdText:TextField;
      
      public var btn_sure:SwfButton;
      
      public const giftIdPosY:int = 150;
      
      public function GiftUI()
      {
         listSpr = new Sprite();
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("information");
         giftIdInput = swf.createComponent("comp_feathers_input_gift");
         btn_sure = swf.createButton("btn_determine");
         giftIdInput.x = 280;
         giftIdInput.y = 150;
         giftIdInput.width = 340;
         giftIdInput.paddingLeft = 10;
         giftIdInput.paddingTop = 4;
         giftIdInput.restrict = "^ ";
         giftIdInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         addChild(giftIdInput);
         giftIdText = new TextField(50,50,"礼 包 码:","FZCuYuan-M03S",25,5715238);
         giftIdText.bold = true;
         giftIdText.x = 150;
         giftIdText.y = 150;
         giftIdText.autoSize = "horizontal";
         addChild(giftIdText);
         btn_sure.y = 350;
         btn_sure.x = 350;
         addChild(btn_sure);
         btn_sure.addEventListener("triggered",sureClick);
      }
      
      private function sureClick(param1:Event) : void
      {
      }
      
      public function set giftList(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         giftIdText = new TextField(50,50,"礼包码:","FZCuYuan-M03S",25,5715238);
         giftIdText.bold = true;
         giftIdText.autoSize = "horizontal";
         addChild(giftIdText);
         giftIdInput.x = 280;
         var _loc4_:* = 100;
         giftIdText.y = _loc4_;
         giftIdInput.y = _loc4_;
         addChild(giftIdInput);
         giftText = new TextField(50,50,"礼包种类:","FZCuYuan-M03S",25,5715238);
         giftText.bold = true;
         giftText.autoSize = "horizontal";
         _loc4_ = 150;
         giftIdText.x = _loc4_;
         giftText.x = _loc4_;
         giftText.y = 100;
         addChild(giftText);
         input_down = swf.createComponent("comp_feathers_button_3");
         input_up = swf.createComponent("comp_feathers_button_2");
         input_up.visible = false;
         input_down.name = "down";
         input_up.name = "up";
         input_up.label = "";
         _loc4_ = 280;
         listSpr.x = _loc4_;
         _loc4_ = _loc4_;
         input_up.x = _loc4_;
         input_down.x = _loc4_;
         _loc4_ = 100;
         listSpr.y = _loc4_;
         _loc4_ = _loc4_;
         input_up.y = _loc4_;
         input_down.y = _loc4_;
         addChild(input_up);
         addChild(input_down);
         addChild(listSpr);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = swf.createComponent("comp_feathers_button_1");
            _loc2_.label = param1[_loc3_];
            _loc2_.name = param1[_loc3_].toString();
            _loc2_.y = 44 * _loc3_ + 44;
            listSpr.addChild(_loc2_);
            _loc3_++;
         }
         listSpr.visible = false;
         this.addEventListener("touch",click);
      }
      
      private function click(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(param1.target as FeathersButton);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               var _loc3_:* = (param1.target as FeathersButton).name;
               if("down" !== _loc3_)
               {
                  if("up" !== _loc3_)
                  {
                     _loc3_ = (param1.target as FeathersButton).name;
                     input_down.label = _loc3_;
                     input_up.label = _loc3_;
                     input_up.visible = false;
                     input_down.visible = true;
                     listSpr.visible = false;
                  }
                  else
                  {
                     input_up.visible = false;
                     input_down.visible = true;
                     listSpr.visible = false;
                  }
               }
               else
               {
                  input_up.visible = true;
                  input_down.visible = false;
                  listSpr.visible = true;
               }
            }
         }
      }
   }
}
