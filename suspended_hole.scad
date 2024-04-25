
//! @author Orso Eric https://github.com/OrsoEric

//Layer height of the 3D printer
gn_layer_height = 0.2;

module base_cylinder(in_diameter, in_height, in_precision = 5)
{
    linear_extrude(in_height)
    circle(d = in_diameter, $fs = 0.1+in_precision, $fa = 0.1+in_precision*3/5);
}

module rounded_rectangle( inx_length, iny_length, inz_height, ind_rounding, in_precision = 0.5 )
{
    linear_extrude( inz_height )
    union()
    {
        square([inx_length-ind_rounding,iny_length], center=true);
        
        square([inx_length,iny_length-ind_rounding], center=true);
        
        translate([-(inx_length/2-ind_rounding/2), -(iny_length/2-ind_rounding/2), 0])
        circle(d=ind_rounding, $fs = 0.1+in_precision, $fa = 0.1+in_precision*3/5);
        
        translate([-(inx_length/2-ind_rounding/2), +(iny_length/2-ind_rounding/2), 0])
        circle(d=ind_rounding, $fs = 0.1+in_precision, $fa = 0.1+in_precision*3/5);
        
        translate([+(inx_length/2-ind_rounding/2), -(iny_length/2-ind_rounding/2), 0])
        circle(d=ind_rounding, $fs = 0.1+in_precision, $fa = 0.1+in_precision*3/5);
        
        translate([+(inx_length/2-ind_rounding/2), +(iny_length/2-ind_rounding/2), 0])
        circle(d=ind_rounding, $fs = 0.1+in_precision, $fa = 0.1+in_precision*3/5);
        
    }
    
}

module suspended_hole( in_big_diameter, in_big_height, in_small_diameter, in_small_height, in_precision = 5, in_wide_feature = gn_layer_height, in_narrow_feature = gn_layer_height )
{
    
    base_cylinder( in_big_diameter, in_big_height-in_wide_feature, in_precision );
    
	if (in_wide_feature > 0)
    translate([0,0,in_big_height-gn_layer_height])
    rounded_rectangle( in_big_diameter, in_small_diameter, in_wide_feature, in_big_diameter/3, in_precision/2);
    
	if (in_narrow_feature > 0)
    translate([0,0,in_big_height])
    rounded_rectangle( in_small_diameter, in_small_diameter, in_narrow_feature, in_small_diameter/3, in_precision/2);
    
	translate([0,0,in_big_height+in_narrow_feature])
	base_cylinder( in_small_diameter, in_small_height - in_narrow_feature, in_precision );
}

module suspended_hole_hex( in_big_diameter, in_big_height, in_small_diameter, in_small_height, in_precision = 5, in_wide_feature = gn_layer_height, in_narrow_feature = gn_layer_height )
{
    //rotate([0,0,90])
    linear_extrude(in_big_height-gn_layer_height)
    circle(d = in_big_diameter, $fn = 6);
    
	if (in_wide_feature > 0)
    translate([0,0,in_big_height-gn_layer_height])
    rounded_rectangle( in_big_diameter, in_small_diameter, in_wide_feature, in_big_diameter/3, in_precision/2);
    
	if (in_narrow_feature > 0)
    translate([0,0,in_big_height])
    rounded_rectangle( in_small_diameter, in_small_diameter, in_narrow_feature, in_small_diameter/3, in_precision/2);
    
	translate([0,0,in_big_height+in_narrow_feature])
	base_cylinder( in_small_diameter, in_small_height - in_narrow_feature, in_precision );
}

//Block with four styles of suspended holes with different combination of wide and narrow features
module test_bench()
{
	nd_hole_big = 8;
	nh_hole_big = 2;
	nd_hole_small = 3.2;
	nh_hole_small = 12;

	n_block_size = nd_hole_big *3;
	n_block_height = nh_hole_big +nh_hole_small;

	n_hole_pitch = nd_hole_big *0.75;

	difference()
	{
		union()
		{
			rounded_rectangle( n_block_size, n_block_size, n_block_height, 10);
		};

		translate([-n_hole_pitch, -n_hole_pitch, 0 ])
		suspended_hole(nd_hole_big, nh_hole_big, nd_hole_small, nh_hole_small, 0.5, 0, 0);

		translate([-n_hole_pitch, +n_hole_pitch, 0 ])
		suspended_hole(nd_hole_big, nh_hole_big, nd_hole_small, nh_hole_small, 0.5, gn_layer_height, 0);

		translate([+n_hole_pitch, -n_hole_pitch, 0 ])
		suspended_hole(nd_hole_big, nh_hole_big, nd_hole_small, nh_hole_small, 0.5, 0, gn_layer_height);

		translate([+n_hole_pitch, +n_hole_pitch, 0 ])
		suspended_hole(nd_hole_big, nh_hole_big, nd_hole_small, nh_hole_small, 0.5, gn_layer_height, gn_layer_height);

	}
}

//Round nut with support features
//suspended_hole( 30, 5, 10, 20, 1 ); 

//Round nut without support features
//suspended_hole( 30, 5, 10, 20, 1, 0, 0 ); 

//Hex nut with support features
//suspended_hole_hex( 30, 5, 10, 20, 1 ); 

//Hex nut without support features
//suspended_hole_hex( 30, 5, 10, 20, 1, 0, 0 ); 

//Block to test the effect of the combination of all support features
//test_bench();