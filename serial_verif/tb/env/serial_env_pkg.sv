////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_env_pkg
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_ENV_PKG_SV
`define SRL_ENV_PKG_SV
package serial_env_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "serial_rx_transaction.sv"
	`include "serial_tx_transaction.sv"
	
	`include "serial_rx_monitor.sv"
	`include "serial_rx_agent.sv"

	`include "serial_driver.sv"
	`include "serial_sequencer.sv"
	`include "serial_tx_monitor.sv"
	`include "serial_tx_agent.sv"

	`include "serial_base_sequence.sv"
	`include "serial_smoke_sequence.sv"

	`include "serial_virtual_sequencer.sv"

	`include "serial_base_virtual_sequence.sv"
	`include "serial_smoke_virtual_sequence.sv"
	`include "serial_kind_rand_virtual_sequence.sv"
	`include "serial_receive_01a.sv"
	`include "serial_receive_01b.sv"
	`include "serial_receive_01c.sv"
	`include "serial_receive_01d.sv"
	`include "serial_receive_01e.sv"

	`include "serial_scoreboard.sv"
	`include "serial_env.sv"

	`include "serial_base_test.sv"
	`include "serial_smoke_test.sv"
	`include "serial_kind_rand_test.sv"
	`include "serial_receive_01a_test.sv"
	`include "serial_receive_01b_test.sv"
	`include "serial_receive_01c_test.sv"
	`include "serial_receive_01d_test.sv"
	`include "serial_receive_01e_test.sv"

endpackage
`endif
