////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_tx_transaction
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_TX_TRANS_SV
`define SRL_TX_TRANS_SV
class serial_tx_transaction extends uvm_sequence_item;

	rand int inter_len;
	rand bit [7:0]preamble = '0;
	rand bit [5:0]signature;
	rand bit [7:0]data;
	rand bit [3:0]parity = '0;
	rand bit [5:0]m_num;

	constraint cons_preamble{
		soft preamble == 8'h55;
	}

	constraint cons_signature{
		soft signature > 0;
	}

	constraint cons_data{
		soft data != 8'h55;
	}

	constraint cons_parity{
		soft parity[3:1] == 3'b000;
		soft parity[0] == (^data)?1'b1:1'b0;
	}

	`uvm_object_utils_begin(serial_tx_transaction)
		`uvm_field_int(inter_len,UVM_ALL_ON)
		`uvm_field_int(preamble,UVM_ALL_ON)
		`uvm_field_int(signature,UVM_ALL_ON)
		`uvm_field_int(data,UVM_ALL_ON)
		`uvm_field_int(parity,UVM_ALL_ON)
		`uvm_field_int(m_num,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "serial_tx_transaction");
		super.new(name);
	endfunction

	extern virtual task ctrl_cons_pre(bit value = 1);
	extern virtual task ctrl_cons_sig(bit value = 1);
	extern virtual task ctrl_cons_data(bit value = 1);
	extern virtual task ctrl_cons_parity(bit value = 1);
endclass

task serial_tx_transaction::ctrl_cons_pre(bit value = 1);
	this.cons_preamble.constraint_mode(value);
endtask

task serial_tx_transaction::ctrl_cons_sig(bit value = 1);
	this.cons_signature.constraint_mode(value);
endtask

task serial_tx_transaction::ctrl_cons_data(bit value = 1);
	this.cons_data.constraint_mode(value);
endtask

task serial_tx_transaction::ctrl_cons_parity(bit value = 1);
	this.cons_parity.constraint_mode(value);
endtask
`endif
