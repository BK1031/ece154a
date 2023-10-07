`timescale 1ns/1ns
`include "alu.v"

module testbench;

reg [31:0] data [0:183];
reg [31:0] input_a;
reg [31:0] input_b;
reg [2:0] input_f;

wire zero_output;
wire overflow_output;
wire carry_output;
wire negative_output;
wire [31:0] result_output;

integer i;
reg[31:0] check[0:4];
reg[31:0] DUToutput[0:4];

initial $readmemh("alu.tv", data);

alu DUT(
    .a(input_a),
    .b(input_b),
    .f(input_f),
    .zero(zero_output),
    .overflow(overflow_output),
    .carry(carry_output),
    .negative(negative_output),
    .result(result_output)
);

initial begin
    for (i = 0; i < 184; i = i + 8) begin
        input_a = data[i];
        input_b = data[i + 1];
        input_f = data[i + 2];
        check[0] = data[i + 3];
        check[1] = data[i + 4];
        check[2] = data[i + 5];
        check[3] = data[i + 6];
        check[4] = data[i + 7];
        #1;
        DUToutput[0] = result_output;
        DUToutput[1] = zero_output;
        DUToutput[2] = overflow_output;
        DUToutput[3] = carry_output;
        DUToutput[4] = negative_output;
        if (DUToutput != check) begin
            $display("Error at %d", i);
            $display("Expected: %b %b %b %b %b", check[0], check[1], check[2], check[3], check[4]);
            $display("Got:      %b %b %b %b %b", DUToutput[0], DUToutput[1], DUToutput[2], DUToutput[3], DUToutput[4]);
            $finish;
        end
    end
    $display("All tests passed!");
end

endmodule