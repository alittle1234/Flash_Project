package  
{
	import flash.geom.Point;
	import flash.events.Event;
	/**
	 * ...
	 * @author AARON
	 */
	public class GroundSmash_Enemy extends AreaOfEffect_Enemy
	{
		//AreaOfEffect_Enemy(  Board:GameBoard, Pos:Point, Speed = 0, Attack = 10, Range = 10, LifeSpan = 10	) 
		public function GroundSmash_Enemy(  brd:GameBoard, pos:Point) 
		{
			super( brd, pos, (0.005), 50, 40, 2000 )
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new groundSmash_enemy();			
		}
		
		override function ApplyDamage( enm:Tower)
		{
			// CALLED AT SPEED INTERVAL FOR DURATION
			enm.TakeDamage( mAttack );
		}
		
	}

}