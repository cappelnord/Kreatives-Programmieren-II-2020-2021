/*
Im Gegensatz zur Programmierung mit echten Threads bei denen
Sachen prinzipiell gleichzeitig passieren können müssen wir
uns bei sclang keine Sorgen machen. Solange wir in einem
Ausführungsstrang den 'Ball' nicht explizit abgeben wird
unser Code ununterbrochen weiterlaufen.
*/


// Geht nicht weil wir den Haupt-Ausführungsstrang nicht
// unterbrechen dürfen!
(
"Hallo".postln;
5.wait;
"Wie geht es?".postln;
)

// Um .wait nutzen zu können müssen wir die Funktion
// in einen Task packen (bzw. in eine Routine) ...
(
Task({
	"Hallo!".postln;
	5.wait;
	"Wie geht es?".postln;
}).play
)

// ... .fork finde ich hier manchmal praktischer!
// Vorsicht: .fork hat standardmäßig ein schlechteres Timing!
(
{
	"Hallo!".postln;
	2.wait;
	"Wie geht es?".postln;
}.fork;
)

(
SynthDef(\pling, {|freq=440, amp=0.1|
	var sig = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.001, 1), doneAction: 2);
	Out.ar(0, sig.dup * amp);
}).add;
)

Synth(\pling, [\freq, 1000])

// Chromatische Tonleiter über 3 Oktaven
(
Task({
	36.do {|i|
		Synth(\pling, [\freq, (48 + i).midicps, \amp, 0.3]);
		(1/2).wait;
	};
}).play;
)

// Tempo ändern:
TempoClock.default.tempo
// Default: 1 BPS bzw. 60 BPM

TempoClock.default.tempo = 140 / 60;

// Vielleicht merkt ihr, dass das Metrum etwas 'eiert'.
// Das hängt damit zusammen, dass .fork standard


(
SynthDef(\kick, {
	var sig = SinOsc.ar(XLine.ar(800, 60, 0.01), phase: 0.5pi);
	sig = sig * EnvGen.ar(Env.perc(0.001, 0.8), doneAction: 2);
	sig = (sig * 2).tanh;
	Out.ar(0, sig.dup * 0.5);
}).add;


SynthDef(\hat, {
	var sig = PinkNoise.ar();
	sig = RHPF.ar(sig, XLine.ar(14000, 11000, 0.1), 0.5) * 3;
	sig = sig * EnvGen.ar(Env.perc(0.001, 0.1), doneAction: 2);
	sig = sig.tanh;
	Out.ar(0, sig.dup * 0.8);
}).add;
)

Synth(\kick);
Synth(\hat);


(
Task({
	Task({
		inf.do {
			Synth(\kick);
			1.wait;
		}
	}).play;

	0.5.wait;

	inf.do {
		Synth(\hat);
		0.25.wait;
		Synth(\hat);
		0.75.wait;
	};
}).play;
)

/*
Wir werden uns noch mit Patterns beschäftigen mit denen
musikalisches Scheduling noch deutlich einfacher/komfortabler wird!
*/


// === Zufall in SuperCollider ===

// Insider-Fact: SuperCollider nutzt Taus88 als Pseudozufallszahlengenerator.

// von 0-5
6.rand;

// von 1-6
(1 + 6.rand)

// Gleitkommazahl
6.0.rand



(
{
	36.do {|i|
		Synth(\pling, [\freq, 440 + 440.0.rand, \amp, 0.3]);
		(1/2).wait;
	};
}.fork
)


// range rand
440.0.rrand(880.0)
rrand(440.0, 880.0)

// gleichmäßig verteilt
5.0.rand

// wahrscheinlichkeit sinkt linear
5.0.linrand

// Auf Histogrammen kann man die Verteilung gut sehen.
Array.fill(20000, {100.rand}).histo.plot(minval: 0)
Array.fill(20000, {100.linrand}).histo.plot(minval: 0)

// Fallgrube:
Array.fill(20000, {100.rand}).histo.plot

// Beachtet hier, dass der angezeigte Wertebereich bei .plot
// sich nach den Daten richtet. Hier sieht man die lineare
// Verteilung nur schlecht weil auf der Y-Achse nur einen
// Ausschnitt anzeigt.


