// ucsbece154a_controller.v
// All Rights Reserved
// Copyright (c) 2023 UCSB ECE
// Distribution Prohibited


module ucsbece154a_controller (
    input         [6:0] op_i, 
    input         [2:0] funct3_i,
    input               funct7b5_i,
    input 	        zero_i,
    output wire          RegWrite_o,
    output wire          ALUSrc_o,
    output wire          MemWrite_o,
    output wire    [1:0] ResultSrc_o,
    output reg     [2:0] ALUControl_o,
    output wire          PCSrc_o,
    output wire    [2:0] ImmSrc_o
);


 `include "ucsbece154a_defines.vh"


// TO DO: Generate properly PCSrc by replacing all `z` values with the correct values

wire branch, jump;
assign PCSrc_o = (zero_i & branch) | jump;


//  TO DO: Implement main decoder 
//  • Replace all `z` values with the correct values
//  • Extend the code to implement jal and lui 

 reg [11:0] controls;
 wire [1:0] ALUOp;


 assign {RegWrite_o,	
	ImmSrc_o,
        ALUSrc_o,
        MemWrite_o,
        ResultSrc_o,
	branch, 
	ALUOp,
	jump} = controls;

 always @ * begin
   case (op_i)
	instr_lw_op:        controls = 12'b100010010000;       
	instr_sw_op:        controls = 12'b000111000000;  
	instr_Rtype_op:     controls = 12'b100000000100;
	instr_beq_op:       controls = 12'b001000001010;   
	instr_ItypeALU_op:  controls = 12'b100010000100;
    instr_jal_op:       controls = 12'b101100100001;
    instr_lui_op:       controls = 12'b110000110000;

	default: begin	    
                            controls = 12'b000000000000;       
            `ifdef SIM
                $warning("Unsupported op given: %h", op_i);
            `else
            ;
            `endif
            
        end 
   endcase
 end

//  TO DO: Implement ALU decoder by replacing all `z` values with the correct values

 wire RtypeSub;

 assign RtypeSub = funct7b5_i & op_i[5];

 always @ * begin
 case(ALUOp)
   ALUop_mem:                 ALUControl_o = 3'b000;
   ALUop_beq:                 ALUControl_o = 3'b001;
   ALUop_other: 
       case(funct3_i)
           instr_addsub_funct3: 
                 if(RtypeSub) ALUControl_o = 3'b001;
                 else         ALUControl_o = 3'b000;
           instr_slt_funct3:  ALUControl_o = 3'b101;
           instr_or_funct3:   ALUControl_o = 3'b011;
           instr_and_funct3:  ALUControl_o = 3'b010;  
           default: begin
                              ALUControl_o = 3'b000;
               `ifdef SIM
                   $warning("Unsupported funct3 given: %h", funct3_i);
               `else
                  ;
               `endif  
           end
       endcase
   default: 
      `ifdef SIM
          $warning("Unsupported ALUop given: %h", ALUOp);
      `else
          ;
      `endif   
  endcase
 end





endmodule

