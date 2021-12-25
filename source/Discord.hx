package;

#if desktop
import Sys.sleep;
import discord_rpc.DiscordRpc;
#end

using StringTools;

class DiscordClient
{
	public function new()
	{
                #if desktop
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: "822967001903005716",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
			//trace("Discord Client Update");
		}

		DiscordRpc.shutdown();
                #end
	}

	static function onReady()
	{
                #if desktop
		DiscordRpc.presence({
			details: "Booting up",
			state: null,
			largeImageKey: 'iconpresence',
			largeImageText: "FNF: Mic'd Up"
		});
                #end
	}

	static function onError(_code:Int, _message:String)
	{
                #if desktop
		trace('Error! $_code : $_message');
                #end
	}

	static function onDisconnected(_code:Int, _message:String)
	{
                #if desktop
		trace('Disconnected! $_code : $_message');
                #end
	}

	public static function initialize()
	{
                #if desktop
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord Client initialized");
                #end
	}

	public static function shutdown()
		{
                        #if desktop
			DiscordRpc.shutdown();
                        #end
		}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
                #if desktop
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'iconpresence',
			largeImageText: "FNF: Mic'd Up",
			smallImageKey : smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000)
		});

		//trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
                #end
	}
}
