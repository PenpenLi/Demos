package extend.particlesystem
{
   public class PDParticle extends Particle
   {
       
      public var colorArgb:extend.particlesystem.ColorArgb;
      
      public var colorArgbDelta:extend.particlesystem.ColorArgb;
      
      public var startX:Number;
      
      public var startY:Number;
      
      public var velocityX:Number;
      
      public var velocityY:Number;
      
      public var radialAcceleration:Number;
      
      public var tangentialAcceleration:Number;
      
      public var emitRadius:Number;
      
      public var emitRadiusDelta:Number;
      
      public var emitRotation:Number;
      
      public var emitRotationDelta:Number;
      
      public var rotationDelta:Number;
      
      public var scaleDelta:Number;
      
      public function PDParticle()
      {
         super();
         colorArgb = new extend.particlesystem.ColorArgb();
         colorArgbDelta = new extend.particlesystem.ColorArgb();
      }
   }
}
