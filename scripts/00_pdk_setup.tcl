# This file is part of https://github.com/celuk/synopsys-flow
# Copyright (C) 2024  Seyyid Hikmet Celik
#                     seyyid4091@gmail.com
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

## this file is a filtered version of tsmc 65nm 12 track pdk library setup that includes stdcells, io cells, bondpads, sealring
## you need to set variables used in the scripts but note that some are stale

set TSMCHOME "/TSMCHOME"

set STDCELL_LEF_FILE ""
set IO_LEF_FILE ""
set BONDPAD_LEF_FILE ""

set STDCELL_GDS_FILE ""
set IO_GDS_FILE ""
set BONDPAD_GDS_FILE ""
set SEALRING_GDS_FILE ""
set SEALRING_WLCSP_GDS_FILE ""

set WB_BONDPAD_LEF_FILE ""
set WB_BONDPAD_GDS_FILE ""

set STD_MILKYWAY ""
set IO_MILKYWAY ""
set BONDPAD_MILKYWAY ""

set STD_MILKYWAY_FRAME_ONLY ""
set IO_MILKYWAY_FRAME_ONLY ""
set BONDPAD_MILKYWAY_FRAME_ONLY ""

set STDCELL_SPICE_FILE ""
set IO_SPICE_FILE ""

set TECH_FILE ""
set GDSOUT_MAP_FILE ""

set PARASITICS_MAP_FILE ""
set PARASITICS_MAX_TLUPLUS_FILE ""
set PARASITICS_NOM_TLUPLUS_FILE ""
set PARASITICS_MIN_TLUPLUS_FILE ""

set STDCELL_DB_FILES [list \
];

set IO_DB_FILES [list \
];

set STDCELL_DB_PREFIX ""
set IO_DB_PREFIX ""

set GDS_FILES_TO_MERGE [list \
];

## you may need some corrections for old runsets to use in Synopsys Fusion Compiler
## you may need check defines in them as well
set TCL_ANTENNA_RULE_FILE ""
set METAL_FILL_FEOL_RUNSET ""
set METAL_FILL_BEOL_RUNSET ""
set DRC_RUNSET ""
set ANTENNA_DRC_RUNSET ""
set MIM_ANTENNA_DRC_RUNSET ""
set LVS_RUNSET ""

set CTS_LIB_CELL_PATTERNS "*/*BUF* */*INV*"

set DONT_TOUCH_CELL_PATTERNS {*Corner* *VDD* *VSS* *PDDW0204CDG* *PDDW0812CDG*}

set TAP_CELL ""

## dcap
set BOUNDARY_CELL ""

## buff 12
set CLOCK_BUFFER_CELL ""

## pad55
set BONDPAD_CELL ""

## 1kx1k
set SEALRING_CELL ""

## dcap
## fill
set FILLER_CELLS [list \
];

## pfiller
set IO_PAD_FILLER_CELLS [list \
];

## dcap
set METAL_FILLER_CELLS [list \
];

set BOUNDARY_CELLS $METAL_FILLER_CELLS

## fill
set NON_METAL_FILLER_CELLS [list \
];

## tie
set TIE_CELLS [list \
];

## buf
set BUFFER_CELLS [list \
];

## lvl
set STD_LEVEL_SHIFTER_CELLS [list \
];

set IO_LEVEL_SHIFTER_CELLS [list \
];

## iso
set STD_ISOLATION_CELLS [list \
];

## pclamp
set IO_ISOLATION_CELLS [list \
];

## pfiller
## sbb654
set ALL_IO_PAD_FILLER_CELLS [list \
];

set TT_OPC_STDCELL "NCCOM"
set BC_OPC_STDCELL "BCCOM"
set LT_OPC_STDCELL "LTCOM"
set ML_OPC_STDCELL "MLCOM"
set WC_OPC_STDCELL "WCCOM"
set WCZ_OPC_STDCELL "WCZCOM"
set WCL_OPC_STDCELL "WCLCOM"

set TT_OPC_IO "NCCOM1"
set BC_OPC_IO "BCCOM1"
set LT_OPC_IO "LTCOM1"
set ML_OPC_IO "MLCOM1"
set WC_OPC_IO "WCCOM1"
set WCZ_OPC_IO "WCZCOM1"
set WCL_OPC_IO "WCLCOM1"
