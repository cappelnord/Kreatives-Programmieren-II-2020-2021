
// Interesse ? Aktuelle Projekte ? Nachholbedarf ?

// testest
{SinOsc.ar(235) * 0.2}.play

s.scope;

// Kleines Beispiel zur sc-synth | sc-lang Kommuikation:
// Nicht möglich da der UGen "Bauplan" (SynthDef) des Synths bereits abgeschlossen ist. Dort ist kein XLine enthalten.
(
SynthDef(\line, { |freq|
	var snd = SinOsc.ar(freq);
	Out.ar(0, snd *0.5);
}).add;
)

Synth(\line, [\freq, XLine.kr(1,10,2)]);

// Eine Lösung: Nun ist unser XLine mit dabei und wir können es über Argumente ansteuern
(
SynthDef(\line, { |start, end, dur |
	var snd = SinOsc.ar(XLine.kr(start, end, dur));
	Out.ar(0, snd * 0.5);
}).add;
)

(
x = Synth(\line, [
	\start, 50,
	\end, 500,
	\dur, 5	]);
)


//Output von Ugens als Input eines anderen Ugens:

// Ein Bus ist ein kleiner Bereich im Speicher an dem samples abgelegt werden können.

/*
/              1-Block (64-samples)          \
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||  AudioRate :  64 Werte
                             1 Value                    ControlRate: 1 Wert
*/

// Diese Buse sind per Default für die Systemhardware vorgesehen

// Default Options
o = Server.default.options;

// Output Channesl Ansehen und Verändern
o.numOutputBusChannels;
o.numOutputBusChannels = 2; // 0 L, 1R

// Input Bus
o.numInputBusChannels ;

o.numInputBusChannels;


// Alle weiteren Buse stehen frei für internes routing, das keinen direkten Input / Output mit der SystemHardware hat.

a = Bus.audio(s, 1); // Audio Bus
b = Bus.control(s); // Control Bus

// Audio Bus
a = Bus.audio(s);

// Index des Busses (...ka ob grammatikalisch richtig, zur Not einfach Index von dem Bus ;)
// Braucht uns eigentlich nicht zu interessieren da wir  Busse direkt an Ugens / Synth übergeben können.
a.index;


a.free;

a.index;
s.meter;

// Control Bus...da machen wir nochmal einen kleinen Block zu nächstes mal !
b = Bus.control(s);


a.index

a.index

(
SynthDef(\A,{ |out = 0, freq |
	Out.ar(a, SinOsc.ar(freq));
}).add;
)

(
SynthDef(\B,{ |out = 0, freq = 440|
	var snd = SinOsc.ar(freq + In.ar(a) * 100);
	Out.ar(0, snd.dup * 0.5 );
}).add;
)

// Wir hören noch nichts
Synth(\A);
Synth(\B);

//  Der Node tree bestimmt in welcher Reihenfolge sich Supercollider durch die synth nodes arbeitet
//  Die Synth die wir verwenden repräsentieren immer Synth Node auf dem server:
s.plotTree;
 // Nun sehen wir die tatsächliche reihenfolge !

// Konkret gilt für diese Reihenfolger: Synth_B welcher Synth_A als input hat muss nach Synth_A ausgeführt werden !

// Die Anordnugn der Synth Nodes können wir natürlich auch beeinflussen:

// addActions für mehr Kontrolle
Synth(\A, [\freq, 100]);
Synth(\B, addAction: 'addToTail');

Synth.tail(s,\B); // Alternativ auch als Convenient Method schreibbar

// doneActions schon bekannt von Envelopes
{PinkNoise.ar(0.5) * Line.kr(1,0,2,doneAction: Done.freeSelf)}.play.onFree {"done".postln};

// Nodes nachträglich Bewegen
~mod = Synth(\A, [\freq, 100]);
~car = Synth(\B, addAction: 'addToTail');

~car.moveBefore(~mod);
~mod.moveBefore(~car);

// Groups
// Group 1--> Default Group Basic Node tree
// Überlicherweise werden alle Nodes, die nicht weiter spezifiziert ist in der Default Group ausgeführt.
// Dadurch ist sichergestellt das Funktionen wie s.record oder s.scope an der richtigen Stelle ausgeführt wird
// Generell ist es ratsam neue Gruppen innerhalb der Default Group zu erstellen und nicht außerhalb --siehe Doku => Default Group

// Groups erstellen und im Post window einsehen
g = Group.new;
h = Group.new(g, \addAfter); // Add actions
s.queryAllNodes;
g.free; h.free;
g.free;

// Mit Gruppen Können wir gleich mehrere Synths hinter Effekte schalten

// Einfaches Beispiel: src->fx

//Zuerst brauchen wir einen Bus
b = Bus.audio(s,2);

~synthgroup = Group.tail(s) //Hier können wir auch Convenient Methods nutzen
~fxgroup =  Group.tail(s)

s.scope;

g = Group.new;
h = Group.new(g, \addAfter);
s.queryAllNodes;
b = Bus.audio(s, 2);

(
SynthDef(\noise, { arg bus = 0;
	var snd = Pan2.ar(WhiteNoise.ar(0.5) * LFPulse.kr(XLine.kr(1, 4, 50)),
		SinOsc.ar(XLine.kr(1,2,20)));

	Out.ar(bus,snd);
}).add;

// Eure Synths

SynthDef(\simpleFM, { | bus = 0, carr_freq = 400, mod_freq = 50 |
        var snd = SinOsc.ar(carr_freq + SinOsc.ar(mod_freq).range(-100, 100));

        Out.ar(bus, snd.dup * 0.5);
}).add;

SynthDef(\pling, {|bus=0, freq=440|
        var sig, env;
        sig = SinOsc.ar(freq);
        env = EnvGen.ar(Env.perc(0.01));
        Out.ar(bus, Pan2.ar(sig*env*0.1));
}).add;

SynthDef(\Fabi, {arg bus = 0;

        var snd = Saw.ar([237, 245], SinOsc.kr(0.8));
        Out.ar(bus, snd*SinOsc.ar(0.78, mul: 0.5))
}).add;

SynthDef(\rectWobble, { | bus = 0, freq = 300, modFreq = 5, amp = 0.2 |
        var mod = SinOsc.ar(modFreq) * 10;
        var snd = GVerb.ar(Pulse.ar(freq + mod) !2, 20, 1, 0.2, spread: 20, taillevel: 0.4);
        Out.ar(bus, snd * amp);
}).add;

SynthDef(\kleinerSynth, { | bus = 0 |

        var snd;

        snd = MoogVCF.ar(Pulse.ar([33,35],[0.9,0.7]),SinOsc.kr(LFNoise0.kr(0.42).range(0.001,2.2)).range(30,4200),0.8);

        Out.ar(bus, snd.dup * 0.5);

}).add;
)

// Mein Effekt

(
SynthDef(\cheapDelay, { arg gain = 0.5, bus = 0, in = 0, time = 0.2, decay;
	var sig = In.ar(in, 2); //Stereo nicht vergessen !
	var snd = CombC.ar(sig, 1, time,decay, add: sig * 0.8);
	Out.ar(0, snd * gain);
}).add;
)

// Wir erstellen eine Gruppe für die Synth und eine für die Synths und eine weiter für Effekte

~synthgroup = Group.tail(s);
~fxgroup = Group.tail(s);

// Nun können wir unsere Synth Nodes adden...

Synth.tail(~synthgroup, \simpleFM, [\bus, b]);
Synth.tail(~synthgroup, \kleinerSynth, [\bus, b]);
Synth.tail(~synthgroup, \pling, [\bus, b]);
Synth.tail(~synthgroup, \Fabi, [\bus, b]);
Synth.tail(~synthgroup, \rectWobble, [\bus, b]);

//...danach unseren Effekt...
~fx = Synth.tail(~fxgroup, \cheapDelay, [\gain, 0.7, \in, b]);

// ...und nun die Delay Parameter für alle Synths verändern
~fx.set(\decay, 2)
~fx.set(\time, 0.1);




