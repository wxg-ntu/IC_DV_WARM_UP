////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_smoke_virtual_sequence
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_SMK_V_SEQ_SV
`define SRL_SMK_V_SEQ_SV
class serial_smoke_virtual_sequence extends serial_base_virtual_sequence;
	`uvm_object_utils(serial_smoke_virtual_sequence)

	rand int length;
	rand int frame_right_num;

	int i = 0;
	int j = 0;
	int k = 0;

	function new(string name = "serial_smoke_virtual_sequence");
		super.new(name);
	endfunction

	virtual task body();
		super.body();
		srl_if.srl_wait_rst();
		`uvm_info(get_type_name(),"\n--------------SEQ START---------------",UVM_LOW)

		frame_right_num = $urandom_range(6,100);
		//length = $urandom_range(3,10);

		//$display("FRAME_NUM is [%0d]",frame_right_num);
		

		//send lots of preamble_right and sig_right frames
		//for(i=0;i<frame_right_num;i++)begin
		//	length = $urandom_range(3,10);
		//	//$display("INTER_LENGTH is [ %0d ]",length);
		//	`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{inter_length == length;
		//														pre == 8'h55;
		//														sig == m_number;
		//														dat > 0;
		//														})
		//end
		//$display("FRAME_RIGHT_NUM is [%0d]",frame_right_num);

		//`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{inter_length == 3;
		//													pre == 8'h55;
		//													sig == 6'h2b;
		//													dat == 8'h47;
		//													m_number == 6'h2b;
		//													})

		//send preamble_invalid frames
		//for(j=0;j<$urandom_range(5,16);j++)begin
		//	length = $urandom_range(3,10);
		//	`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{inter_length == length;
		//														pre != 8'h55;
		//														sig >= 0;
		//														dat >= 0;
		//														dat != 8'h55;
		//														m_number >= 0;
		//														})
		//end
		//$display("PREAMBLE_INVALID FRAMES's NUM is [ %0d ]",j);
		
		
		

		//send preamble_right but signature_invalid frames
		for(k=0;k<$urandom_range(5,20);k++)begin
			length = $urandom_range(3,10);
			`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{inter_length == length;
															pre == 8'h55;
															sig != m_number;
															sig > 0;
															m_number > 0;
															dat != 8'h55;
															})
		end
		$display("PREAMBLE_RIGHT but SIGNATURE_INVALID's NUM is [ %0d ]",k);

		`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{inter_length == 5;
															pre == 8'h55;
															sig == 6'h33;
															dat == 8'h22;
															m_number == 6'h33;
															})

		#100;


		`uvm_info(get_type_name(),"\n--------------SEQ END---------------",UVM_LOW)
	endtask
endclass
`endif
