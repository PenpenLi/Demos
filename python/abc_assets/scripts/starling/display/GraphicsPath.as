package starling.display
{
   public class GraphicsPath implements IGraphicsData
   {
       
      protected var mCommands:Vector.<int>;
      
      protected var mData:Vector.<Number>;
      
      protected var mWinding:String;
      
      public function GraphicsPath(param1:Vector.<int> = null, param2:Vector.<Number> = null, param3:String = "evenOdd")
      {
         super();
         mCommands = param1;
         mData = param2;
         mWinding = param3;
         if(mCommands == null)
         {
            mCommands = new Vector.<int>();
         }
         if(mData == null)
         {
            mData = new Vector.<Number>();
         }
      }
      
      public function get data() : Vector.<Number>
      {
         return mData;
      }
      
      public function get commands() : Vector.<int>
      {
         return mCommands;
      }
      
      public function get winding() : String
      {
         return mWinding;
      }
      
      public function set winding(param1:String) : void
      {
         mWinding = param1;
      }
      
      public function curveTo(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         mCommands.push(3);
         mData.push(param1,param2,param3,param4);
      }
      
      public function lineTo(param1:Number, param2:Number) : void
      {
         mCommands.push(2);
         mData.push(param1,param2);
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         mCommands.push(1);
         mData.push(param1,param2);
      }
      
      public function wideLineTo(param1:Number, param2:Number) : void
      {
         mCommands.push(5);
         mData.push(param1,param2);
      }
      
      public function wideMoveTo(param1:Number, param2:Number) : void
      {
         mCommands.push(4);
         mData.push(param1,param2);
      }
   }
}
