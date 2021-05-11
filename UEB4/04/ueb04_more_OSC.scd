// setup OSC

NetAddr.langPort;
n = NetAddr.new("127.0.0.1", 57120);



// einfache Kick

s.scope;

(
SynthDef(\kick,
	{   |hi = 500, xlow = 300, xhigh = 600|
		var env = EnvGen.ar(Env.perc(0.01, 1), doneAction:2);
		var snd = SinOsc.ar(XLine.kr(hi, 50, 0.1)) * env;
		//snd = RLPF.ar(snd, MouseX.kr(xlow, xhigh));
		//n.sendMsg('/kick', 900);
		//Out.kr(b, snd, 0.7);
		Out.ar(0,snd!2 * 0.5);
	}
).add;
)

(
OSCdef(\receiver,{ |msg|
	Synth(\kick, [\hi, msg[1]]);
},'/kick')
)

// fork um einzelne Nachrichten zu 'sequenzieren'
(
{
	1.wait;
	n.sendMsg('/kick', 200);
	0.5.wait;
	n.sendMsg('/kick', 500);

}.fork(quant:1); // auch quantisierbar !
)

// fork mit loops
// NICHT DIE WAITS VERGESSEN !
(
{
	inf.do{

		1.wait;
		n.sendMsg('/kick', 200);
		0.5.wait;
		n.sendMsg('/kick', 500);
	}
}.fork(quant:1);
)

(
OSCdef(\receiver,{ |msg|
	Synth(\kick, [\hi, msg[1]]);
},'/kick')
)

// fork funktioniert auch in Zusammenahng mit TempoClocks
// Hierbei stehen die waits immer im Verhältnis zur Clock.

(
t = TempoClock.new(170 / 60);
//t = TempoClock.new(160 / 60)
{
	inf.do{
		n.sendMsg('/kick', 200);
		1.wait;
		n.sendMsg('/kick', 500);
	    1.5.wait;
		n.sendMsg('/kick', 200);
		0.5.wait;
		n.sendMsg('/kick', 500);
		1.wait;
	}

}.fork(t, quant:1);
)

(
OSCdef(\receiver,{ |msg|
	Synth(\kick, [\hi, msg[1]]);
},'/kick')
)

// Noch ein Beispiel mir Prand

(
{

	x = Prand([500, 1000, 1500, 100], inf).asStream;
	inf.do{

		0.25.wait;
		n.sendMsg('/kick', x.next;);
		0.5.wait;
		n.sendMsg('/kick', x.next.next);
	}

}.fork(quant:1);
)

// Synth Defs und automatisierte OSC messages


// Problematisch da wir uns zwar beim definieren eine Nachricht rausschicken

(
OSCdef(\receiver,{ |msg|
	msg.postln;
	Synth(\kick, [\hi, msg[1]]);
},'/kick')
)

(
b = Bus.control(s, 1);
SynthDef(\kick,
	{   |hi = 500, xlow = 300, xhigh = 600|

		var env = EnvGen.ar(Env.perc(0.01, 1), doneAction:2);
		var snd = SinOsc.ar(XLine.kr(hi, 50, 0.1)) * env;

		n.sendMsg('/kick', 900);
		Out.kr(b, snd, 0.7);
		Out.ar(0,snd!2 * 0.5);
	}
).add;
)

// Nicht jedoch beim abspielen des Synths !

Synth(\kick);

// Hierbei greift die SC-Lang jedoch auf unseren alten Synth(\kick) zurück....
// Hiermit können wir uns mit Hilfe des Control Bus b ein simples Gate bauen welches und Nachrichten auch beim abspielen des Synths rausschickt
(
{
	inf.do{
		b.get({|value|
			if(value >= 0.1, {n.sendMsg('/kick', "Hallo")});
		});

		0.2.wait;
	};
}.fork(quant:1);
)

(
OSCdef(\receiver,{ |msg|
	msg.postln;
	//Synth(\kick, [\hi, msg[1]]); // das hier führt zu einem kick loop
},'/kick')
)

Synth(\kick);


// Ndefs innerhalb OSCdef für extra smoothnes

Ndef(\sound1).fadeTime = 2;
Ndef(\sound1).quant = 1;

(
OSCdef(\sound1, {|msg|
	Ndef(\sound1, {var snd = SinOsc.ar(180) * LFPulse.kr(msg[1]) * 0.5; snd.dup;}).play;

},'/bass')
)

Ndef(\sound2).fadeTime = 2;
Ndef(\sound2).quant = 1;

(
OSCdef(\sound2, {|msg|
	Ndef(\sound2, {var snd = SinOsc.ar(240) * LFPulse.kr(msg[1]) * 0.5; snd.dup;}).play;

},'/bass')
)

(
{
	x = Pseq([1,0.5,2], inf).asStream;
	inf.do{
		n.sendMsg('/bass', x.next;);
		1.wait;
	};
}.fork(quant: 1);
)

// Oder besser mit Tdefs so kann der sender die Patterns jederzeit update und der Empfänger am Sound arbeiten !

(
Tdef(\pat, {
	x = Pseq([1,0.25,2], inf).asStream;
	loop{
		n.sendMsg('/bass', x.next;);
		1.wait;
		n.sendMsg('/bass', x.next.next;);
		0.25.wait;
	};
}
).quant = 1
)

Tdef(\pat).play;

(
OSCdef(\sound1, {|msg|
	Ndef(\sound1, {var snd = SinOsc.ar(300) * Pulse.kr(msg[1]) * 0.5; snd.dup;}).play;

},'/bass')
)

(
OSCdef(\sound2, {|msg|
	Ndef(\sound2, {var snd = SinOsc.ar(XLine.kr(120,150, 1)) * SinOsc.kr(msg[1]) * 0.5; snd.dup;}).play;

},'/bass')
)


Ndef(\sound1).free;
Ndef(\sound2).free;






