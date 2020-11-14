/* =====================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 3
   ------------------------------------

   Sitzung 04 - 12.11.2020

===================================== */


s.boot;
s.meter;
s.scope;
s.freqscope;

NdefMixer(s);



// ------------------------------------------
// Additive Synthese mit dynamischem Spektrum
// ------------------------------------------


(
Ndef(\add, { | amp = 0.5 |

	var num_K, f_0, k, phi, series, a_k, snd;

	num_K = 20; // Anzahl der Obertöne
	f_0 = 150; // Grundfrequez
	k = Array.series(num_K, 1, 0.5); // Ratios Obertöne
	phi = 0; // Phasen

	series = Array.series(num_K, 0.01, 0.1); // Numerische Serie für die "attack" und "decay"
	                                         // Zeiten der Amplitudenhüllkurven der einzelnen
	                                         // Obertöne
	//series = series.reverse;

	a_k = EnvGen.kr(Env([0, 1, 0], [series, series])); // Amplituden
	//a_k = Env([0, 1, 0], [series, series]).kr; // Alternative EnvGen-Notation

	snd = SinOsc.ar(k * f_0, phi, a_k);

	(snd.sum / num_K) * amp !2;
});
)

Ndef(\add).play;
Ndef(\add).stop;
Ndef(\add).clear;


(
var series, a_k, num_K = 20;

series = Array.series(num_K, 0.01, 0.1);
a_k = Env([0, 1, 0], [series, series]);

a_k.plot;
)


// Multichannel Expansion

play{ SinOsc.ar(400, [0, pi / 2]) * 0.2 };
//play{ SinOsc.ar([400, 400], [0, pi / 2]) * 0.2 };




// --------------------
// Subtraktive Synthese
// --------------------


/*

Die Subtraktive Synthese stellt das konzeptuelle Gegenstück zur Additiven
Synthese dar. Die Idee ist von einem spektral komplexen Ausgangssignal
Frequenzanteile zu subtrahieren um so die Klangfarbe zu modellieren.

Wir wollen von einem Pinken Rauschen ausgehend durch eine Filterbank bei
einzelnen Frequenzbändern klare Tonhöhen entstehen lassen.

*/



(
Ndef(\mod, { | amp = 0.5 |

	Decay2.ar(Dust.ar(50), 0.01, 0.04);
});
)


(
Ndef(\sub, { | amp = 0.3, dist = 1 |

	var decay, source, num_flt, freqs, amps, rings, filter_bank, snd;

	decay = Ndef(\mod); // Modulations Signal

	//source = PinkNoise.ar() * 0.01; // Grundsignal für Filter-Input skalieren!
	source = PinkNoise.ar() * decay * 0.01;

	num_flt = 10; // Anzahl der Filterbänder

	freqs = \freqs.kr(Array.rand(num_flt, 100, 500)); // Filter-Frequenzen
	amps = \amps.kr(Array.fill(num_flt, { 1; })); // Amplituden
	rings = \rings.kr(Array.fill(num_flt, { 1; })); // Resonanz-Zeiten

	filter_bank = DynKlank.ar(`[freqs, amps, rings], source); // Resonierende Filterbank mit DynKlank
	                                                          // Array-Notation mit ` beachten!

	snd = GVerb.ar(filter_bank * 0.4, 150, 10).sum * amp; // Hall mit GVerb
	                                                     // (Raumgröße nicht dynamisch ändern! --> siehe Dokumentation)

	snd = (snd * dist).distort;  // Unary operators für Waveshaping --> siehe "Operators" in Dokumentaion

	                             // Durch eine Vorverstärkung mit dem "dist" Argument
	                             // kann die Stärke der Verzerrung gesteuert werden.

});
)


Ndef(\sub).play;
Ndef(\sub).stop;
Ndef(\sub).set(\freqs, Array.series(10, 40, 7).midicps); // Wohltuende Quintschichtung
Ndef(\sub).set(\dist, 1.5);
Ndef(\sub).set(\amp, 1.0);
Ndef(\sub).clear;



// Mit .fill kann man eigene Funktionen zum Befüllen eines Arrays definieren

Array.fill(10, { 1; });
Array.fill(10, { |i| i + i; });


// Plotten eines Signals um den Effekt von Unary Operators für Waveshaping zu betrachten

{ (SinOsc.ar(1) * XLine.kr(1.0, 100.0, 5.0)).tanh * 0.8 }.plot(5) // Hyperbolische Tangens
{ (SinOsc.ar(1) * XLine.kr(1.0, 10.0, 5.0)).distort * 0.8 }.plot(5) // Nicht-lineare Verzerrung



// DESSERT: Chaotische Klanggeneratoren!

play{ Clip.ar(StandardL.ar(k: MouseX.kr(0.1, 1.0)), -1.0, 1.0) * 0.5 !2 }; // --> https://de.wikipedia.org/wiki/Tschirikow-Taylor-Standardabbildung
