s.boot;

(
SynthDef.new(\beep, {
	arg freq=440, atk=0.002, sus=0.02, rel=0.2, atkcrv=2, relcrv=(-2),
	freqlag=0.05, pan=0, amp=0.2, out=0, outfx=0, ampfx=0;
	var sig, env;
	sig = SinOsc.ar(freq.varlag(freqlag, -8));
	env = EnvGen.kr(
		Env.new(
			[0, 1, 1, 0],
			[atk, sus, rel],
			[atkcrv, 0, relcrv]
		), doneAction:2
	);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
	Out.ar(outfx, sig * ampfx);
}).add;

SynthDef.new(\beep_asr, {
	arg freq=440, atk=0.002, sus=0.02, rel=0.2, atkcrv=2, relcrv=(-2),
	freqlag=0.05, gate=1, pan=0, amp=0.2, out=0, outfx=0, ampfx=0;
	var sig, env;
	sig = SinOsc.ar(freq.varlag(freqlag, -8));
	env = EnvGen.kr(
		Env.asr(atk,1,rel,[atkcrv,relcrv]),
		gate, doneAction:2
	);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
	Out.ar(outfx, sig * ampfx);
}).add;

SynthDef(\samp, {
	arg buf=0, rate=1, spos=0, atk=0, sus=0, rel=0.3, atkcrv=1, relcrv=(-3),
	loop=1, pan=0, amp=0.2, out=0, outfx=0, ampfx=0;
	var sig, env;
	sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf) * rate, 1, spos, loop);
	env = EnvGen.kr(
		Env.new(
			[0, 1, 1, 0],
			[atk, sus, rel],
			[atkcrv, 0, relcrv]
		), doneAction:2
	);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
	Out.ar(outfx, sig * ampfx);
}).add;

SynthDef(\reverb, {
	arg in=0, mix=1, out=0;
	var sig, wet;
	sig = In.ar(in, 2);
	sig = FreeVerb2.ar(sig[0], sig[1],  mix: mix, room: 0.999, damp:0.999);
	sig = LPF.ar(sig, 1200);
	Out.ar(out, sig);
}).add;
)

Synth(\beep, [\freq, 500]);

x = Synth(\beep_asr);
x.set(\gate, 0);

(
Array.rand(8, 50, 90).nearestInScale(Scale.minor.degrees).sort.postln

.collect({ |n,i|
	n = n + [0, rrand(0.08,0.13)]
}).flat

.collect({ |n,i|
	Synth(\beep, [
		\freq, n.midicps,
		\amp, 0.1/(i+1),
		\atk, exprand(1,3),
		\sus, 0,
		\rel, exprand(3,4),
	]);
});
)

(
~notes = Array.rand(8, 50, 90).nearestInScale(Scale.minor.degrees+4).sort.postln

.collect({ |n,i|
	n = n + [0, rrand(0.08,0.13)]
}).flat

.collect({ |n,i|
	Synth(\beep_asr, [
		\freq, n.midicps,
		\amp, 0.1/(i+1),
		\atk, exprand(1,3),
		\sus, 0,
		\rel, exprand(3,4),
	]);
});
)

(
~notes.do({ |n,i|
	n.set(
		\freq,
		Array.rand(~notes.size, 50, 90).sort
		.nearestInScale(Scale.major.degrees).at(i).midicps,
		\freqlag, exprand(0.05, 2)
	)
})
)

~notes.do({ |n| n.set(\gate, 0) });

(
p = Pbind(
	\instrument, \beep,
	\dur, 0.1,
	\scale, Scale.minorPentatonic,
	\degree, Pseq( (0..10), 1),
	\amp, 0.1,
	\atk, 0,
	\sus, 0,
	\rel, 0.6,
	\relcrv, -10,
).play;
)

(
~path = PathName(thisProcess.nowExecutingPath).parentPath ++ "samples/";
b = Buffer.readChannel(s, ~path ++ "wt.aiff", channels:[0]);
)

b.play;

Synth(\samp, [\buf, b, \spos, rrand(0, b.numFrames-1), \amp, 0.8]);

(
Array.rand(16,-1.0,1.0).do({ |n|
	Synth(\samp, [
		\buf, b,
		\spos, rrand(20000,43000) + 80000,
		\atk, 0.2,
		\rel, 5,
		\relcrv, -7,
		\rate, 0.7 * n.midiratio * [-1,1].choose,
		\pan, rrand(-1.0, 1.0),
		\amp, 0.4
	]);
});
)

(
Pbind(
	\instrument, \samp,
	\buf, b,
	\dur, 0.05,
	\spos, Pseries(0,250,inf),
	\amp, Env([1,0],[7],[-4]).asPseg,
	\atk, 0.08,
	\sus, 0,
	\rel, 3,
	\rate, Pgeom(1.4, -0.5.midiratio, inf),
).play;
)

(
s.newBusAllocators;
~rbus = Bus.audio(s, 2);
)

~r = Synth(\reverb, [\in, ~rbus, \out, 0]);

(
~pat = Pbind(
	\instrument, \samp,
	\buf, b,
	\dur, Pexprand(0.005, 2, inf),
	\spos, Pwhite(0, b.numFrames-1, inf),
	\amp, Pexprand(0.25, 0.9, inf),
	\pan, Pwhite(-0.7, 0.7, inf),
	\atk, Pwhite(0.002, 0.02, inf),
	\sus, 0,
	\rel, Pexprand(0.1, 0.5, inf),
	\relcrv, -4,
	\rate, Pwhite(-12.0, 12.0, inf).midiratio,
	\out, 0,
	\outfx, ~rbus,
	\ampfx, Pexprand(0.05, 0.3, inf),
).play;
)

~pat.stop;

(
~srcgroup = Group.new;
~rgroup = Group.after(~srcgroup);
~r = Synth(\reverb, [\in, ~rbus, \out, 0], ~rgroup);
)

MIDIIn.connectAll;

(
~pchwheel = 8192;

MIDIdef.bend(\pchwheel, {
	arg val;
	~pchwheel = val;
	~srcgroup.set(\rate, ~pchwheel.linlin(0,16383,-12,12).midiratio);
});

MIDIdef.noteOn(\sampler, {
	arg vel, num;
	Synth(\samp, [
		\buf, b,
		\rate, ~pchwheel.linlin(0,16383,-12,12).midiratio,
		\spos, num.linlin(0,127,0,b.numFrames-1),
		\amp, vel.linlin(1,127,-30,-1).dbamp,
		\out, 0,
		\atk, 0.005,
		\sus, 0,
		\rel, exprand(0.2, 1),
		\outfx, ~rbus,
		\ampfx, 0.1,
	], ~srcgroup);
});
)

//potential problems with server messages:
//SynthDef must be fully added before Synth can be played
//Buffer must be allocated and filled before it can be played

(
s.waitForBoot({

	SynthDef.new(\beep0007, {
		arg freq=440, atk=0.002, sus=0.02, rel=0.2, atkcrv=2, relcrv=(-2),
		freqlag=0.05, pan=0, amp=0.2, out=0, outfx=0, ampfx=0;
		var sig, env;
		sig = SinOsc.ar(freq.varlag(freqlag, -8));
		env = EnvGen.kr(
			Env.new(
				[0, 1, 1, 0],
				[atk, sus, rel],
				[atkcrv, 0, relcrv]
			), doneAction:2
		);
		sig = sig * env;
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
		Out.ar(outfx, sig * ampfx);
	}).add;

	s.sync;

	Synth(\beep0007);

});
)

Buffer.freeAll;

(
s.waitForBoot({
	~path = PathName(thisProcess.nowExecutingPath).parentPath ++ "samples/";
	b = Buffer.readChannel(s, ~path ++ "wt.aiff", channels:[0]);
	s.sync;
	b.play;
});
)


