package com.mvc.views.uis.mainCity.friend
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import com.mvc.models.vos.mainCity.friend.FriendVO;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import feathers.core.ITextEditor;
   import feathers.controls.text.StageTextTextEditor;
   import starling.display.Quad;
   
   public class FriendAddUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_addFriendBg:SwfSprite;
      
      public var btn_addClose:SwfButton;
      
      public var playerName:TextField;
      
      public var playPower:TextField;
      
      public var inputCheck:FeathersTextInput;
      
      public var btn_addFri:SwfButton;
      
      private var _friendVo:FriendVO;
      
      private var image:Image;
      
      public function FriendAddUI()
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
         spr_addFriendBg = swf.createSprite("spr_addFriendBg");
         btn_addClose = spr_addFriendBg.getButton("btn_addClose");
         playerName = spr_addFriendBg.getTextField("playerName");
         inputCheck = spr_addFriendBg.getChildByName("inputCheck") as FeathersTextInput;
         btn_addFri = spr_addFriendBg.getButton("btn_addFri");
         inputCheck.paddingLeft = 10;
         inputCheck.paddingRight = 10;
         inputCheck.paddingTop = 5;
         inputCheck.maxChars = 30;
         spr_addFriendBg.x = 1136 - spr_addFriendBg.width >> 1;
         spr_addFriendBg.y = 640 - spr_addFriendBg.height >> 1;
         addChild(spr_addFriendBg);
         playerName.fontName = "1";
         playerName.autoSize = "vertical";
         playerName.x = playerName.x - 50;
      }
      
      public function set myFriendVo(param1:FriendVO) : void
      {
         LogUtil("friendVo.headPtId=" + param1.headPtId);
         _friendVo = param1;
         if(image != null)
         {
            GetpropImage.clean(image);
         }
         image = GetPlayerRelatedPicFactor.getHeadPic(param1.headPtId);
         image.x = 88;
         image.y = 85;
         spr_addFriendBg.addChild(image);
         playerName.text = "昵称:" + param1.userName + "\n等级: Lv." + param1.lv;
         inputCheck.text = "与我成为好友，一起畅游口袋妖怪的世界吧！";
         inputCheck.width = 370;
         inputCheck.height = 110;
         inputCheck.textEditorFactory = textFactory;
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
      
      public function get myFriendVo() : FriendVO
      {
         return _friendVo;
      }
   }
}
