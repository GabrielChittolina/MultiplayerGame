package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Player extends FlxSprite {
    public var id:Int;
    public var simulated:Bool;
    public var lastSimulation:Date;

    var _upKey:FlxKey;
    var _downKey:FlxKey;
    var _leftKey:FlxKey;
    var _rightKey:FlxKey;
    var _fireKey:FlxKey;

    public function new(id:Int, keys:Array<FlxKey> = null) {
        super();

        this.id = id;

        if (keys == null) {
            simulated = true;
            lastSimulation = Date.now();
            return;
        }
        
        _upKey = keys[0];
        _downKey = keys[1];
        _leftKey = keys[2];
        _rightKey = keys[3];
        _fireKey = keys[4];
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.keys.anyPressed([_upKey])) {
            y -= 1;
        }

        if (FlxG.keys.anyPressed([_downKey])) {
            y += 1;
        }

        if (FlxG.keys.anyPressed([_leftKey])) {
            x -= 1;
        }
        
        if (FlxG.keys.anyPressed([_rightKey])) {
            x += 1;
        }
        
        if (FlxG.keys.anyJustPressed([_fireKey])) {
            cast(FlxG.state, PlayState).shoot(x, y);
        }
    }
}