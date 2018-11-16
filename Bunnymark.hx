
import hxd.Key;

class Bunny extends h2d.Object {

	public var speedX : Float;
	public var speedY : Float;

	public function new( parent, tile, speedX : Float, speedY : Float ) {
		super( parent );
		this.speedX = speedX;
		this.speedY = speedY;
		new h2d.Bitmap( tile, this );
	}
}

class Bunnymark extends hxd.App {

	var text : h2d.Text;
	var tile : h2d.Tile;
	var bunnies : h2d.Object;
	var bunnyWidth : Int;
	var bunnyHeight : Int;
	var gravity = 0.5;
	var minX = 0;
	var minY = 0;
	var maxX = 600;
	var maxY = 600;
	var isAdding : Bool;
	var amount = 100;

	override function init() {

		tile = hxd.Res.bunny.toTile();
		bunnyWidth = tile.width;
		bunnyHeight = tile.height;
		bunnies = new h2d.Object( s2d );

		text = new h2d.Text( hxd.res.DefaultFont.get(), s2d );
		text.textColor = 0xFFFFFF;
		text.x = text.y = 10;

		addBunnies();

		hxd.Window.getInstance().addEventTarget( onEvent );
	}

	function addBunnies() {
		for( i in 0...amount )
			new Bunny( bunnies, tile, Math.random()*5, Math.random()*5-3 );
		text.text = Std.string( bunnies.numChildren );
	}

	function removeBunnies() {
		var i = 0;
		while( i < amount && bunnies.numChildren > 0 ) {
			bunnies.removeChild( bunnies.getChildAt(0) );
			i++;
		}
		text.text = Std.string( bunnies.numChildren );
	}

	function onEvent( e : hxd.Event ) {
		switch e.kind {
		case EKeyDown:
			switch e.keyCode {
			case Key.UP: addBunnies();
			case Key.DOWN: removeBunnies();
			}
		case EPush: (e.button == 0) ? addBunnies() : removeBunnies();
		case EWheel: (e.wheelDelta > 0) ? addBunnies() : removeBunnies();
		case _:
		}
	}

	override function update(dt:Float) {
		for( child in bunnies.iterator() ) {
			var bunny = cast( child, Bunny );
			bunny.x += bunny.speedX;
			bunny.y += bunny.speedY;
			bunny.speedY += gravity;
			if( bunny.x < minX ) {
				bunny.x = minX;
				bunny.speedX *= -1;
			} else if( (bunny.x + bunnyWidth) > maxX ) {
				bunny.x = maxX - bunnyWidth;
				bunny.speedX *= -1;
			}
			if( bunny.y < minY ) {
				bunny.y = minY;
				bunny.speedY = 0;
			} else if( (bunny.y + bunnyHeight) > maxY ) {
				bunny.y = maxY - bunnyHeight;
				bunny.speedY *= -0.85;
				if( Math.random() > 0.5 ) bunny.speedY -= Math.random() * 6;
			}
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Bunnymark();
	}
}
