package com.mvc.views.uis.mainCity.elfSeries
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.display.Quad;
   
   public class SeriesHelpUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_seriesHelp:SwfSprite;
      
      public var rank:TextField;
      
      public var maxRank:TextField;
      
      public var btn_helpClose:SwfButton;
      
      private var silver:TextField;
      
      private var diamon:TextField;
      
      private var rkDot:TextField;
      
      private var helpTxt:TextField;
      
      public function SeriesHelpUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfSeries");
         spr_seriesHelp = swf.createSprite("spr_seriesHelp");
         rank = spr_seriesHelp.getTextField("rank");
         silver = spr_seriesHelp.getTextField("silver");
         diamon = spr_seriesHelp.getTextField("diamon");
         rkDot = spr_seriesHelp.getTextField("rkDot");
         maxRank = spr_seriesHelp.getTextField("maxRank");
         btn_helpClose = spr_seriesHelp.getButton("btn_helpClose");
         spr_seriesHelp.x = 1136 - spr_seriesHelp.width >> 1;
         spr_seriesHelp.y = 640 - spr_seriesHelp.height >> 1;
         helpTxt = spr_seriesHelp.getChildByName("helpTxt") as TextField;
         helpTxt.vAlign = "top";
         helpTxt.text = "1、在联盟大赛的战斗中，防守方只能自动战斗，其精灵将会以随机顺序出场。\n2、进攻方在战斗途中不能逃跑，且战斗双方都不能使用背包。\n3、若战斗胜利，且防守方的排名高于进攻方，则将双方排名对调。\n4、每天每个玩家可以免费发起战斗5次，每天凌晨5点整重置次数。\n5、每次战斗后，进攻方玩家将获得一个10分钟的冷却时间。\n6、正在进行对战的玩家无法被选作对手。\n7、每天晚上9点整结算排名，并通过邮箱发放排名奖励。";
         addChild(spr_seriesHelp);
      }
      
      public function upDate() : void
      {
         rank.text = "保持当前排名（ 第" + PlayerVO.seriesRank + "名 ），可领奖励为: ";
         silver.text = PlayerVO.seriesSilver;
         diamon.text = PlayerVO.seriesDiamon;
         rkDot.text = PlayerVO.seriesRkDot;
         maxRank.text = PlayerVO.seriesMaxRank;
      }
   }
}
