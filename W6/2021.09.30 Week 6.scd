// 2021.09.30 Week 6

s.boot;

// Signal Flow
// Flows from head to tail. Look at the node tree.

// Can route through buses. Buses are like channels on a mixer.
s.options.numAudioBusChannels;

// By default, busses are blocked out like this
// 0: out 1
// 1: out 2
// 2: in 1
// 3: in 2
// 4 and above are not blocked out yet

// audio calculated in blocks
s.options.blockSize;

// At each block, scsynth goes through the signal flow from head to tail
// Make sure to put effects downstream of the input signals.

// Buses are all wiped at the end of each cycle, so putting things in the wrong order results in silence.

s.defaultGroup;

(
Synth(\defName, [\args], target: s.defaultGroup,
	addAction:
	\addToHead
	\addToTail
	\addAfter
	\addBefore
	\AddReplace
)

// Make groups to keep things in the correct order.
~sourceGroup = Group.new;
~fxGroup = Group.new(~sourceGroup, \addAfter);

// Can pass messages from group to the synths it contains. e.g. can use .set() methods with groups to set all the synths in that group.

// Can allocate buses. Doesn't create more buses, but does name this bus as this global variable:
~fxBus = Bus.audio(s, 2);

// resets the bus counter
s.newBusAllocators;

// forces everything contained to be sent to the server as one message.
(
s.bind({
	// put code here
});
)