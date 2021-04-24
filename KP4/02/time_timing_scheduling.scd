// Siehe: Scheduling and Server timing

// logical time
TempoClock.default.beats

 // physical time
TempoClock.default.elapsedBeats


(
10000.do {
	TempoClock.default.beats.postln;
};
)

(
10000.do {
	TempoClock.default.elapsedBeats.postln;
};
)


(
SynthDef(\pling, {
	var sig = SinOsc.ar(440);
	sig = sig * EnvGen.ar(Env.perc(0.0001, 0.01), doneAction: 2);
	Out.ar(0, sig.dup * 0.3);
}).add;
)

s.scope


// Klingt wahrscheinlich nicht zusammen:
// Ein einfacher Aufruf von Synth nutzt keine time stamps.
(
Synth(\pling);
4000.do {
	TempoClock.default.beats.postln;
};

Synth(\pling);
4000.do {
	TempoClock.default.beats.postln;
};

Synth(\pling);
)

// Sollte zusammen erklingen!

(
(instrument: \pling).play;

4000.do {
	TempoClock.default.beats.postln;
};

(instrument: \pling).play;
4000.do {
	TempoClock.default.beats.postln;
};

(instrument: \pling).play;
)

// Reduziert man die Latenz kommt es zu "late" Nachrichten
s.latency = 0.05;

// Keine Latenz (z.B. gut wenn man Interfaces nutzt)
s.latency = nil;

// Standard
s.latency = 0.2;



// AppClock, TempoClock, SystemClock

// beste Genauigkeit
TempoClock.default.tempo

// SystemClock selbe Genauigkeit wie TempoClock aber bietet
// weniger Funktionen zur Gestaltung von "Musik".

// AppClock kann GUIs erstellen/modifizieren.
// AppClock auch die Clock auf der Code ausgeführt wird
// den man in der IDE ausführt.


(
w = Window("Hi", 400@400);
b = StaticText(w, Rect(40, 40, 200, 200));
b.string = "Hallo";
w.front;
)

// geht
b.string = "Hallo!";


// geht
(
Routine({
	"Hi".postln;
	1.wait;
	{b.string = "Blablablalba"}.defer;
}).play(AppClock);
)

// geht nicht!
(
Routine({
	"Hi".postln;
	1.wait;
	{b.string = "Blablablalba"}.defer;
}).play(AppClock);
)




// Siehe TempoClock

TempoClock.default.beats

(
TempoClock.default.sched(10, {
	"Hallo!".postln;
});
)

(
TempoClock.default.schedAbs(3820, {
	(instrument: \pling).play;
});
)


// Wir versuchen uns einen eigenen Impuls Oszillator zu bauen
// mit Scheduling (scheitern aber effektiv!)

(
SynthDef(\imp, {
	var sig = Impulse.ar(0);
	Line.kr(0, 0.1, 0.001, doneAction: 2);
	// würden wir hier Out nutzen hätten wir nur Impulse
	// am Anfang jedes Blocks (s.options.blockSize)
	OffsetOut.ar(0, sig.dup * 0.2);
}).add;
)

Synth(\imp)

(
Routine({
	5000.do {
		(instrument: \imp).play;
		(16 / s.sampleRate ).wait;
	};
}).play(TempoClock.default);
)


