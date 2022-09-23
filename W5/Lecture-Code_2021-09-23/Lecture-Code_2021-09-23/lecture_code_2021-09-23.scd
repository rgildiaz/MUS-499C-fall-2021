s.boot;

b.free;

b = Buffer.read(s, "/Users/eli/Desktop/audio/voice/voice.aiff");

b.play;

b.query;

///////////////////////////

thisProcess.nowExecutingPath;

PathName(thisProcess.nowExecutingPath).parentPath;

~audiopath = PathName(thisProcess.nowExecutingPath).parentPath ++ "audio/";

(
~voice = Buffer.read(s, ~audiopath ++ "voice/voice.aiff");
~flute_slap = Buffer.read(s, ~audiopath ++ "flute/flute_slap.aiff");
)

~flute_slap.play;

/////////////////

Buffer.freeAll;

(
b = [
	Buffer.read(s, ~audiopath ++ "voice/voice.aiff"),
	Buffer.read(s, ~audiopath ++ "flute/flute_slap.aiff")
];
)

b[0].play;
b[1].play;

Buffer.freeAll;

(
b = (
	voice: Buffer.read(s, ~audiopath ++ "voice/voice.aiff"),
	flute_slap: Buffer.read(s, ~audiopath ++ "flute/flute_slap.aiff"),
	flute_ram: Buffer.read(s, ~audiopath ++ "flute/flute_ram.aiff"),
	gl0: Buffer.read(s, ~audiopath ++ "glitch/glitch0.aiff"),
	gl1: Buffer.read(s, ~audiopath ++ "glitch/glitch1.aiff"),
	gl2: Buffer.read(s, ~audiopath ++ "glitch/glitch2.aiff")
)
)

b[\voice].play;
b[\gl2].play;

b[\voice].numChannels;
//////////////////////////////

(
SynthDef.new(\play, {
	arg buf=0;
	var sig;
	sig = PlayBuf.ar(1, buf);
	Out.ar(0, sig);
}).add;
)

(
SynthDef.new(\play2, {
	arg buf=0;
	var sig;
	sig = PlayBuf.ar(2, buf);
	Out.ar(0, sig);
}).add;
)

Synth.new(\play, [\buf, b[\voice]]);
Synth.new(\play2, [\buf, b[\flute_ram]]);

/////////////////////////////////////

(
SynthDef.new(\play2, {
	arg buf=0, rate=1, t_trig=0, spos=0;
	var sig;
	sig = PlayBuf.ar(2, buf, rate, t_trig, spos);
	Out.ar(0, sig);
}).add;
)

Synth.new(\play2, [\buf, b[\flute_ram], \rate, 0.25]);
Synth.new(\play2, [\buf, b[\flute_ram], \rate, 3.midiratio]);

x = Synth.new(\play2, [\buf, b[\voice], \rate, 1]);
x.set(\rate, 0.75);
x.set(\rate, 0.5);

x.set(\t_trig, 1, \spos, rrand(0, b[\voice].numFrames-1));

(
SynthDef.new(\play2, {
	arg buf=0, rate=1, spos=0;
	var sig, trig;
	trig = Impulse.kr(4);
	sig = PlayBuf.ar(2, buf, rate, trig, spos);
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\play2, [\buf, b[\voice], \rate, 1, \spos, 48000]);
b[\voice].numFrames;

(
SynthDef.new(\play2, {
	arg buf=0, rate=1;
	var sig, trig, env, spos;
	trig = Impulse.kr(2);
	spos = TIRand.kr(0, BufFrames.kr(buf)-1, trig);
	env = EnvGen.kr(Env.new([0,1,0], [0.01,0.5], [1,-2]), trig);
	sig = PlayBuf.ar(2, buf, rate, trig, spos);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\play2, [\buf, b[\voice], \rate, 1]);

(
SynthDef.new(\play2, {
	arg buf=0, rate=1, imphz=4, amp=0.5, pan=0;
	var sig, trig, env, spos;
	trig = Impulse.kr(imphz);
	spos = TIRand.kr(0, BufFrames.kr(buf)-1, trig);
	env = EnvGen.kr(Env.new([0,1,0], [0.01,(1/imphz)-0.01], [1,-2]), trig);
	sig = PlayBuf.ar(1, buf, rate, trig, spos);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	sig = sig * amp;
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\play2, [\buf, b[\voice], \rate, 1, \imphz, 8]);


(
Array.rand(8, -12, 12.0).do({
	arg n;
	Synth.new(\play2,
		[
			\buf, b[\voice],
			\rate, n.midiratio,
			\imphz, rrand(30.0, 40.0),
			\amp, 0.4,
			\pan, rrand(-1.0,1.0),
		]
	);
});
)


(
SynthDef.new(\play_simple, {
	arg buf=0, rate=1, loop=0;
	var sig;
	sig = PlayBuf.ar(2, buf, rate, startPos:spos, loop:loop, doneAction:2);
	Out.ar(0, sig);
}).add;
)

x = Synth(\play_simple, [\buf, b[\flute_ram], \rate, -1, ]);

x.set(\loop, 0);


s.sampleRate

b[\voice].sampleRate



{PlayBuf.ar(1, buf, rate * BufRateScale.kr(buf))}

b[\flute_ram].play

{PlayBuf.ar(2, b[\flute_ram], 1, doneAction:2)}.play

{BufRateScale.kr(b[\flute_ram]).poll;0}.play

{PlayBuf.ar(2, b[\flute_ram], BufRateScale.kr(b[\flute_ram]) * 0.5, doneAction:2)}.play;






