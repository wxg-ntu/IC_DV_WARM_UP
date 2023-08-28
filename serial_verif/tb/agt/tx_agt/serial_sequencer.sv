////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_sequencer
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_SQR_SV
`define SRL_SQR_SV
class serial_sequencer extends uvm_sequencer#(serial_tx_transaction);
	`uvm_component_utils(serial_sequencer)

	function new(string name = "serial_sequencer",uvm_component parent = null);
		super.new(name,parent);
	endfunction

endclass
`endif
