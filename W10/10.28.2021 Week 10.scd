// 10.28.2021 Week 10

s.boot;

// MIDI

// rrand vs Rand?
// . nearestInScale


// MIDI
MIDIClient.init;
MIDIIn.connectAll;

// Show all MIDI data
MIDIFunc.trace(true);

MIDIFunc.trace(false);


// doesn't overwrite
MIDIFunc;
// requires a symbol name, overwrites old data
MIDIdef;


(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	"note on received".postln;
});
)

