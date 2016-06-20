package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import starling.display.Quad;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.Swf;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.core.Starling;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   
   public class PVPMatchimgUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.pvp.PVPMatchimgUI;
       
      private var isMatch:Boolean;
      
      private var bg:Quad;
      
      private var spr_matchimg:SwfSprite;
      
      private var ballMc:SwfMovieClip;
      
      public var cancleBtn:SwfButton;
      
      public var tipsTf:TextField;
      
      private var swf:Swf;
      
      public var pvpMatchCD:int;
      
      public function PVPMatchimgUI()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.pvp.PVPMatchimgUI
      {
         return instance || new com.mvc.views.uis.mainCity.pvp.PVPMatchimgUI();
      }
      
      private function init() : void
      {
         bg = new Quad(1136,640,0);
         bg.alpha = 0.7;
         addChild(bg);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("pvp");
         spr_matchimg = swf.createSprite("spr_matchimg");
         spr_matchimg.x = 1136 - spr_matchimg.width >> 1;
         spr_matchimg.y = 640 - spr_matchimg.height >> 1;
         addChild(spr_matchimg);
         ballMc = spr_matchimg.getChildByName("ballMc") as SwfMovieClip;
         cancleBtn = spr_matchimg.getChildByName("cancleBtn") as SwfButton;
         tipsTf = spr_matchimg.getChildByName("tipsTf") as TextField;
      }
      
      public function showMatchimg(param1:Boolean = true) : void
      {
         pvpMatchCD = 60;
         this.isMatch = param1;
         if(param1)
         {
            tipsTf.text = "匹配中(60)...";
            PlayerVO.isAcceptPvp = false;
         }
         else
         {
            tipsTf.text = "等待对手开始...";
         }
         cancleBtn.addEventListener("triggered",triggeredHanler);
         (Starling.current.root as Game).addChild(this);
      }
      
      public function removeMatchimg() : void
      {
         PlayerVO.isAcceptPvp = true;
         cancleBtn.removeEventListener("triggered",triggeredHanler);
         this.removeFromParent();
      }
      
      private function triggeredHanler(param1:Event) : void
      {
         if(isMatch)
         {
            (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6103();
         }
         else
         {
            (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6105();
         }
      }
      
      public function showCD() : void
      {
         if(isMatch)
         {
            pvpMatchCD = pvpMatchCD - 1;
            tipsTf.text = "匹配中(" + pvpMatchCD + ")...";
            if(pvpMatchCD == 0)
            {
               tipsTf.text = "继续匹配中...";
            }
         }
      }
      
      public function disposeSelf() : void
      {
         this.removeFromParent(true);
         instance = null;
      }
   }
}
