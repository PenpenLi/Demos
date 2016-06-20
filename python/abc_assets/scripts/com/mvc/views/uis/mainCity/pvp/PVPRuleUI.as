package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.controls.ScrollContainer;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.layout.HorizontalLayout;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   
   public class PVPRuleUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var ruleContentTf:TextField;
      
      public var closeBtn:SwfButton;
      
      public var spr_rule:SwfSprite;
      
      public var spr_rankRewardTips:SwfSprite;
      
      public var scrollContainer:ScrollContainer;
      
      public function PVPRuleUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("pvp");
         spr_rule = swf.createSprite("spr_rule");
         spr_rule.x = 1136 - spr_rule.width >> 1;
         spr_rule.y = 640 - spr_rule.height >> 1;
         addChild(spr_rule);
         ruleContentTf = spr_rule.getChildByName("ruleContentTf") as TextField;
         ruleContentTf.vAlign = "top";
         ruleContentTf.height = ruleContentTf.height + 25;
         ruleContentTf.autoScale = true;
         closeBtn = spr_rule.getChildByName("closeBtn") as SwfButton;
         closeBtn.y = closeBtn.y + 10;
         createRankRewardTips();
      }
      
      private function createRankRewardTips() : void
      {
         spr_rankRewardTips = spr_rule.getSprite("rankRewardTipsSpr");
         spr_rankRewardTips.visible = false;
         scrollContainer = new ScrollContainer();
         scrollContainer.x = 50;
         scrollContainer.y = 193;
         scrollContainer.width = 400;
         scrollContainer.height = 110;
         scrollContainer.verticalScrollPolicy = "off";
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.gap = 40;
         scrollContainer.layout = _loc1_;
         spr_rankRewardTips.addChild(scrollContainer);
      }
      
      public function setRule(param1:Boolean) : void
      {
         if(param1)
         {
            spr_rankRewardTips.visible = true;
            (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6010();
            ruleContentTf.text = "\n\n\n\n\n\n\n\n1、11:00~14:00和18:00~22:00计算匹配次数和积分，其余在时间在开放时间内无限匹配次数但不计算积分。\n2、在线挑战赛每天8：00至22：00准时开放，其余时间均为休息时间。\n3、挑战胜利者获得100点挑战积分，50点挑战商店积分，失败者获得50点挑战积分，20点挑战商店积分。\n4、匹配成功后不点击“开始对战”的玩家会被判为逃跑。\n5、在挑战赛的过程中，可以逃跑，视为玩家主动投降，系统判定玩家为输。\n6、每天每个玩家可以免费使用十次匹配功能，每天凌晨重置次数。\n7、每星期天22：00整点结算挑战积分排名，并通过邮件发放排名奖励。\n8、挑战赛过程中不能使用背包道具。";
         }
         else
         {
            spr_rankRewardTips.visible = false;
            ruleContentTf.text = "1、在练习赛的过程中，可以逃跑，视为玩家主动投降，系统判定玩家为输。\n\n2、练习赛过程中不能使用背包道具。\n\n3、练习赛不计算积分，不限制玩家使用次数。\n\n4、玩家可以通过房间号搜索到房间。";
         }
      }
   }
}
