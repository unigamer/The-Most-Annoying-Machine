// The Most Useless Machine
// v1 - OpenSCAD
// Jonathan Jamieson
// www.jonathanjamieson.com
// http://hackaday.io/project/4333-the-most-annoying-machine

//--- Original file preamble
//From http://www.thingiverse.com/thing:27452
//By Peter Uithoven, FabLab Amersfoort
//--- End of Original file preamble
width = 180;
height = 50;
depth = 111.246117975;
materialThickness = 3;
offset = 0; // for lasercutter beam width
boltWidth = 3.7;
boltLength = 12;
nutWidth = 7.85;
nutHeight = 2.6;
spaceAroundBolt = 10;
plugWidth = 30;
plugHeight = materialThickness;
f = 1; // fix for overlapping edges issue
c = 30; //cornerResolution ($fn)
s = 1;//seperator dis.
// ungly, but we can't add to variables since they are calculated compile time
width2 = width+offset*2;
height2 = height+offset*2;
depth2 = depth+offset*2;
plugWidth2 = plugWidth+offset*2;
plugHeight2 = plugHeight+offset;
holeWidth2 = plugWidth-offset*2;
holeHeight2 = plugHeight-offset*2;
boltWidth2 = boltWidth-offset*2;
boltLength2 = boltLength-offset;
nutWidth2 = nutWidth-offset*2;
nutHeight2 = nutHeight-offset*2;
spaceAroundBolt2 = spaceAroundBolt-offset*2;

// Panel Cutout
cutout_width = 24.4;
cutout_height = 34.4;

export();
//assembly3D();
module export()
{
bottom();
translate([width2+s,0,0]) top();
translate([0,depth2+s,0]) front();
translate([width2+s,depth2+s,0]) back();
translate([0,depth2+s+height2+s,0]) left();
translate([depth2-materialThickness*2+s,depth2+s+height2+s,0]) right();
}
module assembly3D()
{
translate([0,0,materialThickness*1.5]) wood() bottom();
%translate([0,materialThickness/2,0]) rotate([90,0,0]) wood() front();
translate([0,depth2-materialThickness/2,0]) rotate([90,0,0]) wood() back();
translate([materialThickness/2,materialThickness,0]) rotate([90,0,90]) wood() left();
%translate([width2-materialThickness/2,materialThickness,0]) rotate([90,0,90]) wood() right();
translate([0,0,height2-materialThickness*1.5-offset]) wood() top();
}
module bottom()
{
difference()
{
union()
{
//TODO: incorporate f
translate([plugHeight2,plugHeight2,0])
square([width2-plugHeight2*2,depth2-plugHeight2*2]);



translate([width2*(2/7),0,0]) plug();
translate([width2*(5/7),0,0]) plug();

translate([width2*(2/7),depth2,0]) rotate([0,0,180]) plug();
translate([width2*(5/7),depth2,0]) rotate([0,0,180]) plug();




translate([0,depth2/2,0])


rotate([0,0,-90]) plug();
translate([width2,depth2/2,0])
rotate([0,0,90]) plug();
}


translate([width2*(2/7),0,0]) boltCutOut1();
translate([width2*(5/7),0,0]) boltCutOut1();



translate([width2*(2/7),depth2,0]) rotate([0,0,180]) boltCutOut1();
translate([width2*(5/7),depth2,0]) rotate([0,0,180]) boltCutOut1();



translate([width2,depth/2,0]) rotate([0,0,90]) boltCutOut1();
translate([0,depth/2,0]) rotate([0,0,-90]) boltCutOut1();
}
}
module top()
{

difference() {

bottom();

translate([width2/2,depth2/2,0]) square([cutout_width, cutout_height], center=true);
translate([width2/2+-30,depth2/2,0]) circle(d=2.75,$fn=70);

}

}


module front()
{
difference()
{
square([width2,height2]);
//width2/2-plugWidth2/2,materialThickness+offset
translate([width2*(2/7)-holeWidth2/2,materialThickness+offset,0]) hole();
translate([width2*(5/7)-holeWidth2/2,materialThickness+offset,0]) hole();


translate([width2*(2/7)-holeWidth2/2,height-materialThickness-offset-holeHeight2,0]) hole();
translate([width2*(5/7)-holeWidth2/2,height-materialThickness-offset-holeHeight2,0]) hole();


*translate([materialThickness+holeHeight2,height2/2-holeWidth2/2,0]) rotate([0,0,90]) hole();
*translate([width2-materialThickness,height2/2-holeWidth2/2,0]) rotate([0,0,90]) hole();
}
}
module back()
{
front();
}
module left()
{
width = depth2-materialThickness*2;
height = height2;
difference()
{
translate([0,0]) square([width,height]);
translate([width/2-holeWidth2/2,materialThickness+offset,0]) hole();
translate([width/2-holeWidth2/2,height-materialThickness-offset-holeHeight2,0]) hole();
*translate([holeHeight2,height2/2-holeWidth2/2,0]) rotate([0,0,90]) hole();
*translate([width-materialThickness,height2/2-holeWidth2/2,0]) rotate([0,0,90]) hole();
}
}
module right()
{
left();
}
module plug()
{
translate([-plugWidth2/2,0,0]) square([plugWidth2,plugHeight2+f]);
}
module boltCutOut1()
{
union()
{
translate([-spaceAroundBolt2/2,-f,0])
square([spaceAroundBolt2,plugHeight2+f]);
translate([-nutWidth2/2,plugHeight2+materialThickness,0])
square([nutWidth2,nutHeight2]);
translate([-boltWidth2/2,0,0])
square([boltWidth2,boltLength2]);
}
}
module hole()
{
difference()
{
square([holeWidth2,holeHeight2]);
translate([holeWidth2/2-spaceAroundBolt/2-offset,0,0])
square([spaceAroundBolt+offset*2,holeHeight2]);
}
translate([holeWidth2/2,holeHeight2/2,0]) circle(r=boltWidth2/2,$fn=c);
}
module boltCutOut2()
{
union()
{
translate([-spaceAroundBolt2/2,-f,0])
square([spaceAroundBolt2,plugHeight2+f]);
translate([-nutWidth2/2,plugHeight2+materialThickness,0])
square([nutWidth2,nutHeight2]);
translate([-boltWidth2/2,0,0])
square([boltWidth2,boltLength2]);
}
}
/////////////// utils ///////////////
module wood(alpha=1)
{
h = materialThickness;
color("BurlyWood",alpha) linear_extrude(height=h,convexity=c,center=true) for (i = [0 : $children-1]) child(i);
}
module mirrored(offset=0)
{
translate([ offset/2, 0, 0]) for (i = [0 : $children-1]) child(i);
translate([-offset/2, 0, 0]) scale([-1,1,1]) for (i = [0 : $children-1]) child(i);
}
module toiletRoll() {
color("White")
{
difference() {
cylinder(h = toiletRollHeigth, r=toiletRollRadius,$fn=c);
translate([0,0,-f]) cylinder(h = toiletRollHeigth+f*2, r=toiletRollInnerRadius,$fn=c);
}
}
}