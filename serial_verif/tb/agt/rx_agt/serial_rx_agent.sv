////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_rx_agent
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_RX_AGT_SV
`define SRL_RX_AGT_SV
class serial_rx_agent extends uvm_agent;
	`uvm_component_utils(serial_rx_agent)

	serial_rx_monitor srl_rx_mon;

	function new(string name = "serial_rx_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);

endclass

function void serial_rx_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	srl_rx_mon = serial_rx_monitor::type_id::create("srl_rx_mon",this);
endfunction

function void serial_rx_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
`endif
