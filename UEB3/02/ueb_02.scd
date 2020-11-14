/* =====================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 3
   ------------------------------------

   Sitzung 02 - 29.10.2020

===================================== */


// --------
// Semikola
// --------


// Bei einzelnen Zeilen ist die Nutzung nicht relevant

"hallo".postln
"hallo".postln;


// Bei Ausführen von Code Blöcken ist die Nutzung relevant da sonst
// einzelne Zeilen nicht als separate Befehle interpretiert werden.

(
"hallo".postln

"tschüss".postln
)

(
"hallo".postln;

"tschüss".postln
)


// Das Gleiche gilt für die Nutzung in Funktionen

(
10.do{ |i|

	i.postln

	(i + 1).postln
}
)


(
10.do{ |i|

	i.postln;

	(i + 1).postln
}
)



// ------
// Zähler
// ------


(
var counter = 0;  // Definition eines Zählers mit lokaler Variable

10.do{ |i|

	counter.postln;

	counter = counter + 2;
}
)


// Das Zähler-Argument in verschachtelten Loops

(
2.do{ |i|

	("i: " ++ i).postln;

	2.do{ |j|

		("j: " ++ j).postln;
	};
}
)


(
2.do{ |i|

	("i: " ++ i).postln;

	2.do{ |j|

		("ii: " ++ i).postln;
	};
}
)


(
2.do{ |i|

	("i: " ++ i).postln;

	2.do{

		("ii: " ++ i).postln;
	};
}
)



// ----------------
// Unipolar/Bipolar
// ----------------


// Server booten plus nützliche GUI-Utilities

s.boot;
s.scope;
s.meter;
s.freqscope;



// Signale plotten um Phase und Polarität zu Visualisieren

{ SinOsc.ar(400) * 0.5 !2 }.play;  // Test Sound


{ SinOsc.ar(1) }.plot(1);  // Einie Phase einer Sinuswelle
{ SinOsc.ar(1, pi / 2) }.plot(1);  // Einie Phase einer Kosinuswelle


{ SinOsc.ar(1) * 0.5 + 0.5 }.plot(1);  // Skalierung des Signals auf 0 - 1
{ SinOsc.ar(1).range(0, 1) }.plot(1);  // Das Gleiche mit .range()


{ SinOsc.ar(400) * SinOsc.ar(1) }.plot(1);  // Da unser Modulationssignal eine Frequenz von 1 Hz hat aber bipolar
                                            // ist, resultiert durch die Multiplikation eine Modulation von 2 Hz.

{ SinOsc.ar(400) * SinOsc.ar(1).range(0, 1) }.plot(1);  // Um eine Modulation von 1 Hz zu erzielen,
                                                        // müssen wir das Signal auf 0 - 1 skalieren.

{ SinOsc.ar(400) * SinOsc.ar(1, (3 / 2) * pi).range(0, 1) }.plot(1);  // Um das modulierte Signal bei 0 anfagen zu lassen,
                                                                      // müssen wir noch die Phase um 270° verschieben.



// --------------------
// Modulation mit Ndefs
// --------------------


NdefMixer(s);  // NdefMixer GUI



// Einfache Modulation

Ndef(\a, { SinOsc.ar(400) * SinOsc.ar(MouseX.kr(1, 100)).range(0, 1) !2 });

Ndef(\a).play;
Ndef(\a).stop;



// Ndef mit Argumenten und lokalen Variablen zur besseren Code-Strukturierung

(
Ndef(\aa, { | freqSnd = 300, freqMod = 10 |

	var snd, mod;

	snd = SinOsc.ar(freqSnd);
	mod = SinOsc.ar(freqMod).range(0, 1);

	snd * mod;
});
)

Ndef(\aa).fadeTime = 2.0;

Ndef(\aa).play;
Ndef(\aa).stop;
Ndef(\aa).clear;

Ndef(\aa).set(\freqSnd, 200);



// Definition des Modulationssignals als separaten Ndef
// und verschachtelung von Ndefs

Ndef(\mod, { | freq = 1 | SinOsc.ar(freq).range(0, 1) });
Ndef(\mod).set(\freq, 10);


(
Ndef(\snd, { | freq = 300 |

	var snd, mod;  // Lokale Variablen

	snd = SinOsc.ar(freq);
	mod = Ndef(\mod);  // Modulationssignal Ndef

	snd * mod;
});
)

Ndef(\snd).play;
Ndef(\snd).stop;



// Wobble Bass


//{ LFSaw.ar(1, 1).range(0, 1) }.plot(2);
//{ LFTri.ar(1, 3).range(0, 1) }.plot(2);


//Ndef(\mod2, { | freq = 10 | LFSaw.ar(freq).range(30, 1000) });
//Ndef(\mod2).set(\freq, 10);


Ndef(\mod2, { LFTri.ar(SinOsc.ar(0.2).range(1, 10)).range(30, 1000) });


(
Ndef(\wobble, { | freq = 40 |

	var snd, mod, filter;

	snd = Pulse.ar(freq);  // Grundsignal
	mod = Ndef(\mod2);  // Modulationssignal zur Modulation der Filterfrequenz
	filter = RLPF.ar(snd, mod, 0.1);  // Tiefpassfilter

	filter * 0.2 !2;  // Ausgangssignal (Pegel skaliert!)
});
)

Ndef(\wobble).play;
Ndef(\wobble).stop;



// Nützliche Methoden zur Ausführung auf alle Ndefs

Ndef.all.do(_.clear);
Ndef.all.do(_.stop);



// Einige UGens für Modulationssignale

/*
SinOsc
Saw
Pulse
LFTri
LFSaw
LFPulse
LFNoise0
LFNoise1
LFNoise2
*/
