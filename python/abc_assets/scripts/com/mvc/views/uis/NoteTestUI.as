package com.mvc.views.uis
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.swf.display.SwfButton;
   import com.common.net.Client;
   import starling.events.Event;
   import com.common.themes.Tips;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class NoteTestUI extends Sprite
   {
      
      private static var intance:com.mvc.views.uis.NoteTestUI;
       
      private var swf:Swf;
      
      private var spr_informationBg:SwfSprite;
      
      private var note:FeathersTextInput;
      
      private var json:FeathersTextInput;
      
      private var btn_ok:SwfButton;
      
      private var btn_close:SwfButton;
      
      private var client:Client;
      
      public function NoteTestUI()
      {
         super();
         client = Client.getInstance();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("assist");
         spr_informationBg = swf.createSprite("spr_informationBg_s");
         json = swf.createComponent("comp_feathers_input_feedback") as FeathersTextInput;
         json.x = 33;
         json.y = 103;
         spr_informationBg.addChild(json);
         LogUtil("    " + json);
         btn_ok = spr_informationBg.getButton("btn_ok");
         btn_close = spr_informationBg.getButton("btn_close");
         spr_informationBg.x = (1136 - spr_informationBg.width) / 2;
         spr_informationBg.y = (640 - spr_informationBg.height) / 2;
         addChild(spr_informationBg);
         this.addEventListener("triggered",clickHandler);
      }
      
      public static function getIntance() : com.mvc.views.uis.NoteTestUI
      {
         if(intance == null)
         {
            intance = new com.mvc.views.uis.NoteTestUI();
         }
         return intance;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_ok !== _loc2_)
         {
            if(btn_close === _loc2_)
            {
               this.removeFromParent();
            }
         }
         else if(json.text != "")
         {
            client.sendBytes(JSON.parse(json.text));
         }
         else
         {
            Tips.show("还没输入");
         }
      }
   }
}
