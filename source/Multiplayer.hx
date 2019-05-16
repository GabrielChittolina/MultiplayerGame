package;

import flixel.FlxSprite;
import flixel.FlxG;

class Multiplayer extends FlxSprite {
    var _count:Float = 0;
    
    public function new() {
        super();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        _count += elapsed;

        if (_count >= 1) {
            _count = 0;
            var p:Player = cast(FlxG.state, PlayState).getPlayerById(1);
            if (p != null) {
                p.x += 5;
            }
        }
    }
}