package com.mvc.models.vos.beginnerGuide
{
   import flash.geom.Point;
   
   public class BeginnerGuideVO
   {
       
      public var mark:String;
      
      public var isIntroduction:String;
      
      public var targetName:String;
      
      public var targetPgae:String;
      
      public var description:String;
      
      public var descriptionPoint:Point;
      
      public var voice:String;
      
      public function BeginnerGuideVO()
      {
         descriptionPoint = new Point();
         super();
      }
   }
}
