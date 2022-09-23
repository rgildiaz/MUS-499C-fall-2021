//Problem Set 5
//Due 3pm CDT Thursday Oct 7th 2021

//Save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set 5.scd").

//For this problem set, I am providing you with some starting SynthDefs - one that loops a buffer, one that applies a flanger effect to an input signal, and one that applies a reverb effect to an input signal. A drum loop sample is also provided:

https://uofi.box.com/s/vrh8j78mhend29hvyydpt4gygtlb0wfh

//Boot the server, evaluate the SynthDefs below, and take some time to read and study them.

(
SynthDef.new(\playbuf, {
	arg buf=0, rate=1, amp=0.3, gate=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.asr(0,1,2,-1), gate, doneAction:2);
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, loop:1);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

SynthDef.new(\flanger, {
	arg in=0, out=0;
	var sig, flanger;
	sig = In.ar(in, 2);
	flanger = In.ar(in, 2);

	//Note for the curious: a flanger effect is created by summing a signal with a delayed copy of itself, in which the delay time is fluctuating, usually sinusoidally. This creates predictable patterns of constructive and destructive interference, resulting in a sweeping resonance effect that follows the pattern of the sine wave (in this case, the pitch of the resonance varies between 100 and 1000 Hz)
	flanger = CombL.ar(sig, 0.01, SinOsc.ar(0.1).exprange(0.001,0.01), 0.03);
	sig = (sig + flanger) * 0.5;

	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in=0, drylevel=0.7, wetlevel=0.3, out=0;
	var sig, reverb;
	sig = In.ar(in, 2);
	reverb = In.ar(in, 2);
	reverb = GVerb.ar(sig.sum, 250, 4);
	reverb = LPF.ar(reverb, 1000);
	sig = (sig * drylevel) + (reverb * wetlevel);
	Out.ar(out, sig);
}).add;
)


//----------
//Problem 0.
//Load the drum loop into a Buffer, stored in a global variable. Use the "thisProcess.nowExecutingPath" method, as you did on the previous problem set — this code file and the drum sample should be placed in the same folder. When you are ready to submit your answers for this problem set, create a zip file of this folder and submit the zip. I should be able to run your code without needing to change the file path.







//----------
//Problem 1.
//Write some code that plays through the buffer, and sends the audio signal through the flanger effect, and then sends the flanger output through the reverb. This will involve allocating some audio busses using Bus.audio(). Add one or more lines of code afterward that stop the sound and handle cleanup (e.g. fade out the Synth that plays the buffer, and free the effect Synths). Do this without using Groups. The signal path should look like this:

// [buf] --> [flanger] --> [reverb] --> [speakers]







//----------
//Problem 2.
//Same as the previous problem, but this time, create and use Groups to organize your signal flow. Remember that you only have to allocate busses once, and redundant bus allocation can lead to problems. Reuse the busses you allocated from the previous problem. Don't forget to include cleanup code again, making sure to remove the Groups as well.








//----------
//Problem 3.
//Same as the previous problem, but swap the order of the two effects. Include some cleanup code. The signal path should look like this:

// [buf] --> [reverb] --> [flanger] --> [speakers]

//The result will sound mostly the same as the previous problem, but there is a very subtle difference — in this case, the reverb tail will have an audible flanger effect applied to it, whereas in the previous problem, the reverb sounds more "normal."






//----------
//Problem 4.
//Write some code that loops through the buffer, and sends that audio signal to both effects in parallel, instead of in series. This will involve modifying the \playbuf SynthDef so that there are two "Out.ar" UGens with two different bus arguments, allowing the signal to branch and follow two different paths. You can use Groups if you want, but this can also be done without Groups. The signal path should look like this:

// [buf] -----> [verb] ----> [speakers]
//         |                     ^
//         |                     |
//         |                     |
//         \--> [flange] --------/









