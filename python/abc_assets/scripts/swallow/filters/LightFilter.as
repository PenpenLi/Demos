package swallow.filters
{
   import starling.filters.FragmentFilter;
   import flash.display3D.Program3D;
   import flash.display3D.Context3D;
   import starling.textures.Texture;
   import starling.utils.getNextPowerOfTwo;
   
   public class LightFilter extends FragmentFilter
   {
       
      private var mShaderProgram:Program3D;
      
      private var mCenterX:Number = 0;
      
      private var mCenterY:Number = 0;
      
      private var mR:Number = 1;
      
      private var mG:Number = 1;
      
      private var mB:Number = 1;
      
      private var mA:Number = 1;
      
      private var mScopeX:Number = 2;
      
      private var mScopeY:Number = 2;
      
      public function LightFilter(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.mCenterX = param1;
         this.mCenterY = param2;
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
         var _loc1_:String = "tex ft1, v0, fs0 <2d,repeat,linear,mipnone>\nmov ft4,v0\nsub ft4,v0,fc1\nabs ft4,ft4\nmul ft4.x,ft4.x,fc1.z\nmul ft4.y,ft4.y,fc1.w\nmul ft4,ft4,ft4\nadd ft4.z,ft4.x,ft4.y\nsqt ft4.w,ft4.z\nmul ft4.w,ft4.w,fc1.z\ndiv ft5,ft1,ft4.wwww\nmul ft5,ft5,fc2\nmov oc, ft5";
         mShaderProgram = assembleAgal(_loc1_);
      }
      
      override protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         param2.setProgramConstantsFromVector("fragment",1,Vector.<Number>([mCenterX / getNextPowerOfTwo(param3.width),mCenterY / getNextPowerOfTwo(param3.height),mScopeX,mScopeY]));
         param2.setProgramConstantsFromVector("fragment",2,Vector.<Number>([r,g,b,a]));
         param2.setProgram(mShaderProgram);
      }
      
      override protected function deactivate(param1:int, param2:Context3D, param3:Texture) : void
      {
      }
      
      public function set centerX(param1:Number) : void
      {
         mCenterX = param1;
      }
      
      public function get centerX() : Number
      {
         return mCenterX;
      }
      
      public function set centerY(param1:Number) : void
      {
         mCenterY = param1;
      }
      
      public function get centerY() : Number
      {
         return mCenterY;
      }
      
      public function get r() : Number
      {
         return mR;
      }
      
      public function set r(param1:Number) : void
      {
         mR = param1;
      }
      
      public function get g() : Number
      {
         return mG;
      }
      
      public function set g(param1:Number) : void
      {
         mG = param1;
      }
      
      public function get b() : Number
      {
         return mB;
      }
      
      public function set b(param1:Number) : void
      {
         mB = param1;
      }
      
      public function get a() : Number
      {
         return mA;
      }
      
      public function set a(param1:Number) : void
      {
         mA = param1;
      }
      
      public function get scopeX() : Number
      {
         return mScopeX;
      }
      
      public function set scopeX(param1:Number) : void
      {
         mScopeX = param1;
      }
      
      public function get scopeY() : Number
      {
         return mScopeY;
      }
      
      public function set scopeY(param1:Number) : void
      {
         mScopeY = param1;
      }
   }
}
