////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_receive_01d_test
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_RCV_01D_TEST
`define SRL_RCV_01D_TEST
class serial_receive_01d_test extends serial_base_test;
	`uvm_component_utils(serial_receive_01d_test)

	function new(string name = "serial_receive_01d_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		serial_receive_01d seq = serial_receive_01d::type_id::create("serial_receive_01d_test");
		super.run_phase(phase);
		phase.raise_objection(this);
		`uvm_info("START SEQ","\nsrl_rcv_01d sequence starting...",UVM_LOW)
		seq.start(this.env.srl_vsqr);
		`uvm_info("END SEQ","\nsrl_rcv_01d sequence ending...",UVM_LOW)
		phase.drop_objection(this);
	endtask

endclass
`endif
