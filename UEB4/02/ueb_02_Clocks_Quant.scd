// Wiederholung Audio Bus und Control Bus

b = Bus.audio(s, 2);
c = Bus.control(s, 1);

{SinOsc.ar(440)}.play;

(
SynthDef(\a, { |freq = 440|
	var sig = SinOsc.ar(freq) * 0.3;
	var ctrl = SinOsc.kr(XLine.kr(1, 500, 10)) * 500;
	Out.kr(c, ctrl);
	Out.ar(b, sig!2);

}).add;
)

// Der Control Bus kontrolliert unseren Filter

(
SynthDef(\b, {
	var sig = In.ar(b, 2);
	var snd = RLPF.ar(sig, 1000 + In.kr(c, 1) , 0.3);
	Out.ar(0, snd * 0.5);
}).add;
)

(
x = Synth(\a);
y =Synth(\b, addAction: 'addToTail');
)


// Kontrollbusse können wir auslesen (c.get) und verändern (c.set)
// In diesem Beispiel lesen wir den Bus aus und setzen seinen Wert (value) als \freq argument unseres Synth(\a).
// Wenn wir geringere wait time verringern, können wir hören wie sich setzung der Frequenz immer mehr einer Modulation durch einen Oszillator gleicht.

(
x = Synth(\a);
y =Synth(\b, addAction: 'addToTail');

Tdef(\a,
	{
		loop{
			c.get({arg value; x.set(\freq, value.abs.postln)});
			0.1.wait;  // Hier besser keine kleineren Werte als 0.001 einfügen !!
		}
	}
).play;
)

//////////////////////////////////////////////////////////////////// Clocks + Quant ///////////////////////////////////////////////////////////////////

// Einfache Drum Synths
(
SynthDef(\kick,{
	var snd = SinOsc.ar(XLine.kr(500,50,0.1));
	var env = EnvGen.ar(Env.perc(0.01, 1), doneAction: 2) * 0.5;
	Out.ar(0, snd!2 * env);
}).add;



SynthDef(\snare,{|ffreq = 4000|
	var snd = RLPF.ar(WhiteNoise.ar(0.5), ffreq, 1);
	var env = EnvGen.ar(Env.perc(0.01, 0.1), doneAction:2) * 0.5;
	Out.ar(0, snd!2 * env);
}).add;
)


// AppClock
// SystemClock
// TempoClock

// Mit der System Clock können wir Events abhängig zur Zeit (in sek) planen und abspielen
(
SystemClock.sched(0.5,{
	Synth(\kick);
});
)


// TempoClock funktioniert ähnlich wie SystemClock, allerdings nicht relativ zur Zeit sondern zum jeweiligem tempo:
(
TempoClock.sched(0.2,{
	Synth(\snare);
});
)

// Unsere kick wird immer zum nächsten (t.beats.ceil) ganzen beat abgespielt
(
t = TempoClock(1);
t.schedAbs(t.beats.ceil, { Synth(\kick); 1});
)

// nun können wir das tempo ändern
t.tempo = 2;
t.tempo = 4;
t.tempo = 0.5;
t.tempo = 1;

// Und die Beats unserer Clock Abfragen

// vergangene Beats
t.elapsedBeats;

// nächster Beat
t.elapsedBeats.ceil;

// letzter Beat
t.elapsedBeats.floor;

(
t = TempoClock(1);
t.schedAbs(t.beats.ceil, { Synth(\kick);
	"letzter Beat:".postln; t.elapsedBeats.floor.postln;
	"nächster Beat:".postln; t.elapsedBeats.ceil.postln; 1});
)

// AppClock für GUIs. Diese ist nicht exakt genug für musikalischesTiming. Dafür haben wir die SystemClock und die TempoClock !
// Beispiel aus composerprogrammer.com: https://composerprogrammer.com/teaching/supercollider/sctutorial/Technicalities/05%20Clocks%20and%20Scheduling.html
(
var w, i;
	i = 0;

	w = Window("My Window", Rect(100, 0, 200, 50));
	// A 200 by 200 window appears at screen co-ordinates (100, 0)
	w.front;
	//schedule moves and resizes for the window
	AppClock.sched(0.0, {

		w.bounds_(Rect(100, (10 * i) % 500, rrand(200,400), 50));
		i=i+1;
		0.125

	});
)

// tempo Clock und Patterns

(
t = TempoClock(1);
t.tempo = 120 / 60;
t.schedAbs(1,{

	Pbind(\instrument, \kick,
		\dur, Pseq([1, 0.5, 0.5], inf)

).play;}
)
)

(
t.schedAbs(1,{

	Pbind(\instrument, \snare,
		\dur, Pseq([1, 0.5, 0.25, 0.25], inf),
		\ffreq, Pwhite(1500,2000,inf);
).play;}
)
)

// Dies geht auch einfacher mit quant ! Mit quant können wir Routinen, Tasks und Pattern abhängig der beats unserer TempoClock abspielen. Geben wir nichts weiteres an gescheiht dies nach der default TempoClock.

TempoClock.default.tempo;

// quant: 1 für den nächsten ganzen beat der Clock
(
Pbind(\instrument, \snare,
	\dur, Pseq([1, 0.5, 0.25, 0.25], inf),
	\ffreq, Pwhite(3500, 3550,inf);
).play(quant: 1);
)


(
Pbind(\instrument, \kick,
	\dur, Pseq([1, 0.5, 0.25, 0.25], inf),
	\ffreq, Pwhite(1500, 1550,inf);
).play(quant: 1);
)

//Funktioniert auch sehr gut mit Pdefs. Verändern wir die Werte im Pseq und führen ihn nochmals aus wird dieser an genau der selben Stelle (selber Schlag bzw. beat) ausgeführt

(
Pdef(\k,
	Pbind(\instrument, \kick,
		\dur, Pseq([1, 0.1, 0.1, 0.25, 0.25] * 1, inf),
		\ffreq, Pwhite(1500, 1550,inf);
	);
)
)

x = Pdef(\k).play(quant: 1);



// Ndefs mit quant: Wenn wir die Werte  ändern (und den Ndef erneut ausführen) bleibt unser Pulse.kr modulator immer gesynced

Ndef(\a, { SinOsc.ar([XLine.kr(500, 700, 30), 351])  * Pulse.kr(1) * 0.2});
Ndef(\b, { Pulse.ar([60, 61])  * Pulse.kr(1) * 0.2});


Ndef(\a).quant = 1.0;
Ndef(\b).quant = 1.0;

Ndef(\a).play;
Ndef(\b).play;

Ndef(\a).fadeTime = 2;
Ndef(\b).fadeTime = 4;


Ndef(\a).free;
Ndef(\b).free;


//  Scheduling and Server timing... Haben wir leider nicht mehr geschafft, dazu kommt evtl noch etwas nächstes mal !
