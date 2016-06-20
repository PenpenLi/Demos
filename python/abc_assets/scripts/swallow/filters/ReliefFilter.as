package swallow.filters
{
   import starling.filters.FragmentFilter;
   import starling.textures.Texture;
   import flash.display3D.Program3D;
   import flash.display3D.Context3D;
   import starling.utils.getNextPowerOfTwo;
   
   public class ReliefFilter extends FragmentFilter
   {
       
      private var setting:Texture;
      
      private var mShaderProgram:Program3D;
      
      private var _thresholdX:Number = 5;
      
      private var _thresholdY:Number = 5;
      
      private var _r:Number = 1;
      
      private var _g:Number = 1;
      
      private var _b:Number = 1;
      
      private var _a:Number = 1;
      
      public function ReliefFilter(param1:Texture, param2:Number = 5.0, param3:Number = 5.0)
      {
         super();
         this.setting = param1;
         _thresholdX = param2;
         _thresholdY = param3;
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
         var _loc1_:String = "mov ft0,v0\nsub ft0.x,v0.x,fc1.x\nsub ft0.y,v0.y,fc1.y\ntex ft1, v0, fs0 <2d,linear,repeat,nomip>\ntex ft2, ft0, fs0 <2d,linear,repeat,nomip>\nsub ft3,ft1,ft2\nmul ft4.x,ft3.x,fc4.y\nmul ft4.y,ft3.y,fc4.z\nmul ft4.z,ft3.z,fc4.z\nmul ft4.w,ft3.w,fc4.w\nadd ft5.x,ft4.x,ft4.y\nadd ft5.x,ft5.x,ft4.z\nmov ft6,ft4\nmov ft6.x,ft5.x\nmov ft6.y,ft5.x\nmov ft6.z,ft5.x\nadd ft6,ft6,fc2\ntex ft0, ft0, fs1 <2d,linear,repeat,nomip>\nmul ft6,ft6,ft0\nmul ft6,ft6,fc3\nmov oc, ft6";
         mShaderProgram = assembleAgal(_loc1_);
      }
      
      override protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         param2.setProgramConstantsFromVector("fragment",1,Vector.<Number>([_thresholdX / getNextPowerOfTwo(param3.width),_thresholdY / getNextPowerOfTwo(param3.height),1,1]));
         param2.setProgramConstantsFromVector("fragment",2,Vector.<Number>([0.5,0.5,0.5,1]));
         param2.setProgramConstantsFromVector("fragment",3,Vector.<Number>([_r,_g,_b,_a]));
         param2.setProgramConstantsFromVector("fragment",4,Vector.<Number>([0.3,0.59,0.11,0]));
         param2.setTextureAt(1,setting.base);
         param2.setProgram(mShaderProgram);
      }
      
      override protected function deactivate(param1:int, param2:Context3D, param3:Texture) : void
      {
         param2.setTextureAt(1,null);
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
      
      public function get r() : Number
      {
         return _r;
      }
      
      public function set r(param1:Number) : void
      {
         _r = param1;
      }
      
      public function get g() : Number
      {
         return _g;
      }
      
      public function set g(param1:Number) : void
      {
         _g = param1;
      }
      
      public function get b() : Number
      {
         return _b;
      }
      
      public function set b(param1:Number) : void
      {
         _b = param1;
      }
      
      public function get a() : Number
      {
         return _a;
      }
      
      public function set a(param1:Number) : void
      {
         _a = param1;
      }
   }
}
