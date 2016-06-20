package lzm.starling.display
{
   import lzm.starling.entityComponent.EntityWorld;
   import starling.textures.Texture;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.display.DisplayObjectContainer;
   import flash.utils.setTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getDefinitionByName;
   import starling.display.DisplayObject;
   import flash.system.System;
   
   public class BaseScene extends EntityWorld
   {
      
      public static const EVENT_BULIDERCOMPLETE:String = "EVENT_BULIDERCOMPLETE";
      
      public static var currentScene:lzm.starling.display.BaseScene;
      
      private static var _backBtnTexture:Texture;
      
      private static var _sceneLoading:lzm.starling.display.BaseSceneLoading;
      
      private static var sceneClassNameQueue:Array = [];
      
      private static var sceneParamsQueue:Array = [];
      
      private static var sceneNumberQueue:int = 0;
       
      protected var _backButton:lzm.starling.display.Button;
      
      private var _sceneNumber:int = 0;
      
      private var _addToStageType:int;
      
      private var _parentScene:lzm.starling.display.BaseScene;
      
      private var _childScene:lzm.starling.display.BaseScene;
      
      protected var _params:Array;
      
      public function BaseScene(param1:Array)
      {
         super();
         _params = param1;
         if(currentScene == null)
         {
            currentScene = this;
         }
      }
      
      public static function initBaseScene(param1:Texture, param2:lzm.starling.display.BaseSceneLoading) : void
      {
         _backBtnTexture = param1;
         _sceneLoading = param2;
      }
      
      protected function addBackFunction() : void
      {
         if(_backButton == null)
         {
            if(_backBtnTexture)
            {
               _backButton = new lzm.starling.display.Button(new Image(_backBtnTexture));
            }
            else
            {
               _backButton = new lzm.starling.display.Button(new Quad(40,40,0),"<-");
            }
            _backButton.x = 14;
            _backButton.y = 7.5;
            addChild(_backButton);
         }
         _backButton.removeEventListeners("triggered");
         if(_addToStageType == 0)
         {
            _backButton.addEventListener("triggered",backFunction);
         }
         else if(_addToStageType == 1)
         {
            _backButton.addEventListener("triggered",backToParentScene);
         }
      }
      
      protected function backFunction(param1:Event) : void
      {
         sceneNumberQueue = sceneNumberQueue - 1;
         var _loc2_:Class = sceneClassNameQueue.pop();
         replaceClass(_loc2_,sceneParamsQueue.pop() as Array);
      }
      
      protected function backToParentScene(param1:Event) : void
      {
         _parentScene.popScene();
      }
      
      public function pushScene(param1:lzm.starling.display.BaseScene, param2:Boolean = true) : void
      {
         if(_childScene)
         {
            return;
         }
         param1._parentScene = this;
         _childScene = param1;
         _childScene._addToStageType = 1;
         _childScene.addBackFunction();
         parent.addChild(_childScene);
         if(param2)
         {
            this.visible = false;
         }
      }
      
      public function popScene(param1:Boolean = true) : void
      {
         if(_childScene == null)
         {
            return;
         }
         _childScene._parentScene = null;
         _childScene.removeFromParent(param1);
         this._childScene = null;
         this.visible = true;
      }
      
      public function replaceClass(param1:Class, param2:Array, param3:Function = null) : void
      {
         sceneClass = param1;
         params = param2;
         callBack = param3;
         this.touchable = false;
         var tempParent:DisplayObjectContainer = this.parent;
         if(tempParent == null)
         {
            throw new Error("没有父级，不能替换");
         }
         _sceneLoading.replaceScene = this;
         _sceneLoading.show(function():void
         {
            buliderCompleteFunc = function(param1:Event):void
            {
               e = param1;
               scene.removeEventListener("EVENT_BULIDERCOMPLETE",buliderCompleteFunc);
               if(scene._sceneNumber > _sceneNumber || sceneClassNameQueue.length > 0)
               {
                  scene.addBackFunction();
               }
               currentScene = scene;
               tempParent.addChild(scene);
               if(callBack)
               {
                  callBack(scene);
               }
               _sceneLoading.hide(function():void
               {
                  replaceTweenOver(tempParent);
                  _sceneLoading.targetScene = null;
               });
            };
            _sceneLoading.replaceScene = null;
            if(sceneNumberQueue == _sceneNumber)
            {
               sceneClassNameQueue.push(getSelfClass());
               sceneParamsQueue.push(_params);
               sceneNumberQueue = sceneNumberQueue + 1;
            }
            var scene:BaseScene = new sceneClass(params);
            _sceneLoading.targetScene = scene;
            scene._sceneNumber = sceneNumberQueue;
            scene._addToStageType = 0;
            scene.addEventListener("EVENT_BULIDERCOMPLETE",buliderCompleteFunc);
         });
      }
      
      public function replaceClassBeRoot(param1:Class, param2:Array, param3:Function = null) : void
      {
         sceneClass = param1;
         params = param2;
         callBack = param3;
         this.touchable = false;
         var tempParent:DisplayObjectContainer = this.parent;
         if(tempParent == null)
         {
            throw new Error("没有父级，不能替换");
         }
         _sceneLoading.replaceScene = this;
         _sceneLoading.show(function():void
         {
            buliderCompleteFunc = function(param1:Event):void
            {
               e = param1;
               scene.removeEventListener("EVENT_BULIDERCOMPLETE",buliderCompleteFunc);
               currentScene = scene;
               tempParent.addChild(scene);
               if(callBack)
               {
                  callBack(scene);
               }
               _sceneLoading.hide(function():void
               {
                  replaceTweenOver(tempParent);
                  _sceneLoading.targetScene = null;
               });
            };
            _sceneLoading.replaceScene = null;
            sceneClassNameQueue = [];
            sceneParamsQueue = [];
            sceneNumberQueue = 0;
            var scene:BaseScene = new sceneClass(params);
            _sceneLoading.targetScene = scene;
            scene._sceneNumber = sceneNumberQueue;
            scene._addToStageType = 0;
            scene.addEventListener("EVENT_BULIDERCOMPLETE",buliderCompleteFunc);
         });
      }
      
      public function dispatchBuliderComplete() : void
      {
      }
      
      protected function replaceTweenOver(param1:DisplayObjectContainer) : void
      {
         param1.removeChild(this,true);
      }
      
      protected function getSelfClass() : Class
      {
         var _loc1_:String = getQualifiedClassName(this);
         return getDefinitionByName(_loc1_) as Class;
      }
      
      public function disposeDisplayObject(param1:DisplayObject) : void
      {
         if(param1)
         {
            param1.removeFromParent();
            param1.dispose();
            var param1:DisplayObject = null;
         }
      }
      
      public function get parentScene() : lzm.starling.display.BaseScene
      {
         return _parentScene;
      }
      
      public function get childScene() : lzm.starling.display.BaseScene
      {
         return _childScene;
      }
      
      override public function dispose() : void
      {
         if(_backButton)
         {
            _backButton.removeFromParent();
            _backButton.dispose();
         }
         System.pauseForGCIfCollectionImminent(1);
         super.dispose();
      }
   }
}
