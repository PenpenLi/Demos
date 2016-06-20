package swallow.filters
{
   import starling.filters.FragmentFilter;
   import flash.display3D.Program3D;
   import starling.textures.Texture;
   import flash.display3D.Context3D;
   
   public class BumpMakerFilter extends FragmentFilter
   {
       
      private var mShaderProgram:Program3D;
      
      private var normalBitmap:Texture;
      
      private var highlightBitmap:Texture;
      
      private var materialBitmap:Texture;
      
      private var mNormalX:Number = 9;
      
      private var mNormalY:Number = 9;
      
      private var mLightValue:Number = 1;
      
      private var mAmbientLightValue:Number = 1;
      
      private var mLightX:Number = 0.05;
      
      private var mLightY:Number = 0.02;
      
      private var mLightContrast:Number = 0;
      
      private var mLightIteration:int = 2;
      
      private var mReflectLightX:Number = 10;
      
      private var mReflectLightY:Number = 1;
      
      private var mReflectLightValue:Number = 0.1;
      
      public function BumpMakerFilter(param1:Texture, param2:Texture, param3:Texture)
      {
         super();
         this.normalBitmap = param1;
         this.highlightBitmap = param2;
         this.materialBitmap = param3;
      }
      
      override public function dispose() : void
      {
         if(mShaderProgram)
         {
            mShaderProgram.dispose();
         }
         super.dispose();
      }
      
      override protected function createPrograms() : void
      {
         var _loc1_:String = "tex ft0, v0, fs1 <2d,repet,nearest,nomip>\ntex ft1, v0, fs0 <2d,repet,nearest,nomip>\ntex ft2, v0, fs2 <2d,repet,nearest,nomip>\ntex ft4, v0, fs3 <2d,repet,nearest,nomip>\nmul ft1,ft1,ft4\ndp3 ft3.x,ft0,fc1\nmul ft3.x,ft3.x,ft2.x\nmul ft5,ft1,ft3.x\nmul ft3.y,ft2.x,fc1.w\nadd ft5,ft5,ft3.y\ndp3 ft6,ft0,fc1\nmul ft6,ft6,fc2.w\nmul ft6,ft6,ft0\nsub ft6,ft6.xyz,fc1.xyz\ndp3 ft6,ft6,fc2\npow ft6,ft6,fc3.x\nmul ft6,ft6,fc3.y\nmul ft6,ft6,fc3.z\nadd ft1,ft5,ft6\nmov oc, ft1\n";
         mShaderProgram = assembleAgal(_loc1_);
      }
      
      override protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         param2.setScissorRectangle(null);
         param2.setProgramConstantsFromVector("fragment",1,Vector.<Number>([mNormalX,mNormalY,mLightValue,mAmbientLightValue]));
         param2.setProgramConstantsFromVector("fragment",2,Vector.<Number>([mLightX,mLightY,mLightContrast,mLightIteration]));
         param2.setProgramConstantsFromVector("fragment",3,Vector.<Number>([mReflectLightX,mReflectLightY,mReflectLightValue,1]));
         param2.setTextureAt(1,normalBitmap.base);
         param2.setTextureAt(2,highlightBitmap.base);
         param2.setTextureAt(3,materialBitmap.base);
         param2.setProgram(mShaderProgram);
      }
      
      override protected function deactivate(param1:int, param2:Context3D, param3:Texture) : void
      {
         param2.setTextureAt(1,null);
         param2.setTextureAt(2,null);
         param2.setTextureAt(3,null);
      }
      
      public function get normalX() : Number
      {
         return mNormalX;
      }
      
      public function set normalX(param1:Number) : void
      {
         mNormalX = param1;
      }
      
      public function get normalY() : Number
      {
         return mNormalY;
      }
      
      public function set normalY(param1:Number) : void
      {
         mNormalY = param1;
      }
      
      public function get lightValue() : Number
      {
         return mLightValue;
      }
      
      public function set lightValue(param1:Number) : void
      {
         mLightValue = param1;
      }
      
      public function get ambientLightValue() : Number
      {
         return mAmbientLightValue;
      }
      
      public function set ambientLightValue(param1:Number) : void
      {
         mAmbientLightValue = param1;
      }
      
      public function get lightX() : Number
      {
         return mLightX;
      }
      
      public function set lightX(param1:Number) : void
      {
         mLightX = param1;
      }
      
      public function get lightY() : Number
      {
         return mLightY;
      }
      
      public function set lightY(param1:Number) : void
      {
         mLightY = param1;
      }
      
      public function get lightContrast() : Number
      {
         return mLightContrast;
      }
      
      public function set lightContrast(param1:Number) : void
      {
         mLightContrast = param1;
      }
      
      public function get lightIteration() : int
      {
         return mLightIteration;
      }
      
      public function set lightIteration(param1:int) : void
      {
         mLightIteration = param1;
      }
      
      public function get reflectLightX() : Number
      {
         return mReflectLightX;
      }
      
      public function set reflectLightX(param1:Number) : void
      {
         mReflectLightX = param1;
      }
      
      public function get reflectLightY() : Number
      {
         return mReflectLightY;
      }
      
      public function set reflectLightY(param1:Number) : void
      {
         mReflectLightY = param1;
      }
      
      public function get reflectLightValue() : Number
      {
         return mReflectLightValue;
      }
      
      public function set reflectLightValue(param1:Number) : void
      {
         mReflectLightValue = param1;
      }
   }
}
