s.boot;

(
SynthDef.new(\sine, {
	arg freq=440, amp=0.2, gate=1,
	atk=0.001, rel=1, acrv=1, rcrv=(-4), pan=0, out=0;
	var sig, env;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, [acrv, rcrv]),
		gate,
		doneAction:2
	);
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp) * env;
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in=0, mix=0.08, out=0;
	var sig, wet;
	sig = In.ar(in, 2);
	sig = FreeVerb2.ar(
		sig[0], sig[1],
		mix: mix.varlag(2),
		room: 0.999,
		damp: 0.85
	);
	Out.ar(out, sig);
}).add;

s.newBusAllocators;
~bus = Bus.audio(s, 2);
)

(
Pdef(\p).clear;
t.stop;
t = TempoClock.new(108/60).permanent_(true);
Pdef(\p).quant = 4;
~reverb = Synth.new(\reverb, [\in, ~bus, \out, 0]);
)

(
Pdef(\p, Pbind(
	\instrument, \sine,
	\dur, Pseq([Pseq([4,2],4), 2, 2], inf).reciprocal,
	\degree, Pseq([Pseq([1,3,4,5],2),1,3],inf) + Prand([0,3],inf) + [0,1,2,3,4],
	\atk, 0.002,
	\rel, Pseq([Pshuf([0.2, 0.2, 0.2, 0.2, 0.5, 1], 1)], inf),
	\rcrv, -5,
	\sustain, 0.01,
	\amp, Array.geom(5,0.15,-6.dbamp),
	\strum, 1/8,
	\pan, Pfunc({ Array.rand(5, -1.0, 1.0) }),
	\out, ~bus,
));
Pdef(\p).play(t);
)

(
Pdef(\pat, Pbind(
	\instrument, \sine,
	\dur, Pseq([0.5, 0.7], inf),
	\degree, Pseq([Pshuf((1..5), 1), 1], inf),
	\scale, Scale.choose(5, 12),
	\mtranspose, Prand((-10..-5), inf),
	\amp, Array.geom(5,0.15,-6.dbamp)
));

Pdef(\pat).play(t);
)

DelayN;

~reverb.set(\mix, 0.15);

Pdef(\p).stop;

~reverb.free;