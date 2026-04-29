`timescale 1ns / 1ps

module shift #(parameter bits=16)(
	input clk,
	input rst, // comes from master for enabling communication
	input [bits-1:0]D,
	output eos,
	output Q
    );

reg [bits-1:0] Dn, count;
reg Qn, eosn;
reg state;

assign Q=Qn;
assign eos=eosn;

always@(posedge clk)
begin
	if (rst==1) begin
		state=0;
		Dn=0;
		eosn=0;
		count=0;
		Qn=0;
	end
	else begin
		case (state)
		 0:begin
			Dn=D;
			state=1;
			Qn=Dn[count];
			eosn=0;
//			count=count+1;
		 end
		 1:begin
			if (count==bits-1) begin
				Qn=Dn[count];
				count=0;
				eosn=1;
				state=0;
			end
		 else begin
			   count=count+1;
			   Qn=Dn[count];
			   
			end
		 end
		 	 
		endcase		
		
	end
end
 
endmodule