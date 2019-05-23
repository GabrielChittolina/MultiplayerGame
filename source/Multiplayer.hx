package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;
import flixel.FlxG;

class Multiplayer extends FlxSprite {
    public static inline var OP_NEW_PLAYER:String = 'n';
    public static inline var OP_MOVE:String = 'm'; // [OP_MOVE, id, x, y, velocity.x, velocity.y]
    public static inline var OP_SHOOT:String = 'b'; // [id, x, y]
    
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
    
    // Testa se o id não existe
    function idTest(id:Int):Bool {
        if (id == _idJogador) return false;
        
        var p:Player = cast(FlxG.state, PlayState).getPlayerById(id);

        if (p == null) {
            FlxG.log.add("l");
            cast(FlxG.state, PlayState).players.add(new Player(id));
        }

        return true;
    }

    public function onMessage(msg:Array<Any>):Void {
        if (msg == null || msg.length == 0) {
            FlxG.log.error("Mensagem mal formada");
            return;
        }
        var op:String = msg[0];
        var idRemetente:Int = cast(msg[1], Int);

        if (!idTest(idRemetente)) {
            return;
        }

        switch (op) {
            case OP_MOVE:
                opMove(
                    cast(msg[1], Int), 
                    cast(msg[2], Int), 
                    cast(msg[3], Int), 
                    cast(msg[4], Float), 
                    cast(msg[5], Float)
                );
            case OP_SHOOT:
                opBullet(
                    cast(msg[1], Int), 
                    cast(msg[2], Int), 
                    cast(msg[3], Int)
                );
            default:
                FlxG.log.error("OP erro: " + op);
        }
    }

    public function opBullet(id:Int, x:Int, y:Int) {
        if (id == _idJogador) return;
        
        var state:PlayState = cast(FlxG.state, PlayState);
        var p:Player = state.getPlayerById(id);

        if (p != null) {
            p.x = x;
            p.y = y;
            state.shoot(x, y);
        }
    }

    public function opMove(id:Int, x:Int, y:Int, vx:Float, vy:Float):Void {
        if (id == _idJogador) return;
        
        var p:Player = cast(FlxG.state, PlayState).getPlayerById(id);
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

        if (_count >= 3) {
            _count = 0;
            send([OP_MOVE, 1, 20, 0, 10, 10]);
            send([OP_MOVE, 2, 40, 0, 10, 10]);
            send([OP_MOVE, 3, 60, 0, 10, 10]);
            send([OP_MOVE, 4, 80, 0, 10, 10]);

            send([OP_SHOOT, 1, 100, 100]);
        }
    }
}