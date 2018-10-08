/* Copyright (C) 2018 Jason T Tech <jasonttech@gmail.com>
 *
 * This work is free: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This work is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this.  If not, see <https://www.gnu.org/licenses/>.
*/


//Wall width at top and bottom
width=2; //[1:0.1:5]


//Extra Height past lips
height = 12; //[2:0.5:50]

/* [Hidden] */
//How much extra room to fit over bottom of hopper
Btolerance=.5;

//Height of Lip
lipH = 15.44;

//Lip Width Not Used
lipW = 2.65;

//DXF file of traced bottom
dxfFile = "beanHopperTrace.dxf";
dxfLayer = "NoSplineExport";

//Overall dimensions of DFX path. Path is moved to 0,0 before export
dxfX = 190.384;
dxfY = 118.995;


//In preview make cut larger to avoid coincident faces.
fudge= $preview ? .04: 0;



//Bed stick
intersection(){
    union (){
        translate([85,-47,0])
            cylinder(r = 8, h=1);
        translate([-85,-47,0])
            cylinder(r = 8, h=1);
        translate([88,55,0])
            cylinder(r = 8, h=1);
        translate([-88,55,0])
            cylinder(r = 8, h=1);
    }
    linear_extrude(height = .2 )
        difference(){
                outline(width+Btolerance + 8);
                outline(width+Btolerance);
        }
}



//Bottom
linear_extrude(height = lipH )
    difference(){
            outline(width+Btolerance);

            outline(Btolerance);
    }


//Middle with inside taper
translate([0,0,lipH]){
    
    difference(){
        linear_extrude(height = height)
            outline(width+Btolerance);

        //Calculate scale factor for middle taper
        topInsideX = dxfX - (width * 2);
        bottomInsideX = dxfX + (Btolerance * 2);
        topInsideY = dxfY - (width * 2);
        bottomeInsideY = dxfY + (Btolerance * 2);

        xscale = topInsideX/bottomInsideX;
        yscale = topInsideY/bottomeInsideY;
        //Cut Taper
        translate([0,0,-fudge/2]){
            linear_extrude(height = height + fudge,scale=[xscale,yscale] )
                outline(Btolerance);
        }

        //cut again to deal with corner scaling differntly
        translate([0,0,-fudge]){
            linear_extrude(height = height + fudge*2)
                outline(-width);
        }
    }
}


//Top
translate([0,0,lipH+height]){
    linear_extrude(height = lipH){
        difference(){
            outline();
            
            outline(-width);
        }
    }
}


//Import, Center, and offset DXF
module outline(offsetR = 0){
    offset(r=offsetR)
        translate([-dxfX/2, -dxfY/2,0])
            import(file = dxfFile,layer = dxfLayer);
}

// vim: set expandtab: tabstop=4 shiftwidth=4
