(
s.options.memSize = 2.pow(20);
s.reboot;
)

(
SynthDef.new(\klank, {
	arg amp=1, out=0, atk=0, sus=0, rel=3;
	var sig, env, freqs, ringtimes;
	freqs = Control.names([\freqs]).kr({exprand(200,10000)}!16);
    ringtimes = Control.names([\ringtimes]).kr(0.2!16);
	env = EnvGen.kr(Env.new([0,1,1,0],[atk,sus,rel],[1,0,-1]),doneAction:2);
	sig = Dust.ar(1!8);
	sig = Decay.ar(sig, 0.05);
	sig = DynKlank.ar(`[freqs, nil, ringtimes], sig);
	sig = Splay.ar(sig) * 0.004;
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

SynthDef.new(\verb, {
	arg in, out;
	var sig;
	sig = In.ar(in,2);
	sig = sig.blend(LPF.ar(GVerb.ar(sig, 250, 5) * 0.5, 2000), 0.8);
	Out.ar(out, sig);
}).add;
)

(
s.newBusAllocators;
~bus = Bus.audio(s,2);
Synth(\verb, [\in, ~bus, \out, 0]);
)

(
Tdef(\klanks, {
	loop{
		Synth(\klank, [
			\freqs, {exprand(500,18000)}!16,
			\ringtimes, {exprand(1,2)}!16,
			\atk, exprand(0.005, 0.5),
			\amp, 0.6,
			\out, ~bus,
		]);
		exprand(0.1,4).wait;
}
}).play;
)

Tdef(\klanks).stop;