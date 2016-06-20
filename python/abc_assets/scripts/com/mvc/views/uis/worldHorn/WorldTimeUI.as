package com.mvc.views.uis.worldHorn
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.util.TimeUtil;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   
   public class WorldTimeUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.worldHorn.WorldTimeUI;
       
      private var swf:Swf;
      
      private var root:Game;
      
      private var spr_worldTime:SwfSprite;
      
      private var worldText:TextField;
      
      private var isShow:Boolean;
      
      public function WorldTimeUI()
      {
         super();
         root = Config.starling.root as Game;
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.worldHorn.WorldTimeUI
      {
         return instance || new com.mvc.views.uis.worldHorn.WorldTimeUI();
      }
      
      public function timekeeper(param1:String = null, param2:String = null, param3:String = null) : void
      {
         if(isShow)
         {
            worldText.text = "当前时间: " + param1 + ":" + param2 + ":" + param3 + "\n" + "下点体力恢复: " + TimeUtil.convertStringToDate(PlayerVO.actionCDTime) + "\n" + "全部体力恢复: " + TimeUtil.convertStringToDate(Math.max(PlayerVO.maxActionForce - PlayerVO.actionForce - 1,0) * 6 * 60 + PlayerVO.actionCDTime);
         }
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_worldTime = swf.createSprite("spr_worldTime");
         worldText = spr_worldTime.getTextField("worldText");
         spr_worldTime.x = 400;
         spr_worldTime.y = 100;
         addChild(spr_worldTime);
         worldText.text = "当前时间: " + WorldTime.getInstance().hourStr + ":" + WorldTime.getInstance().minuteStr + ":" + WorldTime.getInstance().secondStr + "\n" + "下点体力恢复: " + TimeUtil.convertStringToDate(PlayerVO.actionCDTime) + "\n" + "全部体力恢复: " + TimeUtil.convertStringToDate(Math.max(PlayerVO.maxActionForce - PlayerVO.actionForce - 1,0) * 6 * 60 + PlayerVO.actionCDTime);
      }
      
      public function show() : void
      {
         if(!this.parent)
         {
            isShow = true;
            root.addChild(this);
            AniFactor.fadeOutOrIn(this,1,0,0.5);
         }
      }
      
      public function remove() : void
      {
         if(this.parent)
         {
            AniFactor.fadeOutOrIn(this,0,1,0.5);
         }
         isShow = false;
      }
   }
}
