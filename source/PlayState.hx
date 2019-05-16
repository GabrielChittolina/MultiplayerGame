package;

import flixel.FlxState;
import flixel.group.FlxGroup;

class PlayState extends FlxState {
	var _players:FlxGroup;
    var _multiplayer:Multiplayer;

	override public function create():Void {
		super.create();
		_players = new FlxGroup();

		_players.add(new Player(0, UP, DOWN, LEFT, RIGHT));
		_players.add(new Player(1, W, S, A, D));
        add(_multiplayer = new Multiplayer());
		add(_players);
	}

	public function getPlayerById(id:Int):Player {
        for (p in _players) {
            if (cast(p, Player)._id == id) {
                return cast(p, Player);
            }
		}
        return null;
    }

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
