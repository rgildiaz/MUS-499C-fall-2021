// 10.21.2021 Week 9

// More Patterns
// Array values in Pbind
// Array input creates multiple Events (like multichannel expansion)
// Can use Ptuple for a Pattern array
Ptuple;
Ptupe([
	Prand(),
	Prand()
], inf)

// Pfunc evaluates a function and then supplies the result to the key.
Pfunc;

(-7..7).scamble.at([0,1])
Array.rand(2, -7, 7)

// \strum can be used in a Pbind to schedule array events like a strum

// Rest events
Rest;

// If any key in an event has a Rest object, the whole event becomes a rest event
// If any freq generating key in a Pbind is passed a symbol (like \, the empty symbol), that key, and then that event, becomes a rest event.



// Expressing one parameter in terms of another
Pkey;

// Linear distribution scaled over range
\db, Pkey(\midinote).linlin(40, 110, -16, -50)

// or use Pfunc
Pfunc({
	// args within Pfunc within an event represents the Event
	arg ev;
	// Therefore, can use:
	ev[\midinote].linlin(40, 110, -16, -50);
})



// TempoClock and Quantization

t = TempoClock.new(112/60).permanent_(true);

~postinfo = {(t.beats%4 + 1).postln;1;}

t.schedAbs(t.nextBar, {~postinfo.()})




















