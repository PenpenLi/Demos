package swallow.filters
{
   import starling.filters.FragmentFilter;
   import flash.display3D.Program3D;
   import flash.display3D.Context3D;
   import starling.textures.Texture;
   import starling.core.Starling;
   import starling.utils.getNextPowerOfTwo;
   
   public class MosaicFilter extends FragmentFilter
   {
       
      private var mShaderProgram:Program3D;
      
      private var _thresholdX:Number = 5;
      
      private var _thresholdY:Number = 5;
      
      public function MosaicFilter(param1:Number = 5.0, param2:Number = 5.0)
      {
         super();
         _thresholdX = param1;
         _thresholdY = param2;
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
         var _loc1_:String = "tex ft1, v0, fs0 <2d,linear,nomip>\nmul ft2.x,v0.x,fc0.x\nmul ft2.y,v0.y,fc0.y\ndiv ft2.z,ft2.x,fc0.z\ndiv ft2.w,ft2.y,fc0.w\nfrc,ft5.x,ft2.z\nfrc,ft5.y,ft2.w\nsub ft2.z,ft2.z,ft5.x\nsub ft2.w,ft2.w,ft5.y\nmul ft3.x,ft2.z,fc0.z\nmul ft3.y,ft2.w,fc0.w\ndiv ft4.x,ft3.x,fc0.x\ndiv ft4.y,ft3.y,fc0.y\nmov ft4.zw,ft1.zw\ntex ft4,ft4, fs0 <2d,linear,nomip>\nmov oc, ft4";
         mShaderProgram = assembleAgal(_loc1_);
      }
      
      override protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         Starling.context.setScissorRectangle(null);
         param2.setProgramConstantsFromVector("fragment",0,Vector.<Number>([getNextPowerOfTwo(param3.width),getNextPowerOfTwo(param3.height),thresholdX,thresholdY]));
         param2.setProgram(mShaderProgram);
      }
      
      override protected function deactivate(param1:int, param2:Context3D, param3:Texture) : void
      {
      }
      
      public function get thresholdY() : Number
      {
         return _thresholdY;
      }
      
      public function set thresholdY(param1:Number) : void
      {
         _thresholdY = param1;
      }
      
      public function get thresholdX() : Number
      {
         return _thresholdX;
      }
      
      public function set thresholdX(param1:Number) : void
      {
         _thresholdX = param1;
      }
   }
}
