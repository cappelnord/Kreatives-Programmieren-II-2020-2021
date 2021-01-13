s.scope

// Mit Lautstärke aufpassen! Mac User: SafetyNet Quark installieren

// Verschiedene Beispiele von Feedbacks

(
Ndef(\ok, {
	var sig = BPF.ar(Dust2.ar(10), 1000, 0.3);
	var fb = BPF.ar(DelayC.ar(Ndef.ar(\ok), 0.1, 0.1), MouseY.kr(100, 5000), 0.1);
	sig = HPF.ar(sig + (fb * MouseX.kr(0.9, 1.5)), 20);
	sig;
});
)


(
Ndef(\ok, {
	var sig = BPF.ar(Dust2.ar(10) * 20, 1000, 0.1);
	var fb = DelayC.ar(Ndef.ar(\ok), 0.1, 0.1);
	fb = PitchShift.ar(fb, 0.1, MouseY.kr(0.5, 2));
	sig = HPF.ar(sig + (fb * MouseX.kr(0.9, 1.5)), 20);
	sig;
});
)


// Ndefs, der den Feedback-Loop sicher abspielt

Ndef(\okPlay, {Ndef(\ok).tanh * 0.5})
Ndef(\okPlay).play




// Feedback mit 2 Ndefs

(
Ndef(\in, {
	SoundIn.ar(0) + (DelayC.ar(Ndef(\out).ar, 0.2, 0.05) * MouseX.kr(0.4, 1.3));
});

Ndef(\out, {
	HPF.ar(Ndef(\in) + PitchShift.ar(Ndef(\in).ar, 0.1, MouseY.kr(1, 1.5)), 20).tanh;
});

)

Ndef(\out).play




// Mit Feedback Quark

(
Ndef(\ok, {
	var sig = Decay.ar(Dust2.ar(XLine.kr(1, 100, 30)), 0.2) * SinOsc.ar(LFNoise2.kr(1).range(100, 2000)).dup;
	var out = FbC({|fb| PitchShift.ar(sig + (fb * 0.99), 0.01, 1.1)}, 0.2, 0.2);
	out;
})
)

Ndef(\ok).play

