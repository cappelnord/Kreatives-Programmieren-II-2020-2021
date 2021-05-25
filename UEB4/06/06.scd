
// Fast alles was ich euch heute zeige, ist inspiriert von Marije Baalmans Kurs "Designing interactive sound for performative contexts" !

// Check check check 1 2 3
{SinOsc.ar(440) * 0.3}.play;

s.scope;

MIDIClient.init;
MIDIIn.connectAll();

// Alle argumente

(
MIDIdef.cc(\raw, {|...args|
	args.postln;
})
)

// Alle control values

(
MIDIdef.cc(\raw, {|cv, cc|
	cv.postln;
})

// Wir speichern unsere ccvalues in einer Liste speichern
// Dadurch können wir sie im nachhinein analysieren

(
~history = List.new;
MIDIdef.cc(\raw, {|cv, cc|
	cv.postln;
	~history.addFirst(cv);
});
)

// Werte Einsehen

~history.postln;
~history.plotHisto(127,0, 127);

// Später sehen wir aus unseren History Werten auch weitere Parameter generieren können.
// Zum Beispiel indem aus allen Werten den durchschnitt ziehen:
~history.mean
// Oder diese rotieren:
~history.rotate(4)

// Einfacher Synth mit schmalen Filter
(
SynthDef(\FilterNoise, {| amp = 0.9, ffreq = 800, bwr = 0.01, delayTime = 0.5|

	var snd = Resonz.ar(WhiteNoise.ar(3), ffreq, bwr);
	snd = CombC.ar(snd, 2, delayTime, 1, add: snd * 0.9);

	Out.ar(0, snd.dup * amp)
}).add;
)

// Die history steuert die DelayTime welche sich dadurch dass wir immer den durchschnitt aller bisherigen Werte berechnen sehr viel träger verhält
// Dadurch steuern wir mit dem cv direkt einen Filter und die DelayTime richten sich danach in welchem gröberen Frequenzbereich wir uns währenddessen auffhalten:

s.freqscope;

// Ein Beispiel mit exponentiellen Mapping + History
(
~hist = List.new;

y = Synth(\FilterNoise);

MIDIdef.cc(\simpleMap, {|cv, cc|
	//cv.postln;
	~hist.addFirst(cv);
	y.set(
		// exponentielles mapping
		\ffreq, cv.linexp(0, 127, 100, 2000),
		// lineares mapping + round
		\delayTime, ~hist.mean.linlin(0, 127, 0.01, 2).round(0.1).postln;
	);
})
)

// Das selbe nochmal mit fold
(
~hist = List.new;
~min = 500;
~max = 1500;
y = Synth(\FilterNoise);

MIDIdef.cc(\FoldMap, {|cv, cc|
	//cv.postln;
	~hist.addFirst(cv);

	y.set(
		if (cv.linexp(0, 127, 100, 2000)<= ~min, {"fold up !".postln;}, {});
		if (cv.linexp(0, 127, 100, 2000) >= ~max, {"fold down !".postln;},{});

		// fold klappt unsere Werte ab min bzw max nach oben bzw nach unten
		\ffreq, cv.linexp(0, 127, 100, 2000).fold(~min,~max).postln;,

		// lineares mapping + round
		\delayTime, ~hist.mean.linlin(0, 127, 0.01, 2).round(0.1);
	);
})
)

// Custom Mapping mit Custom Envelopes ! Wuhu !
// Wir erstellen uns eine Kurve

(
~customEnv = Env(
	[100, 200, 1200, 100, 1500],
	[0.1, 0.5, 1, 3],
	[\lin, 3, 7, 5])
)

 // So sieht sie aus
~customEnv.plot;

// Nun nutzen wir unsere control values um mithilfe von .at aus unserer Kurve den passenden Wert (Y-Achse, bzw amplitude)
// zur passenden Zeit (X-Achse) auszulesen:
// Dies hat den Effekt dass wir mit unseren Poti die Kurve "abfahren" können.

(
y = Synth(\FilterNoise);

MIDIdef.cc(\Env, {|cv, cc|
	["Raw: " ++ cv].postln;
	"Envelope: ".postln;
	y.set(\ffreq, ~customEnv.at(cv.linlin(0, 127, 0, 4.5)).postln);
});
)

MIDIdef(\Env).free;
