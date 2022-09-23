//Problem Set 7
//Due 3pm CDT Thursday Nov 4th 2021

//Save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set 7.scd").

//-------
//Prompt:

//Create a simple MIDI sampler program, with features as described below.

//For sample content, use the loopable audio sample included with this assignment. Be sure to include this audio sample in your SC project folder, use the 'thisProcess.nowExecutingPath' method, and upload a zip file to the course website.

//Your sampler should be fully polyphonic, and should transpose the pitch up/down according to the incoming MIDI note numbers. Your sampler should be pitch-accurate: the provided sample is the G below middle C, (note number 55), so pressing this key should play back the sample at its original pitch, pressing note 56 should transpose up one semitone, etc.

//Your sampler should also respond to one specific CC number (e.g. the mod wheel, a knob, or a fader), and use its control values to adjust the frequency of a low pass filter, applied globally to all notes.

s.boot;

(
MIDIIn.connectAll;

// MIDIFunc.trace(true);
MIDIFunc.trace(false);
)

(
~path = PathName(thisProcess.nowExecutingPath).parentPath;
~samp = Buffer.read(s, ~path ++ "sample.aiff");

~filtIn = Bus.control(s, 1);
~lpfBus = Bus.audio(s, 2);

SynthDef.new(\playbuf, {
	arg buf=0, rate=1, amp=0.3, gate=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.asr(0,1,0.5,-1), gate, doneAction:2);
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, loop:1);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

// ModWheel
SynthDef.new(\filt, {
	arg filt, out;
	Out.kr(out, filt.lag(0.1));
}).add;

SynthDef.new(\lpf, {
	arg in, cf;
	var sig;
	sig = In.ar(in, 2);
	sig = LPF.ar(sig, cf);
	Out.ar(0, sig);
}).add;
)


(
~lpfSynth = Synth.new(\lpf, [\in, ~lpfBus], s.defaultGroup, \addAfter);
~notes = Array.fill(128, nil);

MIDIdef.noteOn(\on, {
	arg val, num;
	~notes.put(
		num,
		Synth(\playbuf, [
			\rate, (num-55).midiratio,
			\buf, ~samp,
			\amp, val.linexp(0,127,-30, -3).dbamp,
			\gate, 1,
			\out, ~lpfBus
		]);
	);
});

MIDIdef.noteOff(\off, {
	arg val, num;
	~notes[num].set(\gate, 0);
	~notes[num] = nil;
});

MIDIdef.cc(\mod, {
	arg val, num;
	~lpfSynth.set(\cf, val.linexp(0,127,200, 10000));
}, 1);
)

(
s.freeAll;
MIDIdef.freeAll;
)