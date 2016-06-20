package com.mvc.views.uis.login
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.controls.ScrollContainer;
   import starling.display.Quad;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.Button;
   import starling.events.Event;
   import com.mvc.views.mediator.login.LoginWidowMedia;
   import com.mvc.GameFacade;
   import feathers.layout.VerticalLayout;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class SeleteServerUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.login.SeleteServerUI;
       
      private var swf:Swf;
      
      private var spr_selete:SwfSprite;
      
      private var serverArr:Array;
      
      private var panel:ScrollContainer;
      
      private var bg:Quad;
      
      private var input:FeathersTextInput;
      
      private var showContain:Sprite;
      
      private var btn:SwfButton;
      
      public function SeleteServerUI()
      {
         serverArr = ["alllogin.mlwed.com","private.mlwed.com","192.168.1.146","192.168.1.148","192.168.1.185","192.168.1.151","添加新服务器"];
         super();
         var _loc1_:Quad = new Quad(1136,640,16777215);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addContain();
         addserver();
      }
      
      public static function getInstance() : com.mvc.views.uis.login.SeleteServerUI
      {
         if(instance == null)
         {
            instance = new com.mvc.views.uis.login.SeleteServerUI();
         }
         return instance;
      }
      
      private function addserver() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         panel.removeChildren(0,-1,true);
         _loc1_ = 0;
         while(_loc1_ < serverArr.length)
         {
            _loc2_ = new Button();
            _loc2_.width = 490;
            _loc2_.label = serverArr[_loc1_];
            _loc2_.name = "http://" + serverArr[_loc1_] + ":10000";
            panel.addChild(_loc2_);
            _loc2_.addEventListener("triggered",onclick);
            _loc1_++;
         }
      }
      
      private function onclick(param1:Event) : void
      {
         if((param1.target as Button).label == "添加新服务器")
         {
            showContain = new Sprite();
            addChild(showContain);
            addNewWeb();
            return;
         }
         LoginWidowMedia.serverAddress = (param1.target as Button).name;
         GameFacade.getInstance().sendNotification("switch_page","load_login_page");
         this.removeFromParent(true);
      }
      
      private function addNewWeb() : void
      {
         bg = new Quad(1136,640,0);
         bg.alpha = 0.9;
         showContain.addChild(bg);
         input = new FeathersTextInput();
         input.backgroundSkin = swf.createS9Image("s9_inputBg");
         input.backgroundDisabledSkin = swf.createS9Image("s9_inputBg");
         input.backgroundFocusedSkin = swf.createS9Image("s9_inputBg");
         input.textEditorProperties.fontSize = 30;
         input.width = 500;
         input.paddingLeft = 160;
         input.paddingTop = 5;
         input.text = "192.168.1.";
         input.x = 330;
         input.y = 200;
         showContain.addChild(input);
         btn = swf.createButton("btn_ok_b");
         btn.addEventListener("triggered",clickEvent);
         btn.y = input.y + btn.height + 20;
         btn.x = 540;
         showContain.addChild(btn);
      }
      
      private function clickEvent(param1:Event) : void
      {
         serverArr.unshift(input.text);
         addserver();
         showContain.removeFromParent(true);
      }
      
      private function addContain() : void
      {
         panel = new ScrollContainer();
         spr_selete.addChild(panel);
         panel.width = 500;
         panel.height = 380;
         panel.y = 130;
         panel.x = 100;
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 20;
         _loc1_.useVirtualLayout = false;
         panel.scrollBarDisplayMode = "none";
         panel.layout = _loc1_;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("login");
         spr_selete = swf.createSprite("spr_selete");
         spr_selete.x = 1136 - spr_selete.width >> 1;
         spr_selete.y = 640 - spr_selete.height >> 1;
         addChild(spr_selete);
      }
   }
}
