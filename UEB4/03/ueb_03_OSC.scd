
// OSC Open Sound Controll

// OSC vs MIDI
// + OSC schneller MIDI
// + so gut wie jeder Pc besitzt die nötige Hardware
// + über das Netzwerk übertragbar

// - Nicht standartisiert:   /parameter/freq

// Transportprotokoll: UDP / TCP

// Port auf den SC-Lang hört
NetAddr.langPort;


n = NetAddr("127.0.0.1", 57120);

// Wir schicken uns auf diesem Port eine Nachricht an die Adresse "/test", haben aber noch keinen Receiver
n.sendMsg("/test", "Wie gehts ?");

// Mithilfe von OSCdef können wir nachrichten empfangen, deren parameter abgreifen und dementsprechend Code ausführen

// Wie in diesem simplen OSC Chat:

~back = Pseq(["Gut", "Schlecht", "Habe Husten"], inf).asStream;

(
OSCdef(\test,{|msg, time, addr, recvPort|
	msg[1].postln; ~back.next.postln; ("Und das schon um " ++ time.asString ++ " Sekunden").postln;
},'test');
)

n.sendMsg("/test", "Wie geht's ?");

// Indem wir unsere msg als Parameter abgreifen können wir damit auch Synths und andere Klangparameter steuern !
// msg[0] ist immer die Adresse also als Beispiel: "/kick/ffreq"
// msg[1] ist der Wert den wir verschicken: 500  --> ["/kick/ffreq", 500]

(
SynthDef(\pling, {|freq = 440, time = 0.1, ffreq = 600|
	var snd;
	var sig = SinOsc.ar(freq);
	sig = CombC.ar(sig, 1, time, 0.5, add: sig * 0.8 ) * EnvGen.ar(Env.perc(0.01, 1), doneAction: 2);
	sig = Clip.ar(sig * 10) * 0.25;
	snd = RLPF.ar(sig, ffreq, 0.3);
	Out.ar(0, snd.dup * 0.5);
}).add;
)

Synth(\pling);

(
OSCdef(\test,{|msg|
	msg.postln;
	Synth(\pling,[\freq , msg[1]]);
},'/pling/freq');
)

n.sendMsg("/pling/freq", 50);

// Auch SC-Lang und SC-Synth kommunizieren über OSC

// Das ist der listening Port von SC-Synth
o = NetAddr("127.0.0.1", 57110);


// nun können wir eine Message an eine bestimmte Adresse schicken
// Dies bewir in diesem Fall, dass wir einen neuen Synth "/s_new" mit dem synth def name "pling" erstellen. Auch die uns bekannten addActions kommen als 2. Wert der Message vor: 0 steht hier für die addAction 'addToHead'
// Mehr dazu findet ihr in der Help unter --> Server Command Reference

o.sendMsg("/s_new", "pling", 30, 0,0, "freq", 500);

// Same Same but much more convenient !
Synth(\pling,[\freq ,500]);


n = NetAddr("127.0.0.1", 57120);

// Dadurch dass wir unsere Adresse bei OSC Nachrichten selber bestimmen können, können wir uns auch wie in diesem Aufbau IDs erstellen um unsere Nachrichten besser zu kontrollieren



(
Tdef(\sender, {
	~id = Pseq([0,2,1,3], inf).asStream;
	loop{
		n.sendMsg("/test/" ++ ~id.next.asString, ~id.next + 3);
		0.33.wait;
	}
}).quant = 1;

Tdef(\sender).play;
)

(
Tdef(\sender2, {
	~id = Prand(Array.series(4,0,1), inf).asStream;
	loop{
		n.sendMsg("/test/" ++ ~id.next.asString, ~id.next + 2);
		0.5.wait;
	}
// Kleiner Rückblick zum letzten Mal: Auch Tdefs können quantisiert werden
}).quant = 1;

Tdef(\sender2).play;
)

// OSC Leierkasten....
(
OSCdef(\test1, {| msg | msg.postln; Synth(\pling, [\freq, 100 * msg[1]]);},'/test/0' );
OSCdef(\test2, {| msg | msg.postln; Synth(\pling, [\freq, 200 * msg[1]]);},'/test/1' );
OSCdef(\test3, {| msg | msg.postln; Synth(\pling, [\freq, 300 * msg[1]]);},'/test/2' );
OSCdef(\test4, {| msg | msg.postln; Synth(\pling, [\freq, 400 * msg[1]]);},'/test/3' );
)

// Ab hier kommt OSC Junction ins Spiel !
// In diesem Beispiel ändert sich nichts an unserem Empfänger  Port (NetAddr.langPort meistens 57120).
// Aber wir wollen über 57140 etwas herausschicken.
// Damit sei schon einmal sichergestellt, dass wir nicht weiterhin an uns selber nur lokal Nachrichten versenden
// Probiert damit einfach noch ein paar Sachen aus und schickt euch am besten gegenseitig Nachrichten
// Ihr könnte dafür gerne auch die junction benutzen die wir heute erstellt haben: kp4UEB

// Patricks Code zum Testen:

// === OSCjunction Settings ===
// *Receive* from Junction
// Adress: 127.0.0.1
// Port: 57120 (or whatever NetAddr.langPort tells you)
// *Send* to Junction
// Port: 57140 (leave Reply-Adress and Reply-Port empty)

NetAddr.langPort;

// Receiver
(
OSCdef(\test, {|msg|
	msg.postln;
}, '/test');
)

// Sender
n = NetAddr("127.0.0.1", 57140);
n.sendMsg("/test", 113);


// Unser Beispiel mit verschiedenen Adressen / Empfängern

n.sendMsg("/test/0", 300);
n.sendMsg("/test/1", 200);
n.sendMsg("/test/2", 400);


(
OSCdef(\test1,{|msg, time, addr, recvPort| Synth(\pling, [\freq, msg[1], \time, 0.1, \ffreq, msg[1].explin(50, 2000, 50, 1200)]); },'/test/0');

OSCdef(\test2,{|msg, time, addr, recvPort| Synth(\pling, [\freq, msg[1], \time, 0.5]); },'/test/1');

OSCdef(\test3,{|msg, time, addr, recvPort| Synth(\pling, [\freq, msg[1], \time, 0.9]); },'/test/2');
)

// Probiert erst einmal etwas mit verschiedenen Adressen und OSCdefs herum...
// Nächstes Mal können wir dann noch ein paar andere Sachen ausprobieren :)



