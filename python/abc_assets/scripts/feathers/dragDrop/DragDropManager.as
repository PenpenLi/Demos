package feathers.dragDrop
{
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.Touch;
   import starling.core.Starling;
   import feathers.core.PopUpManager;
   import feathers.events.DragDropEvent;
   import flash.errors.IllegalOperationError;
   import flash.events.KeyboardEvent;
   import starling.events.TouchEvent;
   import starling.display.Stage;
   
   public class DragDropManager
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      protected static var _touchPointID:int = -1;
      
      protected static var _dragSource:feathers.dragDrop.IDragSource;
      
      protected static var _dragData:feathers.dragDrop.DragData;
      
      protected static var dropTarget:feathers.dragDrop.IDropTarget;
      
      protected static var isAccepted:Boolean = false;
      
      protected static var avatar:DisplayObject;
      
      protected static var avatarOffsetX:Number;
      
      protected static var avatarOffsetY:Number;
      
      protected static var dropTargetLocalX:Number;
      
      protected static var dropTargetLocalY:Number;
      
      protected static var avatarOldTouchable:Boolean;
       
      public function DragDropManager()
      {
         super();
      }
      
      public static function get touchPointID() : int
      {
         return _touchPointID;
      }
      
      public static function get dragSource() : feathers.dragDrop.IDragSource
      {
         return _dragSource;
      }
      
      public static function get isDragging() : Boolean
      {
         return _dragData != null;
      }
      
      public static function get dragData() : feathers.dragDrop.DragData
      {
         return _dragData;
      }
      
      public static function startDrag(param1:feathers.dragDrop.IDragSource, param2:Touch, param3:feathers.dragDrop.DragData, param4:DisplayObject = null, param5:Number = 0, param6:Number = 0) : void
      {
         if(isDragging)
         {
            cancelDrag();
         }
         if(!param1)
         {
            throw new ArgumentError("Drag source cannot be null.");
         }
         if(!param3)
         {
            throw new ArgumentError("Drag data cannot be null.");
         }
         _dragSource = param1;
         _dragData = param3;
         _touchPointID = param2.id;
         avatar = param4;
         avatarOffsetX = param5;
         avatarOffsetY = param6;
         param2.getLocation(Starling.current.stage,HELPER_POINT);
         if(avatar)
         {
            avatarOldTouchable = avatar.touchable;
            avatar.touchable = false;
            avatar.x = HELPER_POINT.x + avatarOffsetX;
            avatar.y = HELPER_POINT.y + avatarOffsetY;
            PopUpManager.addPopUp(avatar,false,false);
         }
         Starling.current.stage.addEventListener("touch",stage_touchHandler);
         Starling.current.nativeStage.addEventListener("keyDown",nativeStage_keyDownHandler,false,0,true);
         _dragSource.dispatchEvent(new DragDropEvent("dragStart",param3,false));
         updateDropTarget(HELPER_POINT);
      }
      
      public static function acceptDrag(param1:feathers.dragDrop.IDropTarget) : void
      {
         if(dropTarget != param1)
         {
            throw new ArgumentError("Drop target cannot accept a drag at this time. Acceptance may only happen after the DragDropEvent.DRAG_ENTER event is dispatched and before the DragDropEvent.DRAG_EXIT event is dispatched.");
         }
         isAccepted = true;
      }
      
      public static function cancelDrag() : void
      {
         if(!isDragging)
         {
            return;
         }
         completeDrag(false);
      }
      
      protected static function completeDrag(param1:Boolean) : void
      {
         if(!isDragging)
         {
            throw new IllegalOperationError("Drag cannot be completed because none is currently active.");
         }
         if(dropTarget)
         {
            dropTarget.dispatchEvent(new DragDropEvent("dragExit",_dragData,false,dropTargetLocalX,dropTargetLocalY));
            dropTarget = null;
         }
         var _loc2_:feathers.dragDrop.IDragSource = _dragSource;
         var _loc3_:feathers.dragDrop.DragData = _dragData;
         cleanup();
         _loc2_.dispatchEvent(new DragDropEvent("dragComplete",_loc3_,param1));
      }
      
      protected static function cleanup() : void
      {
         if(avatar)
         {
            if(PopUpManager.isPopUp(avatar))
            {
               PopUpManager.removePopUp(avatar);
            }
            avatar.touchable = avatarOldTouchable;
            avatar = null;
         }
         Starling.current.stage.removeEventListener("touch",stage_touchHandler);
         Starling.current.nativeStage.removeEventListener("keyDown",nativeStage_keyDownHandler);
         _dragSource = null;
         _dragData = null;
      }
      
      protected static function updateDropTarget(param1:Point) : void
      {
         var _loc2_:DisplayObject = Starling.current.stage.hitTest(param1,true);
         while(_loc2_ && !(_loc2_ is feathers.dragDrop.IDropTarget))
         {
            _loc2_ = _loc2_.parent;
         }
         if(_loc2_)
         {
            _loc2_.globalToLocal(param1,param1);
         }
         if(_loc2_ != dropTarget)
         {
            if(dropTarget)
            {
               dropTarget.dispatchEvent(new DragDropEvent("dragExit",_dragData,false,dropTargetLocalX,dropTargetLocalY));
            }
            dropTarget = feathers.dragDrop.IDropTarget(_loc2_);
            isAccepted = false;
            if(dropTarget)
            {
               dropTargetLocalX = param1.x;
               dropTargetLocalY = param1.y;
               dropTarget.dispatchEvent(new DragDropEvent("dragEnter",_dragData,false,dropTargetLocalX,dropTargetLocalY));
            }
         }
         else if(dropTarget)
         {
            dropTargetLocalX = param1.x;
            dropTargetLocalY = param1.y;
            dropTarget.dispatchEvent(new DragDropEvent("dragMove",_dragData,false,dropTargetLocalX,dropTargetLocalY));
         }
      }
      
      protected static function nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 27 || param1.keyCode == 16777238)
         {
            param1.preventDefault();
            cancelDrag();
         }
      }
      
      protected static function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:* = false;
         var _loc4_:Stage = Starling.current.stage;
         var _loc2_:Touch = param1.getTouch(_loc4_,null,_touchPointID);
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.phase == "moved")
         {
            _loc2_.getLocation(_loc4_,HELPER_POINT);
            if(avatar)
            {
               avatar.x = HELPER_POINT.x + avatarOffsetX;
               avatar.y = HELPER_POINT.y + avatarOffsetY;
            }
            updateDropTarget(HELPER_POINT);
         }
         else if(_loc2_.phase == "ended")
         {
            _touchPointID = -1;
            _loc3_ = false;
            if(dropTarget && isAccepted)
            {
               dropTarget.dispatchEvent(new DragDropEvent("dragDrop",_dragData,true,dropTargetLocalX,dropTargetLocalY));
               _loc3_ = true;
            }
            dropTarget = null;
            completeDrag(_loc3_);
         }
      }
   }
}
