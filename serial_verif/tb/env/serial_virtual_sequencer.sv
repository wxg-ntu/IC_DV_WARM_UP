////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_virtual_sequencer
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_V_SQR_SV
`define SRL_V_SQR_SV
class serial_virtual_sequencer extends uvm_sequencer;
	`uvm_component_utils(serial_virtual_sequencer);

	serial_sequencer srl_sqr;
	virtual serial_if srl_if;
	
	function new(string name = "serial_virtual_sequencer",uvm_component parent = null);
		super.new(name,parent);
		if(!uvm_config_db#(virtual serial_if)::get(this,"","srl_if",srl_if))
			`uvm_error("NO VIF","Interface should be set to this v_sequecer!")
	endfunction

endclass
`endif
