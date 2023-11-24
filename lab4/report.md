<div style="text-align:right;">Bharat Kathi</div>
<div style="text-align:right;">ECE 154A</div>
<div style="text-align:right;">11/22/23</div>

# Lab 4 Report

## Number of hours spent on lab

I spent about 16 hours on this lab.

## Table 1

<p align="middle">
  <img src="https://github.com/BK1031/ece154a/blob/main/lab4/1.png?raw=true" width="" />
</p>

## Simulation Waveforms

<p align="middle">
  <img src="https://github.com/BK1031/ece154a/blob/main/lab4/2.png?raw=true" width="" />
  <img src="https://github.com/BK1031/ece154a/blob/main/lab4/3.png?raw=true" width="" />
</p>

## Table 2

<p align="middle">
  <img src="https://github.com/BK1031/ece154a/blob/main/lab4/4.png?raw=true" width="500" />
  <img src="https://github.com/BK1031/ece154a/blob/main/lab4/5.png?raw=true" width="500" />
</p>

## `ucsbece154a_controller.v`

```assembly
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
```

## `ucsbece154a_datapath.v`

```assembly
// ucsbece154a_datapath.v
// All Rights Reserved
// Copyright (c) 2023 UCSB ECE
// Distribution Prohibited


module ucsbece154a_datapath (
    input               clk, reset,
    input               RegWrite_i,
    input         [2:0] ImmSrc_i,
    input               ALUSrc_i,
    input               PCSrc_i,
    input         [1:0] ResultSrc_i,
    input         [2:0] ALUControl_i,
    output              zero_o,
    output reg   [31:0] pc_o,
    input        [31:0] instr_i,
    output wire  [31:0] aluresult_o, writedata_o,
    input        [31:0] readdata_i
);

`include "ucsbece154a_defines.vh"

/// Your code here

wire [31:0] PCNext, PCPlus4, PCTarget;
reg  [31:0] ImmExt;
wire [31:0] SrcA, SrcB;
reg [31:0] Result;
wire dummy1;
wire dummy2;
assign PCNext = PCSrc_i ? PCTarget : PCPlus4;
assign SrcB = ALUSrc_i ? ImmExt : writedata_o;

always @ * begin
     case (ResultSrc_i)
        2'b00: Result = aluresult_o;
        2'b01: Result = readdata_i;2'b10: Result = PCPlus4;
        2'b11: Result = ImmExt;
        default: Result = 32'b0;
    endcase
end

always @ * begin
     case (ImmSrc_i)
        3'b000: ImmExt = {{20{instr_i[31]}}, instr_i[31:20]};
        3'b001: ImmExt = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
        3'b010: ImmExt = {{20{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
        3'b011: ImmExt = {{12{instr_i[31]}},instr_i[19:12],instr_i[20],instr_i[30:21],1'b0};
        3'b100: ImmExt = {instr_i[31:12],12'b0};
        default: ImmExt = 32'b0;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc_o <= 32'b0;
    end
    else begin
         pc_o <= PCNext;
     end
end

assign PCPlus4 = pc_o + 32'b100;
assign PCTarget = pc_o + ImmExt;

ucsbece154a_alu ALU (
    .a_i(SrcA),
    .b_i(SrcB),
    .alucontrol_i(ALUControl_i),
    .result_o(aluresult_o),
    .zero_o(zero_o)
);

ucsbece154a_rf rf(
    .clk(clk),
    .a1_i(instr_i[19:15]),
    .a2_i(instr_i[24:20]),
    .a3_i(instr_i[11:7]),
    .rd1_o(SrcA),
    .rd2_o(writedata_o),
    .we3_i(RegWrite_i),
    .wd3_i(Result)
);

endmodule
```