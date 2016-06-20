package com.mvc.views.uis.mainCity.mining
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class MiningInviteUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_invite:SwfSprite;
      
      public var tf_miningTittle:TextField;
      
      public var tf_invite:TextField;
      
      public var btn_change:SwfButton;
      
      public var btn_sure:SwfButton;
      
      public var btn_cancle:SwfButton;
      
      public function MiningInviteUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc2_:Quad = new Quad(1136,640,0);
         _loc2_.alpha = 0.5;
         addChild(_loc2_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mining");
         spr_invite = swf.createSprite("spr_invite");
         spr_invite.x = 1136 - spr_invite.width >> 1;
         spr_invite.y = 640 - spr_invite.height >> 1;
         addChild(spr_invite);
         var _loc1_:TextField = spr_invite.getTextField("tf_tittle");
         tf_miningTittle = spr_invite.getTextField("tf_miningTittle");
         tf_invite = spr_invite.getTextField("tf_invite");
         tf_invite.text = "邀请：全体公会成员";
         btn_change = spr_invite.getButton("btn_change");
         btn_sure = spr_invite.getButton("btn_sure");
         btn_cancle = spr_invite.getButton("btn_cancle");
      }
   }
}
