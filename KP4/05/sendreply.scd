// Kontrolldaten von scsynth nach sclang senden

(
{
	var sig = SoundIn.ar(0);
	var amp = Amplitude.kr(sig, 0.05, 0.05);
	amp = Lag2.kr(amp, 0.3);
	SendReply.kr(Impulse.kr(30), '/amp', [amp]);
}.play
)


(
l = [];
OSCdef(\birne, {|msg|
	msg.postln;
	l = l.add(msg[3]);
}, '/amp');
)

l.plot