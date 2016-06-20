package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import starling.display.Quad;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Image;
   import lzm.starling.swf.Swf;
   import lzm.starling.display.Button;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import starling.core.Starling;
   
   public class PVPRankPlayerInfoUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.pvp.PVPRankPlayerInfoUI;
       
      private var bg:Quad;
      
      private var spr_rankPlayerInfo:SwfSprite;
      
      public var cancleBtn:SwfButton;
      
      public var nameTf:TextField;
      
      public var rankNumTf:TextField;
      
      public var oddsTf:TextField;
      
      public var challengePointTf:TextField;
      
      public var fightTimesTf:TextField;
      
      private var headPic:Image;
      
      private var swf:Swf;
      
      private var closeBtn:Button;
      
      public function PVPRankPlayerInfoUI()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.pvp.PVPRankPlayerInfoUI
      {
         return instance || new com.mvc.views.uis.mainCity.pvp.PVPRankPlayerInfoUI();
      }
      
      private function init() : void
      {
         bg = new Quad(1136,640,0);
         bg.alpha = 0.7;
         addChild(bg);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_rankPlayerInfo = swf.createSprite("spr_PvpRankInfo_s");
         spr_rankPlayerInfo.x = 1136 - spr_rankPlayerInfo.width >> 1;
         spr_rankPlayerInfo.y = 640 - spr_rankPlayerInfo.height >> 1;
         addChild(spr_rankPlayerInfo);
         nameTf = spr_rankPlayerInfo.getChildByName("nameTf") as TextField;
         nameTf.fontName = "1";
         nameTf.hAlign = "center";
         rankNumTf = spr_rankPlayerInfo.getChildByName("rankNumTf") as TextField;
         oddsTf = spr_rankPlayerInfo.getChildByName("oddsTf") as TextField;
         challengePointTf = spr_rankPlayerInfo.getChildByName("challengePointTf") as TextField;
         fightTimesTf = spr_rankPlayerInfo.getChildByName("fightTimesTf") as TextField;
         closeBtn = spr_rankPlayerInfo.getButton("closeBtn");
         closeBtn.addEventListener("triggered",closeBtn_triggeredHandler);
      }
      
      private function closeBtn_triggeredHandler() : void
      {
         this.removeFromParent();
      }
      
      public function showPlayerInfo(param1:Object) : void
      {
         if(headPic)
         {
            headPic.removeFromParent(true);
            headPic = null;
         }
         headPic = GetPlayerRelatedPicFactor.getHeadPic(param1.headId);
         headPic.x = 52;
         headPic.y = 69;
         spr_rankPlayerInfo.addChild(headPic);
         nameTf.text = param1.userName;
         rankNumTf.text = param1.pvpNowRanking;
         challengePointTf.text = param1.fightScore;
         fightTimesTf.text = param1.sumFight;
         if(param1.sumFight != 0)
         {
            oddsTf.text = (param1.sumWin / param1.sumFight * 100).toFixed(2) + "%";
         }
         else
         {
            oddsTf.text = "0%";
         }
         (Starling.current.root as Game).addChild(this);
      }
      
      public function disposeSelf() : void
      {
         this.removeFromParent(true);
         instance = null;
      }
   }
}
