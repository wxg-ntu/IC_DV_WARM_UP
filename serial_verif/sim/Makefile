PLATFORM = linux64

TOP = serial_rx_top
#TOP module name(no  .sv)

export TOP_LEVEL = $(TOP)

DFILES = serial_tx.sv serial_tx.sv 
#SINGLE_TEST = serial_smoke_test
SINGLE_TEST = serial_kind_rand_test
#SINGLE_TEST = serial_receive_01a_test
#SINGLE_TEST = serial_receive_01b_test
#SINGLE_TEST = serial_receive_01c_test
#SINGLE_TEST = serial_receive_01d_test
#SINGLE_TEST = serial_receive_01e_test
#SINGLE_TEST = serial_abnormal_01a_test
TEST_FILES = testname.flist
TEST_NAMES = `cat $(TEST_FILES)`
VERB = UVM_MEDIUM 
UVM_TIME_END = 90000000

INCDIR = +incdir+../tb/agt/rx_agt/ \
		 +incdir+../tb/agt/tx_agt/ \
		 +incdir+../tb/env/ \
		 +incdir+../tb/seq_lib/ \
		 +incdir+../tb/seq_lib/v_seq/ \
		 +incdir+../tb/tests/ \

SEED  = 2
VCOMP = vlogan -full64 -sverilog -timescale=1ns/1ns -l comp.log -kdb
ELAB  =	vcs -full64 -sverilog -cm tgl+branch+fsm+line+cond+assert -debug_access+all -l elab.log $(INCDIR) -timescale=1ns/1ns -kdb \
		-ntb_opts uvm-1.2 \
		-f testfile.flist \
		-LDFLAGS -Wl,--no-as-needed \
        -P ${VERDI_HOME}/share/PLI/VCS/${PLATFORM}/novas.tab ${VERDI_HOME}/share/PLI/VCS/${PLATFORM}/pli.a \
        +vcs+lic+wait
RUN  = $(TOP).simv +fsdb+sva_success -cm tgl+branch+fsm+line+cond+assert +UVM_TESTNAME=$(SINGLE_TEST) +UVM_NO_RELNOTES   -l run.log +ntb_random_seed=$(SEED) \
        -ucli -i dump_fsdb_vcs.tcl \
        +fsdb+autoflush

comp:
		$(VCOMP) $(DFILES) $(SVTB)

elab:
		@echo "Start Compiling..."
		$(ELAB) -top $(TOP) -o $(TOP).simv


run:
		@echo "Running one test..."
		./$(RUN) 

run_all_tests:
		@echo "Rungning all tests and producing coverage report..."
		rm -rf all_tests ; mkdir all_tests
		@for i in $(TEST_NAMES);do \
			mkdir all_tests/$$i; \
			./$(TOP).simv +UVM_TESTNAME=$$i +UVM_VERBOSITY=$(VERB) -cm tgl+branch+fsm+line+cond+assert -l $$i.log +ntb_random_seed=$(SEED) +UVM_NO_RELNOTES -ucli -i dump_fsdb_vcs.tcl +fsdb+autoflush; \
			cp -rf $(TOP).fsdb all_tests/$$i/; \
			cp -rf $(TOP).simv.vdb all_tests/$$i/; \
			mv $$i.log all_tests/$$i/; \
		done
		urg -dir all_tests/*_test/*.vdb -dbname merged.vdb -format both -report cov_report

rung:
		@echo "Running test with GUI-ON..."
		./$(RUN)   -gui &

verdi:
		@echo "Debugging with verdi gui..."
		verdi -ssf $(TOP).fsdb &

ccov:
		@echo "Checking coverage with vdb in dve..."
		dve -full64 -cov -dir $(TOP).simv.vdb &

mccov:
		@echo "Checking merged coverage with vdb in dve..."
		dve -full64 -cov -dir merged.vdb &

rcov:
		@echo "Producing coverage report files in a dirctory..."
		urg -dir $(TOP).simv.vdb -format both -report cov_report

clean:
		@echo "Cleaning up files..."
		\rm -rf *.log
		\rm -rf AN.DB      
		\rm -rf *simv*     
		\rm -rf DVEfiles   
		\rm -rf csrc       
		\rm -rf *vpd       
		\rm -rf ucli.key
		\rm -rf vc_hdrs.h
		\rm -rf 64
		\rm -rf verdiLog
		\rm -rf *.fsdb
		\rm -rf work.lib++
		\rm -rf *novas*
		\rm -rf *cov*
		\rm -rf *merged*
		\rm -rf all_tests

all:clean elab run

alls:clean elab run_all_tests





