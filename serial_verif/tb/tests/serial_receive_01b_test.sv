////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_receive_01b_test
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_RCV_01B_TEST_SV
`define SRL_RCV_01B_TEST_SV
class serial_receive_01b_test extends serial_base_test;
	`uvm_component_utils(serial_receive_01b_test)

	function new(string name = "serial_receive_01b_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		serial_receive_01b seq = serial_receive_01b::type_id::create("serial_receive_01b_test");
		super.run_phase(phase);
		phase.raise_objection(this);
		`uvm_info("START SEQ","\nsrl_rcv_01b sequence starting...",UVM_LOW)
		seq.start(this.env.srl_vsqr);
		`uvm_info("END SEQ","\nsrl_rcv_01b sequence ending...",UVM_LOW)
		phase.drop_objection(this);
	endtask

endclass
`endif
