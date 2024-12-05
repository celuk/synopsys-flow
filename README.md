# synopsys-flow

ICV version U-2022.12-SP4-2 or newer required. If you need to set an ICV executable that is not in your path you need to change related section in ``00_setup.tcl` file.

Also, if you need to give a path for `fc_shell` or `lm_shell` change them in `Makefile`.

If all tools are in path, there are no changes required.

## TL;DR

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
