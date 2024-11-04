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

all: s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s15

ndm: $(LOGS_DIR)
	lm_shell -f $(ndm_script) | tee $(LOGS_DIR)/$(shell basename $(ndm_script) .tcl | sed 's|^.*/||').log

s1: $(LOGS_DIR)
#	fc_shell -f $(script1) | tee $(LOGS_DIR)/$(shell basename $(script1) .tcl | sed 's/^[0-9]*_//').log
	fc_shell -f $(script1) | tee $(LOGS_DIR)/$(shell basename $(script1) .tcl | sed 's|^.*/||').log

s2:
	fc_shell -f $(script2) | tee $(LOGS_DIR)/$(shell basename $(script2) .tcl | sed 's|^.*/||').log

s3:
	fc_shell -f $(script3) | tee $(LOGS_DIR)/$(shell basename $(script3) .tcl | sed 's|^.*/||').log

s4:
	fc_shell -f $(script4) | tee $(LOGS_DIR)/$(shell basename $(script4) .tcl | sed 's|^.*/||').log

s5:
	fc_shell -f $(script5) | tee $(LOGS_DIR)/$(shell basename $(script5) .tcl | sed 's|^.*/||').log

s6:
	fc_shell -f $(script6) | tee $(LOGS_DIR)/$(shell basename $(script6) .tcl | sed 's|^.*/||').log

s7:
	fc_shell -f $(script7) | tee $(LOGS_DIR)/$(shell basename $(script7) .tcl | sed 's|^.*/||').log

s8:
	fc_shell -f $(script8) | tee $(LOGS_DIR)/$(shell basename $(script8) .tcl | sed 's|^.*/||').log

s9:
	fc_shell -f $(script9) | tee $(LOGS_DIR)/$(shell basename $(script9) .tcl | sed 's|^.*/||').log

s10:
	fc_shell -f $(script10) | tee $(LOGS_DIR)/$(shell basename $(script10) .tcl | sed 's|^.*/||').log

s11:
	fc_shell -f $(script11) | tee $(LOGS_DIR)/$(shell basename $(script11) .tcl | sed 's|^.*/||').log

s12:
	fc_shell -f $(script12) | tee $(LOGS_DIR)/$(shell basename $(script12) .tcl | sed 's|^.*/||').log

s13:
	fc_shell -f $(script13) | tee $(LOGS_DIR)/$(shell basename $(script13) .tcl | sed 's|^.*/||').log

s14:
	fc_shell -f $(script14) | tee $(LOGS_DIR)/$(shell basename $(script14) .tcl | sed 's|^.*/||').log

s15:
	fc_shell -f $(script15) | tee $(LOGS_DIR)/$(shell basename $(script15) .tcl | sed 's|^.*/||').log

clean:
	rm -rf *.svf *.log *.txt *.nlib *_rules_* *tmp*/ *cache*/ HDL_LIBRARIES/ legalizer_debug_plots/ work_dir/ pg_model/ *StarRC*/ .node* signoff_check_drc_run/ signoff_check_lvs_run/ signoff_fix_drc_run/ signoff_check_drc_run_after_fix_drc/ signoff_create_pg_augmentation_run/ signoff_check_drc_live_run/ RAIL_DATABASE/ *.ems PreFrameCheck/ ${OUTPUTS_DIR}/ ${REPORTS_DIR}/ ${LOGS_DIR}/

clean_ndms:
	rm -rf data/lib/*
