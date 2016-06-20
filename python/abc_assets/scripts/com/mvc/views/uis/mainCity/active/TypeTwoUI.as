package com.mvc.views.uis.mainCity.active
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.mainCity.active.ActiveVO;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.active.ActivePro;
   
   public class TypeTwoUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var btn_getBtn:SwfButton;
      
      private var image:SwfImage;
      
      private var _activeVo:ActiveVO;
      
      private var btn_notGetBtn:SwfButton;
      
      public function TypeTwoUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("activity");
         btn_getBtn = swf.createButton("btn_getBtn");
         btn_notGetBtn = swf.createButton("btn_notGetBtn");
         var _loc1_:* = 350;
         btn_notGetBtn.x = _loc1_;
         btn_getBtn.x = _loc1_;
         _loc1_ = 380;
         btn_notGetBtn.y = _loc1_;
         btn_getBtn.y = _loc1_;
         btn_notGetBtn.enabled = false;
         btn_getBtn.addEventListener("triggered",getReward);
      }
      
      private function getReward() : void
      {
         EventCenter.addEventListener("ACTIVE_REWARD_SUCCESS",changeState);
         (Facade.getInstance().retrieveProxy("ActivePro") as ActivePro).write1902(_activeVo.id,_activeVo.activeChildVec[0].id);
      }
      
      private function changeState() : void
      {
         EventCenter.removeEventListener("ACTIVE_REWARD_SUCCESS",changeState);
         _activeVo.activeChildVec[0].status = 2;
         showState(false);
      }
      
      private function showState(param1:Boolean) : void
      {
         btn_getBtn.visible = param1;
         btn_notGetBtn.visible = !param1;
      }
      
      public function set myActive(param1:ActiveVO) : void
      {
         _activeVo = param1;
         if(param1.activeChildVec.length > 0)
         {
            if(image)
            {
               image.removeFromParent(true);
               image = null;
            }
            image = swf.createImage("img_01");
            image.x = 5;
            image.y = 35;
            addChild(image);
            addChild(btn_getBtn);
            addChild(btn_notGetBtn);
            if(param1.activeChildVec[0].status != 1)
            {
               showState(false);
            }
            else
            {
               showState(true);
            }
         }
      }
   }
}
