////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_rx_top
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
module serial_rx_top();

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import serial_env_pkg::*;

	parameter CLK_PERIOD = 10;//100MHz,unit = ns
	bit clk = 0;
	bit rst_n = 1;

	serial_if srl_if(clk,rst_n);

	serial_rx U_SERIAL_RX(
				.clk		(clk		),
				.rst_n		(rst_n		),
				.si			(srl_if.si			),
				.m_num		(srl_if.m_num		),
				.s_err		(srl_if.s_err		),
				.p_err		(srl_if.p_err		),
				.data_out	(srl_if.data_out	),
				.r_done		(srl_if.r_done		));

	//set clk value
	always #(CLK_PERIOD/2) clk = ~clk;

	//set reset value
	initial begin
		rst_n = 1;
		repeat(5)begin
			@(srl_if.clk_b);
		end
		rst_n = 0;
		repeat(5)begin
			@(srl_if.clk_b);
		end
		rst_n = 1;
	end

	initial begin
		uvm_config_db#(virtual serial_if)::set(uvm_root::get(),"uvm_test_top.env.srl_tx_agt.srl_drv","srl_if",srl_if);
		uvm_config_db#(virtual serial_if)::set(uvm_root::get(),"uvm_test_top.env.srl_vsqr","srl_if",srl_if);
		uvm_config_db#(virtual serial_if)::set(uvm_root::get(),"uvm_test_top.env.srl_tx_agt.srl_tx_mon","srl_if",srl_if);
		uvm_config_db#(virtual serial_if)::set(uvm_root::get(),"uvm_test_top.env.srl_rx_agt.srl_rx_mon","srl_if",srl_if);
		run_test();
	end


endmodule
