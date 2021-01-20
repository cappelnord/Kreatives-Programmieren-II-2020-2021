b = Buffer.read(s, Document.current.dir +/+ "trump1.wav")
b.play

Ndef(\src, {PlayBuf.ar(1, b, BufRateScale.kr(b) * MouseY.kr(0.5, 2), loop: 1).dup})
// Ndef(\src).play

(
Ndef(\feedback, {
	var fb = DelayC.ar(Ndef(\feedback).ar, 0.2, 0.2) * MouseX.kr(0.5, 1.2);
	var sig = Ndef(\src).ar * 0.4 + fb;
	var pitch = Lag2.kr(Pitch.kr(sig.sum)[0], 1);

	// auch anschuen: Amplitude

	pitch.poll;

	// Problem war, dass der Delay UGen 0 ausgibt solange
	// bis die Delay-Zeit initial erreicht wird. Für Audiosignale
	// ist dies sinnvoll, für Kontroll-Signale nicht.
	// Die Filter sind unstabil bei einer Frequenz von 0.


	sig = BRF.ar(sig, pitch, 0.5);
	sig = BRF.ar(sig, DelayC.kr(pitch, 0.5, 0.5) * 2, 0.5);
	sig = BRF.ar(sig, DelayC.kr(pitch, 1, 1) * 4, 0.5);
	sig = BRF.ar(sig, DelayC.kr(pitch, 1.5, 1.5) * 8, 0.5);

	// Interessant wäre hier auch den Pitch-Tracker noch mal nach
	// dem Filter anzuwenden um zu sehen welche Frequenzen dann gefunden
	// werden und um dann diese herauszufiltern.

	// erst mal für 2 Sekunden Stille bis alle Delays gefüllt sind ...
	// (plus noch 500ms Abstand, damit nicht die Filter noch in einem
	// (instabilen Zustand sind)
	sig = sig * (DelayC.kr(pitch, 2, 2) > 0);

	sig = JPverb.ar(sig, 3) * 0.7;

	LeakDC.ar(HPF.ar(sig, 100));
});
)

Ndef(\monitor, {(Ndef(\feedback).ar * 0.5).tanh * 0.8})
Ndef(\monitor).play

s.scope