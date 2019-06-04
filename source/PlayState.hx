package;

import flixel.FlxState;
import flixel.group.FlxGroup;

class PlayState extends FlxState {
	public var players:FlxGroup;
    public var multiplayer:Multiplayer;
	public var bullets:FlxGroup;

	override public function create():Void {
		super.create();
		players = new FlxGroup();
		bullets = new FlxGroup();

		for (i in 0...100) {
			bullets.add(new Bullet());
		}

		players.add(new Player("11", [UP, DOWN, LEFT, RIGHT, SPACE]));
        add(multiplayer = new Multiplayer());
		add(players);
		add(bullets);
	}

	public function getPlayerById(id:String):Player {
        for (p in players) {
            if (cast(p, Player).id == id) {
                return cast(p, Player);
            }
		}
        return null;
    }

	public function shoot(x:Float, y:Float):Void {
		var b:Bullet = cast bullets.getFirstAvailable();

		if (b != null) {
			b.reset(x, y);
			b.velocity.x = 400;
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
