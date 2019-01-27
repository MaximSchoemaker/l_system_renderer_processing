# l-system-renderer-processing
L-System parsing and rendering system for Processing

![](examples/hilbert_large_dynamic_thick_loop_color.gif)

Reads l-systems from "data/l-system.txt"
1st line: rules
2nd line: start character
3rd line: character to be rendered
4th line: angle of turning

Example (Hilbert Cuvrve):

L -> +RF-LFL-FR+, R -> -LF+RFR+FL-  
L  
F  
90

More examples inside file. Just move any to the top of the file to have it rendered. Editing can be done in real time, cause data/l-system.txt is being hotloaded(!)

The system is set up to have you edit parameters in real time. These paramters have a character which, when held down on a keyboard, will generate an 'x', 'y' and 'z' value using the mouse position (+ mousewheel), a 'click' value using mouse click and an 'on' value when toggled.

par("c").z      = l-system depth  
par("c").click  = animate l-system / render at depth

par("v").z      = additional line thickness  
par("v").x      = line thickness multiplication

par("a").x      = hue range  
par("a").y      = hue offset

par("z").x      = turning angle value (1 is full, 0 is 0)

par("w").click  = render balls / render lines

![](examples/hilbert_breathe.gif)
![](examples/sirpinsky_balls.gif)
![](examples/square_breathe.gif)
