package com.mvc.views.uis.login
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.Image;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.display.Button;
   import lzm.starling.swf.Swf;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.util.LSOManager;
   
   public class LoginWindowUI extends Sprite
   {
       
      public var login_spr:SwfSprite;
      
      public var spr_regis:SwfSprite;
      
      public var login_bg:Image;
      
      public var userTextInput:FeathersTextInput;
      
      public var passwordTextInput:FeathersTextInput;
      
      public var regisUserInput:FeathersTextInput;
      
      public var regisPswInput:FeathersTextInput;
      
      public var regisRePswInput:FeathersTextInput;
      
      public var forgetPswBtn:Button;
      
      public var loginBtn:Button;
      
      public var newUserBtn:Button;
      
      public var regisNewUserBtn:Button;
      
      public var oldUserBtn:Button;
      
      private var swf:Swf;
      
      public function LoginWindowUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("login");
         login_spr = swf.createSprite("spr_loginbg");
         loginBtn = login_spr.getButton("loginBtn");
         newUserBtn = login_spr.getButton("newUserBtn");
         userTextInput = login_spr.getChildByName("userInput") as FeathersTextInput;
         passwordTextInput = login_spr.getChildByName("pswInput") as FeathersTextInput;
         var _loc1_:* = 340;
         passwordTextInput.width = _loc1_;
         userTextInput.width = _loc1_;
         login_spr.x = 1136 - login_spr.width >> 1;
         login_spr.y = 640 - login_spr.height >> 1;
         addChild(login_spr);
         spr_regis = swf.createSprite("spr_regisBg");
         regisNewUserBtn = spr_regis.getButton("regisNewUserBtn");
         oldUserBtn = spr_regis.getButton("oldUserBtn");
         regisUserInput = spr_regis.getChildByName("regisUserInput") as FeathersTextInput;
         regisPswInput = spr_regis.getChildByName("regisPswInput") as FeathersTextInput;
         regisRePswInput = spr_regis.getChildByName("regisRePswInput") as FeathersTextInput;
         _loc1_ = 340;
         regisRePswInput.width = _loc1_;
         _loc1_ = _loc1_;
         regisPswInput.width = _loc1_;
         regisUserInput.width = _loc1_;
         spr_regis.x = 1136 - spr_regis.width >> 1;
         spr_regis.y = 640 - spr_regis.height >> 1;
         userTextInput.text = LSOManager.get("USERNAME");
         passwordTextInput.text = LSOManager.get("USERPSW");
         userTextInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         passwordTextInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         regisUserInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         regisPswInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         regisRePswInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         userTextInput.paddingLeft = 10;
         passwordTextInput.paddingLeft = 10;
         regisUserInput.paddingLeft = 10;
         regisPswInput.paddingLeft = 10;
         regisRePswInput.paddingLeft = 10;
         userTextInput.paddingTop = 4;
         passwordTextInput.paddingTop = 4;
         regisUserInput.paddingTop = 4;
         regisPswInput.paddingTop = 4;
         regisRePswInput.paddingTop = 4;
         userTextInput.restrict = "^ ";
         passwordTextInput.restrict = "^ ";
         regisUserInput.restrict = "^ ";
         regisPswInput.restrict = "^ ";
         regisRePswInput.restrict = "^ ";
      }
   }
}
