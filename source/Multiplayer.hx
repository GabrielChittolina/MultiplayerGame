package;

import flixel.FlxSprite;
import flixel.FlxG;

class Multiplayer extends FlxSprite {
    public static inline var OP_NEW_PLAYER:String = 'n';
    public static inline var OP_MOVE:String = 'm'; // [OP_MOVE, id, x, y, velocity.x, velocity.y]
    
    var _count:Float = 0;
    var _idJogador:Int;
    
    public function new() {
        super();
        _idJogador = -1;
    }

    public function send(msg:Array<Any>):Void {
        // Acoxambrando comunicação
        onMessage(msg);
    }

    public function onMessage(msg:Array<Any>):Void {
        if (msg == null || msg.length == 0) {
            FlxG.log.error("Mensagem mal formada");
            return;
        }
        var op:String = msg[0];

        switch (op) {
            case OP_MOVE:
                doMove(
                    cast(msg[1], Int), 
                    cast(msg[2], Int), 
                    cast(msg[3], Int), 
                    cast(msg[4], Float), 
                    cast(msg[5], Float)
                );
            default:
                FlxG.log.error("OP erro: " + op);
        }
    }

    public function doMove(id:Int, x:Int, y:Int, vx:Float, vy:Float):Void {
        if (id == _idJogador) return;
        
        var p:Player = cast(FlxG.state, PlayState).getPlayerById(1);
            if (p != null) {
                p.x = x;
                p.y = y;
                p.velocity.x = vx;
                p.velocity.y = vy;
            }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        _count += elapsed;

        if (_count >= 4) {
            _count = 0;
            send([OP_MOVE, 1, 10, 10, 10, 10]);
        }
    }
}