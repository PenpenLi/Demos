package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.data.ListCollection;
   import feathers.controls.popups.IPopUpContentManager;
   import feathers.core.PropertyProxy;
   import feathers.system.DeviceCapabilities;
   import starling.core.Starling;
   import feathers.controls.popups.CalloutPopUpContentManager;
   import feathers.controls.popups.VerticalCenteredPopUpContentManager;
   import starling.events.Event;
   import feathers.controls.renderers.IListItemRenderer;
   
   public class PickerList extends FeathersControl
   {
      
      public static const DEFAULT_CHILD_NAME_BUTTON:String = "feathers-picker-list-button";
      
      public static const DEFAULT_CHILD_NAME_LIST:String = "feathers-picker-list-list";
      
      protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";
      
      protected static const INVALIDATION_FLAG_LIST_FACTORY:String = "listFactory";
       
      protected var buttonName:String = "feathers-picker-list-button";
      
      protected var listName:String = "feathers-picker-list-list";
      
      protected var button:feathers.controls.Button;
      
      protected var list:feathers.controls.List;
      
      protected var _dataProvider:ListCollection;
      
      protected var _ignoreSelectionChanges:Boolean = false;
      
      protected var _selectedIndex:int = -1;
      
      protected var _prompt:String;
      
      protected var _labelField:String = "label";
      
      protected var _labelFunction:Function;
      
      protected var _popUpContentManager:IPopUpContentManager;
      
      protected var _typicalItemWidth:Number = NaN;
      
      protected var _typicalItemHeight:Number = NaN;
      
      protected var _typicalItem:Object = null;
      
      protected var _buttonFactory:Function;
      
      protected var _customButtonName:String;
      
      protected var _buttonProperties:PropertyProxy;
      
      protected var _listFactory:Function;
      
      protected var _customListName:String;
      
      protected var _listProperties:PropertyProxy;
      
      protected var _isOpenListPending:Boolean = false;
      
      protected var _isCloseListPending:Boolean = false;
      
      public function PickerList()
      {
         super();
      }
      
      protected static function defaultButtonFactory() : feathers.controls.Button
      {
         return new feathers.controls.Button();
      }
      
      protected static function defaultListFactory() : feathers.controls.List
      {
         return new feathers.controls.List();
      }
      
      public function get dataProvider() : ListCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:ListCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         var _loc3_:int = this.selectedIndex;
         var _loc2_:Object = this.selectedItem;
         this._dataProvider = param1;
         if(!this._dataProvider || this._dataProvider.length == 0)
         {
            this.selectedIndex = -1;
         }
         else
         {
            this.selectedIndex = 0;
         }
         if(this.selectedIndex == _loc3_ && this.selectedItem != _loc2_)
         {
            this.dispatchEventWith("change");
         }
         this.invalidate("data");
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
         this.invalidate("selected");
         this.dispatchEventWith("change");
      }
      
      public function get selectedItem() : Object
      {
         if(!this._dataProvider || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length)
         {
            return null;
         }
         return this._dataProvider.getItemAt(this._selectedIndex);
      }
      
      public function set selectedItem(param1:Object) : void
      {
         if(!this._dataProvider)
         {
            this.selectedIndex = -1;
            return;
         }
         this.selectedIndex = this._dataProvider.getItemIndex(param1);
      }
      
      public function get prompt() : String
      {
         return this._prompt;
      }
      
      public function set prompt(param1:String) : void
      {
         if(this._prompt == param1)
         {
            return;
         }
         this._prompt = param1;
         this.invalidate("selected");
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(param1:String) : void
      {
         if(this._labelField == param1)
         {
            return;
         }
         this._labelField = param1;
         this.invalidate("data");
      }
      
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         this._labelFunction = param1;
         this.invalidate("data");
      }
      
      public function get popUpContentManager() : IPopUpContentManager
      {
         return this._popUpContentManager;
      }
      
      public function set popUpContentManager(param1:IPopUpContentManager) : void
      {
         if(this._popUpContentManager == param1)
         {
            return;
         }
         this._popUpContentManager = param1;
         this.invalidate("styles");
      }
      
      public function get typicalItem() : Object
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(param1:Object) : void
      {
         if(this._typicalItem == param1)
         {
            return;
         }
         this._typicalItem = param1;
         this.invalidate("styles");
      }
      
      public function get buttonFactory() : Function
      {
         return this._buttonFactory;
      }
      
      public function set buttonFactory(param1:Function) : void
      {
         if(this._buttonFactory == param1)
         {
            return;
         }
         this._buttonFactory = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get customButtonName() : String
      {
         return this._customButtonName;
      }
      
      public function set customButtonName(param1:String) : void
      {
         if(this._customButtonName == param1)
         {
            return;
         }
         this._customButtonName = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get buttonProperties() : Object
      {
         if(!this._buttonProperties)
         {
            this._buttonProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._buttonProperties;
      }
      
      public function set buttonProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._buttonProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            var param1:Object = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc3_ = new PropertyProxy();
            var _loc5_:* = 0;
            var _loc4_:* = param1;
            for(var _loc2_ in param1)
            {
               _loc3_[_loc2_] = param1[_loc2_];
            }
            param1 = _loc3_;
         }
         if(this._buttonProperties)
         {
            this._buttonProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._buttonProperties = PropertyProxy(param1);
         if(this._buttonProperties)
         {
            this._buttonProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get listFactory() : Function
      {
         return this._listFactory;
      }
      
      public function set listFactory(param1:Function) : void
      {
         if(this._listFactory == param1)
         {
            return;
         }
         this._listFactory = param1;
         this.invalidate("listFactory");
      }
      
      public function get customListName() : String
      {
         return this._customListName;
      }
      
      public function set customListName(param1:String) : void
      {
         if(this._customListName == param1)
         {
            return;
         }
         this._customListName = param1;
         this.invalidate("listFactory");
      }
      
      public function get listProperties() : Object
      {
         if(!this._listProperties)
         {
            this._listProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._listProperties;
      }
      
      public function set listProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._listProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            var param1:Object = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc3_ = new PropertyProxy();
            var _loc5_:* = 0;
            var _loc4_:* = param1;
            for(var _loc2_ in param1)
            {
               _loc3_[_loc2_] = param1[_loc2_];
            }
            param1 = _loc3_;
         }
         if(this._listProperties)
         {
            this._listProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._listProperties = PropertyProxy(param1);
         if(this._listProperties)
         {
            this._listProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function itemToLabel(param1:Object) : String
      {
         var _loc2_:* = null;
         if(this._labelFunction != null)
         {
            _loc2_ = this._labelFunction(param1);
            if(_loc2_ is String)
            {
               return _loc2_ as String;
            }
            return _loc2_.toString();
         }
         if(this._labelField != null && param1 && param1.hasOwnProperty(this._labelField))
         {
            _loc2_ = param1[this._labelField];
            if(_loc2_ is String)
            {
               return _loc2_ as String;
            }
            return _loc2_.toString();
         }
         if(param1 is String)
         {
            return param1 as String;
         }
         if(param1)
         {
            return param1.toString();
         }
         return "";
      }
      
      public function openList() : void
      {
         this._isCloseListPending = false;
         if(this._popUpContentManager.isOpen)
         {
            return;
         }
         if(!this._isValidating && this.isInvalid())
         {
            this._isOpenListPending = true;
            return;
         }
         this._isOpenListPending = false;
         this._popUpContentManager.open(this.list,this);
         this.list.scrollToDisplayIndex(this._selectedIndex);
         this.list.validate();
      }
      
      public function closeList() : void
      {
         this._isOpenListPending = false;
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(!this._isValidating && this.isInvalid())
         {
            this._isCloseListPending = true;
            return;
         }
         this._isCloseListPending = false;
         this.list.validate();
         this._popUpContentManager.close();
      }
      
      override public function dispose() : void
      {
         if(this.list)
         {
            this.closeList();
            this.list.dispose();
            this.list = null;
         }
         if(this._popUpContentManager)
         {
            this._popUpContentManager.dispose();
            this._popUpContentManager = null;
         }
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         if(!this._popUpContentManager)
         {
            if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
            {
               this.popUpContentManager = new CalloutPopUpContentManager();
            }
            else
            {
               this.popUpContentManager = new VerticalCenteredPopUpContentManager();
            }
         }
      }
      
      override protected function draw() : void
      {
         var _loc8_:* = false;
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc7_:Boolean = this.isInvalid("styles");
         var _loc5_:Boolean = this.isInvalid("state");
         var _loc1_:Boolean = this.isInvalid("selected");
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc6_:Boolean = this.isInvalid("buttonFactory");
         var _loc4_:Boolean = this.isInvalid("listFactory");
         if(_loc6_)
         {
            this.createButton();
         }
         if(_loc4_)
         {
            this.createList();
         }
         if(_loc6_ || _loc7_ || _loc1_)
         {
            if(isNaN(this.explicitWidth))
            {
               this.button.width = NaN;
            }
            if(isNaN(this.explicitHeight))
            {
               this.button.height = NaN;
            }
         }
         if(_loc6_ || _loc7_)
         {
            this._typicalItemWidth = NaN;
            this._typicalItemHeight = NaN;
            this.refreshButtonProperties();
         }
         if(_loc4_ || _loc7_)
         {
            this.refreshListProperties();
         }
         if(_loc4_ || _loc3_)
         {
            _loc8_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.list.dataProvider = this._dataProvider;
            this._ignoreSelectionChanges = _loc8_;
         }
         if(_loc6_ || _loc4_ || _loc5_)
         {
            this.button.isEnabled = this._isEnabled;
            this.list.isEnabled = this._isEnabled;
         }
         if(_loc6_ || _loc3_ || _loc1_)
         {
            this.refreshButtonLabel();
         }
         if(_loc4_ || _loc3_ || _loc1_)
         {
            _loc8_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.list.selectedIndex = this._selectedIndex;
            this._ignoreSelectionChanges = _loc8_;
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         if(_loc6_ || _loc2_ || _loc1_)
         {
            this.layout();
         }
         this.handlePendingActions();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc2_:Boolean = isNaN(this.explicitWidth);
         var _loc4_:Boolean = isNaN(this.explicitHeight);
         if(!_loc2_ && !_loc4_)
         {
            return false;
         }
         this.button.width = NaN;
         this.button.height = NaN;
         if(this._typicalItem)
         {
            if(isNaN(this._typicalItemWidth) || isNaN(this._typicalItemHeight))
            {
               this.button.label = this.itemToLabel(this._typicalItem);
               this.button.validate();
               this._typicalItemWidth = this.button.width;
               this._typicalItemHeight = this.button.height;
               this.refreshButtonLabel();
            }
         }
         else
         {
            this.button.validate();
            this._typicalItemWidth = this.button.width;
            this._typicalItemHeight = this.button.height;
         }
         var _loc3_:Number = this.explicitWidth;
         var _loc1_:Number = this.explicitHeight;
         if(_loc2_)
         {
            _loc3_ = this._typicalItemWidth;
         }
         if(_loc4_)
         {
            _loc1_ = this._typicalItemHeight;
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function createButton() : void
      {
         if(this.button)
         {
            this.button.removeFromParent(true);
            this.button = null;
         }
         var _loc1_:Function = this._buttonFactory != null?this._buttonFactory:defaultButtonFactory;
         var _loc2_:String = this._customButtonName != null?this._customButtonName:this.buttonName;
         this.button = feathers.controls.Button(_loc1_());
         this.button.nameList.add(_loc2_);
         this.button.addEventListener("triggered",button_triggeredHandler);
         this.addChild(this.button);
      }
      
      protected function createList() : void
      {
         if(this.list)
         {
            this.list.removeFromParent(false);
            this.list.dispose();
            this.list = null;
         }
         var _loc2_:Function = this._listFactory != null?this._listFactory:defaultListFactory;
         var _loc1_:String = this._customListName != null?this._customListName:this.listName;
         this.list = feathers.controls.List(_loc2_());
         this.list.nameList.add(_loc1_);
         this.list.addEventListener("change",list_changeHandler);
         this.list.addEventListener("rendererAdd",list_rendererAddHandler);
         this.list.addEventListener("rendererRemove",list_rendererRemoveHandler);
      }
      
      protected function refreshButtonLabel() : void
      {
         if(this._selectedIndex >= 0)
         {
            this.button.label = this.itemToLabel(this.selectedItem);
         }
         else
         {
            this.button.label = this._prompt;
         }
      }
      
      protected function refreshButtonProperties() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = this._buttonProperties;
         for(var _loc1_ in this._buttonProperties)
         {
            if(this.button.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._buttonProperties[_loc1_];
               this.button[_loc1_] = _loc2_;
            }
         }
      }
      
      protected function refreshListProperties() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = this._listProperties;
         for(var _loc1_ in this._listProperties)
         {
            if(this.list.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._listProperties[_loc1_];
               this.list[_loc1_] = _loc2_;
            }
         }
      }
      
      protected function layout() : void
      {
         this.button.width = this.actualWidth;
         this.button.height = this.actualHeight;
         this.button.validate();
      }
      
      protected function handlePendingActions() : void
      {
         if(this._isOpenListPending)
         {
            this.openList();
         }
         if(this._isCloseListPending)
         {
            this.closeList();
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      protected function button_triggeredHandler(param1:Event) : void
      {
         if(this._popUpContentManager.isOpen)
         {
            this.closeList();
            return;
         }
         this.openList();
      }
      
      protected function list_changeHandler(param1:Event) : void
      {
         if(this._ignoreSelectionChanges)
         {
            return;
         }
         this.selectedIndex = this.list.selectedIndex;
      }
      
      protected function list_rendererAddHandler(param1:Event, param2:IListItemRenderer) : void
      {
         param2.addEventListener("triggered",renderer_triggeredHandler);
      }
      
      protected function list_rendererRemoveHandler(param1:Event, param2:IListItemRenderer) : void
      {
         param2.removeEventListener("triggered",renderer_triggeredHandler);
      }
      
      protected function renderer_triggeredHandler(param1:Event) : void
      {
         if(!this._isEnabled)
         {
            return;
         }
         this.closeList();
      }
   }
}
