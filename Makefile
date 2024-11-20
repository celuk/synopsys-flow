FC_EXEC ?= /usr/synopsys/fusioncompiler/V-2023.12-SP3/bin/fc_shell
LM_EXEC ?= /usr/synopsys/icc2/V-2023.12/bin/lm_shell

TOP_MODULE ?= c0_soc

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
script7  ?= scripts/07_cts_opt.tcl
script8  ?= scripts/08_route_auto.tcl
script9  ?= scripts/09_route_opt.tcl
script10 ?= scripts/10_signoff_extraction.tcl
script11 ?= scripts/11_signoff_opt.tcl
script12 ?= scripts/12_signoff_metal_fill.tcl
script13 ?= scripts/13_signoff_drc.tcl
script14 ?= scripts/14_signoff_lvs.tcl
script15 ?= scripts/15_streamout.tcl

$(LOGS_DIR):
	mkdir -p $(LOGS_DIR)

all: s1 s2 s3 s4 s5 s6 s8 s10 s12 s13 s14 s15

ndms: $(LOGS_DIR)
	$(LM_EXEC) -batch -f $(ndm_script) | tee $(LOGS_DIR)/$(shell basename $(ndm_script) .tcl | sed 's|^.*/||').log

s1: $(LOGS_DIR)
#	$(FC_EXEC) -f $(script1) | tee $(LOGS_DIR)/$(shell basename $(script1) .tcl | sed 's/^[0-9]*_//').log
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

s13:
	$(FC_EXEC) -batch -f $(script13) | tee $(LOGS_DIR)/$(shell basename $(script13) .tcl | sed 's|^.*/||').log

s14:
	$(FC_EXEC) -batch -f $(script14) | tee $(LOGS_DIR)/$(shell basename $(script14) .tcl | sed 's|^.*/||').log

s15:
	$(FC_EXEC) -batch -f $(script15) | tee $(LOGS_DIR)/$(shell basename $(script15) .tcl | sed 's|^.*/||').log

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
		signoff_check_drc_run/ \
		signoff_check_antenna_drc_run/ \
		signoff_check_mim_antenna_drc_run/ \
		signoff_check_lvs_run/ \
		signoff_fix_drc_run/ \
		signoff_check_drc_run_after_fix_drc/ \
		signoff_create_pg_augmentation_run/ \
		signoff_check_drc_live_run/ \
		RAIL_DATABASE/ \
		*.ems \
		PreFrameCheck/ \
		.snps_mv_reports \
		pna_output/ \
		${OUTPUTS_DIR}/ \
		${REPORTS_DIR}/ \
		${LOGS_DIR}/ \
		open_block.tcl

clean_ndms:
	rm -rf data/lib/*

clean_all: clean clean_ndms

show:
	@echo "open_lib $(TOP_MODULE).nlib;" > open_block.tcl;
	@echo "redirect -var blocks {list_blocks};" >> open_block.tcl;
	@if [ -n "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "set input \"$(filter-out $@,$(MAKECMDGOALS))\";" >> open_block.tcl; \
		echo "set matching_blocks [lsearch -regexp -inline \$$blocks \".*\$$input.*\"];" >> open_block.tcl; \
		echo "if {[llength \$$matching_blocks] > 0} {" >> open_block.tcl; \
		echo "    set block_name [lindex \$$matching_blocks end];" >> open_block.tcl; \
		echo "} else {" >> open_block.tcl; \
		echo "    puts \"No matching block found for input: \$$input\";" >> open_block.tcl; \
		echo "    exit 1;" >> open_block.tcl; \
		echo "}" >> open_block.tcl; \
	else \
		echo "set block_name [lindex [regexp -all -inline {[^ ]+design} \$$blocks] end];" >> open_block.tcl; \
	fi
	@echo "open_block $(TOP_MODULE).nlib:\$$block_name;" >> open_block.tcl
	@echo "link_block;" >> open_block.tcl
	$(FC_EXEC) -gui -f open_block.tcl
	rm -f open_block.tcl

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
