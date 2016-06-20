package swallow.filters
{
   import starling.filters.FragmentFilter;
   import flash.display3D.Program3D;
   import starling.textures.Texture;
   import flash.display3D.Context3D;
   
   public class MaskFilter extends FragmentFilter
   {
       
      private var mShaderProgram:Program3D;
      
      private var mCenterX:Number = 0;
      
      private var mCenterY:Number = 0;
      
      private var shade:Texture;
      
      private var scaleX:Number = 0;
      
      private var scaleY:Number = 0;
      
      public function MaskFilter(param1:Texture, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.shade = param1;
         this.mCenterX = param2;
         this.mCenterY = param3;
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
         var _loc1_:String = "mov ft0,v0\nadd ft0,ft0,fc0.xy\nmul ft0,ft0,fc0.zw\ntex ft1, v0, fs0 <2d,repet,nearest,linear,mipnone>\ntex ft2, ft0, fs1 <2d,repet,nearest,linear,mipnone>\nmul ft2,ft1,ft2.wwww\nmov oc,ft2";
         mShaderProgram = assembleAgal(_loc1_);
      }
      
      override protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         scaleX = param3.width + param3.height;
         scaleY = shade.width + shade.height;
         param2.setProgramConstantsFromVector("fragment",0,Vector.<Number>([-mCenterX / param3.width,-mCenterY / param3.height,scaleX / scaleY,scaleX / scaleY]));
         param2.setTextureAt(1,shade.base);
         param2.setProgram(mShaderProgram);
      }
      
      override protected function deactivate(param1:int, param2:Context3D, param3:Texture) : void
      {
         param2.setTextureAt(1,null);
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
   }
}
