package com.mvc.views.mediator.union.unionStudy
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.union.unionStudy.StudyChildUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.consts.ConfigConst;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import com.mvc.views.uis.union.unionStudy.StudyListUnitUI;
   import com.mvc.models.proxy.union.UnionPro;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.views.uis.union.unionStudy.MarkUpUI;
   
   public class StudyChildMedia extends Mediator
   {
      
      public static const NAME:String = "StudyChildMedia";
      
      public static var typePage:int;
       
      public var studyChild:StudyChildUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public function StudyChildMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("StudyChildMedia",param1);
         studyChild = param1 as StudyChildUI;
         studyChild.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(studyChild.btn_close === _loc2_)
         {
            if(studyChild.donateList.dataProvider)
            {
               studyChild.donateList.dataProvider.removeAll();
            }
            sendNotification(ConfigConst.SHOW_UNION_STUDY);
            remove();
            if(typePage == 3)
            {
               sendNotification("UPDATE_BAG_ELF");
            }
         }
      }
      
      private function remove() : void
      {
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if(ConfigConst.SHOW_STUDY_MARKUP === _loc2_)
         {
            show();
         }
      }
      
      private function show() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         if(studyChild.donateList.dataProvider)
         {
            studyChild.donateList.dataProvider.removeAll();
         }
         var _loc1_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < UnionPro.markUpVec.length)
         {
            _loc2_ = new StudyListUnitUI();
            _loc2_.myMarkUpVo = UnionPro.markUpVec[_loc4_];
            _loc1_.push({
               "icon":_loc2_,
               "label":""
            });
            displayVec.push(_loc2_);
            _loc4_++;
         }
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         studyChild.donateList.dataProvider = _loc3_;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.SHOW_STUDY_MARKUP];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            if(MarkUpUI.instance)
            {
               MarkUpUI.getInstance().remove();
            }
         }
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("StudyChildMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
