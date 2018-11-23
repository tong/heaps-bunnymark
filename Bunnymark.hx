
import hxd.Key;
import h2d.SpriteBatch;

class Bunny extends h2d.BatchElement {

	public var speedX : Float;
	public var speedY : Float;

	public function new( tile, speedX : Float, speedY : Float ) {
		super( tile );
		this.speedX = speedX;
		this.speedY = speedY;
	}
}

class Bunnymark extends hxd.App {

	var textBackground : h2d.Graphics;
	var text : h2d.Text;
	var tile : h2d.Tile;
	var bunnies : h2d.SpriteBatch;
	var bunnyCount = 0;
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

		bunnies = new h2d.SpriteBatch( tile, s2d );

		var font = hxd.res.DefaultFont.get();
		font.resizeTo( font.size * 2 );
		textBackground = new h2d.Graphics( s2d );
		textBackground.x = 10;
		textBackground.y = 10;
		text = new h2d.Text( font, textBackground );
		text.textColor = 0x000000;
		text.x = 2;

		onResize();

		addBunnies();
	}

	function addBunnies() {
		for( i in 0...amount ) {
			var bunny = new Bunny( tile, Math.random()*10-5, Math.random()*5-3 );
			bunny.x = s2d.mouseX;
			bunny.y = s2d.mouseY;
			bunnies.add( bunny );
		}
		bunnyCount += amount;
		updateInfoText();
	}

	function removeBunnies() {
		var i = 0;
		for( bunny in bunnies.getElements() ) {
			bunny.remove();
			bunnyCount--;
			if( ++i >= amount ) break;
		}
		updateInfoText();
	}

	override function update(dt:Float) {
		if( Key.isDown( Key.DOWN ) || Key.isDown( Key.MOUSE_LEFT ) )
			addBunnies();
		if( Key.isDown( Key.UP ) || Key.isDown( Key.MOUSE_RIGHT ) )
			removeBunnies();
		for( child in bunnies.getElements() ) {
			var bunny : Bunny = cast child;
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

	function updateInfoText( ) {
		text.text = Std.string( bunnyCount );
		textBackground.clear();
		textBackground.beginFill( 0xFFFFFF, 0.75 );
		textBackground.drawRect( 0, 0, text.textWidth+5, text.textHeight );
		textBackground.endFill();
	}

	override function onResize() {
		var window = hxd.Window.getInstance();
		maxX = window.width;
		maxY = window.height;
	}

	static function main() {
		hxd.Res.initEmbed();
		new Bunnymark();
	}
}
