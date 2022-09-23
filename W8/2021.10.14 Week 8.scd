// 2021.10.14 Week 8

// Continuing from Week 7
// Sequencing


// Events are collections
Event;

// Event is unordered, but each item is associated with a key (key value pairs).
// You can make an Event using this:
e = (abc: 4, def: 5, ghi: 6);
e.keys;
e[\abc];

// default Event play
().play;
(amp:0.5).play;
(freq:400).play;

// instead of using Synth.new, you can play with an Event

Synth.new(\defName, [\args]);
(instrument:\instrument, buf:\x, amp: 0.7).play;

(sustain:x).play

// Pbind
(
p = Pbind(
	\instrument, \inst,
	\amp, 0.1,
	\freq, Pseq([200, 300, 400], inf),
);
~seq = p.asStream;
)

// Pbind needs to be passed an empty event
~seq.next(());

// can use .play
~seq.next(()).play;


// can also just play Pbinds

// TempoClock
// Tempo is in beats/sec
t = TempoClock.new(108/60);
t.beats;

// update t's tempo
t.tempo_(164/60);

// make a permanent clock:
t = TempoClock.new(108/60).permanent_(true);

// Kill the clock (even if permanent)
t.stop;














