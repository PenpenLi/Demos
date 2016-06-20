package swallow.filters
{
   import starling.filters.FragmentFilter;
   import flash.display3D.Program3D;
   import flash.display3D.Context3D;
   import starling.textures.Texture;
   
   public class HdrFilter extends FragmentFilter
   {
       
      private var mShaderProgram:Program3D;
      
      private var _threshold:Number = 0;
      
      private var _luminance:Number = 0;
      
      private var _saturation:Number = 0;
      
      private var _contrast:Number = 0;
      
      private var _tone:Number = 0;
      
      private var _scope:Number = 0;
      
      public function HdrFilter(param1:Number = 1.6, param2:Number = 0.3, param3:Number = 0.59, param4:Number = 0.11, param5:Number = 1, param6:Number = 4)
      {
         super();
         this.threshold = param1;
         this.luminance = param2;
         this.saturation = param3;
         this.contrast = param4;
         this.tone = param5;
         this.scope = param6;
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
         var _loc1_:String = "tex ft1, v0, fs0 <2d,repeat,linear,mipnone>\nmul ft2.x,ft1.x,fc1.x\nmul ft2.y,ft1.y,fc1.y\nmul ft2.z,ft1.z,fc1.z\nadd ft2.w,ft2.x,ft2.y\nadd ft2.w,ft2.w,ft2.z\nmov ft6,fc2\nmul ft4.x,ft6.x,ft6.y\nsub ft4.x,ft4.x,ft6.z\nsub ft4.y,ft6.w,ft4.x\nmul ft4.z,ft4.y,ft2.w\nadd ft4.z,ft4.z,ft4.x\nmul ft4.z,ft4.z,ft2.w\nmul ft1,ft1,ft4.zzzz\nmov oc, ft1";
         mShaderProgram = assembleAgal(_loc1_);
      }
      
      override protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         param2.setProgramConstantsFromVector("fragment",1,Vector.<Number>([_luminance,_saturation,_contrast,1]));
         param2.setProgramConstantsFromVector("fragment",2,Vector.<Number>([scope,_threshold,tone,1]));
         param2.setProgram(mShaderProgram);
      }
      
      override protected function deactivate(param1:int, param2:Context3D, param3:Texture) : void
      {
         param2.setBlendFactors("oneMinusSourceColor","oneMinusSourceAlpha");
      }
      
      public function get luminance() : Number
      {
         return _luminance;
      }
      
      public function set luminance(param1:Number) : void
      {
         _luminance = param1;
      }
      
      public function get saturation() : Number
      {
         return _saturation;
      }
      
      public function set saturation(param1:Number) : void
      {
         _saturation = param1;
      }
      
      public function get contrast() : Number
      {
         return _contrast;
      }
      
      public function set contrast(param1:Number) : void
      {
         _contrast = param1;
      }
      
      public function get tone() : Number
      {
         return _tone;
      }
      
      public function set tone(param1:Number) : void
      {
         _tone = param1;
      }
      
      public function get threshold() : Number
      {
         return _threshold;
      }
      
      public function set threshold(param1:Number) : void
      {
         _threshold = param1;
      }
      
      public function get scope() : Number
      {
         return _scope;
      }
      
      public function set scope(param1:Number) : void
      {
         _scope = param1;
      }
   }
}
