package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;
import flixel.FlxG;
import networking.Network;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;
import networking.sessions.Session;

class Multiplayer extends FlxSprite {
    // public static inline var SERVER_IP:String = '127.0.0.1';
    public static inline var SERVER_IP:String = '172.20.83.155';

    public static inline var OP_NEW_PLAYER:String = 'n';
    public static inline var OP_MOVE:String = 'm'; // [OP_MOVE, id, x, y, velocity.x, velocity.y, acceleration.x, acceleration.y]
    public static inline var OP_SHOOT:String = 't'; // [id, x, y]
    public static inline var OP_DEAD:String = 'o'; // [id, x, y]
    
    var _count:Float = 0;
    var _overflowTimer:Float = 0;
    var _overflowInterval:Float = 5; // Minimum time, in seconds, to prevent overload/overflow
    var _overflowLastOp:String = "";
    var _idJogador:String;
    var _client:Session;
    
    public function new() {
        super();
        _idJogador = "11";
        createClient();
    }

    function createClient() {
        _client = Network.registerSession(NetworkMode.CLIENT, {
            ip: SERVER_IP, 
            port: 8888, flash_policy_file_url: 'http://'+ SERVER_IP +':9999/crossdomain.xml' 
        });

        // When a client recieves a message ...
        _client.addEventListener(NetworkEvent.MESSAGE_RECEIVED, onMessageReceived);

        _client.addEventListener(NetworkEvent.INIT_SUCCESS, onInitSuccess);

        // ... and run it!
        _client.start();

        var session = Network.sessions[0];
    }

    function onMessageReceived(event:NetworkEvent):Void {
        FlxG.log.add(event.data);
        onMessage(event.data);
    }

    function onInitSuccess(event:NetworkEvent):Void {
        // FlxG.log.add("Success.");
    }

    public function send(msg:Array<Any>):Void {
        // Acoxambrando comunicação
        // onMessage(msg);
        _client.send(msg);
    }

    public function sendMove(p:Player):Void {
        sendOnOverflow([
            Multiplayer.OP_MOVE, 
            getMyMultiplayerId(), 
            p.x, 
            p.y, 
            p.velocity.x, 
            p.velocity.y, 
            p.acceleration.x, 
            p.acceleration.y
        ]);
    }

    public function getMyMultiplayerId():String {
        return _idJogador;
    }

    public function sendOnOverflow(msg:Array<Any>):Void {
        var op = msg[0];

        if (op == _overflowLastOp) {
            return;
        }

        _overflowLastOp = op;
        send(msg);
    }
    
    // Testa se o id não existe
    function idTest(id:String):Bool {
        if (id == _idJogador) return false;
        
        var p:Player = cast(FlxG.state, PlayState).getPlayerById(id);

        if (p == null) {
            cast(FlxG.state, PlayState).players.add(new Player(id));
        }

        return true;
    }

    public function onMessage(msg:Array<Any>):Void {
        if (msg == null || msg.length == 0) {
            return;
        }
        var op:String = msg[0];
        trace(msg);
        var idRemetente:String = cast(msg[1], String);
        if (!idTest(idRemetente)) {
            return;
        }

        switch (op) {
            case OP_MOVE:
                opMove(
                    idRemetente, 
                    cast(msg[2], Float), // x
                    cast(msg[3], Float), // y
                    cast(msg[4], Float), // velocity.x
                    cast(msg[5], Float), // velocity.y
                    cast(msg[6], Float), // acceleration.x
                    cast(msg[7], Float)  // acceleration.y
                );
            case OP_SHOOT:
                opBullet(
                    idRemetente, 
                    cast(msg[2], Float), 
                    cast(msg[3], Float)
                );
            case OP_DEAD:
                opDead(
                    idRemetente,
                    cast(msg[2], Float), 
                    cast(msg[3], Float)
                );
            default:
        }
    }

    public function opDead(id:String, x:Float, y:Float):Void {
        var p:Player = getPlayer(id);

        if (p == null) return;

        p.x = x;
        p.y = y;
        p.kill();
    }

    public function getState():PlayState {
        var state:PlayState = cast(FlxG.state, PlayState);
        return state;
    }

    public function getPlayer(id:String):Player {
        var state:PlayState = getState();
        var p = state.getPlayerById(id);
        return p;
    }

    public function opBullet(id:String, x:Float, y:Float):Void {
        if (id == _idJogador) return;
        
        var p:Player = getPlayer(id);

        if (p != null) {
            p.x = x;
            p.y = y;
            getState().shoot(x, y);
        }
    }

    public function opMove(id:String, x:Float, y:Float, vx:Float, vy:Float, ax:Float, ay:Float):Void {
        if (id == _idJogador) return;
        
        var p:Player = getPlayer(id);
            if (p != null) {
                p.x = x;
                p.y = y;
                p.velocity.x = vx;
                p.velocity.y = vy;
                p.acceleration.x = ax;
                p.acceleration.y = ay;
            }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        _count += elapsed;
        _overflowTimer += elapsed;

        if (_overflowTimer >= _overflowInterval) {
            _overflowTimer = 0;
            _overflowLastOp = "";
        }

        if (_count >= 3) {
            _count = 0;
            // sendOnOverflow([OP_MOVE, 1, 20, 0, 10, 10]);
            // sendOnOverflow([OP_MOVE, 2, 40, 0, 10, 10]);
            // sendOnOverflow([OP_MOVE, 3, 60, 0, 10, 10]);
            // sendOnOverflow([OP_MOVE, 4, 80, 0, 10, 10]);

            // send([OP_SHOOT, 1, 100, 100]);

            // send([OP_DEAD, 2, 100, 100]);
            // send([OP_DEAD, 3, 100, 100]);
        }
    }
}