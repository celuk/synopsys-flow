# Parameters
set c0_io_pad $BONDPAD_CELL
set c0_io_lib "io"
set c0_bond_pad_suffix "_PAD"

# Delete existing bond pads
set existing_bondpads [get_cells -hier -filter "name =~ *$c0_bond_pad_suffix"]
if { [llength $existing_bondpads] > 0 } {
    remove_cell $existing_bondpads
}

# Create temporary bond pad to get size
set bond_pad_cell "MY_TMP_BONDPAD_12345"
create_cell $bond_pad_cell $c0_io_pad
set bond_pad_bbox [get_attribute [get_cells $bond_pad_cell] bbox]
set bond_pad_height [expr [lindex $bond_pad_bbox 1 1] - [lindex $bond_pad_bbox 0 1]]
remove_cell $bond_pad_cell

# Find IO cells by library
set io_cell_names [get_lib_cells -filter "lib_name == $c0_io_lib"]

# Process each IO cell
foreach io_cell_name $io_cell_names {
    set design_io_cells [get_cells -hier -filter "ref_name == $io_cell_name"]
    
    foreach cell $design_io_cells {
        set cell_name [get_object_name $cell]
        set cell_location [get_attribute $cell origin]
        set cell_orient [string toupper [get_attribute $cell orientation]]
        
        # Create a bond pad for each IO cell
        set bond_pad_name "${cell_name}${c0_bond_pad_suffix}"
        set bond_pad_location $cell_location
        
        create_cell $bond_pad_name $c0_io_pad
        set_attribute $bond_pad_name orientation $cell_orient
        move_objects -to $bond_pad_location [get_cells $bond_pad_name]
        
        echo "Added bond pad: $bond_pad_name at $bond_pad_location with orientation $cell_orient"
    }
}
