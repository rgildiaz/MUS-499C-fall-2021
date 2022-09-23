Quarks.gui;


// 2021.11.11 More GUI

// Guide file: Introduction to GUI
// Contains a near-complete list of GUI objects

// Getting/setting
x.value(); 			// returns the value
x.value_(param); 	// sets the value

// Use Lag to avoid clicks/to smooth out control sigs
Lag;
VarLag;		// Custom curves, like for envs
// Use .lag(s) to lag the signal by s seconds like this:
cf.lag(0.1);
cf.varlag(time, curve);


// Mouse & Key Actions
// Slider: Center, maXimum, miNimum, Random

// Can define mouse and key actions
// .mouseEnterAction_({ |view, mousex, mousey| })
// Find more here:
View;

// Focus
// .canFocus_(bool)

// Decorator
// Decorators can make spacing easier.
FlowLayout;
w.view.decorator_(FlowLayout(w.view.bounds, Point, Point));
Point(3, 5); 3@5;

SimpleController;


// Drawing and Animation
UserView;
Pen;