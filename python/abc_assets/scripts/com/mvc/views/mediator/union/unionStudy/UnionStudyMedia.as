package com.mvc.views.mediator.union.unionStudy
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.union.unionStudy.UnionStudyUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.consts.ConfigConst;
   import starling.display.DisplayObject;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class UnionStudyMedia extends Mediator
   {
      
      public static const NAME:String = "UnionStudyMedia";
       
      public var unionStudy:UnionStudyUI;
      
      public function UnionStudyMedia(param1:Object = null)
      {
         super("UnionStudyMedia",param1);
         unionStudy = param1 as UnionStudyUI;
         unionStudy.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(unionStudy.btn_close !== _loc2_)
         {
            if(unionStudy.btn_hall !== _loc2_)
            {
               if(unionStudy.btn_series !== _loc2_)
               {
                  if(unionStudy.btn_train === _loc2_)
                  {
                     unionStudy.visible = false;
                     StudyChildMedia.typePage = 2;
                     sendNotification("switch_win",null,"LOAD_STUDYCHILD_WIN");
                  }
               }
               else
               {
                  unionStudy.visible = false;
                  StudyChildMedia.typePage = 3;
                  sendNotification("switch_win",null,"LOAD_STUDYCHILD_WIN");
               }
            }
            else
            {
               unionStudy.visible = false;
               StudyChildMedia.typePage = 1;
               sendNotification("switch_win",null,"LOAD_STUDYCHILD_WIN");
            }
         }
         else
         {
            unionStudy.hideBtn();
            WinTweens.closeWin(unionStudy.spr_study,remove);
         }
      }
      
      private function remove() : void
      {
         WinTweens.showCity();
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if(ConfigConst.SHOW_UNIONSTUDY_BTN !== _loc2_)
         {
            if(ConfigConst.SHOW_UNION_STUDY === _loc2_)
            {
               unionStudy.visible = true;
            }
         }
         else
         {
            unionStudy.showBtn();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.SHOW_UNIONSTUDY_BTN,ConfigConst.SHOW_UNION_STUDY];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(Facade.getInstance().hasMediator("StudyChildMedia"))
         {
            (Facade.getInstance().retrieveMediator("StudyChildMedia") as StudyChildMedia).dispose();
         }
         facade.removeMediator("UnionStudyMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.unionStudyAssets);
      }
   }
}
