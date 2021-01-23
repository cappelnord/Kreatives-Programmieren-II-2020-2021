/* =====================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 3
   ------------------------------------

   Sitzung 11 - 21.01.2021

===================================== */


s.meter;
s.scope;


//--------
// BUFFERS
//--------


b = Buffer.alloc(s, 1024); // Allozieren eines Buffers (Werte sind aif 0 initilisiert)
b.bufnum; // Jeder Buffer bekommt einen ID über die man auf den Buffer zugreien kann.
b;

b.plot;


// Man kann nun beliebige Werte an bestimmte Stellen (Indizes)
// des Buffers schreiben. So können Buffer als Wavetables benutzt
// werden.

// Schreiben wir z.B eine Phase einer Sinuswelle in einen Buffer
// um diesen dann mit einer gewissen Geschwindigkeit (Rate) abzu-
// lesen.

/*-------------------------------------

sine:

      pi/2
     /    \
    /      \
   /        \
  /          \
 /            \
0	           pi              2pi
                \             /
                 \           /
                  \         /
                   \       /
                    \     /
                     3/2pi

-------------------------------------*/

// Erst schreiben wir die numerischen Werte
// in einen Array. Der Array muss die gleiche
// Größe des Buffers haben.
(
a = Array.fill(1024,
	{
		|i|
		sin((i / 1023) * 2pi); // Sinusfunktion
	};
);
)

a.plot;

// Jetzt können wir den Array in den Buffer laden.
b.loadCollection(a);


// Mann kann nun auch komplexere Wellenform über
// mathematische Funktionen erstellen und in den
// Buffer schreiben.
(
a = Array.fill(1024,
	{
		|i|
		(sin((i / 1023) * 2pi) ** 2) +
		(cos((i / 1023) * 2pi) ** 3);
	};
);
)


a.plot;
a = a.normalize(-1, 1) // Bie experimentelleren Daten ist es
                       // wichtig die Werte des Arrays zunächst
                       // auf den Audio-Wertebereich (-1, 1)
                       // zu normalisieren

b.loadCollection(a);

b.play(true); // Direktes Abspielen/Loopen des Buffers


// Abspielen des Buffers mit "PlayBuf"
(
play{
	PlayBuf.ar(
		1,
		b.bufnum,
		BufRateScale.kr(b.bufnum) * 2.0, // Durch die Multiplikation mit
		                                 // bestimmten Werten kann man nun
		                                 // die Abspielgeschwindigkeit
                                         // steuern (z.B. * 2.0 = doppelt so
                                         // schnell, * 0.5 = halb so schnell)
		loop: 1.0
	) * 0.5;
};
)


s.sampleRate / b.numFrames; // Frequenz bei nicht skalierter Auslesung
                            // des Buffers.

1 / (s.sampleRate / b.numFrames); // Länge des Buffers in sec.


// In Buffer kann man auch schon bestehende Audiofiles einlesen und
// abspielen.

b = Buffer.read(s, "~/Desktop/a11wlk01-44_1.aiff"); // Alloziert automatisch
                                                    // einen Buffer mit der
                                                    // richtigen Größe und
                                                    // liest die Audiodatei ein
b.numFrames;

(
play{
	PlayBuf.ar(
		1,
		b.bufnum,
		BufRateScale.kr(b.bufnum) * MouseX.kr(0.5, 2.0),
		loop: 1.0
	) !2 * 0.5;
};
)


// Eine alternative und flexiblere Methode zu "PlayBuf" ist "BufRd".
// Wir haben nun die Möglichkeit direkt den Buffer üner ein Audiosignal
// zu inidizieren.
(
play{
	BufRd.ar(
		1,
		b.bufnum,
		// Hier indizieren wir den Buffer mit einem Audiosignal. Phasor ist
		// ein Rampengenerator und ermöglichtes uns nun den Buffer sequentiell
		// zu indizieren und somit den Buffer abzuspielen.
		Phasor.ar(0, BufRateScale.kr(b.bufnum), 0.0, BufFrames.kr(b.bufnum))
	) !2 * 0.5;
};
)


(
play{
	BufRd.ar(
		1,
		b.bufnum,
		// Hier indizieren wir nun beliebuge Indices im Buffer und hören
		// somit nicht mehr den original Klang.
		LFNoise0.ar(s.sampleRate).range(0.0, BufFrames.kr(b.bufnum))
	) !2 * 0.5;
};
)


(
play{
	var chunk, index;

	chunk = MouseX.kr((s.sampleRate / 64), (s.sampleRate / 2)); // Größe des abzuspielenden
	                                                            // Abschnitts

	index = LFNoise0.kr(0.5).range(0.0, (BufFrames.kr(b.bufnum) - chunk)); // Indizierungssignal

	BufRd.ar(
		1,
		b.bufnum,
		Phasor.ar(
			0,
			BufRateScale.kr(b.bufnum),
			index,
			index + chunk
		) !2 * 0.5;
	)
};
)
