/* =====================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 3
   ------------------------------------

   Sitzung 10 - 14.01.2021

===================================== */


/*
(
fork{
	2021.do{
		"Happy New Year!".postln;
		0.1.wait;
	};
}
)
*/


s.meter;
s.scope;



//---------
// FEEDBACK
//---------


/*
  In SuperColldier gibt es verschiedene Arten Feedback zu erzielen.
  Wir beutzen "Ndefs" in dem wir diese "verschachtelt" aufrufen.
*/


// Bei der Nutzung von "Ndefs" in Feedback-Schleifen ist man an eine
// zeitliche Verzögerung gebunden. Genauer genommen wird das Output-
// Signal genau um eine Kontrollperiode versetzt wieder in den Input
// eingeschleift.

s.sampleRate;
s.options.blockSize; // Anzahl der Samples in einer Kontrollperiode (default: 64)

s.sampleRate / s.options.blockSize; // Dauer einer Kontrollperiode in Frequenz

play{ SinOsc.ar(689.0625) * 0.3 };


// WARNUNG: das folgende ist ein Negativbeispiel => NICHT AUSFÜHREN!
/*
(
Ndef(\feedback, {
	Impulse.ar(10) + Ndef.ar(\feedback); // Signal-Umfang wird nicht kontrolliert.
                                         // Summiert sich progressiv auf!
})
)
*/


// Bei Feedback müssen wir uns gewisser Strategien bedienen um das Signal
// nicht "unendlich" in seiner Amplitude steigen zu lassen.
// Hierzu bedienen wir uns einiger "Unary Operators" (siehe in SCDoc unter
// "Operators"): .tanh, .clip, .softclip


//----------------------------------------------------------
// Kurzer Exkurs zu Waveshaping

{ SinOsc.ar(mul: MouseX.kr(0.1, 30)).tanh }.play;
{ SinOsc.ar(1, mul: XLine.kr(0.5, 30, 5.0)).tanh }.plot(5);
{ SinOsc.ar(1, mul: XLine.kr(0.5, 30, 5.0)) }.plot(5);
//----------------------------------------------------------


(
Ndef(\feedback, {
	Dust2.ar(10) + (
		Ndef.ar(\feedback) * MouseX.kr(0.3, 1.1) // Mit der Mouse steuern wir die
		                                         // Amplitude des rückgekoppelten
		                                         // Signals und somit den Feedback-
		                                         // Anteil.
	).tanh; // WICHTIG: .tanh verhindert das
	        // "Explodieren" des Signals!
})
)

(
Ndef(\feedback, {
	SinOsc.ar(400) + (
		Ndef.ar(\feedback) * MouseX.kr(0.3, 1.5)
	).tanh
})
)


// GRUNDREZEPT______________________
(
Ndef(\feedback, {

	// Quelle
	SinOsc.ar(400) +

	(
		// Rekursion
		Ndef.ar(\feedback) *

		// Amplitude (Feedback Anteil)
		MouseX.kr(0.3, 1.5)
	).tanh
})
)
// _________________________________


(
Ndef(\feedback, {
	Dust2.ar(10) + (

		// Durch das Einfügen eines Delays (zeitliche Verzögerung)
		// ist es uns nun möglich die Frequenz die druch die Rückkopplung
		// entsteht zu steuern.
		AllpassN.ar(
			Ndef.ar(\feedback),
			0.2,
			MouseY.kr(0.01, 0.2)
		) * MouseX.kr(0.3, 1.1)
	).tanh;
})
)


(
Ndef(\feedback, {

	GVerb.ar(
		(
			(SinOsc.ar([55, 110, 220, 440] + SinOsc.ar(LFDNoise3.kr(10).range(100, 120)).range(-100, 100)).sum / 4) +
			(
				AllpassC.ar(Ndef.ar(\feedback), 0.2, MouseY.kr(0.01, 0.2)) *
				MouseX.kr(0.3, 1.5)
			).tanh
		) * 0.2, // Hier das Signal noch skalieren!
		100
	).sum
})
)


Ndef(\feedback).play;
Ndef(\feedback).stop;

Ndef.all.do(_.clear);

NdefMixer(s);


//------------------------------------------------------------
// Kurzer Exkurs zu DC-offset

// Bei Experimenten mit Feedback kann es gelegentlich zu
// DC-offfset im Signal kommen. Um diesen zu eliminieren
// kann man den "LeakDC" Filtern anwenden.

play{ DC.ar(0.5) };

play{ (SinOsc.ar(689.0625) * 0.3) + DC.ar(0.5) };

play{ LeakDC.ar(DC.ar(0.5)) };

play{ LeakDC.ar((SinOsc.ar(689.0625) * 0.3) + DC.ar(0.5)) };
//------------------------------------------------------------
