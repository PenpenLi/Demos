package starling.display.graphicsEx
{
   import starling.display.IGraphicsData;
   
   public class GraphicsNaturalSpline implements IGraphicsData
   {
       
      protected var mControlPoints:Array;
      
      protected var mClosed:Boolean;
      
      protected var mSteps:int;
      
      public function GraphicsNaturalSpline(param1:Array = null, param2:Boolean = false, param3:int = 4)
      {
         super();
         mControlPoints = param1;
         mClosed = param2;
         mSteps = param3;
         if(mControlPoints == null)
         {
            mControlPoints = [];
         }
      }
      
      public function get controlPoints() : Array
      {
         return mControlPoints;
      }
      
      public function get closed() : Boolean
      {
         return mClosed;
      }
      
      public function get steps() : int
      {
         return mSteps;
      }
   }
}
