////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_receive_01a_test
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_RCV_01A_TEST
`define SRL_RCV_01A_TEST
class serial_receive_01a_test extends serial_base_test;
	`uvm_component_utils(serial_receive_01a_test)

	function new(string name = "serial_receive_01a_test",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		serial_receive_01a seq = serial_receive_01a::type_id::create("serial_receive_01a_test");
		super.run_phase(phase);
		phase.raise_objection(this);
		`uvm_info("START SEQ","\nsrl_rcv_01a sequence starting...",UVM_LOW)
		seq.start(this.env.srl_vsqr);
		`uvm_info("END SEQ","\nsrl_rcv_01a sequence ending...",UVM_LOW)
		phase.drop_objection(this);
	endtask

endclass
`endif
