package lzm.starling.display
{
   import starling.display.Image;
   import starling.textures.Texture;
   
   public class DistortImage extends Image
   {
       
      private var _w:Number;
      
      private var _h:Number;
      
      public function DistortImage(param1:Texture)
      {
         super(param1);
         _w = param1.width;
         _h = param1.height;
      }
      
      public function setVertextDataPostion(param1:int, param2:Number, param3:Number) : void
      {
         switch(param1)
         {
            case 0:
               mVertexData.setPosition(param1,param2,param3);
               break;
            case 1:
               mVertexData.setPosition(param1,_w + param2,param3);
               break;
            case 2:
               mVertexData.setPosition(param1,param2,_h + param3);
               break;
            case 3:
               mVertexData.setPosition(param1,_w + param2,_h + param3);
               break;
         }
         resetAllTexCoords();
         onVertexDataChanged();
      }
      
      protected function resetAllTexCoords() : void
      {
         mVertexData.setTexCoords(0,0,0);
         mVertexData.setTexCoords(1,1,0);
         mVertexData.setTexCoords(2,0,1);
         mVertexData.setTexCoords(3,1,1);
      }
   }
}
