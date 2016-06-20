package com.mvc.views.uis.mainCity.specialAct.diamondUp
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfMovieClip;
   import feathers.controls.Label;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.mainCity.specialAct.DiaMarkUpVO;
   import starling.core.Starling;
   import com.massage.ane.UmengExtension;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class DiamondUpUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_diamondUp:SwfSprite;
      
      public var spr_numList:SwfSprite;
      
      public var btn_buyDiamond:SwfButton;
      
      public var btn_recharge:SwfButton;
      
      public var btn_close:SwfButton;
      
      public var tf_ownDiamond:TextField;
      
      public var tf_getDiamond:TextField;
      
      public var tf_remainTimes:TextField;
      
      public var tf_nextDiamondNum:TextField;
      
      private var tf_num0:TextField;
      
      private var tf_num1:TextField;
      
      private var tf_num2:TextField;
      
      private var tf_num3:TextField;
      
      private var tf_num4:TextField;
      
      private var tf_num5:TextField;
      
      private var mc_numList0:SwfMovieClip;
      
      private var mc_numList1:SwfMovieClip;
      
      private var mc_numList2:SwfMovieClip;
      
      private var mc_numList3:SwfMovieClip;
      
      private var mc_numList4:SwfMovieClip;
      
      private var mc_numList5:SwfMovieClip;
      
      private var index:int;
      
      public var leftTimeLable:Label;
      
      public function DiamondUpUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("diamondUp");
         spr_diamondUp = swf.createSprite("spr_diamondUp");
         spr_diamondUp.x = 1136 - spr_diamondUp.width >> 1;
         spr_diamondUp.y = 640 - spr_diamondUp.height >> 1;
         addChild(spr_diamondUp);
         spr_numList = spr_diamondUp.getSprite("spr_numList");
         spr_numList.clipRect = new Rectangle(0,0,500,105);
         spr_numList.visible = false;
         btn_buyDiamond = spr_diamondUp.getButton("btn_buyDiamond");
         btn_recharge = spr_diamondUp.getButton("btn_recharge");
         btn_close = spr_diamondUp.getButton("btn_close");
         tf_ownDiamond = spr_diamondUp.getTextField("tf_ownDiamond");
         tf_getDiamond = spr_diamondUp.getTextField("tf_getDiamond");
         tf_getDiamond.autoScale = true;
         tf_remainTimes = spr_diamondUp.getTextField("tf_remainTimes");
         tf_nextDiamondNum = (btn_buyDiamond.skin as Sprite).getChildByName("tf_diamondNum") as TextField;
         tf_num0 = spr_diamondUp.getTextField("tf_num0");
         tf_num1 = spr_diamondUp.getTextField("tf_num1");
         tf_num2 = spr_diamondUp.getTextField("tf_num2");
         tf_num3 = spr_diamondUp.getTextField("tf_num3");
         tf_num4 = spr_diamondUp.getTextField("tf_num4");
         tf_num5 = spr_diamondUp.getTextField("tf_num5");
         mc_numList0 = spr_numList.getMovie("mc_numList0");
         mc_numList0.gotoAndStop(0);
         mc_numList1 = spr_numList.getMovie("mc_numList1");
         mc_numList1.gotoAndStop(0);
         mc_numList2 = spr_numList.getMovie("mc_numList2");
         mc_numList2.gotoAndStop(0);
         mc_numList3 = spr_numList.getMovie("mc_numList3");
         mc_numList3.gotoAndStop(0);
         mc_numList4 = spr_numList.getMovie("mc_numList4");
         mc_numList4.gotoAndStop(0);
         mc_numList5 = spr_numList.getMovie("mc_numList5");
         mc_numList5.gotoAndStop(0);
         var _loc1_:TextFormat = new TextFormat("FZCuYuan-M03S",25,16777215);
         leftTimeLable = new Label();
         leftTimeLable.x = 430;
         leftTimeLable.y = 50;
         leftTimeLable.text = "活动倒计时: " + setColor("00") + "天 " + setColor("00") + "小时 " + setColor("00") + "分 " + setColor("00") + "秒</font>";
         leftTimeLable.textRendererProperties.textFormat = _loc1_;
         leftTimeLable.textRendererProperties.isHTML = true;
         spr_diamondUp.addChild(leftTimeLable);
         tf_ownDiamond.autoScale = true;
      }
      
      private function setColor(param1:String) : String
      {
         return "<font color=\'#ffee00\'>" + param1 + "</font>";
      }
      
      public function updateInfo() : void
      {
         tf_ownDiamond.text = PlayerVO.diamond;
         tf_nextDiamondNum.text = DiaMarkUpVO.nextNeedDia;
         tf_getDiamond.text = DiaMarkUpVO.addUpDia;
         tf_remainTimes.text = DiaMarkUpVO.lessNum;
      }
      
      public function showMC() : void
      {
         var _loc1_:* = 0;
         PlayerVO.diamond = PlayerVO.diamond - tf_nextDiamondNum.text;
         tf_ownDiamond.text = PlayerVO.diamond;
         PlayerVO.isAcceptPvp = false;
         Starling.current.root.touchable = false;
         spr_numList.visible = true;
         index = 0;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            (this["mc_numList" + _loc1_] as SwfMovieClip).gotoAndPlay(Math.random() * 10 * _loc1_);
            (this["mc_numList" + _loc1_] as SwfMovieClip).visible = true;
            (this["tf_num" + _loc1_] as TextField).visible = false;
            Starling.juggler.delayCall(stopMc,0.8 * _loc1_ + 0.8);
            _loc1_++;
         }
      }
      
      private function stopMc() : void
      {
         if(index >= 6)
         {
            return;
         }
         (this["mc_numList" + index] as SwfMovieClip).gotoAndStop(0);
         (this["mc_numList" + index] as SwfMovieClip).visible = false;
         (this["tf_num" + index] as TextField).visible = true;
         if(DiaMarkUpVO.theGetDia.length - index - 1 >= 0)
         {
            (this["tf_num" + index] as TextField).text = DiaMarkUpVO.theGetDia.charAt(DiaMarkUpVO.theGetDia.length - index - 1);
         }
         else
         {
            (this["tf_num" + index] as TextField).text = "0";
         }
         index = index + 1;
         if(index >= 6)
         {
            updateInfo();
            PlayerVO.isAcceptPvp = true;
            Starling.current.root.touchable = true;
            UmengExtension.getInstance().UMAnalysic("bonusMoney|" + DiaMarkUpVO.theGetDia + "|7");
            Facade.getInstance().sendNotification("update_play_diamond_info",PlayerVO.diamond + DiaMarkUpVO.theGetDia);
            tf_ownDiamond.text = PlayerVO.diamond;
         }
      }
   }
}
