////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_kind_rand_test
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_KIND_RAND_TEST_SV
`define SRL_KIND_RAND_TEST_SV
class serial_kind_rand_test extends serial_base_test;
	`uvm_component_utils(serial_kind_rand_test)

	function new(string name = "serial_kind_rand_test",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		serial_kind_rand_virtual_sequence seq = serial_kind_rand_virtual_sequence::type_id::create("serial_kind_rand_test");	
		super.run_phase(phase);
		phase.raise_objection(this);
		`uvm_info("START SEQ","smoke sequence starting...",UVM_LOW)
		seq.start(this.env.srl_vsqr);
		`uvm_info("END SEQ","smoke sequence ending...",UVM_LOW)
		phase.drop_objection(this);
	endtask

endclass
`endif
