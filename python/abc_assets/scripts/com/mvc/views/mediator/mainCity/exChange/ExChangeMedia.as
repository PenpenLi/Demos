package com.mvc.views.mediator.mainCity.exChange
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.exChange.ExChangeUI;
   import com.mvc.views.uis.mainCity.exChange.ExModeUnitUI;
   import starling.events.Event;
   import com.mvc.views.uis.mainCity.exChange.GotoExChange;
   import flash.system.System;
   import com.common.util.ShowHelpTip;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.exChange.ExChangeVO;
   import com.mvc.models.proxy.mainCity.exChange.ExChangePro;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ExChangeMedia extends Mediator
   {
      
      public static const NAME:String = "ExChangeMedia";
      
      public static var lightArr:Array = [955391,12406505,16766512];
      
      public static var lightSourceArr:Array = [2979818,13187817,15632421];
       
      public var exChange:ExChangeUI;
      
      private var exModeVec:Vector.<ExModeUnitUI>;
      
      public function ExChangeMedia(param1:Object = null)
      {
         exModeVec = new Vector.<ExModeUnitUI>([]);
         super("ExChangeMedia",param1);
         exChange = param1 as ExChangeUI;
         exChange.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(exChange.btn_close !== _loc2_)
         {
            if(exChange.btn_help === _loc2_)
            {
               ShowHelpTip.getInstance().show(0);
            }
         }
         else
         {
            if(GotoExChange.instance)
            {
               GotoExChange.getInstance().remove();
               return;
            }
            sendNotification("switch_page","load_maincity_page");
            System.gc();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_EXCHANGE_MODE","SHOW_EXCHANGE_ELF","CLOSE_EXCHANGE_ELF"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_EXCHANGE_MODE" !== _loc2_)
         {
            if("SHOW_EXCHANGE_ELF" !== _loc2_)
            {
               if("CLOSE_EXCHANGE_ELF" === _loc2_)
               {
                  exChange.elfContain.visible = true;
                  openAni();
               }
            }
            else
            {
               exChange.elfContain.visible = false;
               closeAni();
               GotoExChange.getInstance().show(param1.getBody() as ExChangeVO,exChange);
            }
         }
         else
         {
            show();
         }
      }
      
      private function show() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         LogUtil("展示交换模式");
         exModeVec = Vector.<ExModeUnitUI>([]);
         _loc1_ = 0;
         while(_loc1_ < ExChangePro.exChangeVec.length)
         {
            _loc2_ = new ExModeUnitUI();
            _loc2_.mode = ExChangePro.exChangeVec[_loc1_];
            _loc2_.x = _loc1_ * 330;
            exChange.elfContain.addChild(_loc2_);
            exModeVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function openAni() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < exModeVec.length)
         {
            exModeVec[_loc1_].openAni();
            _loc1_++;
         }
      }
      
      public function closeAni() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < exModeVec.length)
         {
            exModeVec[_loc1_].closeAni();
            _loc1_++;
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         closeAni();
         exModeVec = null;
         facade.removeMediator("ExChangeMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.exChangeAssets);
      }
   }
}
