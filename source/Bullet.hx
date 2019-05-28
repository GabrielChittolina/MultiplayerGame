package;

import flixel.FlxSprite;
import flixel.FlxG;

class Bullet extends FlxSprite {
    public function new() {
        super();
        makeGraphic(100, 100, 0xffff0000);
        kill();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (!isOnScreen()) {
            kill();
        }
    }
}