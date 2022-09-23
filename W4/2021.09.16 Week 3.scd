// 2021.09.16

s.boot;

(
f = {
	var sig;
	sig = SinOsc.ar(1);
	sig = sig * 0.15;
};
)

f.plot(2);

// .ar Audio Rate: runs the UGen at the sample rate. Every second of the sine wave there are 44100 samples
s.sampleRate;

// .kr Control Rate: slower because you don't need 48000 samples per second in many cases. .kr is calculated using the block size.
s.options.blockSize;
s.options.blockSize/s.sampleRate;

// This means that .kr omits everything except every 64th sample

// This matters for things that you hear
(
f = {
	var sig;
	sig = [
		SinOsc.ar(257),
		SinOsc.kr(257)
	];
	sig = sig * 0.15;
}.plot(0.03);
)

// Not so much for LFOs
(
f = {
	var sig;
	sig = [
		SinOsc.ar(1),
		SinOsc.kr(1)
	];
	sig = sig * 0.15;
}.plot(1);
)

// Both .ar
(
f = {
	var sig, mod, modhz;
	modhz = MouseX.kr(1, 4000, 1);
	mod = SinOsc.ar(modhz).bipolar(400);
	sig = SinOsc.ar(500 + mod);
	sig = sig * 0.15;
}.play;
)

// Mod .kr
(
f = {
	var sig, mod, modhz;
	modhz = MouseX.kr(1, 4000, 1).poll;
	mod = SinOsc.kr(modhz).bipolar(400);
	sig = SinOsc.ar(500 + mod);
	sig = sig * 0.15;
}.play;
)

// .ir Initialization Rate: rarest of the three. A UGen that runs at .ir only calculates the rate when it is executed
SampleRate.ir;


///////////////////////////////////////////////////////////////////////////////////

// Filters
//////////         ***** DO NOT FEED VALUES OUTSIDE THE AUDIBLE SPECTRUM *****                ///////////////////

(
f = {
	var sig;
	sig = Saw.ar([40, 40.5]);
	sig = sig * 0.2;
}.play;
)

FreqScope.new;

// LPF
(
f = {
	var sig, lpf;
	lpf = MouseX.kr(20, 20000, 1).poll;
	// Prevents any bad values.
	lpf = lpf.clip(20, 20000);
	sig = Saw.ar([40, 40.5]);
	sig = LPF.ar(sig, lpf);
	sig = sig * 0.2;
}.play;
)

// HPF
(
f = {
	var sig, filt;
	filt = MouseX.kr(20, 20000, 1).poll;
	// Prevents any bad values.
	filt = filt.clip(20, 20000);
	sig = Saw.ar([40, 40.5]);
	sig = HPF.ar(sig, filt);
	sig = sig * 0.2;
}.play;
)

// BPF
(
f = {
	var sig, filt;
	filt = MouseX.kr(20, 20000, 1).poll;
	// Prevents any bad values.
	filt = filt.clip(20, 20000);
	sig = PinkNoise.ar(0.5!2);
	// 													0 < rq <= 1
	sig = BPF.ar(sig, filt, rq:1);
	sig = sig * 0.2;
}.play;
)

// BRF
(
f = {
	var sig, filt;
	filt = MouseX.kr(20, 20000, 1).poll;
	// Prevents any bad values.
	filt = filt.clip(20, 20000);
	sig = Saw.ar([40, 40.5]);
	sig = BRF.ar(sig, filt);
	sig = sig * 0.2;
}.play;
)

// RLPF
// Includes an rq arg
(
f = {
	var sig, filt;
	filt = MouseX.kr(20, 20000, 1).poll;
	// Prevents any bad values.
	filt = filt.clip(20, 20000);
	sig = Saw.ar([40, 40.5]);
	sig = RLPF.ar(sig, filt, rq: 1);
	sig = sig * 0.2;
}.play;
)

// RHPF
(
f = {
	var sig, filt;
	filt = MouseX.kr(20, 20000, 1).poll;
	// Prevents any bad values.
	filt = filt.clip(20, 20000);
	sig = Saw.ar([40, 40.5]);
	sig = RHPF.ar(sig, filt, rq: 1);
	sig = sig * 0.2;
}.play;
)


/////////////////////////////////////////////////////////////

// Panning and Spatialization

(
SynthDef(\pan, {
	arg pan=0, out=0;
	var sig, env;
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, 1000, 0.1, 4);
	sig = sig * LFPulse.kr(8);
	sig = sig * 0.2;
	// Expects one channel, outputs 2 channels
	sig = Pan2.ar(sig, pan);

	// Balance2 expects 2 channels and balances them accross the stereo field.
	// sig = Balance2.ar(left_sig, right_sig, pan);
	// if sig is already an array: left_sig = sig[0], right_sig = sig[1]

	// Splay can take an array of any size. Pans these inputs linearly accross the stereo field
	// sig = Splay.ar(inArray, spread);
	Out.ar(0);
});
)

Synth.new(\pan);

















