package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.GetCommon;
   import com.mvc.models.vos.elf.ElfVO;
   
   public class PVPChallengeUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_challenge:SwfSprite;
      
      public var onlineMatchBtn:SwfButton;
      
      public var beginPlayBtn:SwfButton;
      
      public var matchRulesBtn:SwfButton;
      
      public var rankBtn:SwfButton;
      
      public var cashRewardsBtn:SwfButton;
      
      public var lineupBtn:SwfButton;
      
      public var bagBtn:SwfButton;
      
      public var myPointTf:TextField;
      
      public var myTotalFightTf:TextField;
      
      public var myOddsTf:TextField;
      
      public var myNameTf:TextField;
      
      public var myNameSpr:Sprite;
      
      public var myTopRankTf:TextField;
      
      public var myNowRankTf:TextField;
      
      public var npcPointTf:TextField;
      
      public var npcTotalFightTf:TextField;
      
      public var npcOddsTf:TextField;
      
      public var npcNameTf:TextField;
      
      public var npcNameSpr:Sprite;
      
      public var npcTopRankTf:TextField;
      
      public var npcNowRankTf:TextField;
      
      public var matchTimesTf:TextField;
      
      public var countdownTf:TextField;
      
      public var myElfCamp:com.mvc.views.uis.mainCity.pvp.PVPElfCampUI;
      
      public var npcElfCamp:com.mvc.views.uis.mainCity.pvp.PVPElfCampUI;
      
      public function PVPChallengeUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("pvp");
         spr_challenge = swf.createSprite("spr_challenge");
         addChild(spr_challenge);
         onlineMatchBtn = spr_challenge.getChildByName("onlineMatchBtn") as SwfButton;
         beginPlayBtn = spr_challenge.getChildByName("beginPlayBtn") as SwfButton;
         beginPlayBtn.visible = false;
         matchRulesBtn = spr_challenge.getChildByName("matchRulesBtn") as SwfButton;
         rankBtn = spr_challenge.getChildByName("rankBtn") as SwfButton;
         cashRewardsBtn = spr_challenge.getChildByName("cashRewardsBtn") as SwfButton;
         lineupBtn = spr_challenge.getChildByName("lineupBtn") as SwfButton;
         bagBtn = spr_challenge.getChildByName("bagBtn") as SwfButton;
         myPointTf = spr_challenge.getChildByName("myPointTf") as TextField;
         myTotalFightTf = spr_challenge.getChildByName("myTotalFightTf") as TextField;
         myOddsTf = spr_challenge.getChildByName("myOddsTf") as TextField;
         myNameSpr = new Sprite();
         myNameSpr.x = 119;
         myNameSpr.y = 343;
         spr_challenge.addChild(myNameSpr);
         myTopRankTf = spr_challenge.getChildByName("myTopRankTf") as TextField;
         myNowRankTf = spr_challenge.getChildByName("myNowRankTf") as TextField;
         npcPointTf = spr_challenge.getChildByName("npcPointTf") as TextField;
         npcTotalFightTf = spr_challenge.getChildByName("npcTotalFightTf") as TextField;
         npcOddsTf = spr_challenge.getChildByName("npcOddsTf") as TextField;
         npcNameTf = spr_challenge.getChildByName("npcNameTf") as TextField;
         npcNameTf.text = "";
         npcNameSpr = new Sprite();
         npcNameSpr.x = 815;
         npcNameSpr.y = 343;
         spr_challenge.addChild(npcNameSpr);
         showName(npcNameSpr,"？？？？？？",0);
         npcTopRankTf = spr_challenge.getChildByName("npcTopRankTf") as TextField;
         npcNowRankTf = spr_challenge.getChildByName("npcNowRankTf") as TextField;
         matchTimesTf = spr_challenge.getChildByName("matchTimesTf") as TextField;
         countdownTf = spr_challenge.getChildByName("countdownTf") as TextField;
         countdownTf.visible = false;
      }
      
      public function showName(param1:Sprite, param2:String, param3:int) : void
      {
         var _loc6_:* = null;
         param1.removeChildren(0,-1,true);
         var _loc4_:TextField = new TextField(50,30,"","1",25,5715238,true);
         _loc4_.autoSize = "horizontal";
         _loc4_.text = param2;
         var _loc5_:* = 240;
         if(_loc5_ - _loc4_.width < 80)
         {
            _loc5_ = _loc4_.width + 80;
         }
         _loc4_.x = _loc5_ - _loc4_.width >> 1;
         _loc4_.y = 42 - _loc4_.height >> 1;
         LogUtil("==============",_loc4_.x,_loc4_.y,param1.x,param1.y,"====",_loc5_,_loc4_.width,param1.height,_loc4_.height);
         param1.addChild(_loc4_);
         if(param3 > 0)
         {
            _loc6_ = GetCommon.getVipIcon(param3);
            _loc6_.x = _loc4_.x - _loc6_.width - 5;
            param1.addChild(_loc6_);
         }
      }
      
      public function showMyElfCamp(param1:Vector.<ElfVO>) : void
      {
         if(!myElfCamp)
         {
            myElfCamp = new com.mvc.views.uis.mainCity.pvp.PVPElfCampUI(param1);
         }
         else
         {
            myElfCamp.removeFromParent(true);
            myElfCamp = null;
            myElfCamp = new com.mvc.views.uis.mainCity.pvp.PVPElfCampUI(param1);
         }
         myElfCamp.x = 125;
         myElfCamp.y = 395;
         spr_challenge.addChild(myElfCamp);
      }
      
      public function showNPCElfCamp(param1:Vector.<ElfVO>) : void
      {
         if(!npcElfCamp)
         {
            npcElfCamp = new com.mvc.views.uis.mainCity.pvp.PVPElfCampUI(param1);
         }
         else
         {
            npcElfCamp.removeFromParent(true);
            npcElfCamp = null;
            npcElfCamp = new com.mvc.views.uis.mainCity.pvp.PVPElfCampUI(param1);
         }
         npcElfCamp.x = 825;
         npcElfCamp.y = 395;
         spr_challenge.addChild(npcElfCamp);
      }
   }
}
