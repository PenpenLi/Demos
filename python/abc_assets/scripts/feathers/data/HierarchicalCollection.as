package feathers.data
{
   import starling.events.EventDispatcher;
   
   public class HierarchicalCollection extends EventDispatcher
   {
       
      protected var _data:Object;
      
      protected var _dataDescriptor:feathers.data.IHierarchicalCollectionDataDescriptor;
      
      public function HierarchicalCollection(param1:Object = null)
      {
         _dataDescriptor = new ArrayChildrenHierarchicalCollectionDataDescriptor();
         super();
         if(!param1)
         {
            var param1:Object = [];
         }
         this.data = param1;
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         this.dispatchEventWith("reset");
         this.dispatchEventWith("change");
      }
      
      public function get dataDescriptor() : feathers.data.IHierarchicalCollectionDataDescriptor
      {
         return this._dataDescriptor;
      }
      
      public function set dataDescriptor(param1:feathers.data.IHierarchicalCollectionDataDescriptor) : void
      {
         if(this._dataDescriptor == param1)
         {
            return;
         }
         this._dataDescriptor = param1;
         this.dispatchEventWith("reset");
         this.dispatchEventWith("change");
      }
      
      public function isBranch(param1:Object) : Boolean
      {
         return this._dataDescriptor.isBranch(param1);
      }
      
      public function getLength(... rest) : int
      {
         rest.unshift(this._data);
         return this._dataDescriptor.getLength.apply(null,rest);
      }
      
      public function updateItemAt(param1:int, ... rest) : void
      {
         rest.unshift(param1);
         this.dispatchEventWith("updateItem",false,rest);
      }
      
      public function getItemAt(param1:int, ... rest) : Object
      {
         rest.unshift(param1);
         rest.unshift(this._data);
         return this._dataDescriptor.getItemAt.apply(null,rest);
      }
      
      public function getItemLocation(param1:Object, param2:Vector.<int> = null) : Vector.<int>
      {
         return this._dataDescriptor.getItemLocation(this._data,param1,param2);
      }
      
      public function addItemAt(param1:Object, param2:int, ... rest) : void
      {
         rest.unshift(param2);
         rest.unshift(param1);
         rest.unshift(this._data);
         this._dataDescriptor.addItemAt.apply(null,rest);
         this.dispatchEventWith("change");
         rest.shift();
         rest.shift();
         this.dispatchEventWith("addItem",false,rest);
      }
      
      public function removeItemAt(param1:int, ... rest) : Object
      {
         rest.unshift(param1);
         rest.unshift(this._data);
         var _loc3_:Object = this._dataDescriptor.removeItemAt.apply(null,rest);
         this.dispatchEventWith("change");
         rest.shift();
         this.dispatchEventWith("removeItem",false,rest);
         return _loc3_;
      }
      
      public function removeItem(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:Vector.<int> = this.getItemLocation(param1);
         if(_loc3_)
         {
            _loc4_ = [];
            _loc2_ = _loc3_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc4_.push(_loc3_[_loc5_]);
               _loc5_++;
            }
            this.removeItemAt.apply(this,_loc4_);
         }
      }
      
      public function setItemAt(param1:Object, param2:int, ... rest) : void
      {
         rest.unshift(param2);
         rest.unshift(param1);
         rest.unshift(this._data);
         this._dataDescriptor.setItemAt.apply(null,rest);
         rest.shift();
         rest.shift();
         this.dispatchEventWith("replaceItem",false,rest);
         this.dispatchEventWith("change");
      }
   }
}
