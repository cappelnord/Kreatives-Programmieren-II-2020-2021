/* =====================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 3
   ------------------------------------

   Sitzung 09 - 17.12.2020

===================================== */


(
SynthDef(\aSynth, { | freq = #[60, 64, 67], atk = 0.01, rel = 1.0, flt_range = #[100, 800], amp = 0.5 |

	var snd, env, flt, rev;

	snd = Saw.ar(freq.midicps);
	env = EnvGen.ar(Env.perc(atk, rel), doneAction: 2);
	flt = RLPF.ar(snd, (env * (flt_range[1] - flt_range[0])) + flt_range[0], 0.1);
	rev = GVerb.ar(Splay.ar(flt, 0.5), 80, 1);

	Out.ar(0, rev * env * amp)
}).add;
)

(
var elements, miditable, transitionMatrix;

elements = (
	\chords: (
		\cmaj: [\c, \e, \g],
		\dmin: [\d, \f, \a],
		\emin: [\e, \g, \b],
		\fmaj: [\f, \a, \c],
		\gmaj: [\g, \b, \d],
		\amin: [\a, \c, \e]
	),

	\synthParams: (
		\presetOne: [\atk, 0.3, \rel, 2.0, \flt_range, [100, 500]],
		\presetTwo: [\atk, 0.01, \rel, 0.5, \flt_range, [100, 3000]]
	)
);

miditable = (
	\c: [60, 72, 84, 96],
	\d: [62, 74, 86, 98],
	\e: [64, 76, 88, 100],
	\f: [65, 77, 89, 101],
	\g: [55, 67, 79, 91],
	\a: [57, 69, 81, 93],
	\b: [59, 71, 83, 95]
);

transitionMatrix = (
	\cmaj: [\dmin, \emin, \gmaj, \amin],
	\dmin: [\gmaj],
	\emin: [\fmaj, \amin],
	\fmaj: [\cmaj, \dmin, \gmaj],
	\gmaj: [\cmaj, \amin],
	\amin: [\cmaj, \dmin, \emin]
);

fork{
	var currChord = \cmaj, currChordMidi = List[60, 64, 67], nextChord, nextChordMidi, preset;

	inf.do{

		nextChordMidi = List.newClear;

		preset = elements[\synthParams].keys.choose;

		Synth(\aSynth, [\freq, currChordMidi.asArray] ++ elements[\synthParams][preset]);

		nextChord = transitionMatrix[currChord].choose;

		elements[\chords][nextChord].do(
			{
				|item, i|
				nextChordMidi.add(miditable[item][miditable[item].size.rand]);
			}
		);

		"-----------------------------------".postln;
		("current chord: " ++ currChord.asString + currChordMidi.asArray).postln;
		("next chord: " ++ nextChord.asString + nextChordMidi.asArray).postln;
		"-----------------------------------".postln;
		"".postln;

		currChord = nextChord;
		currChordMidi = nextChordMidi;

		(0.5 + 1.0.rand).wait;
	};
};
)
