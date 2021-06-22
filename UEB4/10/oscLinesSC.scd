NetAddr.langPort

n = NetAddr("127.0.0.1", 12000)

//Zuerst den Responder Ausführen....
(
OSCdef(\processing, {|msg|
	var x = 700.rand;
	var y = 700.rand;
	var c = 255.rand;
	Synth(\pling, [
		// exponentielles scaling für die Tonhöhe
		\freq1, x.linexp(0, 700, 100, 2000),
		\freq2, y.linexp(0, 700, 100, 2000),
		// die xPosition können wir linear auf unser panning scalen
		\pos, x.linlin(0, 700, -1, 1),
		\amp, msg[1].linlin(0, 10, 0, 0.5)
	]);
	msg[1].postln;
	n.sendMsg("/processing", x, y, c);
}, "/sc")
)

// Hiermit starten wir  unseren Message Loop
// 3 Argumente für x,y und color
n.sendMsg("/processing", 600, 300, 100);

NetAddr.langPort;

n = NetAddr("127.0.0.1", 12000);



(
OSCdef(\processing, {|msg|
        msg.postln;
        n.sendMsg("/processing", 100);
}, "/sc")
)


// Austauschbarer Synthi mit Parametern für x + y:

(
SynthDef(\pling, {|freq1 = 100, freq2 = 200, pos = 0, amp = 0.2|
	var snd = Mix.ar([SinOsc.ar(freq1), SinOsc.ar(freq2)]);
	var env = EnvGen.ar(Env.perc(0.01, 1), doneAction:2);
	snd = Pan2.ar(snd * env, pos);
	snd = snd * env;
	Out.ar(0, snd * amp);
}).add;
)

Synth(\pling);

