package com.common.util.loading
{
   import starling.display.Sprite;
   import starling.display.Image;
   import flash.geom.Rectangle;
   import starling.text.TextField;
   import flash.utils.Timer;
   import starling.utils.AssetManager;
   import starling.display.Quad;
   import flash.events.TimerEvent;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.common.events.EventCenter;
   import starling.events.Event;
   import starling.utils.deg2rad;
   import com.common.net.CheckNetStatus;
   
   public class GameLoading extends Sprite
   {
      
      public static var intance:com.common.util.loading.GameLoading;
       
      private var loadingImg:Image;
      
      public var pageLoadingBg:String;
      
      private var loadBg:Image;
      
      private var loadProgressSpr:Sprite;
      
      private var rect:Rectangle;
      
      private var promptText:TextField;
      
      private var rootClass:Game;
      
      private var timer:Timer;
      
      private var tipVec:Vector.<String>;
      
      private var progressWidth:Number;
      
      private var progressHeight:Number;
      
      private var ball:Image;
      
      private var callBack:Function;
      
      public var assets:AssetManager;
      
      private var bg:Quad;
      
      private var _isTellNetDisconnected:Boolean;
      
      private var _isLoadingAssets:Boolean;
      
      private var _isLogout:Boolean;
      
      public function GameLoading()
      {
         rect = new Rectangle();
         tipVec = Vector.<String>(["注意您的体力，体力消耗完了您就不能进行冒险和战斗了","精灵的属性会影响战斗的效果，例如火系的对战草系的有明显的伤害加成哦","精灵中心可以为您治疗精灵的伤势。","野生的精灵会袭击您，尽量带上足够的精灵进行冒险","部分特殊的地区有稀有的精灵等待着您捕抓哦~","某些地图需要特定的条件才能开启，例如学习一字斩技能之类的","受伤的精灵更容易被捕抓到哦~","利用特定的精灵球可以提高某类精灵捕抓的成功率哦","合理的使用技能可以方便您提前结束战斗","游戏总共有8个道馆，打败了道馆馆主之后才能到达下一个城市哦","您最多只能带6只精灵进行冒险/战斗，合理的选择您的精灵组建您的精灵战队吧","精灵扭蛋机可以让您抽取精灵，当您身上的空间不足时，精灵会自动存到您的家中哦~","在打倒所有的馆长之后，您将面对联盟四天王，努力打败他们成为冠军训练师吧","商店可以购买你需要的药品，在战斗中使用可以使精灵持续战斗","捕抓精灵之后，精灵图鉴将会记录精灵的信息,收服所有的精灵填满你的精灵图鉴吧","完成每日任务可以获得大量经验和金币哦","您可以在世界展示您的精灵，让其他人仰望您的精灵吧","每个精灵的属性都不相同，挑选属性最好的进行培养吧","在王者之路上以前的敌人将会再次出现，他们的目的就是阻止你登上冠军的宝座!","偷偷地告诉你，精灵不进化可以更早地学习技能哦！","你知道吗？当精灵处于睡眠和麻痹状态时，捕捉几率会大大提升哦！"]);
         super();
         initStage();
         bg = new Quad(1136,640,16777215);
         timer = new Timer(4000);
      }
      
      public static function getIntance() : com.common.util.loading.GameLoading
      {
         if(intance == null)
         {
            intance = new com.common.util.loading.GameLoading();
         }
         return intance;
      }
      
      protected function timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:int = tipVec.length;
         var _loc3_:String = tipVec[Math.floor(_loc2_ * Math.random())];
         promptText.text = _loc3_;
      }
      
      private function initStage() : void
      {
         assets = LoadOtherAssetsManager.getInstance().assets;
         rootClass = Config.starling.root as Game;
         loadBg = new Image(assets.getTexture("tipBg"));
         loadBg.x = 30;
         loadBg.y = 490;
         addChild(loadBg);
         var _loc1_:Image = new Image(assets.getTexture("progressBar"));
         progressWidth = _loc1_.width;
         progressHeight = _loc1_.height;
         loadProgressSpr = new Sprite();
         loadProgressSpr.x = 350;
         loadProgressSpr.y = 560;
         loadProgressSpr.addChild(_loc1_);
         loadProgressSpr.clipRect = rect;
         addChild(loadProgressSpr);
         ball = new Image(assets.getTexture("ball"));
         ball.pivotX = ball.width >> 1;
         ball.pivotY = ball.height >> 1;
         ball.y = 570;
         ball.x = 350;
         addChild(ball);
         promptText = new TextField(900,100,"","FZCuYuan-M03S",20,16777215);
         promptText.autoSize = "left";
         promptText.x = 100;
         promptText.y = loadProgressSpr.y - 80;
         this.addChild(promptText);
      }
      
      public function showLoading(param1:Function) : void
      {
         LoadSwfAssetsManager.isLoading = true;
         ball.y = 570;
         ball.x = 350;
         rect.width = 0;
         rect.height = 0;
         loadProgressSpr.clipRect = rect;
         LogUtil("rettct-------------------------------------: " + rect);
         addChildAt(bg,0);
         var _loc2_:Tween = new Tween(bg,1,"easeOut");
         Starling.juggler.add(_loc2_);
         _loc2_.animate("alpha",1,0);
         callBack = param1;
         rootClass.touchable = false;
         _isLoadingAssets = true;
         EventCenter.addEventListener("load_other_asset_complete",addPageLoadingAssets);
         pageLoadingBg = "loadingBg" + Math.ceil(11 * Math.random());
         LoadOtherAssetsManager.getInstance().addPageLoadingAssets(pageLoadingBg);
         if(promptText.text == "")
         {
            randomText();
         }
         timer.addEventListener("timer",timerHandler);
         timer.start();
         rootClass.addChild(this);
         ball.addEventListener("enterFrame",onBall_ENTER_FRAME);
      }
      
      private function addPageLoadingAssets() : void
      {
         EventCenter.removeEventListener("load_other_asset_complete",addPageLoadingAssets);
         addLoadingBg();
         if(callBack != null)
         {
            callBack();
         }
      }
      
      private function addLoadingBg() : void
      {
         Starling.juggler.removeTweens(bg);
         var t:Tween = new Tween(bg,1,"easeOut");
         Starling.juggler.add(t);
         t.animate("alpha",0,1);
         t.onComplete = function():void
         {
            bg.removeFromParent();
            bg.alpha = 1;
         };
         loadingImg = new Image(assets.getTexture(pageLoadingBg));
         addChildAt(loadingImg,0);
      }
      
      private function randomText() : void
      {
         var _loc1_:int = tipVec.length;
         var _loc2_:String = tipVec[Math.floor(_loc1_ * Math.random())];
         promptText.text = _loc2_;
      }
      
      public function updateProgress(param1:Number) : void
      {
         if(loadProgressSpr == null)
         {
            return;
         }
         if(param1)
         {
            rect.width = progressWidth * param1;
            rect.height = progressHeight;
            ball.x = rect.width + loadProgressSpr.x;
            loadProgressSpr.clipRect = rect;
         }
      }
      
      private function onBall_ENTER_FRAME(param1:Event) : void
      {
         ball.rotation = ball.rotation + deg2rad(3);
      }
      
      public function removeLoading() : void
      {
         LogUtil("移除loading");
         rootClass.touchable = true;
         if(this.parent == null)
         {
            return;
         }
         _isLoadingAssets = false;
         if(_isTellNetDisconnected)
         {
            CheckNetStatus.reConnect();
            _isTellNetDisconnected = false;
         }
         timer.stop();
         timer.removeEventListener("timer",timerHandler);
         ball.removeEventListener("enterFrame",onBall_ENTER_FRAME);
         removeFromParent();
         ball.y = 570;
         ball.x = 350;
         rect.width = 0;
         rect.height = 0;
         loadProgressSpr.clipRect = rect;
         LogUtil("rettct后-------------------------------------: " + rect);
         if(loadingImg)
         {
            loadingImg.texture.dispose();
            loadingImg.removeFromParent(true);
            loadingImg = null;
         }
         LoadOtherAssetsManager.getInstance().removeAsset([pageLoadingBg],false);
         callBack = null;
         if(_isLogout)
         {
            LogUtil("怎样处罚");
            _isLogout = false;
            CheckNetStatus.reLogin();
         }
      }
      
      public function set isTellNetDisconnect(param1:Boolean) : void
      {
         _isTellNetDisconnected = param1;
      }
      
      public function set isLogout(param1:Boolean) : void
      {
         _isLogout = param1;
      }
      
      public function get isLoadingAssets() : Boolean
      {
         return _isLoadingAssets;
      }
   }
}
