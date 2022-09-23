//Problem Set 4
//Due 3pm Sept 30th 2021

//----------
//Problem 0.
//Download the following two audio samples (a desk bell and a drum loop):

https://uofi.box.com/s/vrh8j78mhend29hvyydpt4gygtlb0wfh //drum loop
https://uofi.box.com/s/2jcyp9wic50dqs78fa1weyijihldwwtj //desk bell

//Boot the audio server. As demonstrated in class, create a project folder named "[your last name] Problem Set 4." Save this code file in that folder, naming it "[your last name] Problem Set 4.scd," and also move or copy these two audio files into this folder.

/**NOTE: when you submit your assignment, make sure to compress this folder as a zip file and submit the zip file, so that your submission contains code and audio — don't submit only the scd file!!**/

//Using the "thisProcess.nowExecutingPath" approach, write some code that reads these two files into Buffers, and stores each Buffer in a unique global variable name. If you've done this correctly, I should be able to run this code on my own computer to read these files into buffers, without having to change any of your code.





//----------
//Problem 1.
//Write a line of code that returns the number of audio channels in the drum loop file, and another line of code that returns the number of audio channels in the desk bell file. No need to produce any sound here — just print/return the channel size information.





//----------
//Problem 2.
//Write a UGen function (not a SynthDef) that plays the desk bell sample once, at its original playback rate. The Synth should free itself when we reach the end of the sound file. Make sure to compensate for the possibility of a mismatch between the server's sampling rate and the sampling rate at which the sound file was created.





//----------
//Problem 3.
//Convert the UGen function from the previous problem into a SynthDef. In the SynthDef, declare arguments for the bufnum, the playback rate, the overall signal amplitude, and the output bus. Then, use iteration to play the desk bell sample at five different pitches simultaneously, to create a five-voice chord. Make sure the amplitude of the overall sound doesn't clip above 0 dB.





//----------
//Problem 4.
//Create a new SynthDef or modify the existing SynthDef so that it is capable of looping and non-looping playback. Include a sustaining envelope with a gate argument that controls overall amplitude. Below this new/modified SynthDef, include a line of code that creates a Synth which endlessly loops through the drum sample at its original rate, and a second line of code that closes the envelope gate to fade out the sound.






//----------
//Problem 5.
//Add a similar line of code that creates a Synth that endlessly loops through the drum sample, but backward. Add a second line of code that closes the envelope gate and fades out the sound.





//----------
//Problem 6.
//Use iteration to play three copies of the backward-looping drum sample at very slightly different playback rates (e.g. -0.99, -1.0, -1.01), so that these three Synths drift out of phase with each other over time. Make sure the amplitude of the overall sound doesn't clip above 0 dB. Write another line of code that fades out all three Synths.





