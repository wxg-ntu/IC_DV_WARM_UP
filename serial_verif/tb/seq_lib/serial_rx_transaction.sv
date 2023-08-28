////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_rx_transaction
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_RX_TRANS_SV
`define SRL_RX_TRANS_SV
class serial_rx_transaction extends uvm_sequence_item;

	rand bit s_err;
	rand bit p_err;
	rand bit [7:0]data_out;
	rand bit r_done;


	`uvm_object_utils_begin(serial_rx_transaction)
		`uvm_field_int(s_err,UVM_ALL_ON)
		`uvm_field_int(p_err,UVM_ALL_ON)
		`uvm_field_int(data_out,UVM_ALL_ON)
		`uvm_field_int(r_done,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "serial_rx_transaction");
		super.new(name);
	endfunction

endclass
`endif
