package;

import networking.Network;
import networking.sessions.Session;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.MouseEvent;

class Server extends Sprite {

    var _ids:Int = 0;

    public function new() {
        super();
        run();
    }

    /**
    * Run the application in server mode. This methid will be executed after
    * clicking on the `Server` button.
    */
    private function run() {
        // Create the server...
        var server = Network.registerSession(NetworkMode.SERVER, { ip: '0.0.0.0', port: 8888, flash_policy_file_port: 9999 });

        // ... add some event listeners...

        // When a client is connected...
        server.addEventListener(NetworkEvent.CONNECTED, function(event: NetworkEvent) {
        // Send the current position of the cube.
        event.client.send([]);
        });

        // When recieving a message from a client...
        server.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(event: NetworkEvent) {
        // ... and broadcast the location to all clients.
        server.send(event.data);
        });

        // ... and run it!
        server.start();
    }
}