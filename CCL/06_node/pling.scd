o = NetAddr("127.0.0.1", 57140)
o.sendMsg("/message", "Mein Name ist Patrick! Cool!")

(
SynthDef(\pling, {|freq=440|
	var sig = SinOsc.ar(freq);
	var env = EnvGen.ar(Env.perc(0.01, 1), doneAction: 2);
	Out.ar(0, sig.dup * env * 0.5);
}).add;

OSCdef(\pling, {|msg|
	msg.postln;
	Synth(\pling, [\freq, msg[1]]);
}, '/pling')

)

Synth(\pling)