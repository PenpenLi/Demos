package com.mvc.views.uis.mainCity.active
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.ScrollContainer;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.active.ActiveVO;
   import com.mvc.models.vos.mainCity.active.ActiveChildVO;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.layout.HorizontalLayout;
   import starling.events.Event;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.active.ActivePro;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   
   public class RewardThreeUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_listBg:SwfSprite;
      
      private var btn_alreadyGet:SwfButton;
      
      private var btn_get:SwfButton;
      
      private var btn_notGet:SwfButton;
      
      private var rewardCotain:ScrollContainer;
      
      private var title:TextField;
      
      private var isHasSpace:Boolean = true;
      
      public var activeVo:ActiveVO;
      
      private var _activeChild:ActiveChildVO;
      
      public function RewardThreeUnit()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("activity");
         spr_listBg = swf.createSprite("spr_list1");
         btn_alreadyGet = spr_listBg.getButton("btn_alreadyGet");
         btn_get = spr_listBg.getButton("btn_get");
         btn_notGet = spr_listBg.getButton("btn_notGet");
         title = spr_listBg.getTextField("title");
         addChild(spr_listBg);
         btn_alreadyGet.enabled = false;
         btn_notGet.enabled = false;
         rewardCotain = new ScrollContainer();
         rewardCotain.width = 520;
         rewardCotain.height = 100;
         rewardCotain.y = 10;
         rewardCotain.x = 5;
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.useVirtualLayout = false;
         _loc1_.gap = 5;
         rewardCotain.verticalScrollPolicy = "none";
         rewardCotain.layout = _loc1_;
         spr_listBg.addChild(rewardCotain);
         this.addEventListener("triggered",onclick);
      }
      
      private function onclick(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_get !== _loc2_)
         {
            if(btn_alreadyGet !== _loc2_)
            {
               if(btn_notGet !== _loc2_)
               {
               }
            }
         }
         else
         {
            EventCenter.addEventListener("ACTIVE_REWARD_SUCCESS",changeState);
            (Facade.getInstance().retrieveProxy("ActivePro") as ActivePro).write1902(activeVo.id,_activeChild.id);
         }
      }
      
      private function changeState() : void
      {
         EventCenter.removeEventListener("ACTIVE_REWARD_SUCCESS",changeState);
         _activeChild.status = 2;
         showState(2);
      }
      
      public function set myActiveChild(param1:ActiveChildVO) : void
      {
         _activeChild = param1;
         if(param1.rewardTip == "")
         {
            setPostion(false);
         }
         else
         {
            setPostion(true);
         }
         title.text = param1.rewardTip;
         showRwward(param1.reward);
         showState(param1.status);
      }
      
      private function showRwward(param1:Object) : void
      {
         var _loc6_:* = null;
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         if(param1.poke)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.poke.length)
            {
               _loc6_ = new DropPropUnitUI();
               _loc6_.isShowAttribute = false;
               _loc3_ = GetElfFactor.getElfVO(param1.poke[_loc5_].pokeId);
               _loc3_.lv = param1.poke[_loc5_].lv;
               _loc6_.myElfVo = _loc3_;
               _loc6_.rewardNameTf.text = _loc3_.name + "×" + param1.poke[_loc5_].num;
               var _loc7_:* = 0.7;
               _loc6_.scaleY = _loc7_;
               _loc6_.scaleX = _loc7_;
               rewardCotain.addChild(_loc6_);
               _loc5_++;
            }
            if(PlayerVO.cpSpace + PlayerVO.pokeSpace - PlayerVO.comElfVec.length - GetElfFactor.bagElfNum() < param1.poke.length)
            {
               isHasSpace = false;
            }
         }
         if(param1.diamond)
         {
            _loc6_ = new DropPropUnitUI();
            _loc6_.setOtherAward("奖励钻石×" + param1.diamond.num);
            _loc7_ = 0.7;
            _loc6_.scaleY = _loc7_;
            _loc6_.scaleX = _loc7_;
            rewardCotain.addChild(_loc6_);
         }
         if(param1.silver)
         {
            _loc6_ = new DropPropUnitUI();
            _loc6_.setOtherAward("奖励金币×" + param1.silver.num);
            _loc7_ = 0.7;
            _loc6_.scaleY = _loc7_;
            _loc6_.scaleX = _loc7_;
            rewardCotain.addChild(_loc6_);
         }
         if(param1.action)
         {
            _loc6_ = new DropPropUnitUI();
            _loc6_.setOtherAward("奖励体力×" + param1.action.num);
            _loc7_ = 0.7;
            _loc6_.scaleY = _loc7_;
            _loc6_.scaleX = _loc7_;
            rewardCotain.addChild(_loc6_);
         }
         if(param1.prop)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.prop.length)
            {
               _loc6_ = new DropPropUnitUI();
               _loc2_ = GetPropFactor.getPropVO(param1.prop[_loc4_].pId);
               _loc2_.rewardCount = param1.prop[_loc4_].num;
               _loc6_.myPropVo = _loc2_;
               _loc7_ = 0.7;
               _loc6_.scaleY = _loc7_;
               _loc6_.scaleX = _loc7_;
               rewardCotain.addChild(_loc6_);
               _loc4_++;
            }
         }
      }
      
      public function setPostion(param1:Boolean) : void
      {
         if(param1)
         {
            var _loc2_:* = 54;
            btn_notGet.y = _loc2_;
            _loc2_ = _loc2_;
            btn_get.y = _loc2_;
            btn_alreadyGet.y = _loc2_;
         }
         else
         {
            _loc2_ = 32;
            btn_notGet.y = _loc2_;
            _loc2_ = _loc2_;
            btn_get.y = _loc2_;
            btn_alreadyGet.y = _loc2_;
         }
      }
      
      private function showState(param1:int) : void
      {
         btn_alreadyGet.visible = false;
         btn_get.visible = false;
         btn_notGet.visible = false;
         switch(param1)
         {
            case 0:
               btn_notGet.visible = true;
               break;
            case 1:
               btn_get.visible = true;
               break;
            case 2:
               btn_alreadyGet.visible = true;
               break;
         }
      }
   }
}
