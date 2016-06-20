package com.mvc.views.uis.mainCity.lottery
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import com.mvc.models.vos.mainCity.lottery.LotteryRewardVO;
   import lzm.starling.swf.display.SwfImage;
   import starling.text.TextField;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.mainCity.lottery.LotteryVO;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class LotteryItemUI extends Sprite
   {
      
      public static var isHasSpace:Boolean = true;
      
      public static var elfRewardNum:int;
       
      private var swf:Swf;
      
      private var index:int;
      
      private var lotterVO:LotteryRewardVO;
      
      public var spr_colour:SwfImage;
      
      public var decs:TextField;
      
      private var _sprItemArr:Array;
      
      public function LotteryItemUI(param1:int, param2:LotteryRewardVO)
      {
         super();
         index = param1;
         lotterVO = param2;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("lottery");
         spr_colour = swf.createImage("img_colour" + index);
         addChild(spr_colour);
         spr_colour.color = 255;
         init();
      }
      
      private function init() : void
      {
         initIcon();
      }
      
      private function initText() : void
      {
         decs = new TextField(100,35,"","FZCuYuan-M03S",30,16777215);
         decs.autoSize = "none";
         decs.hAlign = "center";
         decs.x = 35;
         decs.y = 105;
         addChild(decs);
      }
      
      private function initIcon() : void
      {
         showRwward(lotterVO,this,0.75);
      }
      
      public function setText(param1:String) : void
      {
         decs.text = param1;
      }
      
      public function setImgColour(param1:uint) : void
      {
         spr_colour.color = param1;
      }
      
      public function showRwward(param1:Object, param2:Sprite, param3:Number = 1) : void
      {
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         elfRewardNum = 0;
         if(param1.poke)
         {
            LogUtil("奖励宠物");
            _loc6_ = new DropPropUnitUI();
            var _loc7_:* = param3;
            _loc6_.scaleY = _loc7_;
            _loc6_.scaleX = _loc7_;
            _loc6_.touchable = false;
            _loc5_ = GetElfFactor.getElfVO(param1.poke.pokeid);
            _loc5_.lv = param1.poke.lv;
            _loc6_.myElfVo = _loc5_;
            param2.addChild(_loc6_);
            elfRewardNum = §§dup().elfRewardNum + param1.poke.num;
            _loc6_.setTextColor(5715237,30,30);
            if(PlayerVO.cpSpace + PlayerVO.pokeSpace - PlayerVO.comElfVec.length - GetElfFactor.bagElfNum() < elfRewardNum)
            {
               isHasSpace = false;
            }
            else
            {
               isHasSpace = true;
            }
         }
         if(param1.diamond)
         {
            LogUtil("奖励钻石");
            _loc6_ = new DropPropUnitUI();
            _loc7_ = param3;
            _loc6_.scaleY = _loc7_;
            _loc6_.scaleX = _loc7_;
            _loc6_.setOtherAward("奖励钻石×" + param1.diamond.num);
            _loc6_.setTextColor(5715237,35,35);
            param2.addChild(_loc6_);
         }
         if(param1.prop)
         {
            LogUtil("奖励道具");
            _loc6_ = new DropPropUnitUI();
            _loc7_ = param3;
            _loc6_.scaleY = _loc7_;
            _loc6_.scaleX = _loc7_;
            _loc4_ = GetPropFactor.getPropVO(param1.prop.pId);
            _loc4_.rewardCount = param1.prop.num;
            _loc6_.myPropVo = _loc4_;
            _loc6_.setTextColor(5715237,35,35);
            param2.addChild(_loc6_);
         }
         if(LotteryVO.rewardList.length > 8)
         {
            _loc6_.x = 48;
            _loc6_.y = 18;
         }
         else
         {
            _loc6_.x = 70;
            _loc6_.y = 20;
         }
      }
   }
}
