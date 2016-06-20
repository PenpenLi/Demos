package com.common.util
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import starling.display.Quad;
   
   public class ShowHelpTip extends Sprite
   {
      
      private static var instance:com.common.util.ShowHelpTip;
       
      private var swf:Swf;
      
      private var spr_help:SwfSprite;
      
      private var title:TextField;
      
      private var prompt:TextField;
      
      public var titleArr:Array;
      
      public var promptArr:Array;
      
      public function ShowHelpTip()
      {
         titleArr = ["交换规则","规则说明"];
         promptArr = ["1、玩家要达到一定的等级才能进入精灵交换中心\n2、每个级别的交换，都会有次数的限制，每周五更新次数和精灵的种类\n3、玩家可以自行选择需要交换的精灵，交换之后的精灵统一等级为5级，性格、性别均为随机\n4、选定精灵后，需要玩家自己确定交换才能正式交换\n5、在背包、联盟大赛防守阵容、训练位置中的精灵，不能进行交换","1、在捕虫大会中捕获精灵可以获得排行的积分\n2、在获得20000积分后可以进入排行榜\n3、排行榜5每分钟刷新一次\n4、日若排行积分同，在时间上先达到的训练师排在名次前列\n5、排名奖励在活动结束后的次日以邮件形式发放"];
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      public static function getInstance() : com.common.util.ShowHelpTip
      {
         return instance || new com.common.util.ShowHelpTip();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_help = swf.createSprite("spr_help");
         title = spr_help.getTextField("title");
         prompt = spr_help.getTextField("prompt");
         spr_help.x = 1136 - spr_help.width >> 1;
         spr_help.y = 640 - spr_help.height >> 1;
         addChild(spr_help);
      }
      
      public function show(param1:int) : void
      {
         title.text = titleArr[param1];
         prompt.text = promptArr[param1];
         (Config.starling.root as Game).addChild(this);
         this.addEventListener("touch",ontouch);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            removeFromParent();
         }
      }
   }
}
