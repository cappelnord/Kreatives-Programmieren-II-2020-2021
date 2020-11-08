/* =====================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 3
   ------------------------------------

   Sitzung 03 - 05.11.2020

===================================== */


Quarks.gui;


s.boot;
s.scope;
s.meter;


NdefMixer(s);


// -----------------
// Additive Synthese
// -----------------



// Harmonisches Spektrum
// ---------------------------------------------------

(
Ndef(\addHarmonic, { | amp = 0.5 |

	var snd, num_K, f_0, k, phi, a_k;

	num_K = 20;  // Anzahl der Obertöne
	f_0 = 80;  // Grundfrequenz
	k = Array.series(num_K, 1, 1);  // Oberton Ratios
	phi = Array.series(num_K, 0, (2 * pi) / num_K);  // Phasen
	a_k = Array.geom(num_K, 1, 0.8);  // Amplituden

	snd = SinOsc.ar(k * f_0, phi, a_k);

	(snd.sum / num_K) * amp !2;
});
)


Ndef(\addHarmonic).play;
Ndef(\addHarmonic).stop;
Ndef(\addHarmonic).set(\amp, 2.0);
Ndef(\addHarmonic).clear;



(
var num_K = 20, f_0 = 80;

(Array.series(num_K, 1, 1) * f_0).postln;  // Frequenzen
(Array.series(num_K, 0, (2 * pi) / 20)).postln;  // Phasen
(Array.geom(num_K, 1, 0.8)).postln;  // Amplituden
)



// Inharmonisches Spektrum
// ---------------------------------------------------

(
Ndef(\addInharmonic, { | amp = 0.5 |

	var snd, num_K, f_k, phi, a_k;

	num_K = 20;
	f_k = Array.rand(num_K, 80, 1000);  // Odertöne stehen nicht mehr in Verhältnis zu einer Grundfrequenz (siehe "f_0" oben!)
	phi = Array.series(num_K, 0, (2 * pi) / num_K);
	a_k = Array.geom(num_K, 1, 0.8);

	//snd = SinOsc.ar(f_k, phi, a_k);
	snd = SinOsc.ar(\f_k.kr(f_k), phi, a_k);  // Setzten eines Array-Arguments mit .set durch Symbol-Notation ("\f_k.kr()")

	(snd.sum / num_K) * amp !2;
});
)


Ndef(\addInharmonic).play;
Ndef(\addInharmonic).stop;
Ndef(\addInharmonic).set(\amp, 0.8);
Ndef(\addInharmonic).set(\f_k, Array.rand(20, 800, 1000));
Ndef(\addInharmonic).clear;



// Akkord-Verschiebung durch LFO
// ---------------------------------------------------

Ndef(\mod, { | min = 1, max = 2| LFNoise0.kr(SinOsc.kr(1).range(1, 10)).range(min, max) })  // LFO

{ LFNoise0.kr(10).range(0, 10) }.plot(2);  // plot

/*
LFNoise1
LFNoise2
*/


(
Ndef(\addChord, { | amp = 0.5 |

	var snd, freqs, mod;

	freqs = [2034, 578, 432, 334];
	mod = Ndef(\mod);

	snd = Pulse.ar(\freqs.kr(freqs) * mod);

	(snd.sum / freqs.size) * amp !2;
});
)


Ndef(\addChord).play;
Ndef(\addChord).stop;
Ndef(\addChord).set(\freqs, [60, 61, 65, 68].midicps);
Ndef(\addChord).clear;
