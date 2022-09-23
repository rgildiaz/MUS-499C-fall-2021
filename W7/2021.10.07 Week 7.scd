// 2021.10.07

s.boot;

// Sequencing

b = (); // () creates an unordered collection called an event.


// Routines can be evaluated incrementally
Routine;

(
~r = Routine.new({
	(8 * 7).postln;
	// schedules next statement.
	2.wait;
	(4 + 4).postln;
});
)

~r.next;
~r.play;

// Can only run a routine once unless you .reset it or reevaluate.
~r.reset;


(
~r = Routine.new({
	[10, 20, 30, 40].do({
		arg n;
		(n / 10).postln;
		1.wait;
	});
});
)

// Routines spit out the wait value.

(
~noteGen = Routine.new({
	inf.do({
		[1, 2, 3,4,5,6,6].do({
			arg n;
			n.wait;
		});
	});
});
)

~noteGen.next;
~noteGen.nextN(4);

// can plug this into a Synth


// Patterns
Pattern;

// A Pattern is a blueprint or a set of instructions about creating a Stream or Routine. If you need the real values, turn the Pattern into a Stream.

p = Pseq([1, 2, 3,4,5,6,6], inf);
~noteGen = p.asStream;

// Works
~noteGen.next;

// Doesn't
p.next;

// Selects a random item form the input array
Prand;

// Same as Prand, but doesn't ever select the same item twice in a row. (distinguishes by index, not value)
Pxrand;

// Weighted rand, uses second array to weight array. Second array should have the same number of values as the first array, and the values within should sum to 1
Pwrand;

// Can use .normalizeSum to normalize an array:
c = [10, 4000, 320].normalizeSum;

// Suffles an array and then sequentially outputs that order
Pshuf;

// Can use this:
(
p = Pseq([ Pshuf([1,2,3,4,5], 1)], inf);
~seq = p.asStream;
)

~seq.nextN(20);













