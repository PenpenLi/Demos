package
{
   import starling.display.Sprite;
   import flash.media.StageWebView;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import feathers.controls.Alert;
   import starling.display.Image;
   import flash.display.Loader;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.events.Event;
   import feathers.data.ListCollection;
   import flash.desktop.NativeApplication;
   import com.massage.ane.UmengExtension;
   import com.common.events.EventCenter;
   import lzm.util.HttpClient;
   import com.common.util.loading.NETLoading;
   import com.common.themes.Tips;
   import org.puremvc.as3.patterns.facade.Facade;
   import lzm.util.LSOManager;
   import com.common.managers.SoundManager;
   import flash.events.KeyboardEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.animation.Tween;
   import starling.core.Starling;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.ApplicationDomain;
   import flash.text.Font;
   import lzm.starling.swf.Swf;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.proxy.login.LoginPro;
   import com.common.util.dialogue.Dialogue;
   import com.common.themes.MyFeathersTheme;
   import com.mvc.GameFacade;
   import com.mvc.views.uis.login.SeleteServerUI;
   import com.mvc.models.vos.login.PlayerVO;
   import flash.events.StatusEvent;
   
   public class Game extends Sprite
   {
      
      public static var httpView:StageWebView;
      
      public static var loginRect:Rectangle;
      
      public static var officialRect:Rectangle;
      
      public static var activityHttp:String = "";
      
      public static var noticeHttp:String = "";
      
      public static var loginNoticeHttp:String = "";
      
      public static var token:String;
      
      public static var _url:String = "http://alllogin.mlwed.com:10000";
      
      public static var _noticeUrl:String = "http://ucbg.mlwed.com:3000/admin/gameglobal/gamenotice";
      
      public static var upLoadUrl:String = "http://bug.mlwed.com/bug.php";
      
      public static var system:String = "android";
       
      private var _currentPage:DisplayObject;
      
      private var exitAlert:Alert;
      
      private var isReady:Boolean;
      
      private var startImg:Image;
      
      private var loader:Loader;
      
      private var pageChangeBg:SwfMovieClip;
      
      private var isCloseView:Boolean;
      
      private var temViewPort:Rectangle;
      
      private var temUrl:String;
      
      private var isUpdate:Boolean;
      
      public function Game()
      {
         super();
         if(Pocketmon._description == "ouwanzf")
         {
            _url = "http://ymlogin.mlwed.com:10000";
            _noticeUrl = "http://ymbg.mlwed.com:3000/admin/gameglobal/gamenotice";
         }
         if(Pocketmon._description == "paojiao")
         {
            _url = "http://pjlogin.mlwed.com:10000";
            _noticeUrl = "http://pjbg.mlwed.com:3000/admin/gameglobal/gamenotice";
         }
         if(Pocketmon._description == "tencent" || Pocketmon._description == "tencent2")
         {
            _url = "http://yyblogin.mlwed.com:10000";
            _noticeUrl = "http://yybbg.mlwed.com:3000/admin/gameglobal/gamenotice";
         }
         Pocketmon.sdkTool.initSDK();
         LogUtil("Pocketmon._channel=======",Pocketmon._channel,Pocketmon._channel != 2);
         if(Pocketmon._channel != 2)
         {
            LogUtil("这不是UC呀");
            addEventListener("addedToStage",initStage);
         }
         NativeApplication.nativeApplication.addEventListener("keyDown",onKeyDown);
         EventCenter.addEventListener("SERVER_LIST",serverList);
         EventCenter.addEventListener("GET_EXIT",useMyselfExit);
         EventCenter.addEventListener("error",errorHandler);
         UmengExtension.getInstance().addEventListener("status",handler_status);
         UmengExtension.getInstance().UmengiInit("true");
         UmengExtension.getInstance().UMUpdate("1");
         HttpClient.send(_noticeUrl,null,noticeComplete);
      }
      
      public static function addHttpView() : void
      {
         loginRect = new Rectangle(165 * Config.scaleX,130 * Config.scaleY + Config.starling.viewPort.y,780 * Config.scaleX,375 * Config.scaleY);
         officialRect = new Rectangle(165 * Config.scaleX,130 * Config.scaleY + Config.starling.viewPort.y,780 * Config.scaleX,425 * Config.scaleY);
      }
      
      private function errorHandler(param1:starling.events.Event, param2:Object) : void
      {
         var _loc3_:Alert = Alert.show(JSON.stringify(param2),"",new ListCollection([{"label":"确定"}]));
         _loc3_.addEventListener("close",reStarGame);
      }
      
      private function reStarGame() : void
      {
         NativeApplication.nativeApplication.exit();
         UmengExtension.getInstance().UMAnalysic("exit");
      }
      
      private function serverList(param1:starling.events.Event) : void
      {
         EventCenter.removeEventListener("SERVER_LIST",serverList);
         HttpClient.send(_url + "/verifyUser",param1.data,checkComplete,timeout,"post");
         NETLoading.addLoading();
      }
      
      private function checkComplete(param1:Object) : void
      {
         NETLoading.removeLoading();
         if(param1 == "true")
         {
            HttpClient.send(_url + "/servlist",{
               "sid":Pocketmon.sdkTool.token,
               "platform":Pocketmon.sdkTool.platform,
               "channel":Pocketmon._description
            },checkComplete2,timeout);
            NETLoading.addLoading();
         }
         else
         {
            Tips.show("登录验证失败");
         }
      }
      
      private function checkComplete2(param1:Object) : void
      {
         var _loc3_:* = null;
         NETLoading.removeLoading();
         var _loc2_:Object = JSON.parse(param1 as String);
         var _loc4_:int = _loc2_.sevStatus;
         switch(_loc4_)
         {
            case 0:
               _loc3_ = Alert.show(_loc2_.msg,"温馨提示",new ListCollection([{"label":"确定"}]));
               break;
            case 1:
               if(_loc2_.loginRes)
               {
                  Facade.getInstance().sendNotification("GET_SERVER",param1);
               }
               else
               {
                  Tips.show("登录失败，请检查信息是否输入正确");
               }
               break;
         }
      }
      
      public function initStage() : void
      {
         LogUtil("=========初始化舞台=======");
         Config.device_width = stage.stageWidth;
         Config.device_height = stage.stageHeight;
         Config.stage = stage;
         this.scaleX = stage.stageWidth / 1136;
         this.scaleY = stage.stageHeight / 640;
         Config.scaleX = this.scaleX;
         Config.scaleY = this.scaleY;
         if(stage.stageWidth < 900)
         {
            Config.isOpenAni = false;
         }
         LogUtil(Config.scaleX + "==横向拉伸");
         LogUtil(Config.scaleY + "==纵向拉伸");
         LogUtil(LSOManager.has("BGMusic"),LSOManager.has("SEMusic"));
         if(LSOManager.has("BGMusic"))
         {
            SoundManager.BGSwitch = LSOManager.get("BGMusic");
         }
         if(LSOManager.has("SEMusic"))
         {
            SoundManager.SESwitch = LSOManager.get("SEMusic");
         }
         if(LSOManager.has("isOpenCartoon"))
         {
            Config.isOpenAni = LSOManager.get("isOpenCartoon");
         }
         if(LSOManager.has("isGetPower"))
         {
            Config.getPowerSwitch = LSOManager.get("isGetPower");
         }
         if(LSOManager.has("isPrivateChat"))
         {
            Config.privateChaSwitch = LSOManager.get("isPrivateChat");
         }
         if(LSOManager.has("isSeriesAttack"))
         {
            Config.seriesAttackSwitch = LSOManager.get("isSeriesAttack");
         }
         if(LSOManager.has("isAutoFightSave"))
         {
            Config.isAutoFighting = LSOManager.get("isAutoFightSave");
         }
         if(LSOManager.has("isAutoFightUsePropSave"))
         {
            Config.isAutoFightingUseProp = LSOManager.get("isAutoFightUsePropSave");
         }
         if(LSOManager.has("isPvpInviteSureSave"))
         {
            Config.isPvpInviteSure = LSOManager.get("isPvpInviteSureSave");
         }
         if(LSOManager.has("isOpenFightingAniSave"))
         {
            Config.isOpenFightingAni = LSOManager.get("isOpenFightingAniSave");
         }
         someReady();
      }
      
      private function noticeComplete(param1:Object) : void
      {
         LogUtil("登录前公告请求完成=" + param1);
         var _loc2_:Object = JSON.parse(param1 as String);
         loginNoticeHttp = _loc2_.gameNotice;
      }
      
      private function timeout(param1:Object) : void
      {
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 16777238 || param1.keyCode == 32)
         {
            param1.preventDefault();
            Pocketmon.sdkTool.exit();
            if(httpView != null && Pocketmon._channel == 0)
            {
               isCloseView = true;
               temViewPort = httpView.viewPort;
               temUrl = httpView.location;
               httpView.dispose();
               httpView = null;
            }
         }
      }
      
      private function useMyselfExit() : void
      {
         if(Config.stage == null)
         {
            NativeApplication.nativeApplication.exit();
            UmengExtension.getInstance().UMAnalysic("exit");
            if(Game.httpView != null)
            {
               Game.httpView.dispose();
               Game.httpView = null;
            }
         }
         else if(exitAlert == null && isReady)
         {
            exitAlert = Alert.show("退出游戏?","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            exitAlert.addEventListener("close",exitHandler);
            if(httpView != null)
            {
               isCloseView = true;
               temViewPort = httpView.viewPort;
               temUrl = httpView.location;
               httpView.dispose();
               httpView = null;
            }
         }
      }
      
      private function exitHandler(param1:starling.events.Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            NativeApplication.nativeApplication.exit();
            UmengExtension.getInstance().UMAnalysic("exit");
         }
         else if(isCloseView && httpView == null)
         {
            isCloseView = false;
            httpView = new StageWebView();
            httpView.stage = Config.starling.nativeStage;
            httpView.viewPort = temViewPort;
            httpView.loadURL(temUrl);
         }
         exitAlert = null;
      }
      
      private function initConfig() : void
      {
         var _loc2_:* = null;
         _loc2_ = File.applicationStorageDirectory.resolvePath("assets/AssetsConfig.json");
         if(!_loc2_.exists)
         {
            _loc2_ = File.applicationDirectory.resolvePath("assets/AssetsConfig.json");
         }
         LogUtil(_loc2_.nativePath);
         var _loc3_:FileStream = new FileStream();
         _loc3_.open(_loc2_,"read");
         var _loc1_:String = _loc3_.readUTFBytes(_loc3_.bytesAvailable);
         _loc3_.close();
         _loc2_ = null;
         _loc3_ = null;
         Config.configInfo = JSON.parse(_loc1_);
      }
      
      private function addLogo() : void
      {
         if(Config.starling.nativeStage.getChildByName("startPage") != null)
         {
            Config.starling.nativeStage.removeChild(Config.starling.nativeStage.getChildByName("startPage"));
         }
         startImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("startBg"));
         addChild(startImg);
         EventCenter.removeEventListener("load_other_asset_complete",addLogo);
         loadOtherAssets();
      }
      
      private function someReady() : void
      {
         LogUtil("准备 .......");
         initConfig();
         addHttpView();
         loadFont();
      }
      
      private function removeLogo() : void
      {
         if(isUpdate)
         {
            return;
         }
         LogUtil("移除logo");
         EventCenter.removeEventListener("LOAD_LOGIN_ASSET_COMPLETE",removeLogo);
         var t:Tween = new Tween(startImg,0.5);
         Starling.juggler.add(t);
         t.animate("alpha",0,1);
         t.onComplete = function():void
         {
            startImg.removeFromParent(true);
            LoadOtherAssetsManager.getInstance().removeAsset(["startBg"],false);
            starIntoGame();
         };
      }
      
      private function loadFont() : void
      {
         LogUtil("加载字体");
         loader = new Loader();
         loader.load(new URLRequest("assets/font/font.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
         loader.contentLoaderInfo.addEventListener("complete",onLoadComplete);
      }
      
      private function onLoadComplete(param1:flash.events.Event) : void
      {
         LogUtil("注册字体");
         var _loc2_:Class = ApplicationDomain.currentDomain.getDefinition("MyFont") as Class;
         Font.registerFont(_loc2_);
         loader.contentLoaderInfo.removeEventListener("complete",onLoadComplete);
         loader.unload();
         loader = null;
         loadStartBg();
      }
      
      private function loadStartBg() : void
      {
         LogUtil("加载开始图片");
         EventCenter.addEventListener("load_other_asset_complete",addLogo);
         LoadOtherAssetsManager.getInstance().addAssets(["startBg.jpg"]);
      }
      
      private function loadOtherAssets() : void
      {
         LogUtil("加载其他资源");
         EventCenter.addEventListener("load_other_asset_complete",loadOtherComplete);
         LoadOtherAssetsManager.getInstance().addAssets(["themes","xml"]);
      }
      
      private function loadOtherComplete() : void
      {
         LogUtil("加载loading资源");
         EventCenter.removeEventListener("load_other_asset_complete",loadOtherComplete);
         Swf.init(this);
         EventCenter.addEventListener("load_swf_asset_complete",loadLoadingComplete);
         LoadSwfAssetsManager.getInstance().addAssets(["loading"],false,60);
      }
      
      private function loadLoadingComplete() : void
      {
         LogUtil("加载loading资源完成");
         EventCenter.removeEventListener("load_swf_asset_complete",loadLoadingComplete);
         EventCenter.addEventListener("LOAD_LOGIN_ASSET_COMPLETE",removeLogo);
         LoadOtherAssetsManager.getInstance().addLoginAssets();
      }
      
      private function servlistComplete(param1:Object) : void
      {
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil("登陆返回服务器列表=" + param1);
         NETLoading.removeLoading();
         var _loc4_:Object = JSON.parse(param1 as String);
         if(_loc4_.loginRes)
         {
            _loc5_ = _loc4_.session;
            if(_loc4_.servlst.length != 0)
            {
               _loc3_ = _loc4_.servlst[0].ip;
               _loc2_ = _loc4_.servlst[0].port;
            }
            Facade.getInstance().registerProxy(new LoginPro({
               "ip":_loc3_,
               "port":_loc2_,
               "key":_loc5_
            }));
            return;
         }
         Tips.show("登录失败，请检查信息是否输入正确");
      }
      
      private function starIntoGame() : void
      {
         LogUtil("开始进入游戏");
         SoundManager.getInstance().init();
         NETLoading.init(this);
         Dialogue.init();
         Tips.init(this);
         isReady = true;
         new MyFeathersTheme(stage);
         pageChangeBg = LoadSwfAssetsManager.getInstance().assets.getSwf("loading").createMovieClip("mc_clound");
         pageChangeBg.stop(true);
         pageChangeBg.touchable = false;
         pageChangeBg.loop = false;
         pageChangeBg.name = "pageChangeBg";
         GameFacade.getInstance().startup();
         if(Pocketmon._channel == 0)
         {
            addChild(SeleteServerUI.getInstance());
         }
         else
         {
            GameFacade.getInstance().sendNotification("switch_page","load_login_page");
         }
      }
      
      private function setEmbedElf() : void
      {
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_poke");
         var _loc1_:Array = [];
         var _loc5_:* = 0;
         var _loc4_:* = _loc2_.sta_poke;
         for each(var _loc3_ in _loc2_.sta_poke)
         {
            if(_loc1_.indexOf(_loc3_.@pinyinName) == -1)
            {
               _loc1_.push(_loc3_.@pinyinName);
            }
         }
      }
      
      public function addPageChangeBg(param1:Function = null) : void
      {
         callBack = param1;
         this.touchable = false;
         pageChangeBg.visible = true;
         addChild(pageChangeBg);
         pageChangeBg.gotoAndPlay("come");
         pageChangeBg.completeFunction = function(param1:SwfMovieClip):void
         {
            this.touchable = true;
            pageChangeBg.completeFunction = null;
            if(callBack != null)
            {
               callBack();
            }
         };
      }
      
      public function removePageChangeBg(param1:Function = null) : void
      {
         callBack = param1;
         PlayerVO.isAcceptPvp = false;
         if(pageChangeBg.parent)
         {
            setChildIndex(pageChangeBg,numChildren - 1);
         }
         else
         {
            addChild(pageChangeBg);
         }
         pageChangeBg.gotoAndPlay("go");
         pageChangeBg.completeFunction = function(param1:SwfMovieClip):void
         {
            PlayerVO.isAcceptPvp = true;
            pageChangeBg.completeFunction = null;
            pageChangeBg.removeFromParent();
            pageChangeBg.stop(true);
            if(callBack != null)
            {
               callBack();
            }
         };
      }
      
      private function handler_status(param1:StatusEvent) : void
      {
         LogUtil("level:" + param1.level,",code:" + param1.code);
         var _loc2_:* = param1.code;
         if("umengInit" !== _loc2_)
         {
            if("Token" !== _loc2_)
            {
               if("Update" !== _loc2_)
               {
                  if("Ignore" !== _loc2_)
                  {
                     if("NotNow" !== _loc2_)
                     {
                        if("payOk" !== _loc2_)
                        {
                           if("device_id" !== _loc2_)
                           {
                           }
                        }
                     }
                     else
                     {
                        NativeApplication.nativeApplication.exit();
                     }
                  }
               }
               else
               {
                  isUpdate = true;
               }
            }
            else
            {
               token = param1.level;
            }
         }
      }
      
      private function result(param1:Object) : void
      {
      }
      
      public function set page(param1:DisplayObject) : void
      {
         _currentPage = param1;
      }
      
      public function get page() : DisplayObject
      {
         return _currentPage;
      }
   }
}
