package
{
   import flash.display.Stage;
   import starling.core.Starling;
   import flash.geom.Rectangle;
   import starling.utils.RectangleUtil;
   
   public class App
   {
      
      private static var _stage:Stage;
       
      public function App()
      {
         super();
      }
      
      public static function init(param1:Stage) : void
      {
         _stage = param1;
         param1.align = "TL";
         param1.scaleMode = "noScale";
         param1.color = 0;
         param1.frameRate = Config.GAME_FPS;
         Config.isDebug = new Error().getStackTrace().search(new RegExp(":[0-9]+]$","m")) > -1;
         LogUtil("是否debug" + Config.isDebug);
         Starling.handleLostContext = true;
         var _loc3_:Rectangle = rectangle1;
         if(_stage.fullScreenWidth / _stage.fullScreenHeight < 1.57)
         {
            _loc3_ = rectangle2;
         }
         else
         {
            _loc3_ = rectangle1;
         }
         var _loc2_:Starling = new Starling(Game,param1,_loc3_,null,"auto","auto");
         _loc2_.enableErrorChecking = false;
         _loc2_.showStats = false;
         _loc2_.start();
         Config.starling = _loc2_;
      }
      
      public static function get rectangle2() : Rectangle
      {
         var _loc2_:Number = 1136;
         var _loc3_:Number = 640;
         var _loc1_:Rectangle = RectangleUtil.fit(new Rectangle(0,0,_loc2_,_loc3_),new Rectangle(0,0,_stage.fullScreenWidth,_stage.fullScreenHeight),"showAll",false);
         return _loc1_;
      }
      
      public static function get rectangle1() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle(0,0,_stage.fullScreenWidth,_stage.fullScreenHeight);
         return _loc1_;
      }
   }
}
