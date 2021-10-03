// SideChain mit Bus input: Ich hatte vergessen dass der Compander natürlich den Bus nur auf Audiorate abgreifen kann, wenn man auch den input mit In.ar abgreift !

(
SynthDef(\sideNoise, { | in |
	var snd, input;
	input = In.ar(in);
	snd = WhiteNoise.ar(0.5) * EnvGen.ar(Env.perc(0.01, 3), doneAction: 2);
	snd = Compander.ar(snd, input * 2,  0.2, 1, slopeAbove: 0.1);
	Out.ar(0, snd!2 * 0.7);
}).add;
)

(
SynthDef(\pling, { |bus|
	var snd ;
	snd = SinOsc.ar(XLine.kr(100, 2000, 1, doneAction: 2))  * Pulse.kr(5);
	Out.ar(bus, snd!2);
	Out.ar(0, snd!2 * 0.5);
}).add;
)



(
~sidebus = Bus.audio(s, 2);
Synth(\pling, [\bus, ~sidebus]);
Synth(\sideNoise, [\in, ~sidebus],addAction: \addToTail);
s.plotTree; // Der Compressor sollte nach dem input ausgeführt werden
)



// Hier noch etwas zur Daten Filterung mithilfe eines Buffers:
// Die Beispiele sind alle leicht abgeändert von Marije Baalman aus dem Kurs "Designing interactive sound for performative contexts"

~randoms = Pseq(Array.fill(1000, {100.rand}), inf).asStream;
// Das ist dann der Eingangswert der gefiltert werden soll. Im Kurs verwendeten wir einen Lichtsensor. Zur Demo reichen auch erst einmal random werte:

//  Nachdem wir Werte generieren können wir verschieden FilterMethoden wie Mean oder Median Testen:
(
Tdef(\generateVals, {
	loop{
		~light = ~randoms.next;
		0.01.wait;
}
}).play;
)

~buffer = Array.fill( 100, { ~light });

// Mean

(
Tdef( \calculateMean, {
	loop{
		~buffer = ~buffer.rotate(1);
		~buffer = ~buffer.put( 0, ~light.next );
		~filtered = ~buffer.mean;
		//~buffer.postln;
		0.01.wait;
	};
}).play;
)

//  Hier können wir uns noch den Buffer ansehen und die Werte miteinander vergleichen:
(
~buffer.plot;
["raw: " ++ ~light].postln;
["filtered: " ++ ~filtered].postln;
)

// Median

(
Tdef( \calculateMedian, {
	loop{
		~buffer = ~buffer.rotate(1);
		~buffer = ~buffer.put( 0, ~light.next );
		~filtered = ~buffer.median;
		// ~buffer.postln;
		0.01.wait;
	};
}).play;
)

(
~buffer.plot;
["raw: " ++ ~light].postln;
["filtered: " ++ ~filtered].postln;
)

// --- exponential smoothing
// Beim Exponential smoothing können wir noch darüber hinaus die Glättung über den alpha parameter steuern !

(
~alpha = 0.05;
Tdef( \calculateExponential, {
	var expVal = ~light;
	loop{
		expVal = (~alpha * ~light) + ((1 - ~alpha)*expVal);
		~filtered = expVal;
		// ~buffer.postln;

		0.01.wait;
	};
}).play;
)

(
~buffer.plot;
["raw: " ++ ~light].postln;
["filtered: " ++ ~filtered].postln;
)


// try different values for alpha

~alpha = 0.1;
~alpha = 0.005;
~alpha = 0.05;
~alpha = 0.025;





