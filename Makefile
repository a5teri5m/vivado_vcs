

include config.mk

PROJECT_DEPFILES:= $(wildcard $(addsuffix /*,$(addprefix ./scripts/,$(SRCS_DIRS) $(SIMS_DIRS))))

.PHONY: all clean \
		create_project run_synth run_impl export_sdk \
		export_bd_design export_xci_design \
		create_commit_archive create_project_archive


all: run_impl


create_project: run_vivado.sh
	

run_synth: $(PROJECT_DIR)/.synth_done
	

run_impl: $(PROJECT_DIR)/.impl_done
	

export_sdk: run_sdk.sh
	

config.tcl: config.mk
	@if [ "$(PROJECT_NAME)" != "" ]; then \
		echo "set PROJECT_NAME   $(PROJECT_NAME)" > $@; \
	else \
		echo "PROJECT_NAME is not defined in config.mk"; \
		rm -rvf config.tcl; \
		exit 1; \
	fi
	@if [ "$(PROJECT_DIR)" != "" ]; then \
		echo "set PROJECT_DIR    $(PROJECT_DIR)" >> $@; \
	else \
		echo "PROJECT_DIR is not defined in config.mk"; \
		rm -rvf config.tcl; \
		exit 1; \
	fi
	@echo "set SRCS_DIRS      [list $(SRCS_DIRS)]" >> $@
	@echo "set SIMS_DIRS      [list $(SIMS_DIRS)]" >> $@
	@if [ "$(TOP_MODULE)" != "" ]; then \
		echo "set TOP_MODULE     $(TOP_MODULE)" >> $@; \
	else \
		echo "TOP_MODULE is not defined in config.mk"; \
		rm -rvf config.tcl; \
		exit 1; \
	fi
	@if [ "$(PART)" != "" ]; then \
		echo "set PART           $(PART)" >> $@; \
	else \
		echo "PART is not defined in config.mk"; \
		rm -rvf config.tcl; \
		exit 1; \
	fi
	@if [ "$(BOARD_PARTS)" != "" ]; then \
		echo "set BOARD_PARTS    $(BOARD_PARTS)" >> $@; \
	fi
	@if [ "$(PROJECT_CONFIG)" != "" ]; then \
		echo "set PROJECT_CONFIG $(PROJECT_CONFIG)" >> $@; \
	else \
		echo "PROJECT_CONFIG is not defined in config.mk"; \
		rm -rvf config.tcl; \
		exit 1; \
	fi
	@if [ "$(SYNTH_CONFIG)" != "" ]; then \
		echo "set SYNTH_CONFIG   $(SYNTH_CONFIG)" >> $@; \
	else \
		echo "SYNTH_CONFIG is not defined in config.mk"; \
		rm -rvf config.tcl; \
		exit 1; \
	fi
	@if [ "$(IMPL_CONFIG)" != "" ]; then \
		echo "set IMPL_CONFIG    $(IMPL_CONFIG)" >> $@; \
	else \
		echo "IMPL_CONFIG is not defined in config.mk"; \
		rm -rvf config.tcl; \
		exit 1; \
	fi
	@echo "set IP_REPO_PATHS  [list $(IP_REPO_PATHS)]" >> $@ 
	@if [ "$(RUN_JOBS)" != "" ]; then \
		echo "set RUN_JOBS    $(RUN_JOBS)" >> $@; \
	else \
		echo "RUN_JOBS is not defined in config.mk"; \
		rm -rvf config.tcl; \
		exit 1; \
	fi
	@echo Create $@	


run_vivado.sh: config.tcl $(PROJECT_DEPFILES)
	@(if [ -e $(PROJECT_DIR) ]; then \
		flg=N; \
		echo "PROJECT_DIR ($(PROJECT_DIR)) is already exist."; \
		read -p "Delete PROJECT_DIR ($(PROJECT_DIR))? [y/N] :" flg; \
		if [ $$flg == "y" ] || [ $$flg == "Y" ]; then \
			rm -rvf $(PROJECT_DIR); \
			mkdir $(PROJECT_DIR); \
		else \
			echo "stop"; \
			exit 1; \
		fi \
	else \
		mkdir $(PROJECT_DIR); \
	fi)
	@(cd $(PROJECT_DIR); \
	  export LM_LICENSE_FILE=$(VIVADO_LICENSE); \
	  source $(VIVADO_SETTINGS); \
	  vivado -mode batch -source ../scripts/create_project.tcl; \
	  if [ $$? -ne 0 ]; then \
		  exit 1; \
	  fi \
	)
	@echo "#!/bin/bash" > $@
	@echo "export LM_LICENSE_FILE=$(VIVADO_LICENSE)" >> $@
	@echo "source $(VIVADO_SETTINGS)" >> $@
	@echo "cd $(PROJECT_DIR)" >> $@
	@echo "vivado $(PROJECT_NAME).xpr &" >> $@
	@chmod a+x $@
	@echo Create $@


$(PROJECT_DIR)/.synth_done: run_vivado.sh
	@(export LM_LICENSE_FILE=$(VIVADO_LICENSE); \
		dirs=(`cat $(PROJECT_DIR)/synth.lst`); \
		err=0; \
		for d in $${dirs[@]}; do \
			echo "Synthesis ./$(PROJECT_DIR)/$$d"; \
			./$(PROJECT_DIR)/$$d/runme.sh; \
			./scripts/check_runme_log.pl ./$(PROJECT_DIR)/$$d/runme.log > ./$(PROJECT_DIR)/$$d/runme.sum; \
			err=$$?; \
			cat ./$(PROJECT_DIR)/$$d/runme.sum; \
			if [ $$err -ne 0 ]; then \
				break; \
			fi \
		done; \
		if [ $$err -ne 0 ]; then \
			exit 1; \
		fi \
	)
	@touch $@


$(PROJECT_DIR)/.impl_done: $(PROJECT_DIR)/.synth_done
	@(export LM_LICENSE_FILE=$(VIVADO_LICENSE); \
		dirs=(`cat $(PROJECT_DIR)/impl.lst`); \
		err=0; \
		for d in $${dirs[@]}; do \
			echo "Implementation ./$(PROJECT_DIR)/$$d"; \
			./$(PROJECT_DIR)/$$d/runme.sh; \
			./scripts/check_runme_log.pl ./$(PROJECT_DIR)/$$d/runme.log > ./$(PROJECT_DIR)/$$d/runme.sum; \
			err=$$?; \
			cat ./$(PROJECT_DIR)/$$d/runme.sum; \
			if [ $$err -ne 0 ]; then \
				break; \
			fi \
		done; \
		if [ $$err -ne 0 ]; then \
			exit 1; \
		fi \
	)
	@touch $@


run_sdk.sh: $(PROJECT_DIR)/.impl_done
	@if [ -e $(PROJECT_DIR)/$(PROJECT_NAME).sdk ]; then \
		echo $(PROJECT_NAME).sdk is already exist; \
	else \
		mkdir $(PROJECT_DIR)/$(PROJECT_NAME).sdk; \
	fi
	@if [ -e $(SYSDEF_FILE) ]; then \
		cp -f $(SYSDEF_FILE) $(HDF_FILE); \
		echo Copy from $(SYSDEF_FILE) to $(HDF_FILE); \
	else \
		echo "$(SYSDEF_FILE) is not found."; \
		exit 1; \
	fi 
	@echo "#!/bin/bash" > $@
	@echo "export LM_LICENSE_FILE=$(VIVADO_LICENSE)" >> $@
	@echo "source $(VIVADO_SETTINGS)" >> $@
	@echo "cd $(PROJECT_DIR)" >> $@
	@echo "vivado -mode batch -source ../scripts/run_sdk.tcl &" >> $@
	@chmod a+x $@
	@echo Create $@
	

export_bd_design: 
	@(cd $(PROJECT_DIR); \
	  export LM_LICENSE_FILE=$(VIVADO_LICENSE); \
	  source $(VIVADO_SETTINGS); \
	  vivado -mode batch -source ../scripts/export_bd_design.tcl \
	)
	

export_xci_design: 
	@(cd $(PROJECT_DIR); \
	  export LM_LICENSE_FILE=$(VIVADO_LICENSE); \
	  source $(VIVADO_SETTINGS); \
	  vivado -mode batch -source ../scripts/export_xci_design.tcl \
	)


create_commit_archive:
	@(sha=`git rev-parse HEAD |sed -e 's/\(.\{8\}\).*/\1/g' `; \
		git archive --format=zip HEAD -o $(PROJECT_NAME).$$sha.zip \
	)


create_project_archive: run_vivado.sh
	@(cd $(PROJECT_DIR); \
	  export LM_LICENSE_FILE=$(VIVADO_LICENSE); \
	  source $(VIVADO_SETTINGS); \
	  vivado -mode batch -source ../scripts/create_archive.tcl \
	)
	


clean:
	@(flg=N; \
	  read -p "Delete all generation files? [y/N] :" flg; \
	  if [ $$flg == "y" ] || [ $$flg == "Y" ]; then \
		rm -rvf config.tcl $(PROJECT_DIR) run_vivado.sh \
	         synth.log impl.log run_sdk.sh; \
	 else \
		exit 1; \
	 fi \
	)

