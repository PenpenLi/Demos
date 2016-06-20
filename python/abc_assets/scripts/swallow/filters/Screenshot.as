package swallow.filters
{
   import starling.filters.FragmentFilter;
   import flash.display3D.Program3D;
   import flash.display.BitmapData;
   import starling.display.Quad;
   import starling.display.Sprite;
   import flash.display3D.Context3D;
   import starling.textures.Texture;
   import starling.core.Starling;
   
   public class Screenshot extends FragmentFilter
   {
       
      private var mShaderProgram:Program3D;
      
      private var canvas:BitmapData;
      
      private var canvasQuad:Quad;
      
      private var canvasW:Number;
      
      private var canvasH:Number;
      
      private var callBack:Function;
      
      private var scene:Sprite;
      
      public function Screenshot(param1:Sprite, param2:Number = 100, param3:Number = 100, param4:Function = null)
      {
         super();
         this.canvasW = param2;
         this.canvasH = param3;
         this.callBack = param4;
         this.scene = param1;
         canvasQuad = new Quad(1,1);
         canvasQuad.filter = this;
         param1.addChild(canvasQuad);
      }
      
      override public function dispose() : void
      {
         canvasQuad.filter = null;
         scene.removeChild(canvasQuad);
         if(mShaderProgram)
         {
            mShaderProgram.dispose();
         }
         super.dispose();
      }
      
      override protected function createPrograms() : void
      {
         var _loc1_:String = "tex ft0, v0, fs0 <2d,repeat,linear,mipnone>\nmov oc, ft0";
         mShaderProgram = assembleAgal(_loc1_);
      }
      
      override protected function activate(param1:int, param2:Context3D, param3:Texture) : void
      {
         param2.setProgram(mShaderProgram);
      }
      
      override protected function deactivate(param1:int, param2:Context3D, param3:Texture) : void
      {
         if(canvas == null)
         {
            canvas = new BitmapData(canvasW,canvasH,true,4.294967295E9);
         }
         Starling.context.drawToBitmapData(canvas);
         if(callBack != null)
         {
            callBack(canvas);
         }
      }
   }
}
