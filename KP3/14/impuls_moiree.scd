(
{
	var n = 2000;
	Splay.ar(n.collect {|i|
		Impulse.ar(10 + (0.0001 * i)) * (i%2==0).if(1, -1)
	});
}.play;
)

s.options.numOutputBusChannels = 8;

(
{
var n = 2000;
var sigs = n.collect {|i|
		Impulse.ar(10 + (0.0001 * i)) * (i%2==0).if(1, -1)
	};
	var channels = sigs.clump(8);
	Out.ar(0, Mix.ar(channels));
}.play;
)

// Patterns

(
Pbind(
	\degree, Pseq([0, 2, 4, 7],inf),
	\dur, 1.0 * 0.25
).play;

Pbind(
	\degree, Pseq([0, 2, 4, 7],inf),
	\dur, 1.01 * 0.25
).play;
)
