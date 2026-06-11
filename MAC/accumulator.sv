`include "complement.sv"

module accumulator(input [31:0] A,
                   input [31:0] B,
                   output [31:0] output_sum,
                   output signal_NaN);
  
  //Create special value flags
  wire A_subnormal;		//subnormal:			exponent bits are all 0
  wire A_special;		//special values: 		indicated by exponent value of all 1
  wire A_inf;			//infinity: 			a special value with mantissa of 0 and sign 0
  wire A_n_inf;			//negative infinity: 	a special value with mantissa 0 and sign 1
  wire A_qNaN;			//quiet Not a Number:	a special value mantissa MSB 10. represents an invalid operation without triggering an error
  wire A_sNaN;			//signal Not a Number:	a special value with mantissa MSB 01 or 11. represents an invalid state that triggers an error
  
  wire B_subnormal;
  wire B_special;
  wire B_inf;
  wire B_n_inf;
  wire B_qNaN;
  wire B_sNaN;
  
  //Hold special value flags for now
  assign A_subnormal = !(A[30] || A[29] || A[28] || A[27] || A[26] || A[25] || A[24] || A[23]);
  assign A_special = A[30] && A[29] && A[28] && A[27] && A[26] && A[25] && A[24] && A[23];
  assign A_inf = !A[31] && A_special && !A[22] && !A[21];
  assign A_n_inf = A[31] && A_special && !A[22] && !A[21];
  assign A_qNaN = A_special && A[22];
  assign A_sNaN = A_special && A[21];
  
  assign B_subnormal = !(B[30] || B[29] || B[28] || B[27] || B[26] || B[25] || B[24] || B[23]);
  assign B_special = B[30] && B[29] && B[28] && B[27] && B[26] && B[25] && B[24] && B[23];
  assign B_inf = !B[31] && B_special && !B[22] && !B[21];
  assign B_n_inf = B[31] && B_special && !B[22] && !B[21];
  assign B_qNaN = B_special && B[22];
  assign B_sNaN = B_special && B[21];
  
  //Calculated exponent difference of A and B
  wire signed [8:0] exp_diff;
  wire signed [8:0] exp_diff_comp;
  
  //Absolute value for shifting
  wire signed [8:0] exp_diff_abs;
  
  //Calculate exponent difference
  assign exp_diff = ({A[30:24],A[23] || A_subnormal}) - ({B[30:24],B[23] || B_subnormal});
  
  custom_twos_complement #(.WIDTH(9)) exp_comp(.A(exp_diff), .B(exp_diff_comp));
  
  //Absolute value using a mux and inverter
  //edit: assign exp_diff_abs = exp_diff[8] ? exp_diff * (-1) : exp_diff; now uses custom twos comp
  assign exp_diff_abs = exp_diff[8] ? exp_diff_comp : exp_diff;
 
  
  //Unshifted mantissas
  wire [23:0] A_mantissa;
  wire [23:0] B_mantissa;
  
  //Shifted mantissas
  wire [23:0] A_mantissa_shifted;
  wire [23:0] B_mantissa_shifted;
  
  //Create mantissa with leading 0 if subnormal, and leading 1 otherwise
  assign A_mantissa = {!A_subnormal, A[22:0]};
  assign B_mantissa = {!B_subnormal, B[22:0]};
  
  //Shift based on which exponent was greater (is exp difference positive or negative)
  assign A_mantissa_shifted = exp_diff[8] ? A_mantissa >> exp_diff_abs : A_mantissa;
  assign B_mantissa_shifted = exp_diff[8] ? B_mantissa : B_mantissa >> exp_diff_abs;
  
  
  //Determine if A and B are added or subtracted based on sign bit
  wire subtracting;
  
  assign subtracting = A[31] ^ B[31];
  
  /* This is the original method of finding the sum/difference
  // It calculated all three values and then used a multiplexer to select the correct answer
  // But having three 25 bit addition blocks seems expensive, so I changed it to one with 
  // a zero detector and a twos complement multiplexer instead
  */
  
  //calculate the sum or difference
  /*
  wire signed [24:0] sum;
  
  wire signed [24:0] difference1;
  
  wire signed [24:0] difference2;
  
  wire signed [24:0] difference3;
  
  assign difference1 = A_mantissa_shifted + B_mantissa_shifted;
  
  assign difference2 = A_mantissa_shifted - B_mantissa_shifted;
  
  assign difference3 = B_mantissa_shifted - A_mantissa_shifted;
  
  assign sum = subtracting ? ((exp_diff[8] || difference2[24]) ? difference3 : difference2) : difference1;
  */
  
  //Made an optimization to only do a single addition and simply change the parameters internally
  //A 2s complement is cheaper than a full addition or subtraction
  //However, additional logic is needed due to the use of 2s complement that changes the overflow bit compared to logic above
  
  //Need this wire because carry bit goes against pattern if B is zero and only if B is zero
  wire B_mantissa_is_zero;
  
  assign B_mantissa_is_zero = !(|B_mantissa_shifted[23:0]);
  
  //Twos complement of B changes addition to subtraction
  wire [23:0] B_mantissa_shifted_comp;
  
  custom_twos_complement #(.WIDTH(24)) mantissa_comp(.A(B_mantissa_shifted), .B(B_mantissa_shifted_comp));
  
  wire signed [24:0] sum;
  
  wire signed [24:0] difference;
  
  //Compute accumulation based on whether the two values are subtracted or not
  assign difference = A_mantissa_shifted + (subtracting ? B_mantissa_shifted_comp : B_mantissa_shifted);
  
  //Twos complement of the difference changes A - B to B - A
  wire signed [24:0] difference_comp;
  
  custom_twos_complement #(.WIDTH(25)) diff_comp(.A({(!difference[24] ^ B_mantissa_is_zero),difference[23:0]}), .B(difference_comp));
  
  //Determine whether to use A + B, A - B, or B - A
  //In the specific case where B is 0 and A - B, the sign bit is flipped
  assign sum = subtracting ? (exp_diff[8] || (!difference[24] ^ B_mantissa_is_zero)) ? difference_comp : {(!difference[24] ^ B_mantissa_is_zero),difference[23:0]} : difference;
  
  
  //Find the number of leading zeroes in the result to adjust mantissa
  wire signed [8:0] leading_zeroes;
  
  //I couldn't find a better way to find leading zeroes with arbitrary number of 1s
  //There is technically one that uses parity and subtraction, but it's quite complicated
  assign leading_zeroes = sum[24] ? 0 : sum[23] ? 1 : sum[22] ? 2 : sum[21] ? 3 : sum[20] ? 4 : sum[19] ? 5 : sum[18] ? 6 : sum[17] ? 7 : sum[16] ? 8 : sum[15] ? 9 : sum[14] ? 10 : sum[13] ? 11 : sum[12] ? 12 : sum[11] ? 13 : sum[10] ? 14 : sum[9] ? 15 : sum[8] ? 16 : sum[7] ? 17 : sum[6] ? 18 : sum[5] ? 19 : sum[4] ? 20 : sum[3] ? 21 : sum[2] ? 22 : sum[1] ? 23 : sum[0] ? 24 : 25;
  
  
  //Get the current mantissa from the greater exponent defaulting to A
  wire signed [8:0] exp_hold;
  
  assign exp_hold = {1'b0,exp_diff[8] ? B[30:23] : A[30:23]};
  
  wire signed [8:0] adjusted_exp;
  
  assign adjusted_exp = exp_hold - leading_zeroes + (A_subnormal && B_subnormal);
  
  //If the current mantissa will be adjusted to a value less than 0 based on the number of leading zeroes, the value is subnormal
  //Essentially, if leading_zeroes is greater than the mantissa, the mantissa will go below 0. Instead, make the output subnormal
  wire is_subnormal;
  
  assign is_subnormal = adjusted_exp[8];
  
  //If the value is subnormal, the output should only be shifted by the mantissa value
  //Otherwise, shift left by leading zeroes
  wire [24:0] adjusted_sum;
  
  assign adjusted_sum = is_subnormal ? sum << exp_hold : sum << leading_zeroes;
  
  //exception handling
  wire is_infinity;
  wire is_n_infinity;
  wire is_qNaN;
  wire is_special;
  wire is_zero;
  
  assign is_infinity = (!adjusted_exp[0] && adjusted_exp[1] && adjusted_exp[2] && adjusted_exp[3] && adjusted_exp[4] && adjusted_exp[5] && adjusted_exp[6] && adjusted_exp[7] && leading_zeroes == 0) || (A_inf ^ B_n_inf) || (B_inf ^ A_n_inf);
  
  assign is_n_infinity = is_infinity && (A_n_inf || B_n_inf);
  
  assign is_qNaN = (A_inf && B_n_inf) || (B_inf && A_n_inf) || A_qNaN || A_sNaN || B_qNaN || B_sNaN;
  
  assign is_special = is_infinity || is_qNaN;
  
  assign is_zero = leading_zeroes[0] && !leading_zeroes[1] && !leading_zeroes[2] && leading_zeroes[3] && leading_zeroes[4];
  
  //Account for subnormal exponent equal to -126 instead of -127 here
  assign output_sum[20:0] = (is_subnormal && A_subnormal && B_subnormal) ? adjusted_sum[20:0] : adjusted_sum[21:1];
  assign output_sum[22:21] = is_special ? is_qNaN ? {2'b10} : {2'b00} : (is_subnormal && A_subnormal && B_subnormal) ? adjusted_sum[22:21] : adjusted_sum[23:22];
  
  //Set exponent to 0 if subnormal, and normal mantissa value from previous calculations if not subnormal
  assign output_sum[30:23] = is_special ? {8'b11111111} :(is_subnormal || is_zero) ? {8'b0} : adjusted_exp + 1;
  
  //Set the sign to the match the input with the larger exponent
  //If they have equal exponents, set the sign based on the result of subtraction
  //If there was no subtraction, arbitrarily use the sign of A
  //Additionally, infinity tends to not register as the larger exponent, so manually add it as a condition
  assign output_sum[31] = (A_inf || (B_subnormal && !A_subnormal)) ? A[31] : (B_inf || (A_subnormal && !B_subnormal)) ? B[31] : (subtracting ? (exp_diff[8] || !difference[24] ? B[31] : A[31]) : A[31]) || is_n_infinity;
  
  assign signal_NaN = A_sNaN || B_sNaN;
  
endmodule
