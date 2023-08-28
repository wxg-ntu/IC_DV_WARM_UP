////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_if
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_IF_SV
`define SRL_IF_SV
interface serial_if(input clk,rst_n);

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	bit si;
	logic [5:0]m_num;
	bit s_err;
	bit p_err;
	logic [7:0]data_out;
	bit r_done;

	clocking clk_b @(posedge clk);
		default input #1 output #1;
	endclocking

	task srl_wait_clk(int n);
		repeat(n)begin
			@(clk_b);
		end
	endtask

	task srl_wait_rst();
		@(posedge rst_n);
	endtask

	property check_2_cycle_s_err;
		disable iff (!rst_n) @(clk_b)
		$rose(s_err) |-> ##1 s_err;
	endproperty

	CHECK_TWO_CYCLE:assert property(check_2_cycle_s_err);

endinterface
`endif
