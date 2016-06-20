package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.util.HttpClient;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.display.Image;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.pvp.PVPPracticePreMediaor;
   import com.mvc.views.mediator.mainCity.pvp.PVPChallengeMediator;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   
   public class PVPBgUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_pvpBg:SwfSprite;
      
      public var challengeGameBtn:SwfButton;
      
      public var practiceGameBtn:SwfButton;
      
      public var closeBtn:SwfButton;
      
      public var challengeGameImg:SwfImage;
      
      public var practiceGameImg:SwfImage;
      
      public var challengeTittleImg:SwfImage;
      
      public var practiceTittleImg:SwfImage;
      
      public var btn_friend:SwfButton;
      
      public var btn_laba:SwfButton;
      
      public function PVPBgUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("pvp");
         if(swf == null)
         {
            HttpClient.send(Game.upLoadUrl,{
               "custom":Game.system,
               "message":"PVPbG为空:SWF",
               "token":Game.token,
               "userId":PlayerVO.userId,
               "swfVersion":Pocketmon.swfVersion,
               "description":Pocketmon._description
            },null,null,"post");
         }
         var _loc1_:Image = swf.createImage("img_pvpBigBg") as Image;
         addChild(_loc1_);
         spr_pvpBg = swf.createSprite("spr_pvpBg");
         if(spr_pvpBg == null)
         {
            HttpClient.send(Game.upLoadUrl,{
               "custom":Game.system,
               "message":"PVPbG为空:spr_pvpBg",
               "token":Game.token,
               "userId":PlayerVO.userId,
               "swfVersion":Pocketmon.swfVersion,
               "description":Pocketmon._description
            },null,null,"post");
         }
         spr_pvpBg.x = 1136 - spr_pvpBg.width >> 1;
         spr_pvpBg.y = 640 - spr_pvpBg.height >> 1;
         addChild(spr_pvpBg);
         challengeGameBtn = spr_pvpBg.getChildByName("challengeGameBtn") as SwfButton;
         practiceGameBtn = spr_pvpBg.getChildByName("practiceGameBtn") as SwfButton;
         closeBtn = spr_pvpBg.getChildByName("closeBtn") as SwfButton;
         btn_friend = swf.createButton("btn_friend_b");
         if(btn_friend == null)
         {
            HttpClient.send(Game.upLoadUrl,{
               "custom":Game.system,
               "message":"PVPbG为空:btn_friend",
               "token":Game.token,
               "userId":PlayerVO.userId,
               "swfVersion":Pocketmon.swfVersion,
               "description":Pocketmon._description
            },null,null,"post");
         }
         btn_friend.x = -3;
         btn_friend.y = 320;
         spr_pvpBg.addChild(btn_friend);
         btn_laba = swf.createButton("btn_laba_b");
         if(btn_laba == null)
         {
            HttpClient.send(Game.upLoadUrl,{
               "custom":Game.system,
               "message":"PVPbG为空:btn_laba",
               "token":Game.token,
               "userId":PlayerVO.userId,
               "swfVersion":Pocketmon.swfVersion,
               "description":Pocketmon._description
            },null,null,"post");
         }
         btn_laba.x = 0;
         btn_laba.y = 430;
         spr_pvpBg.addChild(btn_laba);
         challengeGameImg = spr_pvpBg.getChildByName("challengeGameImg") as SwfImage;
         practiceGameImg = spr_pvpBg.getChildByName("practiceGameImg") as SwfImage;
         challengeTittleImg = spr_pvpBg.getChildByName("challengeTittleImg") as SwfImage;
         practiceTittleImg = spr_pvpBg.getChildByName("practiceTittleImg") as SwfImage;
      }
      
      public function showChallengeOrPractice(param1:Boolean) : void
      {
         showBtn(param1);
         if(param1)
         {
            showChallenge();
         }
         else
         {
            showPracticePrepare();
         }
      }
      
      private function showBtn(param1:Boolean) : void
      {
         challengeGameImg.visible = param1;
         practiceGameImg.visible = !param1;
         challengeTittleImg.visible = param1;
         practiceTittleImg.visible = !param1;
      }
      
      public function showChallenge() : void
      {
         LogUtil("显示挑战赛页面");
         if(Facade.getInstance().hasMediator("PVPPracticePreMediaor"))
         {
            ((Facade.getInstance().retrieveMediator("PVPPracticePreMediaor") as PVPPracticePreMediaor).UI as PVPPracticePreUI).removeFromParent();
         }
         if(!Facade.getInstance().hasMediator("PVPChallengeMediator"))
         {
            Facade.getInstance().registerMediator(new PVPChallengeMediator(new PVPChallengeUI()));
         }
         var _loc1_:PVPChallengeUI = (Facade.getInstance().retrieveMediator("PVPChallengeMediator") as PVPChallengeMediator).UI as PVPChallengeUI;
         _loc1_.showMyElfCamp(PlayerVO.bagElfVec);
         spr_pvpBg.addChild(_loc1_);
         (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6101();
         PVPBgMediator.pvpFrom = 1;
      }
      
      public function showPracticePrepare() : void
      {
         LogUtil("显示练习赛准备");
         if(Facade.getInstance().hasMediator("PVPChallengeMediator"))
         {
            ((Facade.getInstance().retrieveMediator("PVPChallengeMediator") as PVPChallengeMediator).UI as PVPChallengeUI).removeFromParent();
         }
         if(!Facade.getInstance().hasMediator("PVPPracticePreMediaor"))
         {
            Facade.getInstance().registerMediator(new PVPPracticePreMediaor(new PVPPracticePreUI()));
         }
         var _loc1_:PVPPracticePreUI = (Facade.getInstance().retrieveMediator("PVPPracticePreMediaor") as PVPPracticePreMediaor).UI as PVPPracticePreUI;
         if(PVPBgMediator.pvpFrom != 2)
         {
            (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6201(1);
         }
         spr_pvpBg.addChild(_loc1_);
      }
   }
}
