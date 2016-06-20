package feathers.core
{
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import flash.utils.Dictionary;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.ResizeEvent;
   
   public class DefaultPopUpManager implements IPopUpManager
   {
       
      protected var _popUps:Vector.<DisplayObject>;
      
      protected var _popUpToOverlay:Dictionary;
      
      protected var _popUpToFocusManager:Dictionary;
      
      protected var _centeredPopUps:Vector.<DisplayObject>;
      
      protected var _overlayFactory:Function;
      
      protected var _ignoreRemoval:Boolean = false;
      
      protected var _root:DisplayObjectContainer;
      
      public function DefaultPopUpManager(param1:DisplayObjectContainer = null)
      {
         _popUps = new Vector.<DisplayObject>(0);
         _popUpToOverlay = new Dictionary(true);
         _popUpToFocusManager = new Dictionary(true);
         _centeredPopUps = new Vector.<DisplayObject>(0);
         _overlayFactory = defaultOverlayFactory;
         super();
         this.root = param1;
      }
      
      public static function defaultOverlayFactory() : DisplayObject
      {
         var _loc1_:Quad = new Quad(100,100,0);
         _loc1_.alpha = 0;
         return _loc1_;
      }
      
      public function get overlayFactory() : Function
      {
         return this._overlayFactory;
      }
      
      public function set overlayFactory(param1:Function) : void
      {
         this._overlayFactory = param1;
      }
      
      public function get root() : DisplayObjectContainer
      {
         return this._root;
      }
      
      public function set root(param1:DisplayObjectContainer) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(this._root == param1)
         {
            return;
         }
         var _loc6_:int = this._popUps.length;
         var _loc4_:Boolean = this._ignoreRemoval;
         this._ignoreRemoval = true;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = this._popUps[_loc5_];
            _loc2_ = DisplayObject(_popUpToOverlay[_loc3_]);
            _loc3_.removeFromParent(false);
            if(_loc2_)
            {
               _loc2_.removeFromParent(false);
            }
            _loc5_++;
         }
         this._ignoreRemoval = _loc4_;
         this._root = param1;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = this._popUps[_loc5_];
            _loc2_ = DisplayObject(_popUpToOverlay[_loc3_]);
            if(_loc2_)
            {
               this._root.addChild(_loc2_);
            }
            this._root.addChild(_loc3_);
            _loc5_++;
         }
      }
      
      public function addPopUp(param1:DisplayObject, param2:Boolean = true, param3:Boolean = true, param4:Function = null) : DisplayObject
      {
         var _loc5_:* = null;
         if(param2)
         {
            if(param4 == null)
            {
               var param4:Function = this._overlayFactory;
            }
            if(param4 == null)
            {
               param4 = defaultOverlayFactory;
            }
            _loc5_ = param4();
            _loc5_.width = this._root.stage.stageWidth;
            _loc5_.height = this._root.stage.stageHeight;
            this._root.addChild(_loc5_);
            this._popUpToOverlay[param1] = _loc5_;
         }
         this._popUps.push(param1);
         this._root.addChild(param1);
         param1.addEventListener("removedFromStage",popUp_removedFromStageHandler);
         if(this._popUps.length == 1)
         {
            this._root.stage.addEventListener("resize",stage_resizeHandler);
         }
         if(FocusManager.isEnabled && param1 is DisplayObjectContainer)
         {
            this._popUpToFocusManager[param1] = new FocusManager(DisplayObjectContainer(param1));
         }
         if(param3)
         {
            if(param1 is IFeathersControl)
            {
               param1.addEventListener("resize",popUp_resizeHandler);
            }
            this._centeredPopUps.push(param1);
            this.centerPopUp(param1);
         }
         return param1;
      }
      
      public function removePopUp(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:int = this._popUps.indexOf(param1);
         if(_loc3_ < 0)
         {
            throw new ArgumentError("Display object is not a pop-up.");
         }
         param1.removeFromParent(param2);
         return param1;
      }
      
      public function isPopUp(param1:DisplayObject) : Boolean
      {
         return this._popUps.indexOf(param1) >= 0;
      }
      
      public function isTopLevelPopUp(param1:DisplayObject) : Boolean
      {
         var _loc5_:* = 0;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:int = this._popUps.length - 1;
         _loc5_ = _loc2_;
         while(_loc5_ >= 0)
         {
            _loc4_ = this._popUps[_loc5_];
            if(_loc4_ == param1)
            {
               return true;
            }
            _loc3_ = this._popUpToOverlay[_loc4_];
            if(_loc3_)
            {
               return false;
            }
            _loc5_--;
         }
         return false;
      }
      
      public function centerPopUp(param1:DisplayObject) : void
      {
         var _loc2_:Stage = this._root.stage;
         if(param1 is IValidating)
         {
            IValidating(param1).validate();
         }
         param1.x = (_loc2_.stageWidth - param1.width) / 2;
         param1.y = (_loc2_.stageHeight - param1.height) / 2;
      }
      
      protected function popUp_resizeHandler(param1:Event) : void
      {
         var _loc3_:DisplayObject = DisplayObject(param1.currentTarget);
         var _loc2_:int = this._centeredPopUps.indexOf(_loc3_);
         if(_loc2_ < 0)
         {
            return;
         }
         this.centerPopUp(_loc3_);
      }
      
      protected function popUp_removedFromStageHandler(param1:Event) : void
      {
         if(this._ignoreRemoval)
         {
            return;
         }
         var _loc5_:DisplayObject = DisplayObject(param1.currentTarget);
         _loc5_.removeEventListener("removedFromStage",popUp_removedFromStageHandler);
         var _loc3_:int = this._popUps.indexOf(_loc5_);
         this._popUps.splice(_loc3_,1);
         var _loc4_:DisplayObject = DisplayObject(this._popUpToOverlay[_loc5_]);
         if(_loc4_)
         {
            _loc4_.removeFromParent(true);
            delete _popUpToOverlay[_loc5_];
         }
         var _loc2_:IFocusManager = this._popUpToFocusManager[_loc5_];
         if(_loc2_)
         {
            delete this._popUpToFocusManager[_loc5_];
            FocusManager.removeFocusManager(_loc2_);
         }
         _loc3_ = this._centeredPopUps.indexOf(_loc5_);
         if(_loc3_ >= 0)
         {
            if(_loc5_ is IFeathersControl)
            {
               _loc5_.removeEventListener("resize",popUp_resizeHandler);
            }
            this._centeredPopUps.splice(_loc3_,1);
         }
         if(_popUps.length == 0)
         {
            this._root.stage.removeEventListener("resize",stage_resizeHandler);
         }
      }
      
      protected function stage_resizeHandler(param1:ResizeEvent) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:Stage = this._root.stage;
         var _loc6_:int = this._popUps.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = this._popUps[_loc5_];
            _loc2_ = DisplayObject(this._popUpToOverlay[_loc3_]);
            if(_loc2_)
            {
               _loc2_.width = _loc4_.stageWidth;
               _loc2_.height = _loc4_.stageHeight;
            }
            _loc5_++;
         }
         _loc6_ = this._centeredPopUps.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = this._centeredPopUps[_loc5_];
            centerPopUp(_loc3_);
            _loc5_++;
         }
      }
   }
}
