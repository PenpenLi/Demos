package swallow.filters
{
   import starling.filters.FragmentFilter;
   import flash.display3D.Program3D;
   import flash.display3D.Context3D;
   import starling.textures.Texture;
   
   public class WaveFilter extends FragmentFilter
   {
       
      private var mShaderProgram:Program3D;
      
      private var _thresholdScope:Number = 0;
      
      private var _thresholdDensity:Number = 0;
      
      private var _direction:Number = 0;
      
      private var _frequency:Number = 0;
      
      public function WaveFilter(param1:Number = 250, param2:Number = 10, param3:Number = 20, param4:Number = 0.005)
      {
         super();
         this.direction = param1;
         this.frequency = param2;
         this.thresholdScope = param3;
         this.thresholdDensity = param4;
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
         var _loc1_:String = "mov ft2,v0\nmov ft0,fc1\ndiv ft1.x,ft0.x,ft0.y\nmul ft1.y,v0.x,ft0.z\nadd ft1.z,ft1.x,ft1.y\ncos ft1.w,ft1.z\nmul ft1.x,ft1.w,ft0.w\nadd ft2.x,ft2.x,ft1.x\ndiv ft4.x,ft0.x,ft0.y\nmul ft4.y,v0.y,ft0.z\nadd ft4.z,ft4.x,ft4.y\ncos ft4.w,ft4.z\nmul ft4.x,ft4.w,ft0.w\nadd ft2.y,ft2.y,ft4.x\nmov ft5,ft2\ntex ft5, ft5, fs0 <2d,repet,linear,nomip>\nmov oc,ft5";
         mShaderProgram = assembleAgal(_loc1_);
      }
      
      override protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         param2.setProgramConstantsFromVector("fragment",1,Vector.<Number>([_direction,_frequency,_thresholdScope,_thresholdDensity]));
         param2.setProgram(mShaderProgram);
      }
      
      override protected function deactivate(param1:int, param2:Context3D, param3:Texture) : void
      {
      }
      
      public function get thresholdScope() : Number
      {
         return _thresholdScope;
      }
      
      public function set thresholdScope(param1:Number) : void
      {
         _thresholdScope = param1;
      }
      
      public function get thresholdDensity() : Number
      {
         return _thresholdDensity;
      }
      
      public function set thresholdDensity(param1:Number) : void
      {
         _thresholdDensity = param1;
      }
      
      public function get direction() : Number
      {
         return _direction;
      }
      
      public function set direction(param1:Number) : void
      {
         _direction = param1;
      }
      
      public function get frequency() : Number
      {
         return _frequency;
      }
      
      public function set frequency(param1:Number) : void
      {
         _frequency = param1;
      }
   }
}
