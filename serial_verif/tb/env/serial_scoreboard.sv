////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_scoreboard
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_SCB_SV
`define SRL_SCB_SV
class serial_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(serial_scoreboard)

	bit enable = 1;
	serial_tx_transaction srl_tx_trans_queue[$];
	int check_tx_pkg_num = 0;
	int check_rx_pkg_num = 0;
	int check_num = 0;
	int check_suc_num = 0;
	int check_fail_num = 0;

	event start_comp;
	event ok_to_comp = start_comp;

	uvm_tlm_analysis_fifo #(serial_tx_transaction) srl_tx_fifo;
	uvm_tlm_analysis_fifo #(serial_rx_transaction) srl_rx_fifo;


	function new(string name = "serial_scoreboard",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	extern virtual function void check_phase(uvm_phase phase);

endclass

function void serial_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	srl_tx_fifo = new("srl_tx_fifo",this);
	srl_rx_fifo = new("srl_rx_fifo",this);
endfunction

function void serial_scoreboard::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction

task serial_scoreboard::run_phase(uvm_phase phase);
	serial_tx_transaction tx_trans_tmp;
	serial_tx_transaction tx_trans_tmp_comp;
	serial_rx_transaction rx_trans_tmp;

	super.run_phase(phase);
	if(enable)begin
		fork
			forever begin
				srl_tx_fifo.get(tx_trans_tmp);
				if(tx_trans_tmp.preamble == 8'h55)begin
					srl_tx_trans_queue.push_back(tx_trans_tmp);
					check_tx_pkg_num++;
					->start_comp;
				end
				else begin
					if(
								{tx_trans_tmp.preamble[7:1]} == 7'b101_0101 ||
								{tx_trans_tmp.preamble[6:0],tx_trans_tmp.signature[5]} == 8'h55 ||
								{tx_trans_tmp.preamble[5:0],tx_trans_tmp.signature[5:4]} == 8'h55 ||
								{tx_trans_tmp.preamble[4:0],tx_trans_tmp.signature[5:3]} == 8'h55 ||
								{tx_trans_tmp.preamble[3:0],tx_trans_tmp.signature[5:2]} == 8'h55 ||
								{tx_trans_tmp.preamble[2:0],tx_trans_tmp.signature[5:1]} == 8'h55 ||
								{tx_trans_tmp.preamble[1:0],tx_trans_tmp.signature[5:0]} == 8'h55 ||
								{tx_trans_tmp.preamble[0],tx_trans_tmp.signature,tx_trans_tmp.data[7]} == 8'h55 ||
								{tx_trans_tmp.signature[5:0],tx_trans_tmp.data[7:6]} == 8'h55 ||
								{tx_trans_tmp.signature[4:0],tx_trans_tmp.data[7:5]} == 8'h55 ||
								{tx_trans_tmp.signature[3:0],tx_trans_tmp.data[7:4]} == 8'h55 ||
								{tx_trans_tmp.signature[2:0],tx_trans_tmp.data[7:3]} == 8'h55 ||
								{tx_trans_tmp.signature[1:0],tx_trans_tmp.data[7:2]} == 8'h55 ||
								{tx_trans_tmp.signature[0],tx_trans_tmp.data[7:1]} == 8'h55 ||
								{tx_trans_tmp.data[7:0]} == 8'h55 // to avoid break_frame

					)begin
						srl_tx_trans_queue.push_back(tx_trans_tmp);
						check_tx_pkg_num++;
						->start_comp;
					end
				end
			end
			forever begin
				srl_rx_fifo.get(rx_trans_tmp);
				check_rx_pkg_num++;
				wait(ok_to_comp.triggered);
				if(srl_tx_trans_queue.size() > 0)begin
					tx_trans_tmp_comp = srl_tx_trans_queue.pop_front();
					check_num++;
					if(rx_trans_tmp.s_err && tx_trans_tmp_comp.m_num != tx_trans_tmp_comp.signature)begin
							check_suc_num++;
							`uvm_info("SCB comp_invalid_sig_successful",$sformatf("\n Check invalid signature successfully! Tx_trans_sig is [ %0d ], but Magic_num is [ %0d ]",tx_trans_tmp_comp.signature,tx_trans_tmp_comp.m_num),UVM_LOW)
					end
					else begin
						if(tx_trans_tmp_comp.data == rx_trans_tmp.data_out)begin
							if( 
								(
									( (!(^{tx_trans_tmp_comp.data,tx_trans_tmp_comp.parity[0]}))&&(!rx_trans_tmp.p_err) ) || 
									( ((^{tx_trans_tmp_comp.data,tx_trans_tmp_comp.parity[0]}))&&(rx_trans_tmp.p_err) )
								) &&
								tx_trans_tmp_comp.parity[3:1] == 3'b000
							  )begin
								check_suc_num++;
								`uvm_info("SCB comp_data_successful",$sformatf("\nCOMP_NUM is [ %0d ] TX_trans_data_parity is [%b][%b] and RX_trans_data_p_err is [%b][%b]\n",check_num,tx_trans_tmp_comp.data,tx_trans_tmp_comp.parity,rx_trans_tmp.data_out,rx_trans_tmp.p_err),UVM_LOW)
							end
							else begin
								check_fail_num++;
								`uvm_error("SCB comp_parity_fail",$sformatf("COMP_NUM is [ %0d ] TX_trans_data_parity is [%b][%b] but RX_trans_data_p_err is [%b][%b]",check_num,tx_trans_tmp_comp.data,tx_trans_tmp_comp.parity,rx_trans_tmp.data_out,rx_trans_tmp.p_err))
							end
						end
						else begin
							check_fail_num++;
							`uvm_error("SCB comp_data_fail",$sformatf("COMP_NUM is [%d] TX_trans_data is [%b] but RX_trans_data is [%b]",check_num,tx_trans_tmp_comp.data,rx_trans_tmp.data_out))
						end
					end
				end
				else begin
					`uvm_error(get_type_name(),"Get an RX_transaction but no TX_transaction was sent to DUT!")
					rx_trans_tmp.print();
				end
			end
		join
	end
endtask

function void serial_scoreboard::check_phase(uvm_phase phase);
	serial_tx_transaction srl_tx_debug_trans;

	super.check_phase(phase);
	if(enable)begin
		if(srl_tx_trans_queue.size() > 0)begin
			srl_tx_debug_trans = srl_tx_trans_queue.pop_front();
			srl_tx_debug_trans.print();
			`uvm_error("MORE INPUT_DATA","TX_transaction has sent to DUT but not received some of them!")
		end
		$display("\t##################################################");
		$display("\t##################    SCB REPORT    ##############");
		$display();
		$display("\t\t\t check_suc_pkg_num is %d",check_suc_num);
		$display("\t\t\t check_fail_pkg_num is %d",check_fail_num);
		$display("\t\t\t check_pkg_num is %d",check_num);
		$display();
		$display("\t\t\t get_tx_pkg_num is %d",check_tx_pkg_num);
		$display("\t\t\t get_rx_pkg_num is %d",check_rx_pkg_num);
		$display();
		if(!check_fail_num)
			$display("\t################    CASE PASSED!    ##############");
		else
			$display("\t################    CASE FAILED!    ##############");
		$display("\t##################################################");
	end
	else begin
		$display("\t##################    SCB CLOSED    ##################");
	end
endfunction
`endif
