package lzm.starling.display
{
   import starling.display.Sprite;
   
   public class ContentListItem extends Sprite
   {
       
      private var _content:lzm.starling.display.ScrollContainer;
      
      var index:int;
      
      var otherOpenY:Number;
      
      var normalY:Number;
      
      public function ContentListItem()
      {
         super();
         _content = new lzm.starling.display.ScrollContainer();
      }
      
      public function get content() : lzm.starling.display.ScrollContainer
      {
         return _content;
      }
   }
}
