package com.mvc.views.uis.login
{
   import starling.display.Sprite;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import flash.desktop.NativeApplication;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.LoadOtherAssetsManager;
   import lzm.util.OSUtil;
   import com.mvc.views.uis.login.notice.Download;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import flash.media.StageWebView;
   import com.mvc.views.uis.login.notice.LoginNoticeUI;
   import starling.events.Event;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class LoginUI extends Sprite
   {
       
      public var login_bg:Image;
      
      public var loginBtn:SwfButton;
      
      public var starGameBtn:SwfButton;
      
      private var swf:Swf;
      
      public var spr_nowserver:SwfSprite;
      
      public var region_now:TextField;
      
      private var version:TextField;
      
      public var currState:TextField;
      
      public var cliclkLoginBtn:SwfButton;
      
      public var decArr:Array;
      
      public function LoginUI()
      {
         decArr = [""];
         super();
         init();
         addVersion();
      }
      
      private function addVersion() : void
      {
         version = new TextField(200,50,"","FZCuYuan-M03S",20,16777215);
         var _loc1_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:String = _loc1_.children()[3];
         version.text = "版本号:" + Pocketmon.swfVersion;
         version.x = 940;
         version.y = 591;
         this.addChild(version);
      }
      
      private function init() : void
      {
         var _loc5_:* = false;
         var _loc6_:* = 0;
         var _loc1_:* = null;
         var _loc4_:* = null;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("login");
         login_bg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("backgound"));
         addChild(login_bg);
         spr_nowserver = swf.createSprite("spr_nowserver");
         starGameBtn = spr_nowserver.getButton("starGameBtn");
         region_now = spr_nowserver.getTextField("region_now");
         currState = spr_nowserver.getTextField("currState");
         currState.touchable = false;
         cliclkLoginBtn = swf.createButton("btn_stargame_b");
         cliclkLoginBtn.x = 1136 - cliclkLoginBtn.width >> 1;
         cliclkLoginBtn.y = 534;
         if((OSUtil.isAndriod() || OSUtil.isIPhone()) && Pocketmon._description != "yyd")
         {
            addChild(cliclkLoginBtn);
         }
         spr_nowserver.x = 1136 - spr_nowserver.width >> 1;
         spr_nowserver.y = 440;
         region_now.text = "点击选区";
         var _loc2_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc3_:Namespace = _loc2_.namespace();
         if(_loc2_._loc3_::versionNumber < "1.5.0")
         {
            Config.isOpenNatice = true;
            _loc5_ = false;
            _loc6_ = 0;
            while(_loc6_ < Download.downloadArr.length)
            {
               if(Pocketmon._description == Download.downloadArr[_loc6_][0])
               {
                  if(Download.downloadArr[_loc6_][1] != "下载链接")
                  {
                     _loc5_ = true;
                  }
                  break;
               }
               _loc6_++;
            }
            if(_loc5_)
            {
               _loc1_ = "<font size=\'20\'>训练师，游戏有新版本啦，要先去下载新版本安装哦！</font>";
               _loc4_ = Alert.show(_loc1_,"",new ListCollection([{"label":"下载"}]));
               _loc4_.addEventListener("close",exitHandler);
            }
            else
            {
               _loc1_ = "<font size=\'20\'>训练师，游戏有新版本啦，要先去下载新版本安装哦！</font>\n<font size=\'17\' color=\'#1c6b04\'>(09:30分后重新打开本游戏，游戏内将会引导训练师更新新版本哦)</font>";
               _loc4_ = Alert.show(_loc1_,"",new ListCollection([{"label":"确定"}]));
               _loc4_.addEventListener("close",exitHandler);
            }
         }
         else if(!Config.isOpenNatice && Game.loginNoticeHttp != "")
         {
            Config.isOpenNatice = true;
            Game.httpView = new StageWebView();
            Game.httpView.stage = Config.starling.nativeStage;
            Game.httpView.viewPort = Game.loginRect;
            Game.httpView.loadURL(Game.loginNoticeHttp);
            addChild(LoginNoticeUI.getInstance());
         }
         else if(Game.httpView != null)
         {
            Game.httpView.dispose();
            Game.httpView = null;
         }
      }
      
      private function exitHandler(param1:Event, param2:Object) : void
      {
         var _loc5_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = undefined;
         if(param2.label == "确定")
         {
            NativeApplication.nativeApplication.exit();
         }
         if(param2.label == "下载")
         {
            _loc4_ = 0;
            while(_loc4_ < Download.downloadArr.length)
            {
               if(Pocketmon._description == Download.downloadArr[_loc4_][0])
               {
                  _loc5_ = Download.downloadArr[_loc4_][1];
                  break;
               }
               _loc4_++;
            }
            _loc3_ = new URLRequest(_loc5_);
            navigateToURL(_loc3_);
            NativeApplication.nativeApplication.exit();
         }
         else
         {
            NativeApplication.nativeApplication.exit();
         }
      }
   }
}
