# synopsys-flow

Standalone Synopsys Fusion Compiler Flow

Check this for Cadence one: https://github.com/celuk/cadence-flow

ICV version `U-2022.12-SP4-2` or newer required, so Fusion Compiler, too. If you need to set an ICV executable that is not in your path you need to change related section in `00_setup.tcl` file.

Also, if you need to give a path for `fc_shell` or `lm_shell` change them in `Makefile`.

If all tools are in path, there are no changes required.

Before running place all lef, gds, timing libs, tech PDK files correctly in [`data/lef`](data/lef), [`data/gds`](data/gds), [`data/nldm`](data/nldm), [`data/tech`](data/tech) folders.

For using another PDK, you need to modify data folder, whole [`00_pdk_setup.tcl`](scripts/00_pdk_setup.tcl), write an ndm creation script like [`00_create_ndms.tcl`](scripts/00_create_ndms.tcl) and you may need to change some parts of the flow for technology node specific things such as [`tap cells`](scripts/04_design_planning.tcl#L45) in `TSMC65`.

For sramless designs changing the verilog code in [`data/rtl`](data/rtl), changing the constraint in [`data/sdc`](data/sdc/c0_soc.sdc), setting top module name in [00_setup.tcl](scripts/00_setup.tcl#L18), placing required files into [`data`](data) folder and filling variables in [`00_pdk_setup.tcl`](scripts/00_pdk_setup.tcl) should be sufficient to run the whole flow and get a GDS that is ready for fabrication. You should have a soc verilog module for IOs such as [`c0_soc.v`](data/rtl/c0_soc.v) that wraps your top module.

## USAGE OF THIS FLOW TOOL TL;DR

Making ndms and running the flow:
```bash
make ndms # for the first time
make all
```

Cleaning all ndms and flow related garbage:
```bash
make clean_all
```

Cleaning just flow related garbage:
```bash
make clean
```

Running selected scripts of the flow such as step1-2-3:
```bash
make s1 s2 s3
```

Removing certain blocks and steps after such as 7th block and after:
```bash
make remove 7
```

Show the latest block:
```bash
make show # with gui
make show_cli # without gui
```

Show 11th block:
```bash
make show 11
```

**Note:** After showing the blocks you can immediately run Live ICV by pressing the icon in GUI without bothering to set options again.

Following command removes 5th block and the blocks after (5-6-7-...), then runs the steps 5 and 6 and shows latest(6th) block without gui:
```bash
make remove 5 s5 s6 show_cli
```

Following command removes all blocks and runs all again.
```bash
make clean all
```

Following command cleans all garbage including generated ndms, then generates ndms, runs all the flow scripts and show the latest block at the end of the operations.
```bash
make clean_all ndms all show
```
