# This file is part of https://github.com/celuk/synopsys-flow
# Copyright (C) 2024  Seyyid Hikmet Celik
# 					  seyyid4091@gmail.com
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

FC_EXEC ?= /usr/synopsys/fusioncompiler/V-2023.12-SP3/bin/fc_shell
#/usr/synopsys/fusioncompiler/W-2024.09-SP2/bin/fc_shell
LM_EXEC ?= /usr/synopsys/fusioncompiler/V-2023.12-SP3/bin/lm_shell
#/usr/synopsys/icc2/V-2023.12/bin/lm_shell
#/usr/synopsys/icc2/W-2024.09-SP2/bin/lm_shell

TOP_MODULE ?= c0_soc
SETUP_TCL ?= scripts/00_setup.tcl

OUTPUTS_DIR ?= outputs
REPORTS_DIR ?= reports
LOGS_DIR ?= logs

ndm_script ?= scripts/00_create_ndms.tcl
script1  ?= scripts/01_synthesize.tcl
script2  ?= scripts/02_init_design.tcl
script3  ?= scripts/03_compile.tcl
script4  ?= scripts/04_design_planning.tcl
script5  ?= scripts/05_placement.tcl
script6  ?= scripts/06_cts.tcl
script7  ?= scripts/07_routing.tcl
script8  ?= scripts/08_signoff_extraction.tcl
script9  ?= scripts/09_signoff_metal_fill.tcl
script10 ?= scripts/10_signoff_drc.tcl
script11 ?= scripts/11_signoff_lvs.tcl
script12 ?= scripts/12_streamout.tcl

$(LOGS_DIR):
	mkdir -p $(LOGS_DIR)

all: s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12

ndms: $(LOGS_DIR)
	$(LM_EXEC) -batch -f $(ndm_script) | tee $(LOGS_DIR)/$(shell basename $(ndm_script) .tcl | sed 's|^.*/||').log

s1: $(LOGS_DIR)
	$(FC_EXEC) -batch -f $(script1) | tee $(LOGS_DIR)/$(shell basename $(script1) .tcl | sed 's|^.*/||').log

s2:
	$(FC_EXEC) -batch -f $(script2) | tee $(LOGS_DIR)/$(shell basename $(script2) .tcl | sed 's|^.*/||').log

s3:
	$(FC_EXEC) -batch -f $(script3) | tee $(LOGS_DIR)/$(shell basename $(script3) .tcl | sed 's|^.*/||').log

s4:
	$(FC_EXEC) -batch -f $(script4) | tee $(LOGS_DIR)/$(shell basename $(script4) .tcl | sed 's|^.*/||').log

s5:
	$(FC_EXEC) -batch -f $(script5) | tee $(LOGS_DIR)/$(shell basename $(script5) .tcl | sed 's|^.*/||').log

s6:
	$(FC_EXEC) -batch -f $(script6) | tee $(LOGS_DIR)/$(shell basename $(script6) .tcl | sed 's|^.*/||').log

s7:
	$(FC_EXEC) -batch -f $(script7) | tee $(LOGS_DIR)/$(shell basename $(script7) .tcl | sed 's|^.*/||').log

s8:
	$(FC_EXEC) -batch -f $(script8) | tee $(LOGS_DIR)/$(shell basename $(script8) .tcl | sed 's|^.*/||').log

s9:
	$(FC_EXEC) -batch -f $(script9) | tee $(LOGS_DIR)/$(shell basename $(script9) .tcl | sed 's|^.*/||').log

s10:
	$(FC_EXEC) -batch -f $(script10) | tee $(LOGS_DIR)/$(shell basename $(script10) .tcl | sed 's|^.*/||').log

s11:
	$(FC_EXEC) -batch -f $(script11) | tee $(LOGS_DIR)/$(shell basename $(script11) .tcl | sed 's|^.*/||').log

s12:
	$(FC_EXEC) -batch -f $(script12) | tee $(LOGS_DIR)/$(shell basename $(script12) .tcl | sed 's|^.*/||').log

clean:
	rm -rf \
		*.svf \
		*.log \
		*.txt* \
		*.nlib \
		*_rules_* \
		*tmp*/ \
		*cache*/ \
		HDL_LIBRARIES/ \
		legalizer_debug_plots/ \
		work_dir/ \
		pg_model/ \
		*StarRC*/ \
		.node* \
		signoff_fill_run/ \
		signoff_metal_density_report_run/ \
		signoff_check_drc_run_after_metal_fill/ \
		signoff_check_drc_run/ \
		signoff_check_antenna_drc_run/ \
		signoff_check_mim_antenna_drc_run/ \
		signoff_check_lvs_run/ \
		signoff_fix_drc_run/ \
		signoff_check_drc_run_after_fix_drc/ \
		signoff_create_pg_augmentation_run/ \
		signoff_check_drc_live_run/ \
		signoff_check_design_run/ \
		RAIL_DATABASE/ \
		*.ems \
		PreFrameCheck/ \
		.snps_mv_reports \
		pna_output/ \
		${OUTPUTS_DIR}/ \
		${REPORTS_DIR}/ \
		${LOGS_DIR}/ \
		CLIBs/ \
		export_mw_fram* \
		generate_frame_from_mw* \
		clock_auto_exceptions* \
		open_block.tcl \
		remove_block.tcl

clean_ndms:
	rm -rf data/lib/* data/lib/.[^.]*/ data/lib/..?*/

clean_all: clean clean_ndms

show show_cli:
	@echo "open_lib $(TOP_MODULE).nlib;" > open_block.tcl; \
	echo "redirect -var raw_blocks {list_blocks};" >> open_block.tcl; \
	echo "set blocks [regexp -all -inline {[^ ]+\.design} \$$raw_blocks];" >> open_block.tcl; \
	$(eval IS_CLI := $(filter show_cli,$(MAKECMDGOALS))) \
	$(eval SHOW_ARGS := $(if $(IS_CLI),$(shell echo "$(MAKECMDGOALS)" | sed -n 's/.*show_cli *\([^ ]*\).*/\1/p'),$(shell echo "$(MAKECMDGOALS)" | sed -n 's/.*show *\([^ ]*\).*/\1/p'))) \
	if [ -n "$(SHOW_ARGS)" ]; then \
		echo "set input \"$(SHOW_ARGS)\";" >> open_block.tcl; \
		echo "if {[regexp {^0?[0-9]+$$} \$$input]} {" >> open_block.tcl; \
		echo "    set padded_input [format \"%02d\" \$$input];" >> open_block.tcl; \
		echo "    set matching_blocks [lsearch -regexp -all -inline \$$blocks \".*\$$padded_input.*\"];" >> open_block.tcl; \
		echo "} else {" >> open_block.tcl; \
		echo "    set matching_blocks [lsearch -regexp -all -inline \$$blocks \".*\$$input.*\"];" >> open_block.tcl; \
		echo "}" >> open_block.tcl; \
		echo "if {[llength \$$matching_blocks] > 0} {" >> open_block.tcl; \
		echo "    set block_name [lindex \$$matching_blocks end];" >> open_block.tcl; \
		echo "} else {" >> open_block.tcl; \
		echo "    puts \"No matching block found for input: \$$input\";" >> open_block.tcl; \
		echo "    exit 1;" >> open_block.tcl; \
		echo "}" >> open_block.tcl; \
	else \
		echo "set block_name [lindex \$$blocks end];" >> open_block.tcl; \
	fi; \
	echo "open_block $(TOP_MODULE).nlib:\$$block_name;" >> open_block.tcl; \
	echo "link_block;" >> open_block.tcl; \
	echo "source $(SETUP_TCL);" >> open_block.tcl; \
	if [ -n "$(IS_CLI)" ]; then \
		$(FC_EXEC) -f open_block.tcl; \
	else \
		$(FC_EXEC) -gui -f open_block.tcl; \
	fi; \
	rm -f open_block.tcl;

remove_single_block:
	@echo "open_lib $(TOP_MODULE).nlib;" > remove_block.tcl; \
	echo "redirect -var blocks {list_blocks};" >> remove_block.tcl; \
	echo "set input \"$(filter-out $@,$(MAKECMDGOALS))\";" >> remove_block.tcl; \
	echo "set matching_blocks [lsearch -regexp -inline \$$blocks \".*\$$input.*\"];" >> remove_block.tcl; \
	echo "if {[llength \$$matching_blocks] > 0} {" >> remove_block.tcl; \
	echo "    foreach block \$$matching_blocks {" >> remove_block.tcl; \
	echo "        puts \"Removing block: \$$block\";" >> remove_block.tcl; \
	echo "        remove_blocks -force \$$block;" >> remove_block.tcl; \
	echo "    }" >> remove_block.tcl; \
	echo "} else {" >> remove_block.tcl; \
	echo "    puts \"No matching block found for input: \$$input\";" >> remove_block.tcl; \
	echo "    exit 1;" >> remove_block.tcl; \
	echo "}" >> remove_block.tcl; \
	$(FC_EXEC) -batch -f remove_block.tcl; \
	rm -f remove_block.tcl;

remove:
	@echo "open_lib $(TOP_MODULE).nlib;" > remove_block.tcl; \
	echo "redirect -var raw_blocks {list_blocks};" >> remove_block.tcl; \
	echo "set blocks [regexp -all -inline {[^ ]+\.design} \$$raw_blocks];" >> remove_block.tcl; \
	echo "set input \"$(word 1, $(filter-out $@,$(MAKECMDGOALS)))\";" >> remove_block.tcl; \
	echo "set matching_start_index [lsearch -regexp \$$blocks \".*\$$input.*\"];" >> remove_block.tcl; \
	echo "if {\$$matching_start_index != -1} {" >> remove_block.tcl; \
	echo "    set blocks_to_remove [lrange \$$blocks \$$matching_start_index end];" >> remove_block.tcl; \
	echo "    foreach block \$$blocks_to_remove {" >> remove_block.tcl; \
	echo "        puts \"Removing block: \$$block\";" >> remove_block.tcl; \
	echo "        remove_blocks -force \$$block;" >> remove_block.tcl; \
	echo "    }" >> remove_block.tcl; \
	echo "} else {" >> remove_block.tcl; \
	echo "    puts \"No matching block found for input: \$$input\";" >> remove_block.tcl; \
	echo "    exit 1;" >> remove_block.tcl; \
	echo "}" >> remove_block.tcl; \
	$(FC_EXEC) -batch -f remove_block.tcl; \
	rm -f remove_block.tcl;

cli:
	$(FC_EXEC)

%:
	@:
