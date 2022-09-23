(
s.freeAll;

~cleanup = {
	ServerBoot.removeAll;
	ServerQuit.removeAll;
	ServerTree.removeAll;
	CmdPeriod.removeAll;
};

ServerQuit.add(~cleanup);

~cleanup.();

~path = PathName(thisProcess.nowExecutingPath).parentPath ++ "samples/";
~pchwheel = 8192;
s.newBusAllocators;
~rbus = Bus.audio(s, 2);

MIDIIn.connectAll;

MIDIdef.bend(\pchwheel, {
	arg val;
	~pchwheel = val;
	~srcgroup.set(\rate, ~pchwheel.linlin(0,16383,-12,12).midiratio);
}).permanent_(true);

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
}).permanent_(true);

~events = [
	{
		~sound0 = Synth(\beep_asr, [\freq, 400]);
	},

	{
		~sound0.set(\freq, 500);
	},
	{
		~sound0.set(\gate, 0);
	}
];

~counter = 0;

~go = {
	~events[~counter].value;
	~counter = ~counter + 1
};

s.waitForBoot({

	b = Buffer.readChannel(s, ~path ++ "wt.aiff", channels:[0]);

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

	s.sync;

	~makeNodes = {
		~srcgroup = Group.new;
		~rgroup = Group.after(~srcgroup);
		~r = Synth(\reverb, [\in, ~rbus, \out, 0], ~rgroup);
	};

	ServerTree.add(~makeNodes);
	ServerTree.run;

});
)

~go.();

~counter = 0; //reset