package com.mvc.views.mediator.login
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.models.vos.login.ServerVO;
   import lzm.util.LSOManager;
   import com.mvc.views.uis.login.LoginUI;
   import starling.animation.IAnimatable;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   import starling.events.Touch;
   import com.common.util.loading.NETLoading;
   import com.common.themes.Tips;
   import starling.events.Event;
   import starling.core.Starling;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.proxy.login.LoginPro;
   
   public class LoginMedia extends Mediator
   {
      
      public static const NAME:String = "LoginMedia";
      
      public static var serverVec:Vector.<ServerVO> = new Vector.<ServerVO>([]);
      
      public static var myServerVec:Vector.<ServerVO> = new Vector.<ServerVO>([]);
      
      public static var isLogin:Boolean;
      
      public static var lastLoginAdress:String = LSOManager.get("LASTLOGIN");
      
      public static var serverId:int = LSOManager.get("SERVERID");
      
      public static var serverIp:String = LSOManager.get("SERVERIP");
      
      public static var serverName:String = LSOManager.get("SERVERNAME");
      
      public static var serverProt:int = LSOManager.get("PORT");
       
      private var registerData:Object;
      
      private var servlistData:Object;
      
      private var listArr:Array;
      
      public var loginUI:LoginUI;
      
      public var key:String;
      
      private var delay:IAnimatable;
      
      public function LoginMedia(param1:Object = null)
      {
         super("LoginMedia",param1);
         loginUI = param1 as LoginUI;
      }
      
      public static function serverIDSort(param1:Vector.<ServerVO>) : Vector.<ServerVO>
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         _loc3_ = 1;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length - _loc3_)
            {
               if(param1[_loc4_].serverId < param1[_loc4_ + 1].serverId)
               {
                  _loc2_ = param1[_loc4_];
                  param1[_loc4_] = param1[_loc4_ + 1];
                  param1[_loc4_ + 1] = _loc2_;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return param1;
      }
      
      override public function onRegister() : void
      {
         loginUI.addEventListener("triggered",clickHandler);
         loginUI.region_now.addEventListener("touch",changeServer);
      }
      
      private function changeServer(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(param1.target as TextField);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               sendNotification("switch_win",loginUI,"LOAD_SERVER");
               loginUI.spr_nowserver.visible = false;
            }
         }
      }
      
      private function timeout(param1:Object) : void
      {
         NETLoading.removeLoading();
         Tips.show("请求超时");
      }
      
      private function checkComplete2(param1:String) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         LogUtil("请求所有账号信息=",param1,(JSON.parse(param1) as Array).length);
         var _loc2_:Array = JSON.parse(param1) as Array;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = new ServerVO();
            _loc4_.headId = _loc2_[_loc3_].headPtId;
            _loc4_.playerLv = _loc2_[_loc3_].plyLv;
            _loc4_.playerName = _loc2_[_loc3_].nickName;
            _loc4_.rankVip = _loc2_[_loc3_].vipLv;
            _loc4_.userId = _loc2_[_loc3_].userId;
            competion(_loc4_);
            myServerVec.push(_loc4_);
            _loc3_++;
         }
         NETLoading.removeLoading();
         sendNotification("switch_win",loginUI,"LOAD_SERVER");
         loginUI.spr_nowserver.visible = false;
      }
      
      private function competion(param1:ServerVO) : void
      {
         var _loc5_:* = null;
         var _loc3_:* = 0;
         var _loc2_:String = param1.userId;
         var _loc4_:int = _loc2_.substr(_loc2_.indexOf("s") + 1,_loc2_.indexOf("p") - _loc2_.indexOf("s") - 1);
         LogUtil("serverId=",_loc4_);
         _loc3_ = 0;
         while(_loc3_ < serverVec.length)
         {
            if(serverVec[_loc3_].serverId == _loc4_)
            {
               _loc5_ = serverVec[_loc3_];
               break;
            }
            _loc3_++;
         }
         param1.serverId = _loc5_.serverId;
         param1.serverName = _loc5_.serverName;
         param1.serverIp = _loc5_.serverIp;
         param1.serverProt = _loc5_.serverProt;
         param1.forbid = _loc5_.forbid;
         param1.isFix = _loc5_.isFix;
         param1.isBusy = _loc5_.isBusy;
         param1.clientnum = _loc5_.clientnum;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(loginUI.starGameBtn !== _loc2_)
         {
            if(loginUI.cliclkLoginBtn === _loc2_)
            {
               Pocketmon.sdkTool.login();
               loginUI.cliclkLoginBtn.enabled = false;
               delay = Starling.juggler.delayCall(openBtn,2);
            }
         }
         else if(Pocketmon.sdkTool.token)
         {
            startGame();
         }
         else
         {
            Pocketmon.sdkTool.login();
         }
      }
      
      private function openBtn() : void
      {
         if(loginUI.cliclkLoginBtn)
         {
            loginUI.cliclkLoginBtn.enabled = true;
         }
      }
      
      private function servlistComplete(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = false;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         LogUtil("登陆返回服务器列表======" + param1);
         NETLoading.removeLoading();
         servlistData = JSON.parse(param1 as String);
         if(servlistData.loginRes)
         {
            _loc2_ = servlistData.servlst;
            serverVec = Vector.<ServerVO>([]);
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc5_ = new ServerVO();
               _loc5_.serverId = _loc2_[_loc4_].id;
               _loc5_.serverName = _loc2_[_loc4_].nickname;
               _loc5_.serverIp = _loc2_[_loc4_].ip;
               _loc5_.serverProt = _loc2_[_loc4_].port;
               _loc5_.forbid = _loc2_[_loc4_].forbid;
               _loc5_.isFix = _loc2_[_loc4_].isFix;
               _loc5_.isBusy = _loc2_[_loc4_].isBusy;
               _loc5_.clientnum = _loc2_[_loc4_].clientnum;
               serverVec.push(_loc5_);
               if(_loc2_[_loc4_].ip == LSOManager.get("SERVERIP"))
               {
                  _loc3_ = true;
               }
               _loc4_++;
            }
            serverIDSort(serverVec);
            updateNowServer(serverVec);
            key = servlistData.session;
            if(_loc2_.length == 0 || !_loc3_)
            {
               loginUI.region_now.text = "点击选区";
               loginUI.currState.text = "";
            }
            if(!LSOManager.get("LASTLOGIN") && _loc2_.length > 0 && !_loc3_)
            {
               lastLoginAdress = serverVec[0].serverId + "区    " + serverVec[0].serverName;
               serverId = LoginMedia.serverVec[0].serverId;
               serverIp = LoginMedia.serverVec[0].serverIp;
               serverName = LoginMedia.serverVec[0].serverName;
               serverProt = LoginMedia.serverVec[0].serverProt;
               loginUI.region_now.text = lastLoginAdress;
            }
            return;
         }
         Tips.show("登录失败，请检查信息是否输入正确");
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("GET_SERVER" !== _loc3_)
         {
            if("LOGIN_GAME" !== _loc3_)
            {
               if("UPDATE_NOW_SERVER" !== _loc3_)
               {
                  if("LOGIN_FAIL" === _loc3_)
                  {
                     loginUI.cliclkLoginBtn.enabled = true;
                  }
               }
               else
               {
                  LogUtil("更新现在的服务器");
                  sendNotification("switch_win",null);
                  updateNowServer(serverVec);
                  loginUI.spr_nowserver.visible = true;
               }
            }
            else
            {
               startGame();
            }
         }
         else
         {
            if(!loginUI.cliclkLoginBtn)
            {
               return;
            }
            loginUI.cliclkLoginBtn.removeFromParent(true);
            loginUI.cliclkLoginBtn = null;
            Starling.juggler.remove(delay);
            loginUI.addChild(loginUI.spr_nowserver);
            _loc2_ = param1.getBody();
            servlistComplete(_loc2_);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["LOGIN_GAME","UPDATE_NOW_SERVER","GET_SERVER","LOGIN_FAIL"];
      }
      
      public function startGame() : void
      {
         if(loginUI.region_now.text == "点击选区")
         {
            Tips.show("请选择服务器");
            return;
         }
         LogUtil("lastLoginAdress=" + lastLoginAdress,"serverId=" + serverId,"serverIp=" + serverIp,"serverName=" + serverName,"serverProt=" + serverProt);
         facade.registerProxy(new LoginPro({
            "ip":serverIp,
            "port":serverProt,
            "key":key
         }));
         save();
      }
      
      private function save() : void
      {
         LSOManager.put("LASTLOGIN",lastLoginAdress);
         LSOManager.put("SERVERID",serverId);
         LSOManager.put("SERVERIP",serverIp);
         LSOManager.put("SERVERNAME",serverName);
         LSOManager.put("PORT",serverProt);
      }
      
      public function updateNowServer(param1:Vector.<ServerVO>) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = false;
         var _loc4_:* = 0;
         if(param1.length == 0)
         {
            loginUI.region_now.text = "点击选区";
            loginUI.currState.text = "";
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(param1[_loc2_].serverId == serverId)
               {
                  if(param1[_loc2_].isFix || param1[_loc2_].forbid || param1[_loc2_].isBusy)
                  {
                     loginUI.region_now.text = "点击选区";
                     loginUI.currState.text = "";
                     return;
                  }
               }
               _loc2_++;
            }
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               LogUtil("arr[j].serverId == serverId",param1[_loc4_].serverId,serverId);
               if(param1[_loc4_].serverId == serverId)
               {
                  _loc3_ = true;
                  break;
               }
               _loc4_++;
            }
            if(!_loc3_)
            {
               loginUI.region_now.text = "点击选区";
               loginUI.currState.text = "";
               return;
            }
            loginUI.region_now.text = lastLoginAdress;
            writeState(param1[_loc4_].clientnum);
            LogUtil("更新现在所选的服务器地址");
         }
      }
      
      private function writeState(param1:int) : void
      {
         LogUtil("写入状态" + param1);
         if(param1 >= 0 && param1 < 20)
         {
            loginUI.currState.text = "流畅";
            loginUI.currState.color = 2919680;
         }
         else if(param1 >= 20 && param1 < 500)
         {
            loginUI.currState.text = "火爆";
            loginUI.currState.color = 16711939;
         }
         else
         {
            loginUI.currState.text = "拥挤";
            loginUI.currState.color = 14575872;
         }
      }
      
      public function dispose() : void
      {
         loginUI.login_bg.texture.dispose();
         loginUI.login_bg.removeFromParent(true);
         facade.removeMediator("LoginMedia");
         UI.dispose();
         viewComponent = null;
      }
      
      public function get UI() : LoginUI
      {
         return viewComponent as LoginUI;
      }
   }
}
