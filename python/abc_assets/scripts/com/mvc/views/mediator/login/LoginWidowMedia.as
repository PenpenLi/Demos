package com.mvc.views.mediator.login
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.login.LoginWindowUI;
   import starling.events.Event;
   import com.common.themes.Tips;
   import lzm.starling.swf.display.SwfSprite;
   import com.common.util.loading.NETLoading;
   import lzm.util.HttpClient;
   import com.common.util.encypt.SHA1;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import lzm.util.LSOManager;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class LoginWidowMedia extends Mediator
   {
      
      public static const NAME:String = "LoginWidowMedia";
      
      public static var serverAddress:String = "http://192.168.1.146:10000";
       
      public var loginWindow:LoginWindowUI;
      
      private var session:String;
      
      public function LoginWidowMedia(param1:Object = null)
      {
         super("LoginWidowMedia",param1);
         loginWindow = param1 as LoginWindowUI;
         loginWindow.addEventListener("triggered",triggeredHandler);
         if(Pocketmon._description == "ouwanzf" && Pocketmon._channel == 0)
         {
            serverAddress = "http://ymlogin.mlwed.com:10000";
         }
         if(Pocketmon._description == "paojiao" && Pocketmon._channel == 0)
         {
            serverAddress = "http://pjlogin.mlwed.com:10000";
         }
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(loginWindow.loginBtn !== _loc2_)
         {
            if(loginWindow.regisNewUserBtn !== _loc2_)
            {
               if(loginWindow.newUserBtn !== _loc2_)
               {
                  if(loginWindow.oldUserBtn === _loc2_)
                  {
                     loginHanlder(loginWindow.spr_regis,loginWindow.login_spr);
                  }
               }
               else
               {
                  loginHanlder(loginWindow.login_spr,loginWindow.spr_regis);
               }
            }
            else
            {
               if(loginWindow.regisUserInput.text == "" || loginWindow.regisPswInput.text == "" || loginWindow.regisRePswInput.text == "")
               {
                  Tips.show("请完善注册信息");
                  return;
               }
               if(loginWindow.regisPswInput.text != loginWindow.regisRePswInput.text)
               {
                  Tips.show("密码不一致");
                  return;
               }
               sendHttp("register",loginWindow.regisUserInput.text,loginWindow.regisPswInput.text);
            }
         }
         else
         {
            if(loginWindow.userTextInput.text == "" || loginWindow.passwordTextInput.text == "")
            {
               Tips.show("请完善用户信息");
               return;
            }
            sendHttp("verifyUser",loginWindow.userTextInput.text,loginWindow.passwordTextInput.text);
         }
      }
      
      private function loginHanlder(param1:SwfSprite, param2:SwfSprite) : void
      {
         param1.removeFromParent();
         loginWindow.addChild(param2);
      }
      
      private function sendHttp(param1:String, param2:String, param3:String) : void
      {
         NETLoading.addLoading();
         if(param1 == "register")
         {
            HttpClient.send(serverAddress + "/" + param1,{
               "userName":param2,
               "password":param3
            },registerComplete,timeout);
         }
         else if(param1 == "verifyUser")
         {
            HttpClient.send(serverAddress + "/" + param1,{
               "platform":"mc",
               "userName":param2,
               "password":SHA1.hash(param3)
            },verifyUserComplete,timeout,"post");
         }
      }
      
      private function verifyUserComplete(param1:String) : void
      {
         LogUtil("验证结果data==",param1);
         NETLoading.removeLoading();
         var _loc2_:Object = JSON.parse(param1);
         session = _loc2_.session;
         if(session != "")
         {
            NETLoading.addLoading();
            HttpClient.send(serverAddress + "/servlist",{
               "platform":"mc",
               "session":session
            },servlistComplete,timeout);
         }
         else
         {
            Tips.show("验证失败");
         }
      }
      
      private function registerComplete(param1:Object) : void
      {
         LogUtil("注册返回的结果=" + param1);
         NETLoading.removeLoading();
         var _loc2_:Object = JSON.parse(param1 as String);
         if(_loc2_.result == 1)
         {
            loginWindow.spr_regis.removeFromParent();
            sendHttp("verifyUser",loginWindow.regisUserInput.text,loginWindow.regisPswInput.text);
            remeRePassword();
         }
         else
         {
            Tips.show("用户名已存在");
         }
      }
      
      private function servlistComplete(param1:Object) : void
      {
         var _loc3_:* = null;
         LogUtil("登录返回的结果=" + param1);
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
                  loginWindow.login_spr.removeFromParent();
                  remePassword();
                  sendNotification("GET_SERVER",param1);
               }
               else
               {
                  Tips.show("登录失败，请检查信息是否输入正确");
               }
               break;
         }
      }
      
      private function timeout(param1:Object) : void
      {
         Tips.show("请求超时");
         NETLoading.removeLoading();
      }
      
      private function remePassword() : void
      {
         LSOManager.put("USERNAME",loginWindow.userTextInput.text);
         LSOManager.put("USERPSW",loginWindow.passwordTextInput.text);
      }
      
      private function remeRePassword() : void
      {
         loginWindow.userTextInput.text = loginWindow.regisUserInput.text;
         loginWindow.passwordTextInput.text = loginWindow.regisPswInput.text;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("" !== _loc2_)
         {
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("LoginWidowMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
