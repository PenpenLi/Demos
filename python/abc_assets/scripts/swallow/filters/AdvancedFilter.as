package swallow.filters
{
   import starling.filters.FragmentFilter;
   import flash.display3D.Program3D;
   import flash.display3D.Context3D;
   import starling.textures.Texture;
   import starling.core.Starling;
   
   public class AdvancedFilter extends FragmentFilter
   {
       
      private var mShaderProgram:Program3D;
      
      private var maddR:Number = 0;
      
      private var maddG:Number = 0;
      
      private var maddB:Number = 0;
      
      private var maddA:Number = 0;
      
      public function AdvancedFilter(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super();
         this.maddG = param1;
         this.maddG = param1;
         this.maddB = param3;
         this.maddA = param4;
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
         var _loc1_:String = "tex ft0, v0,fs0 <2d,repeat,linear,mipnone>\nmul ft1,fc0,ft0.wwww\nadd ft0,ft0,ft1\nmov oc, ft0\n";
         mShaderProgram = assembleAgal(_loc1_);
      }
      
      override protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         Starling.context.setScissorRectangle(null);
         param2.setProgramConstantsFromVector("fragment",0,Vector.<Number>([maddR,maddG,maddB,maddA]));
         param2.setProgram(mShaderProgram);
      }
      
      override protected function deactivate(param1:int, param2:Context3D, param3:Texture) : void
      {
      }
      
      public function get addR() : Number
      {
         return maddR;
      }
      
      public function set addR(param1:Number) : void
      {
         maddR = param1;
      }
      
      public function get addG() : Number
      {
         return maddG;
      }
      
      public function set addG(param1:Number) : void
      {
         maddG = param1;
      }
      
      public function get addB() : Number
      {
         return maddB;
      }
      
      public function set addB(param1:Number) : void
      {
         maddB = param1;
      }
      
      public function get addA() : Number
      {
         return maddA;
      }
      
      public function set addA(param1:Number) : void
      {
         maddA = param1;
      }
   }
}
