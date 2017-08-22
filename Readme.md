This is a Sketchup plugin that simulates the grinds produced by the Tormek gouge jig.

So far it can procedurally generate a woodturning bowl gouge but with a few limitations:
* Nose profile is circular although people usually make them parabolic-ish
* Nose profile generation freaks out if you deviate too much from the default parameters

Check out this project if you're interested in interacting with Sketchup via its Ruby API.  Also if you're looking to draw smooth parabolas I'm using the `Curve` class which looks very nice.

# Usage

If you'd like to try out the code:
# Clone this repo to someplace on your computer: `git clone https://github.com/DavidPx/SketchupGougeCreator.git`
# Within Sketchup, Window > Ruby Console
# type: `load 'c:\directorywherethecodeis\Gouge3D\gouge3d\main.rb'`