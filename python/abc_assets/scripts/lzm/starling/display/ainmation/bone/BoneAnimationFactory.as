package lzm.starling.display.ainmation.bone
{
   import starling.utils.AssetManager;
   import starling.display.Image;
   import starling.textures.Texture;
   
   public class BoneAnimationFactory
   {
       
      private var _imagesData:Object;
      
      private var _moviesData:Object;
      
      private var _assetManager:AssetManager;
      
      public function BoneAnimationFactory(param1:Object, param2:AssetManager)
      {
         super();
         if(param1)
         {
            _imagesData = param1["images"];
            _moviesData = param1["movies"];
         }
         _assetManager = param2;
      }
      
      public function get movies() : Object
      {
         return {
            "images":_imagesData,
            "movies":_moviesData
         };
      }
      
      public function set movies(param1:Object) : void
      {
         _imagesData = param1["images"];
         _moviesData = param1["movies"];
      }
      
      public function get assetManager() : AssetManager
      {
         return _assetManager;
      }
      
      public function set assetManager(param1:AssetManager) : void
      {
         _assetManager = param1;
      }
      
      public function createAnimation(param1:String, param2:int = 24) : BoneAnimation
      {
         var _loc6_:* = 0;
         var _loc5_:Object = _moviesData[param1];
         var _loc7_:Array = _loc5_["images"];
         var _loc4_:int = _loc7_.length;
         var _loc3_:Object = {};
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc3_[_loc7_[_loc6_]] = createImage(_loc7_[_loc6_]);
            _loc6_++;
         }
         return new BoneAnimation(_loc5_,_loc3_,param2);
      }
      
      public function createImage(param1:String) : Image
      {
         var _loc2_:Object = _imagesData[param1];
         var _loc3_:Texture = _assetManager.getTexture(param1);
         var _loc4_:Image = new Image(_loc3_);
         _loc4_.pivotX = -_loc2_.pivotX;
         _loc4_.pivotY = -_loc2_.pivotY;
         return _loc4_;
      }
      
      public function hasMovie(param1:String) : Boolean
      {
         return _moviesData[param1];
      }
      
      public function get movieNames() : Array
      {
         var _loc1_:Array = [];
         var _loc4_:* = 0;
         var _loc3_:* = _moviesData;
         for(var _loc2_ in _moviesData)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
   }
}
