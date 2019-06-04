package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Player extends FlxSprite {
    public var id:String;
    public var simulated:Bool;
    public var lastSimulation:Date;
    public var speed:Int = 20;

    var _upKey:FlxKey;
    var _downKey:FlxKey;
    var _leftKey:FlxKey;
    var _rightKey:FlxKey;
    var _fireKey:FlxKey;

    public function new(id:String, keys:Array<FlxKey> = null) {
        super();

        this.id = id;

        if (keys == null) {
            simulated = true;
            lastSimulation = Date.now();
            return;
        }

        velocity.set(0, 0);
        maxVelocity.set(50, 50);
        
        _upKey = keys[0];
        _downKey = keys[1];
        _leftKey = keys[2];
        _rightKey = keys[3];
        _fireKey = keys[4];
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        var send = false;

        if (FlxG.keys.anyPressed([_upKey])) {
            acceleration.y = -speed;
            send = true;
        }

        if (FlxG.keys.anyPressed([_downKey])) {
            acceleration.y = speed;
            send = true;
        }

        if (FlxG.keys.anyPressed([_leftKey])) {
            acceleration.x = -speed;
            send = true;
        }
        
        if (FlxG.keys.anyPressed([_rightKey])) {
            acceleration.x = speed;
            send = true;
        }

        var mps = cast(FlxG.state, PlayState).multiplayer;
        if (send) {
            mps.sendMove(this);
        }

        if (FlxG.keys.anyJustPressed([_fireKey])) {
            cast(FlxG.state, PlayState).shoot(x, y);
            mps.send([
                Multiplayer.OP_SHOOT, 
                mps.getMyMultiplayerId(), 
                x, 
                y
            ]);
        }
    }
}