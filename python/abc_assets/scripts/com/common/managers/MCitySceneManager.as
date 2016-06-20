package com.common.managers
{
   import starling.display.Image;
   import flash.display.Bitmap;
   import starling.textures.Texture;
   
   public class MCitySceneManager
   {
      
      private static var instance:com.common.managers.MCitySceneManager;
       
      private const sky:Class = sky_png$e9fa7076ea5485078d210ae50e37e4871783336207;
      
      public function MCitySceneManager()
      {
         super();
      }
      
      public static function getInstance() : com.common.managers.MCitySceneManager
      {
         return instance || new com.common.managers.MCitySceneManager();
      }
      
      public function getImg(param1:String) : Image
      {
         textureName = param1;
         var theClass:Class = this[textureName] as Class;
         var bitmap:Bitmap = new theClass() as Bitmap;
         var texture:Texture = Texture.fromBitmapData(bitmap.bitmapData,false);
         texture.root.onRestore = function():void
         {
            var _loc1_:Bitmap = new theClass() as Bitmap;
            texture.root.uploadBitmapData(_loc1_.bitmapData);
            _loc1_.bitmapData.dispose();
            _loc1_ = null;
         };
         var image:Image = new Image(texture);
         bitmap.bitmapData.dispose();
         bitmap = null;
         return image;
      }
   }
}
