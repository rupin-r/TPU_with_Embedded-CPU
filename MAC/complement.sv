module custom_twos_complement #(parameter WIDTH=8)
  (input [WIDTH-1:0] A, output [WIDTH-1:0] B);

  wire [WIDTH-1:0] select;

  assign select[0] = A[0];
  assign B[0] = A[0];

  genvar i;
  generate
    for (i = 1; i < WIDTH; i = i + 1) begin : select_loop
      assign select[i] = A[i] | select[i-1];
    end
  endgenerate
  
  genvar j;
  generate
    for (j = 1; j < WIDTH; j = j + 1) begin : output_loop
      assign B[j] = A[j] ^ select[j-1];
    end
  endgenerate

endmodule
