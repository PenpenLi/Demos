package lzm.starling.display
{
   import starling.display.Quad;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import lzm.starling.STLConstant;
   import flash.geom.Rectangle;
   import starling.events.Event;
   
   public class Alert
   {
      
      private static var background:Quad;
      
      private static var dialogs:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private static var root:DisplayObjectContainer;
      
      private static var stageWidth:Number = NaN;
      
      private static var stageHeight:Number = NaN;
       
      public function Alert()
      {
         super();
      }
      
      public static function init(param1:DisplayObjectContainer, param2:Number, param3:Number) : void
      {
         Alert.root = param1;
         Alert.stageWidth = param2;
         Alert.stageHeight = param3;
      }
      
      private static function get container() : DisplayObjectContainer
      {
         return Alert.root == null?STLConstant.currnetAppRoot:Alert.root;
      }
      
      private static function get width() : Number
      {
         return isNaN(Alert.stageWidth)?STLConstant.StageWidth:Alert.stageWidth;
      }
      
      private static function get height() : Number
      {
         return isNaN(Alert.stageHeight)?STLConstant.StageHeight:Alert.stageHeight;
      }
      
      public static function show(param1:DisplayObject) : void
      {
         container.addChild(param1);
      }
      
      public static function alert(param1:DisplayObject, param2:Boolean = true) : void
      {
         var _loc3_:* = null;
         if(dialogs.indexOf(param1) != -1)
         {
            return;
         }
         param1.addEventListener("addedToStage",dialogAddToStage);
         initBackGround();
         container.addChild(background);
         container.addChild(param1);
         if(param2)
         {
            _loc3_ = param1.getBounds(param1.parent);
            param1.x = (width - _loc3_.width) / 2;
            param1.y = (height - _loc3_.height) / 2;
         }
      }
      
      private static function dialogAddToStage(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         _loc2_.removeEventListener("addedToStage",dialogAddToStage);
         _loc2_.addEventListener("removedFromStage",dialogRemoveFromStage);
         dialogs.push(_loc2_);
      }
      
      private static function dialogRemoveFromStage(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         _loc2_.removeEventListener("removedFromStage",dialogRemoveFromStage);
         dialogs.pop();
         if(dialogs.length == 0)
         {
            background.removeFromParent();
         }
         else
         {
            _loc2_ = dialogs[dialogs.length - 1];
            try
            {
               container.swapChildren(background,_loc2_);
               return;
            }
            catch(error:Error)
            {
               return;
            }
         }
      }
      
      private static function initBackGround() : void
      {
         if(background)
         {
            return;
         }
         background = new Quad(width,height,0);
         background.alpha = 0.5;
      }
   }
}
