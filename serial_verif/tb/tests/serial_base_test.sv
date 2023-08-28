////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_base_test
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_BASE_TEST_SV
`define SRL_BASE_TEST_SV
class serial_base_test extends uvm_test;
	`uvm_component_utils(serial_base_test)

	serial_env env;
	

	function new(string name = "serial_base_test",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = serial_env::type_id::create("env",this);
	endfunction

	virtual function void check_phase(uvm_phase phase);
		super.check_phase(phase);
		//uvm_top.print_topology();
	endfunction

endclass
`endif
