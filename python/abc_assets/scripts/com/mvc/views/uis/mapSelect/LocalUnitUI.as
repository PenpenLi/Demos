package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.GetCommon;
   import org.puremvc.as3.patterns.facade.Facade;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.themes.Tips;
   import com.mvc.models.vos.fighting.FightingConfig;
   
   public class LocalUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var bg:SwfScale9Image;
      
      private var localTxt:TextField;
      
      private var nowLocal:TextField;
      
      private var _nowId:int;
      
      private var _localId:int;
      
      public function LocalUnitUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         bg = swf.createS9Image("s9_inputBg");
         bg.width = 250;
         bg.height = 60;
         addChild(bg);
         localTxt = GetCommon.getText(50,5,150,50,"","FZCuYuan-M03S",25,9713664,this);
         nowLocal = GetCommon.getText(160,5,80,50,"","FZCuYuan-M03S",25,2919680,this);
      }
      
      public function show(param1:int, param2:int) : void
      {
         _nowId = param1;
         _localId = param2;
         localTxt.text = SeleLocalUI.localNameArr[param2][0];
         if(param1 == param2)
         {
            localTxt.x = localTxt.x - 30;
            nowLocal.text = "当前";
         }
         this.addEventListener("touch",seleEvent);
      }
      
      private function tipsMap() : void
      {
         SeleLocalUI.getInstance().remove();
         Facade.getInstance().sendNotification("switch_page",SeleLocalUI.localNameArr[_localId][1]);
      }
      
      private function seleEvent(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            if(_localId == _nowId)
            {
               Tips.show("亲，这里就是哦，不用跳转了");
            }
            else if(_localId == 1)
            {
               if(FightingConfig.openCity > 15)
               {
                  tipsMap();
               }
               else
               {
                  Tips.show("亲，你还没有解锁【" + SeleLocalUI.localNameArr[_localId][0] + "】哦");
               }
            }
            else if(_localId == 0)
            {
               tipsMap();
            }
         }
      }
   }
}
