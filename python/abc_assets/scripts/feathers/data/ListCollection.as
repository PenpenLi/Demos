package feathers.data
{
   import starling.events.EventDispatcher;
   
   public class ListCollection extends EventDispatcher
   {
       
      protected var _data:Object;
      
      protected var _dataDescriptor:feathers.data.IListCollectionDataDescriptor;
      
      public function ListCollection(param1:Object = null)
      {
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
         if(!param1)
         {
            this.removeAll();
            return;
         }
         this._data = param1;
         if(this._data is Array && !(this._dataDescriptor is ArrayListCollectionDataDescriptor))
         {
            this.dataDescriptor = new ArrayListCollectionDataDescriptor();
         }
         else if(this._data is Vector.<Number> && !(this._dataDescriptor is VectorNumberListCollectionDataDescriptor))
         {
            this.dataDescriptor = new VectorNumberListCollectionDataDescriptor();
         }
         else if(this._data is Vector.<int> && !(this._dataDescriptor is VectorIntListCollectionDataDescriptor))
         {
            this.dataDescriptor = new VectorIntListCollectionDataDescriptor();
         }
         else if(this._data is Vector.<uint> && !(this._dataDescriptor is VectorUintListCollectionDataDescriptor))
         {
            this.dataDescriptor = new VectorUintListCollectionDataDescriptor();
         }
         else if(this._data is Vector.<*> && !(this._dataDescriptor is VectorListCollectionDataDescriptor))
         {
            this.dataDescriptor = new VectorListCollectionDataDescriptor();
         }
         else if(this._data is XMLList && !(this._dataDescriptor is XMLListListCollectionDataDescriptor))
         {
            this.dataDescriptor = new XMLListListCollectionDataDescriptor();
         }
         this.dispatchEventWith("reset");
         this.dispatchEventWith("change");
      }
      
      public function get dataDescriptor() : feathers.data.IListCollectionDataDescriptor
      {
         return this._dataDescriptor;
      }
      
      public function set dataDescriptor(param1:feathers.data.IListCollectionDataDescriptor) : void
      {
         if(this._dataDescriptor == param1)
         {
            return;
         }
         this._dataDescriptor = param1;
         this.dispatchEventWith("reset");
         this.dispatchEventWith("change");
      }
      
      public function get length() : int
      {
         return this._dataDescriptor.getLength(this._data);
      }
      
      public function updateItemAt(param1:int) : void
      {
         this.dispatchEventWith("updateItem",false,param1);
      }
      
      public function getItemAt(param1:int) : Object
      {
         return this._dataDescriptor.getItemAt(this._data,param1);
      }
      
      public function getItemIndex(param1:Object) : int
      {
         return this._dataDescriptor.getItemIndex(this._data,param1);
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         this._dataDescriptor.addItemAt(this._data,param1,param2);
         this.dispatchEventWith("change");
         this.dispatchEventWith("addItem",false,param2);
      }
      
      public function removeItemAt(param1:int) : Object
      {
         var _loc2_:Object = this._dataDescriptor.removeItemAt(this._data,param1);
         this.dispatchEventWith("change");
         this.dispatchEventWith("removeItem",false,param1);
         return _loc2_;
      }
      
      public function removeItem(param1:Object) : void
      {
         var _loc2_:int = this.getItemIndex(param1);
         if(_loc2_ >= 0)
         {
            this.removeItemAt(_loc2_);
         }
      }
      
      public function removeAll() : void
      {
         if(this.length == 0)
         {
            return;
         }
         this._dataDescriptor.removeAll(this._data);
         this.dispatchEventWith("change");
         this.dispatchEventWith("reset",false);
      }
      
      public function setItemAt(param1:Object, param2:int) : void
      {
         this._dataDescriptor.setItemAt(this._data,param1,param2);
         this.dispatchEventWith("change");
         this.dispatchEventWith("replaceItem",false,param2);
      }
      
      public function addItem(param1:Object) : void
      {
         this.addItemAt(param1,this.length);
      }
      
      public function push(param1:Object) : void
      {
         this.addItemAt(param1,this.length);
      }
      
      public function addAll(param1:ListCollection) : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc3_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.getItemAt(_loc4_);
            this.addItem(_loc2_);
            _loc4_++;
         }
      }
      
      public function addAllAt(param1:ListCollection, param2:int) : void
      {
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc5_:int = param1.length;
         var _loc3_:* = param2;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = param1.getItemAt(_loc6_);
            this.addItemAt(_loc4_,_loc3_);
            _loc3_++;
            _loc6_++;
         }
      }
      
      public function pop() : Object
      {
         return this.removeItemAt(this.length - 1);
      }
      
      public function unshift(param1:Object) : void
      {
         this.addItemAt(param1,0);
      }
      
      public function shift() : Object
      {
         return this.removeItemAt(0);
      }
      
      public function contains(param1:Object) : Boolean
      {
         return this.getItemIndex(param1) >= 0;
      }
   }
}
