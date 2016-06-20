package swallow.effect
{
   import starling.display.Image;
   import starling.display.DisplayObject;
   import starling.textures.RenderTexture;
   import flash.geom.Rectangle;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import flash.display3D.Context3D;
   import starling.errors.MissingContextError;
   import starling.display.Quad;
   
   public class EffectScene extends Image
   {
       
      private var childList:Vector.<DisplayObject>;
      
      private var renderTexture:RenderTexture;
      
      private var mMask:Rectangle;
      
      public function EffectScene(param1:int, param2:int, param3:Boolean = true, param4:Number = -1)
      {
         super(init(param1,param2,param3,param4));
         childList = new Vector.<DisplayObject>();
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         if(mMask == null)
         {
            super.render(param1,param2);
         }
         else
         {
            _loc3_ = Starling.context;
            if(_loc3_ == null)
            {
               throw new MissingContextError();
            }
            param1.finishQuadBatch();
            _loc3_.setScissorRectangle(mMask);
            super.render(param1,param2);
            param1.finishQuadBatch();
            _loc3_.setScissorRectangle(null);
         }
         _loc4_ = 0;
         while(_loc4_ < childList.length)
         {
            renderTexture.draw(childList[_loc4_]);
            _loc4_++;
         }
         Starling.context.setBlendFactors("zero","zero");
      }
      
      private function init(param1:int, param2:int, param3:Boolean = true, param4:Number = -1) : RenderTexture
      {
         var _loc5_:Quad = new Quad(1,1);
         renderTexture = new RenderTexture(param1,param2,param3,param4);
         renderTexture.draw(_loc5_);
         return renderTexture;
      }
      
      public function addChild(param1:DisplayObject) : void
      {
         if(childList.indexOf(param1) == -1)
         {
            childList.push(param1);
         }
      }
      
      public function removeChild(param1:DisplayObject) : void
      {
         var _loc2_:int = childList.indexOf(param1);
         if(_loc2_ != -1)
         {
            childList.splice(_loc2_,1);
         }
      }
      
      public function swapChildren(param1:DisplayObject, param2:DisplayObject, param3:int = 0) : void
      {
         var _loc4_:int = childList.indexOf(param1);
         var _loc5_:int = childList.indexOf(param2);
         swapChildrenAt(_loc4_,_loc5_);
      }
      
      public function swapChildrenAt(param1:int, param2:int, param3:int = 0) : void
      {
         var _loc5_:DisplayObject = childList[param3][param1];
         var _loc4_:DisplayObject = childList[param3][param2];
         childList[param1] = _loc4_;
         childList[param2] = _loc5_;
      }
      
      public function getChildIndex(param1:DisplayObject, param2:int = 0) : int
      {
         return childList.indexOf(param1);
      }
      
      public function numChildren(param1:int = 0) : int
      {
         return childList.length;
      }
      
      public function getChildAt(param1:int, param2:int) : DisplayObject
      {
         if(param1 < childList.length)
         {
            return childList[param1];
         }
         return null;
      }
      
      public function get mask() : Rectangle
      {
         return mMask;
      }
      
      public function set mask(param1:Rectangle) : void
      {
         mMask = param1;
      }
   }
}
