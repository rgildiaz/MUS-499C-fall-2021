// 2021.09.09 Week 3

s.boot;

// multichannel expansion
3 + [4, 5];

(
~fn = {
	arg freq=200, offset=2, lpf=1500, amp=0.2;
	var sig;
	// multichannel expansion: generates 2 Saws, one at freq and one at freq + offset. sig becomes an array with these two Saw synths.
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF.ar(sig, lpf);
	sig = sig * amp;
};
)

x = ~fn.play(args: [\freq, 150]);
x.free;

// Synth and SynthDef
// Synths are a sound generating or modifying unit.
// SynthDefs are a blueprint for a Synth. They are not the same as a Synth itself.
// SynthDefs take first a name usually a symbol, and then a function that represents the Synth.

(
SynthDef.new(\saw, {
	arg freq=200, offset=2, lpf=1500, amp=0.2, out=0;
	var sig;
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF.ar(sig, lpf);
	sig = sig * amp;
	// SynthDefs require the out UGen.
	Out.ar(out, sig);
	// 				DO NOT FORGET TO .add
}).add;
)

// To play a SynthDef
x = Synth.new(\saw, [\freq, 150, \lpf, 3000]);
x.free;

// Buses:
// Can route audio through buses. By default, SuperCollider assumes that you have 2 hardware ins and outs.
// Hardware outputs are automatically mapped to buses 0 and 1, hardware ins are automatically mapped to buses 2 and 3.

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Envelopes
// An envelope is a signal whose shape is customizable. It is generally a series of lines from value to value. They are usually used to modify amplitude.
Env; 			// Like a SynthDef
EnvGen;			// Like a Synth


// Example of ADSR env.
(
e = Env.new(
	// levels
	[0, 1, 0.5, 0.5, 0],
	// dur in seconds (n - 1 segments)
	[1, 1, 2, 1],
	// curve values (0 is linear, positive values and negative values curve in different directions, increasing as it gets further away from 0).
	[0, 0, 0, 0]
);

e.plot;
)

// There are other options (Env.perc, Env.asr, Env.linen, .sine, .triangle, etc.)

// Envelopes do not go away on their own. They continue generating 0's after the Env. is over. Use doneAction to specify what the Env. should do.
Done;

(
SynthDef.new(\saw, {
	arg freq=200, offset=2, lpf=1500, amp=0.2, out=0;
	var sig, env;
	env = EnvGen.ar(
		Env.new(
			[0, 1, 0.5, 0.5, 0],
			[1, 1, 2, 1],
			[1, -2, 0, 3]
		),
		doneAction:2
	);
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF.ar(sig, lpf);
	sig = sig * amp;
	sig = sig * env;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\saw, [\freq, 150, \lpf, 3000]);


// Can also use Line and others
Line.ar(1, 0, 2, doneAction:2);
// Exponentional
XLine.ar(1, 0.00001, 2, doneAction:2)

// Gated Envelopes
// Sometimes, Envelopes do not have a deteriministic duration (like a violinist bowing). We then need a way to tell the Env to stop
// Use release node to specify which node sustains.
// Then, provide a gate arg.

(
SynthDef.new(\saw, {
	arg freq=200, gate=1, offset=2, lpf=1500, amp=0.2, out=0;
	var sig, env;
	env = EnvGen.ar(
		Env.new(
			[0, 1, 0.5, 0],
			[1, 1, 1],
			[1, -2, 3],
			releaseNode: 2
		),
		gate,
		doneAction:2
	);
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF.ar(sig, lpf);
	sig = sig * amp;
	sig = sig * env;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\saw, [\freq, 150, \lpf, 3000]);

// To close the gate:
x.set(\gate, 0);

//////////////////////////////////////////////////////////////

// Iteration


// This is bad:
x = [];

(
x = x.add( Synth.new(\saw, [\freq, 45.midicps, \lpf, 3000, \amp, 0.15]) );
x = x.add( Synth.new(\saw, [\freq, 55.midicps, \lpf, 3000, \amp, 0.15]) );
x = x.add( Synth.new(\saw, [\freq, 59.midicps, \lpf, 3000, \amp, 0.15]) );
x = x.add( Synth.new(\saw, [\freq, 61.midicps, \lpf, 3000, \amp, 0.15]) );
x = x.add( Synth.new(\saw, [\freq, 62.midicps, \lpf, 3000, \amp, 0.15]) );
x = x.add( Synth.new(\saw, [\freq, 63.midicps, \lpf, 3000, \amp, 0.15]) );
)

x[0].set(\gate, 0);
x[1].set(\gate, 0);
x[2].set(\gate, 0);
x[3].set(\gate, 0);
x[4].set(\gate, 0);
x[5].set(\gate, 0);
x[6].set(\gate, 0);


// Use those instead

// collect iterates over an array and performs a function on each element. It then returns an array that is filled with the operated-on elements of the original array.

// collect does not overwire the original array.
(
[45, 55, 59, 61, 62, 63].collect({
	arg n;
	100 + n;
});
)



(
~notes = [45, 55, 59, 61, 62, 63];
~synths = ~notes.collect({
	arg n;
	Synth.new(\saw, [\freq, n.midicps, \lpf, 3000, \amp, 0.15])
});
)

(
~synths.collect({
	// Second arg is index.
	arg n, i;
	n.set(\gate, 0);
});
)


// Can also use .do
// The difference between do and collect is that .collect returns a new array. .do ALWAYS returns its receiver.

(
~synths.do({
	arg n;
	n.set(\gate, 0);
});
)





