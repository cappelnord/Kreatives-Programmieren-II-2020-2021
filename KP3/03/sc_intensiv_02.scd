// SuperCollider Intensiv 02
// 04.11.2020

// Arrays

// Help: Array
// Help: ArrayedCollection
// Help: SequencableCollection

// Funktionieren erstmal wie in Python ...
// ... ich muss euch das nicht noch mal erklären :)s

x = [1, 4, 10, 100];
x[1]; // zweites Element
x[0]; = 1000 // Zuweisung

// Arrays können Objekte mit verschiedenen Typen beinhalten
y = [100, "ABC", SinOsc];

// Arrays können verschachtelt sein
x = [100, [1000, 2000], 200];
x[1][0] = "Apfel";
x;

// Arrays enthalten nur Referenzen auf Objekte
// somit enthählt Objekt b hier nicht 3 unterschiedliche Arrays
// sondern 3 mal den selben Array
a = [1000, 2000];
b = [a, a, a];
a[0] = "Birne";
b;

// Mit .copy erhalten wir voneinander unabhängige Kopien
// von Objekten.
c = [a.copy, a.copy, a.copy];
c[0][0] = "Kiwi";
c;

// (Hinweis: .deepCopy kopiert Datenstrukturen
// inklusiver aller Unterlemente)


// SuperCollider bringt viele Funktionen für Arrays
// bereits mit! Mehr dazu in den oben referenzierten
// Hilfedateien.

[100, 200, 400].size;
[100, 200, 400].sum;
[100, 200, 400].mean;

[100, 200, 300, 400].scramble;
[100, 200, 300, 400].rotate(1);
[100, 200, 300, 400].rotate(-1);
[100, 200, 300, 400].first;
[100, 200, 300, 400].last;
[100, 200, 300, 400].indexOf(300);


// Ergebnis: nil
[100, 200, 300, 400].indexOf(101)

// Pythone: None
// Null, undefined
// nil wurd oft benutzt um das Abhandensein eines
// Objekts oder Ergebnisses auszudrücken.



// Ausblick: .do habt ihr bereits als
// Zählschleife gesehen. .do funktioniert
// auch wunderbar um über Arrays zu iterieren!

(
[100, 200, 300, 400].do {|x, i|
	x.postln;
	i.postln;
};
)


// Operationen auf Arrays

// Die meisten mathematischen Operationen können auch
// auf Arrays angewandt werden. Hierbei wird die Operation
// auf jedes Element des Arrays angewandt, Ergebnis ist
// ein neuer Array.

[20, 30, 30] * 10;
[100, 200, 300] + 1;
[0.1, 0.2, 0.3, 0.4].sin;
[1, -3, 10, -2].abs;
[1, 2, 3, 4, 5].pow(2);

// Dies gilt auch bei verschachtelten Arrays!
[1, [10, 100], 1000] * 2;

// Werden 2 Arrays miteinander verrechnet dann werden
// jeweils die Komponenten miteinander verrechnet
[1, 2, 3] * [1, 10, 100];

// Haben die Arrays nicht die selbe Länge dann
// wird bei den kürzeren Arrays wieder von Vorne begonnen
[1, 2, 3, 4, 5, 6, 7, 8, 9] * [1, 10, 100, 1000];
[1, 2, 3, 4, 5] * [10, 100, 1000] + [0, 1];


// Auf Seiten der Klangsynthese repräsentieren Arrays
// Mehrkanalsignale. Diese können entweder nur intern
// geführt werdeen (und später zusammengemischt werden)
// oder aber auch an die Soundhardware ausgegeben werden.

// Merken: Die Anzahl der verbundenen Ein-/Ausgänge muss
// vor dem Booten des Servers festgelegt werden.

s.options.numOutputBusChannels = 8;
s.options.numInputBusChannels = 8;

// Stereo ...
// Multichannel ...
// 64 Kanäle ...
// usw.


s.scope;


(
Ndef(\stereo, {
	[SinOsc.ar(440), Saw.ar(50)] * 0.2;
});
)

Ndef(\stereo).play

// Hinweis: Der ! ist eine Kurzform der .dup
// Nachricht, und erzeugt einen Array in den
// das Objekt mehrfach eingebettet wird.

"Hallo" ! 2
"Hallo" ! 4

"Hallo".dup
"Hallo".dup(4)

(
Ndef(\stereo, {
	SinOsc.ar(440) ! 2 * 0.2;
});
)

Ndef(\stereo).stop;


// Einfaches Stereo-Panning erhalten wir mit dem
// Pan2 Ugen.

// Help: Pan2

Ndef(\pan, {Pan2.ar(WhiteNoise.ar * 0.1, -1)});
Ndef(\pan).play;

Ndef(\pan, {Pan2.ar(WhiteNoise.ar * 0.1, 0)});
Ndef(\pan, {Pan2.ar(WhiteNoise.ar * 0.1, 1)});
Ndef(\pan, {Pan2.ar(WhiteNoise.ar * 0.1, 0.75)});
Ndef(\pan, {Pan2.ar(WhiteNoise.ar * 0.1, SinOsc.kr(1))});

Ndef(\pan).stop;


// Multichannel Expansion
// Help: Multichannel Expansion

// 1-Kanal Signale können durch eine arithmetische
// Operation mit einem Array zu 2 Signalen expandiert werden.

(
Ndef(\mexp, {
	Saw.ar(50) * [0.1, 0.2]
});
)

Ndef(\mexp).play

(
Ndef(\mexp, {
	Saw.ar(50) * [SinOsc.kr(0.5), SinOsc.kr(0.52)] * 0.4
});
)

// Jedochen reicht es hier bereits aus, dass an vieler
// Stelle Arrays als Argumente genutzt werden um
// Mehrkanal-Signale zu erzeugen.

Saw.ar([50, 100]); // [ a Saw, a Saw]

(
Ndef(\mexp, {
	Saw.ar([50, 100]) * 0.4
});
)

(
Ndef(\mexp, {
	Saw.ar([50, 100]) * SinOsc.ar([0.5, 0.52]) * 0.4
});
)


// .sum kann genutzt werden um mehrere Kanäle
// zusammen zu mischen. Alternativ: Mix bzw. Mix.ar

// Help: Mix

(
Ndef(\mexp, {
	var freqs = [100, 102, 800, 322, 2000];
	var amps =  [0.1, 0.2, 0.1, 0.4, 0.2];
	var sigs = SinOsc.ar(freqs) * amps;
	sigs.sum ! 2 * 0.3
});
)

// Splay ist ein praktischer UGens um mehrere
// Kanäle im Stereo-Panorama verteilt zusammenzumischen

(
Ndef(\mexp, {
	var freqs = [100, 102, 800, 322, 2000];
	var amps =  [0.1, 0.2, 0.1, 0.4, 0.2];
	var sigs = SinOsc.ar(freqs) * amps;
	Splay.ar(sigs);
});
)

Ndef(\mexp).stop;

// Die Klasse Array hat verschiedene Klassenmethoden
// um Arrays zu erzeugen (Help: Array)

Array.series(16, 1, 1);
Array.series(16, 1, 1) * 220; // (harmonische Obertonreihe)

Array.rand(16, 20, 2000);
Array.exprand(16, 20, 2000);

(
Ndef(\cluster, {
	Splay.ar(SinOsc.ar(Array.exprand(12, 20, 2000))) * 0.6
});
)

Ndef(\cluster).fadeTime = 5;

Ndef(\cluster).play;

Ndef(\cluster, {Splay.ar(SinOsc.ar(Array.exprand(8, 20, 200))) * 0.6});
Ndef(\cluster, {Splay.ar(SinOsc.ar(Array.exprand(8, 20, 400))) * 0.6});
Ndef(\cluster, {Splay.ar(SinOsc.ar(Array.exprand(8, 20, 800))) * 0.6});
Ndef(\cluster, {Splay.ar(SinOsc.ar(Array.exprand(16, 20, 8000))) * 0.6});
Ndef(\cluster, {Splay.ar(SinOsc.ar(Array.exprand(8, 20, 200))) * 0.6});

Ndef(\cluster).end; // (fadet aus!)

// Alternative Schreibweisen für Array.series

Array.series(16, 1, 1);
(1..16);

Array.series(100, 0, 0.01);
(0, 0.01..1);

// nur ungerade Zahlen, etc ...
(1, 3..20);

// Arrays können geplotted werden!
[100, 200, 400].plot

// Niklas Beispiel:
24.pow((((0, 0.01..1) - 1).pow(2)).neg()).plot