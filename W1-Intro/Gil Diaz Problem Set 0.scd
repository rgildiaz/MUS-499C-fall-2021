//Problem Set 0
//Due 3pm Sept 2nd 2021

//First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set 0.scd"), and upload this renamed file to the course website for your submission.



//----------
//Problem 0.
//The following code produces an error when evaluated. Correct the error and add a comment indicating the problem. Comments are created by starting a line with two forward slashes, exactly like this line. Remember to use the correct keyboard shortcut to evaluate a multi-line chunk of code.

(
oranges = 3;
oranges = oranges * 2;
oranges = oranges - 1;
)


// Corrected code:
(
// The original code did not define "oranges" as a variable, which threw an error every time "oranges" was used.
var oranges = 3;
oranges = oranges * 2;
oranges = oranges - 1;
)




//----------
//Problem 1.
//The following code produces an error. Correct the error and add a comment indicating the problem.

(
var oldBalance, deposit, newBalance;
oldBalance = 5
deposit = 100;
newBalance = oldBalance + deposit;
)



// Corrected code:
(
var oldBalance, deposit, newBalance;
// The original code was missing a semicolon at the end of the next line.
oldBalance = 5;
deposit = 100;
newBalance = oldBalance + deposit;
)




//----------
//Problem 2.
//The following code produces an error. Correct the error and add a comment indicating the problem.

(
var classroomSize, numClasses, totalStudents;
classroomSize = 30;
numClasses = 4;
totalstudents = classroomSize * numClasses;
)


// Corrected code:
(
// var totalStudents is defined here on line 70.
var classroomSize, numClasses, totalStudents;
classroomSize = 30;
numClasses = 4;
// The original code did not capitalize the "S" in var totalStudents on the next line, 74, and since vars are case-sensitive, this threw an error as "totalStudents" was defined, but "totalstudents" was not.
totalStudents = classroomSize * numClasses;
)




//----------
//Problem 3.
//The following code produces an error. Correct the error and add a comment indicating the problem.

(
~func = {
	arg, x=5, y=6, z=7;
	var product;
	product = x * y * z;
};
)


// Corrected code:
(
~func = {
	// There should not be a comma after "arg" when declaring arguments.
	arg x=5, y=6, z=7;
	var product;
	product = x * y * z;
};
)

~func.();




//----------
//Problem 4.
//There are two different syntax styles for passing an method to a receiver. The first, demonstrated in class, takes the form: 'receiver.method' and is called "receiver syntax." For example:

8.class;

//The other syntax, called "function call syntax," takes the form 'method(receiver)' — it begins with the method and continues with the receiver, enclosed in parentheses, like this:

class(8);

//With this in mind, consider the following expression, which returns a boolean (a true/false value) indicating whether the square of 45 is an odd number. It is written entirely in receiver syntax. Rewrite this expression so that it is *entirely* in function call syntax.

45.squared.odd;

// function call syntax:
odd(squared(45));




//----------
//Problem 5.
//Write a comment that explains why the following code expression produces an error message.

45.odd.squared;

// The .odd method for Integers returns a boolean: true if the receiver is odd and false otherwise. The .squared method returns a*a, where a is the receiver. Since booleans cannot be multiplied, this throws an error.





//----------
//Problem 6.
//The 'postln' method is useful for printing the values of code statements, allowing us to see additional information about code as it runs. This is particularly helpful for debugging broken code. For example, the following function squares an input value, posts the value, and then continues by subtracting 1, and returns the result:

(
~func = {
	arg num;
	num = num.squared;
	num.postln;
	num = num - 1;
};
)

~func.(6);

//Write a function that accepts three input arguments and prints the class that each item belongs to. Add at least one additional line of code that evaluates the function, to demonstrate that it works.

(
~func2 = {
	|in1, in2, in3|
	[in1, in2, in3].do({
		arg i;
		i.class.postln;
	});
};
)

~func2.(true, "true", \true);



//----------
//Problem 7.
//Create a named function that takes an Array as an input argument, and returns that same Array in which the first and last items have switched positions. If the input array has only one item, the function should return that same array, unaltered. After creating this function, include one or more additional lines of code that evaluate the function, to demonstrate that it works correctly (there are multiple ways to solve this problem).

(
~switch = {
	arg in;
	var tempAr=Array(in.size);

	// Copy the array (is there a better way to do this? I couldn't find a "copy" function.)
	in.do({ arg i;
		tempAr.add(i);
	});

	// Replace the first and last values of tempAr
	tempAr[0] = in[in.size - 1];
	tempAr[tempAr.size - 1] = in[0];
	tempAr;
};
)

~switch.([1, 2, 3, 4]);
~switch.([1]);
~switch.([true, "true", \true, false, "false", \false]);




// Wanted to try with 0 size array. This is the best I could do. Is there a way to force the function to return something and exit immediately? I wanted to avoid putting all of the code that copies and switches values inside the if statement, but I could not find a way to break if the array is empty.
(
~switch0 = {
	arg in;
	var tempAr=Array(in.size);

	// Check if in is empty
	if(in.size == 0,

		// if yes, return in
		{
			in;
		},

		// else, proceed as normal
		{
			// Copy the array
			in.do({ arg i;
				tempAr.add(i);
			});
			// Replace the first and last values of tempAr
			tempAr[0] = in[in.size - 1];
			tempAr[tempAr.size - 1] = in[0];
			tempAr;
		}
	);
};
)

~switch0.([]);
~switch0.([1, 2, 3, 4]);
~switch0.([1]);
~switch0.([true, "true", \true, false, "false", \false]);


//----------
//Problem 8.
//Write a line of code that boots the audio server. Then, write a named UGen function that generates a sine wave. The function should include an argument for the amplitude of the sine wave (i.e. the 'mul' argument of SinOsc). Include a few additional lines of code that play the UGen function with different amplitude values, to demonstrate that it works (please only use 'mul' values that are between 0 and 1). For each line of code that produces sound, include a line of code that stops that sound (I shouldn't need to press command-period).

s.boot;

(
~sine = {
	arg mul;
	SinOsc.ar(200, mul:mul);
};
)

~play = ~sine.play(args: [mul:0.01]);
~play.free;

~play = ~sine.play(args: [mul:0.1]);
~play.free;

~play = ~sine.play(args: [mul:0.5]);
~play.free;
