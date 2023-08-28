////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_smoke_test
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_SMK_TEST_SV
`define SRL_SMK_TEST_SV
class serial_smoke_test extends serial_base_test;
	`uvm_component_utils(serial_smoke_test)

	function new(string name = "serial_smoke_test",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		serial_smoke_virtual_sequence seq = serial_smoke_virtual_sequence::type_id::create("serial_smoke_virtual_sequence");
		super.run_phase(phase);
		phase.raise_objection(this);
		`uvm_info("START SEQ","smoke sequence starting...",UVM_LOW)
		seq.start(this.env.srl_vsqr);
		`uvm_info("END SEQ","smoke sequence ending...",UVM_LOW)
		phase.drop_objection(this);
	endtask

endclass
`endif
