`timescale 1ns/1ps

module fp_adder_testbench;
  reg [31:0] a;
  reg [31:0] b;
  wire [31:0] c;
  wire sNaN;
  
  reg clk;
  
  always #5 clk = ~clk;

  initial begin
    clk = 0;
  end

  testing_accumulator dut(.A(a), .B(b), .output_sum(c), .signal_NaN(sNaN));
  
  initial
  begin 
    
    $dumpfile("trace.vcd");
    $dumpvars(0, fp_adder_testbench);
    
    //TESTING ZERO
    //(+0) + (+0) = 0
    a =32'b00000000000000000000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be X0000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 1");
    @(posedge clk)
    
    //(-0) + (+0) = 0
    a =32'b10000000000000000000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be X0000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 2");
    @(posedge clk)
    
    //(+0) + (-0) = 0
    a =32'b00000000000000000000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be X0000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 3");
    @(posedge clk)
    
    //(-0) + (-0) = 0
    a =32'b10000000000000000000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be X0000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 4");
    @(posedge clk)
    
    //(+0) + (+1) = +1
    a =32'b00000000000000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be 00111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00111111100000000000000000000000) $display("OK");
    else $display("NOT OK 5");
    @(posedge clk)
    
    //(-0) + (+1) = +1
    a =32'b10000000000000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be 00111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00111111100000000000000000000000) $display("OK");
    else $display("NOT OK 6");
    @(posedge clk)
    
    //(+0) + (-1) = -1
    a =32'b00000000000000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be 10111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10111111100000000000000000000000) $display("OK");
    else $display("NOT OK 7");
    @(posedge clk)
    
    //(-0) + (-1) = -1
    a =32'b10000000000000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be 10111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10111111100000000000000000000000) $display("OK");
    else $display("NOT OK 8");
    @(posedge clk)
    
    //(+1) + (+0) = +1
    a =32'b00111111100000000000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be 00111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00111111100000000000000000000000) $display("OK");
    else $display("NOT OK 9");
    @(posedge clk)
    
    //(+1) + (-0) = +1
    a =32'b00111111100000000000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be 00111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00111111100000000000000000000000) $display("OK");
    else $display("NOT OK 10");
    @(posedge clk)
    
    //(-1) + (+0) = -1
    a =32'b10111111100000000000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be 10111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10111111100000000000000000000000) $display("OK");
    else $display("NOT OK 11");
    @(posedge clk)
    
    //(-1) + (-0) = -1
    a =32'b10111111100000000000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be 10111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10111111100000000000000000000000) $display("OK");
    else $display("NOT OK 12");
    @(posedge clk)
    
    //(+0) + (+10.375) = +10.375
    a =32'b00000000000000000000000000000000; b =32'b01000001001001100000000000000000; 
    //answer should be 01000001001001100000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000001001001100000000000000000) $display("OK");
    else $display("NOT OK 13");
    @(posedge clk)
    
    //(-0) + (+10.375) = +10.375
    a =32'b10000000000000000000000000000000; b =32'b01000001001001100000000000000000; 
    //answer should be 01000001001001100000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000001001001100000000000000000) $display("OK");
    else $display("NOT OK 14");
    @(posedge clk)
    
    //(+0) + (-10.375) = -10.375
    a =32'b00000000000000000000000000000000; b =32'b11000001001001100000000000000000; 
    //answer should be 11000001001001100000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b11000001001001100000000000000000) $display("OK");
    else $display("NOT OK 15");
    @(posedge clk)
    
    //(-0) + (-10.375) = -10.375
    a =32'b10000000000000000000000000000000; b =32'b11000001001001100000000000000000; 
    //answer should be 11000001001001100000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b11000001001001100000000000000000) $display("OK");
    else $display("NOT OK 16");
    @(posedge clk)
    
    //(+10.375) + (+0) = +10.375
    a =32'b01000001001001100000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be 01000001001001100000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000001001001100000000000000000) $display("OK");
    else $display("NOT OK 17");
    @(posedge clk)
    
    //(+10.375) + (-0) = +10.375
    a =32'b01000001001001100000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be 01000001001001100000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000001001001100000000000000000) $display("OK");
    else $display("NOT OK 18");
    @(posedge clk)
    
    //(-10.375) + (+0) = -10.375
    a =32'b11000001001001100000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be 11000001001001100000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b11000001001001100000000000000000) $display("OK");
    else $display("NOT OK 19");
    @(posedge clk)
    
    //(-10.375) + (-0) = -10.375
    a =32'b11000001001001100000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be 11000001001001100000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b11000001001001100000000000000000) $display("OK");
    else $display("NOT OK 20");
    @(posedge clk)
    
  
    //TESTING INTEGERS
    //(+1) + (+1) = (+2)
    a =32'b00111111100000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be 01000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000000000000000000000000000000) $display("OK");
    else $display("NOT OK 21");
    @(posedge clk)
    
    //(+1) + (+2) = (+3)
    a =32'b00111111100000000000000000000000; b =32'b01000000000000000000000000000000; 
    //answer should be 01000000010000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000000010000000000000000000000) $display("OK");
    else $display("NOT OK 22");
    @(posedge clk)
    
    //(+2) + (+1) = (+3)
    a =32'b01000000000000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be 01000000010000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000000010000000000000000000000) $display("OK");
    else $display("NOT OK 23");
    @(posedge clk)
        
    //(+1) + (+1569) = (+1570)
    a =32'b00111111100000000000000000000000; b =32'b01000100110001000010000000000000; 
    //answer should be 11000001001001100000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000100110001000100000000000000) $display("OK");
    else $display("NOT OK 24");
    @(posedge clk)
    
    //(+1569) + (+1) = (+1570)
    a =32'b01000100110001000010000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be 01000100110001000100000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000100110001000100000000000000) $display("OK");
    else $display("NOT OK 25");
    @(posedge clk)
    
    //(+1569) + (1569) = (+3138)
    a =32'b01000100110001000010000000000000; b =32'b01000100110001000010000000000000; 
    //answer should be 01000101010001000010000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000101010001000010000000000000) $display("OK");
    else $display("NOT OK 26");
    @(posedge clk)
    
    //(+5) + (+6) = (+11)
    a =32'b01000000101000000000000000000000; b =32'b01000000110000000000000000000000; 
    //answer should be 01000001001100000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000001001100000000000000000000) $display("OK");
    else $display("NOT OK 27");
    @(posedge clk)
    
    //(+6) + (+5) = (+11)
    a =32'b01000000110000000000000000000000; b =32'b01000000101000000000000000000000; 
    //answer should be 01000001001100000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000001001100000000000000000000) $display("OK");
    else $display("NOT OK 28");
    @(posedge clk)
    
    //(+1) + (-2) = (-1)
    a =32'b00111111100000000000000000000000; b =32'b11000000000000000000000000000000; 
    //answer should be 10111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10111111100000000000000000000000) $display("OK");
    else $display("NOT OK 29");
    @(posedge clk)
    
    //(-2) + (+1) = (-1)
    a =32'b11000000000000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be 10111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10111111100000000000000000000000) $display("OK");
    else $display("NOT OK 30");
    @(posedge clk)
    
    //(+2) + (-1) = (+1)
    a =32'b01000000000000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be 00111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00111111100000000000000000000000) $display("OK");
    else $display("NOT OK 31");
    @(posedge clk)
    
    //(-1) + (+2) = (+1)
    a =32'b10111111100000000000000000000000; b =32'b01000000000000000000000000000000; 
    //answer should be 00111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00111111100000000000000000000000) $display("OK");
    else $display("NOT OK 32");
    @(posedge clk)
    
    //(+5) + (-6) = (-1)
    a =32'b01000000101000000000000000000000; b =32'b11000000110000000000000000000000; 
    //answer should be 10111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10111111100000000000000000000000) $display("OK");
    else $display("NOT OK 33");
    @(posedge clk)
    
    //(-6) + (+5) = (-1)
    a =32'b11000000110000000000000000000000; b =32'b01000000101000000000000000000000; 
    //answer should be 10111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10111111100000000000000000000000) $display("OK");
    else $display("NOT OK 34");
    @(posedge clk)
    
    //(+6) + (-5) = (+1)
    a =32'b01000000110000000000000000000000; b =32'b11000000101000000000000000000000; 
    //answer should be 00111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00111111100000000000000000000000) $display("OK");
    else $display("NOT OK 35");
    @(posedge clk)
    
    //(-5) + (+6) = (+1)
    a =32'b11000000101000000000000000000000; b =32'b01000000110000000000000000000000; 
    //answer should be 00111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00111111100000000000000000000000) $display("OK");
    else $display("NOT OK 36");
    @(posedge clk)
    
    //(-1) + (-1569) = (-1570)
    a =32'b10111111100000000000000000000000; b =32'b11000100110001000010000000000000; 
    //answer should be 11000100110001000100000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b11000100110001000100000000000000) $display("OK");
    else $display("NOT OK 37");
    @(posedge clk)
    
    //(-1569) + (+5) = (-1564)
    a =32'b11000100110001000010000000000000; b =32'b01000000101000000000000000000000; 
    //answer should be 11000100110000111000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b11000100110000111000000000000000) $display("OK");
    else $display("NOT OK 38");
    @(posedge clk)
    
    //(+2) + (-1569) = (-1567)
    a =32'b01000000000000000000000000000000; b =32'b11000100110001000010000000000000; 
    //answer should be 11000100110000111110000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b11000100110000111110000000000000) $display("OK");
    else $display("NOT OK 39");
    @(posedge clk)
    
    //(+1569) + (-6) = (1563)
    a =32'b01000100110001000010000000000000; b =32'b11000000110000000000000000000000; 
    //answer should be 01000100110000110110000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000100110000110110000000000000) $display("OK");
    else $display("NOT OK 40");
    @(posedge clk)
    
  
    //TESTING INTEGER CANCELLATION
    //(+1) + (-1) = (0)
    a =32'b00111111100000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be 11000100110000111110000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 41");
    @(posedge clk)
    
    //(-1) + (+1) = (0)
    a =32'b10111111100000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be 11000100110000111110000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 42");
    @(posedge clk)
    
    //(+6) + (-6) = (0)
    a =32'b01000000110000000000000000000000; b =32'b11000000110000000000000000000000; 
    //answer should be 11000100110000111110000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 43");
    @(posedge clk)
    
    //(-6) + (+6) = (0)
    a =32'b11000000110000000000000000000000; b =32'b01000000110000000000000000000000; 
    //answer should be 11000100110000111110000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 44");
    @(posedge clk)
    
    //(+1569) + (-1569) = (0)
    a =32'b01000100110001000010000000000000; b =32'b11000100110001000010000000000000; 
    //answer should be 11000100110000111110000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 45");
    @(posedge clk)
    
    //(-1569) + (+1569) = (0)
    a =32'b11000100110001000010000000000000; b =32'b01000100110001000010000000000000; 
    //answer should be 11000100110000111110000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 46");
    @(posedge clk)
    
  
    //TESTING INFINITIES
    //(+INF) + (+0) = (+INF)
    a =32'b01111111100000000000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 47");
    @(posedge clk)
    
    //(+INF) + (-0) = (+INF)
    a =32'b01111111100000000000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 48");
    @(posedge clk)
    
    //(+INF) + (+1) = (+INF)
    a =32'b01111111100000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 49");
    @(posedge clk)
    
    //(+INF) + (-1) = (+INF)
    a =32'b01111111100000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 50");
    @(posedge clk)
    
    //(+INF) + (+SUB) = (+INF)
    a =32'b01111111100000000000000000000000; b =32'b00000000000000100101000010010001; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 51");
    @(posedge clk)
    
    //(+INF) + (-SUB) = (+INF)
    a =32'b01111111100000000000000000000000; b =32'b10000000000000100101000010010001; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 52");
    @(posedge clk)
    
    //(+0) + (+INF) = (+INF)
    a =32'b00000000000000000000000000000000; b =32'b01111111100000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 53");
    @(posedge clk)
    
    //(-0) + (+INF) = (+INF)
    a =32'b10000000000000000000000000000000; b =32'b01111111100000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 54");
    @(posedge clk)
    
    //(+1) + (+INF) = (+INF)
    a =32'b00111111100000000000000000000000; b =32'b01111111100000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 55");
    @(posedge clk)
    
    //(-1) + (+INF) = (+INF)
    a =32'b10111111100000000000000000000000; b =32'b01111111100000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 56");
    @(posedge clk)
    
    //(+SUB) + (+INF) = (+INF)
    a =32'b00000000000000100101000010010001; b =32'b01111111100000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 57");
    @(posedge clk)
    
    //(-SUB) + (+INF) = (+INF)
    a =32'b10000000000000100101000010010001; b =32'b01111111100000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 58");
    @(posedge clk)
    
    //(+INF) + (+INF) = (+INF)
    a =32'b01111111100000000000000000000000; b =32'b01111111100000000000000000000000; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b01111111100) $display("OK");
    else $display("NOT OK 59");
    @(posedge clk)
    
    //(+INF) + (-INF) = (qNaN)
    a =32'b01111111100000000000000000000000; b =32'b11111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 60");
    @(posedge clk)
    
    //(-INF) + (+0) = (-INF)
    a =32'b11111111100000000000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 61");
    @(posedge clk)
    
    //(-INF) + (-0) = (-INF)
    a =32'b11111111100000000000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 62");
    @(posedge clk)
    
    //(-INF) + (+1) = (-INF)
    a =32'b11111111100000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 63");
    @(posedge clk)
    
    //(-INF) + (-1) = (-INF)
    a =32'b11111111100000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 64");
    @(posedge clk)
    
    //(-INF) + (+SUB) = (-INF)
    a =32'b11111111100000000000000000000000; b =32'b00000000000000100101000010010001; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 65");
    @(posedge clk)
    
    //(-INF) + (-SUB) = (-INF)
    a =32'b11111111100000000000000000000000; b =32'b10000000000000100101000010010001; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 66");
    @(posedge clk)
    
    //(+0) + (-INF) = (-INF)
    a =32'b00000000000000000000000000000000; b =32'b11111111100000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 67");
    @(posedge clk)
    
    //(-0) + (-INF) = (-INF)
    a =32'b10000000000000000000000000000000; b =32'b11111111100000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 68");
    @(posedge clk)
    
    //(+1) + (-INF) = (-INF)
    a =32'b00111111100000000000000000000000; b =32'b11111111100000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 69");
    @(posedge clk)
    
    //(-1) + (-INF) = (-INF)
    a =32'b10111111100000000000000000000000; b =32'b11111111100000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 70");
    @(posedge clk)
    
    //(+SUB) + (-INF) = (-INF)
    a =32'b00000000000000100101000010010001; b =32'b11111111100000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 71");
    @(posedge clk)
    
    //(-SUB) + (-INF) = (-INF)
    a =32'b10000000000000100101000010010001; b =32'b11111111100000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 72");
    @(posedge clk)
    
    //(-INF) + (-INF) = (-INF)
    a =32'b11111111100000000000000000000000; b =32'b11111111100000000000000000000000; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 11'b11111111100) $display("OK");
    else $display("NOT OK 73");
    @(posedge clk)
    
  
    //TESTING qNaN
    //(+qNaN) + (+0) = (qNaN)
    a =32'b01111111110000000000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 74");
    @(posedge clk)
    
    //(+qNaN) + (-0) = (qNaN)
    a =32'b01111111110000000000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 75");
    @(posedge clk)
    
    //(+qNaN) + (+1) = (qNaN)
    a =32'b01111111110000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 76");
    @(posedge clk)
    
    //(+qNaN) + (-1) = (qNaN)
    a =32'b01111111110000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 77");
    @(posedge clk)
    
    //(+qNaN) + (+SUB) = (qNaN)
    a =32'b01111111110000000000000000000000; b =32'b00000000000000100101000010010001; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 78");
    @(posedge clk)
    
    //(+qNaN) + (-SUB) = (qNaN)
    a =32'b01111111110000000000000000000000; b =32'b10000000000000100101000010010001; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 79");
    @(posedge clk)
    
    //(+qNaN) + (+INF) = (qNaN)
    a =32'b01111111110000000000000000000000; b =32'b01111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 80");
    @(posedge clk)
    
    //(+qNaN) + (-INF) = (qNaN)
    a =32'b01111111110000000000000000000000; b =32'b11111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 81");
    @(posedge clk)
    
    //(+0) + (+qNaN) = (qNaN)
    a =32'b00000000000000000000000000000000; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 82");
    @(posedge clk)
    
    //(-0) + (+qNaN) = (qNaN)
    a =32'b10000000000000000000000000000000; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 83");
    @(posedge clk)
    
    //(+1) + (+qNaN) = (qNaN)
    a =32'b00111111100000000000000000000000; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 84");
    @(posedge clk)
    
    //(-1) + (+qNaN) = (qNaN)
    a =32'b10111111100000000000000000000000; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 85");
    @(posedge clk)
    
    //(+SUB) + (+qNaN) = (qNaN)
    a =32'b00000000000000100101000010010001; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 86");
    @(posedge clk)
    
    //(-SUB) + (+qNaN) = (qNaN)
    a =32'b10000000000000100101000010010001; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 87");
    @(posedge clk)
    
    //(+INF) + (+qNaN) = (qNaN)
    a =32'b11111111100000000000000000000000; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 88");
    @(posedge clk)
    
    //(-INF) + (+qNaN) = (qNaN)
    a =32'b01111111100000000000000000000000; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 89");
    @(posedge clk)
    
    //(+qNaN) + (+qNaN) = (qNaN)
    a =32'b01111111110000000000000000000000; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 90");
    @(posedge clk)
    
    //(+qNaN) + (-qNaN) = (qNaN)
    a =32'b01111111110000000000000000000000; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 91");
    @(posedge clk)
    
    //(-qNaN) + (+0) = (qNaN)
    a =32'b11111111110000000000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 92");
    @(posedge clk)
    
    //(-qNaN) + (-0) = (qNaN)
    a =32'b11111111110000000000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 93");
    @(posedge clk)
    
    //(-qNaN) + (+1) = (qNaN)
    a =32'b11111111110000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 94");
    @(posedge clk)
    
    //(-qNaN) + (-1) = (qNaN)
    a =32'b11111111110000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 95");
    @(posedge clk)
    
    //(-qNaN) + (+SUB) = (qNaN)
    a =32'b11111111110000000000000000000000; b =32'b00000000000000100101000010010001; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 96");
    @(posedge clk)
    
    //(-qNaN) + (-SUB) = (qNaN)
    a =32'b11111111110000000000000000000000; b =32'b10000000000000100101000010010001; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 97");
    @(posedge clk)
    
    //(-qNaN) + (+INF) = (qNaN)
    a =32'b11111111110000000000000000000000; b =32'b01111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 98");
    @(posedge clk)
    
    //(-qNaN) + (-INF) = (qNaN)
    a =32'b11111111110000000000000000000000; b =32'b11111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 99");
    @(posedge clk)
    
    //(+0) + (-qNaN) = (qNaN)
    a =32'b00000000000000000000000000000000; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 100");
    @(posedge clk)
    
    //(-0) + (-qNaN) = (qNaN)
    a =32'b10000000000000000000000000000000; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 101");
    @(posedge clk)
    
    //(+1) + (-qNaN) = (qNaN)
    a =32'b00111111100000000000000000000000; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 102");
    @(posedge clk)
    
    //(-1) + (-qNaN) = (qNaN)
    a =32'b10111111100000000000000000000000; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 103");
    @(posedge clk)
    
    //(+SUB) + (-qNaN) = (qNaN)
    a =32'b00000000000000100101000010010001; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 104");
    @(posedge clk)
    
    //(-SUB) + (-qNaN) = (qNaN)
    a =32'b10000000000000100101000010010001; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 105");
    @(posedge clk)
    
    //(+INF) + (-qNaN) = (qNaN)
    a =32'b01111111100000000000000000000000; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 106");
    @(posedge clk)
    
    //(-INF) + (-qNaN) = (qNaN)
    a =32'b11111111100000000000000000000000; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 107");
    @(posedge clk)
    
    //(-qNaN) + (-qNaN) = (qNaN)
    a =32'b11111111110000000000000000000000; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 108");
    @(posedge clk)
    
    //(+qNaN) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b01111111110000000000000000000000; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 109");
    @(posedge clk)
    
    //(+qNaN) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b01111111110000000000000000000000; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 110");
    @(posedge clk)
    
    //(-qNaN) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b11111111110000000000000000000000; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 111");
    @(posedge clk)
    
    //(-qNaN) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b11111111110000000000000000000000; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 112");
    @(posedge clk)
    
    //(+sNaN) + (+qNaN) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 113");
    @(posedge clk)
    
    //(-sNaN) + (+qNaN) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b01111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 114");
    @(posedge clk)
    
    //(+sNaN) + (-qNaN) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 115");
    @(posedge clk)
    
    //(-sNaN) + (-qNaN) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b11111111110000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 116");
    @(posedge clk)
    
  
    //TESTING sNaN
    //(+sNaN) + (+0) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 117");
    @(posedge clk)
    
    //(+sNaN) + (-0) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 118");
    @(posedge clk)
    
    //(+sNaN) + (+1) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 119");
    @(posedge clk)
    
    //(+sNaN) + (-1) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 120");
    @(posedge clk)
    
    //(+sNaN) + (+SUB) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b00000000000000100101000010010001; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 121");
    @(posedge clk)
    
    //(+sNaN) + (-SUB) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b10000000000000100101000010010001; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 122");
    @(posedge clk)
    
    //(+sNaN) + (+INF) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b01111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 123");
    @(posedge clk)
    
    //(+sNaN) + (-INF) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b11111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 124");
    @(posedge clk)
    
    //(+0) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b00000000000000000000000000000000; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 125");
    @(posedge clk)
    
    //(-0) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b10000000000000000000000000000000; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 126");
    @(posedge clk)
    
    //(+1) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b00111111100000000000000000000000; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 127");
    @(posedge clk)
    
    //(-1) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b10111111100000000000000000000000; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 128");
    @(posedge clk)
    
    //(+SUB) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b00000000000000100101000010010001; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 129");
    @(posedge clk)
    
    //(-SUB) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b10000000000000100101000010010001; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 130");
    @(posedge clk)
    
    //(+INF) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b01111111100000000000000000000000; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 131");
    @(posedge clk)
    
    //(-INF) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b11111111100000000000000000000000; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 132");
    @(posedge clk)
    
    //(+sNaN) + (+sNaN) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b01111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 133");
    @(posedge clk)
    
    //(+sNaN) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b01111111101000000000000000000000; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 134");
    @(posedge clk)
    
    //(-sNaN) + (+0) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b00000000000000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 135");
    @(posedge clk)
    
    //(-sNaN) + (-0) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b10000000000000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 136");
    @(posedge clk)
    
    //(-sNaN) + (+1) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 137");
    @(posedge clk)
    
    //(-sNaN) + (-1) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 138");
    @(posedge clk)
    
    //(-sNaN) + (+SUB) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b00000000000000100101000010010001; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 139");
    @(posedge clk)
    
    //(-sNaN) + (-SUB) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b10000000000000100101000010010001; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 140");
    @(posedge clk)
    
    //(-sNaN) + (+INF) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b01111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 141");
    @(posedge clk)
    
    //(-sNaN) + (-INF) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b11111111100000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 142");
    @(posedge clk)
    
    //(+0) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b00000000000000000000000000000000; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 143");
    @(posedge clk)
    
    //(-0) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b10000000000000000000000000000000; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 144");
    @(posedge clk)
    
    //(+1) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b00111111100000000000000000000000; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 145");
    @(posedge clk)
    
    //(-1) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b10111111100000000000000000000000; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 146");
    @(posedge clk)
    
    //(+SUB) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b00000000000000100101000010010001; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 147");
    @(posedge clk)
    
    //(-SUB) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b10000000000000100101000010010001; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 148");
    @(posedge clk)
    
    //(+INF) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b01111111100000000000000000000000; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 149");
    @(posedge clk)
    
    //(-INF) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b11111111100000000000000000000000; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 150");
    @(posedge clk)
    
    //(-sNaN) + (-sNaN) = (qNaN) with sNaN signal
    a =32'b11111111101000000000000000000000; b =32'b11111111101000000000000000000000; 
    //answer should be X1111111110XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:21] == 10'b1111111110) $display("OK");
    else $display("NOT OK 151");
    @(posedge clk)
    
  
    //TESTING SUBNORMAL
    a =32'b00000000011111111111111111111111; b =32'b00000000000000000000000000000001;
    //(+MAX_SUBNORMAL) + (+MAX_SUBNORMAL)
    a =32'b00000000011111111111111111111111; b =32'b00000000011111111111111111111111; 
    //answer should be 00000000111111111111111111111110
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000111111111111111111111110) $display("OK");
    else $display("NOT OK 152");
    @(posedge clk)
    
    //(+MAX_SUBNORMAL) + (-MAX_SUBNORMAL)
    a =32'b00000000011111111111111111111111; b =32'b10000000011111111111111111111111; 
    //answer should be X0000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 153");
    @(posedge clk)
    
    //(-MAX_SUBNORMAL) + (+MAX_SUBNORMAL)
    a =32'b10000000011111111111111111111111; b =32'b00000000011111111111111111111111; 
    //answer should be X0000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 154");
    @(posedge clk)
    
    //(-MAX_SUBNORMAL) + (-MAX_SUBNORMAL)
    a =32'b10000000011111111111111111111111; b =32'b10000000011111111111111111111111; 
    //answer should be 10000000111111111111111111111110
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000111111111111111111111110) $display("OK");
    else $display("NOT OK 155");
    @(posedge clk)
    
    //(+MIN_SUBNORMAL) + (+MIN_SUBNORMAL)
    a =32'b00000000000000000000000000000001; b =32'b00000000000000000000000000000001; 
    //answer should be 00000000000000000000000000000010
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000000000000000000000000010) $display("OK");
    else $display("NOT OK 156");
    @(posedge clk)
    
    //(+MIN_SUBNORMAL) + (-MIN_SUBNORMAL)
    a =32'b00000000000000000000000000000001; b =32'b10000000000000000000000000000001; 
    //answer should be X0000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 157");
    @(posedge clk)
    
    //(-MIN_SUBNORMAL) + (+MIN_SUBNORMAL)
    a =32'b10000000000000000000000000000001; b =32'b00000000000000000000000000000001; 
    //answer should be X0000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 158");
    @(posedge clk)
    
    //(-MIN_SUBNORMAL) + (-MIN_SUBNORMAL)
    a =32'b10000000000000000000000000000001; b =32'b10000000000000000000000000000001; 
    //answer should be 10000000000000000000000000000010
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000000000000000000000000010) $display("OK");
    else $display("NOT OK 159");
    @(posedge clk)
    
    //(+MAX_SUBNORMAL) + (+MIN_SUBNORMAL)
    a =32'b00000000011111111111111111111111; b =32'b00000000000000000000000000000001; 
    //answer should be 00000000100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000100000000000000000000000) $display("OK");
    else $display("NOT OK 160");
    @(posedge clk)
    
    //(+MAX_SUBNORMAL) + (-MIN_SUBNORMAL)
    a =32'b00000000011111111111111111111111; b =32'b10000000000000000000000000000001; 
    //answer should be 00000000011111111111111111111110
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000011111111111111111111110) $display("OK");
    else $display("NOT OK 161");
    @(posedge clk)
    
    //(-MAX_SUBNORMAL) + (+MIN_SUBNORMAL)
    a =32'b10000000011111111111111111111111; b =32'b00000000000000000000000000000001; 
    //answer should be 10000000011111111111111111111110
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000011111111111111111111110) $display("OK");
    else $display("NOT OK 162");
    @(posedge clk)
    
    //(-MAX_SUBNORMAL) + (-MIN_SUBNORMAL)
    a =32'b10000000011111111111111111111111; b =32'b10000000000000000000000000000001; 
    //answer should be 10000000100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000100000000000000000000000) $display("OK");
    else $display("NOT OK 163");
    @(posedge clk)
    
    //(+MIN_SUBNORMAL) + (+MAX_SUBNORMAL)
    a =32'b00000000000000000000000000000001; b =32'b00000000011111111111111111111111; 
    //answer should be 00000000100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000100000000000000000000000) $display("OK");
    else $display("NOT OK 164");
    @(posedge clk)
    
    //(+MIN_SUBNORMAL) + (-MAX_SUBNORMAL)
    a =32'b00000000000000000000000000000001; b =32'b10000000011111111111111111111111; 
    //answer should be 10000000011111111111111111111110
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000011111111111111111111110) $display("OK");
    else $display("NOT OK 165");
    @(posedge clk)
    
    //(-MIN_SUBNORMAL) + (+MAX_SUBNORMAL)
    a =32'b10000000000000000000000000000001; b =32'b00000000011111111111111111111111; 
    //answer should be 00000000011111111111111111111110
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000011111111111111111111110) $display("OK");
    else $display("NOT OK 166");
    @(posedge clk)
    
    //(-MIN_SUBNORMAL) + (-MAX_SUBNORMAL)
    a =32'b10000000000000000000000000000001; b =32'b10000000011111111111111111111111; 
    //answer should be 10000000100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000100000000000000000000000) $display("OK");
    else $display("NOT OK 167");
    @(posedge clk)
    
    //slightly less than max subnormal + more than min subnormal
    a =32'b00000000011111111111111110000000; b =32'b00000000000000000111111111111111; 
    //answer should be 00000000100000000111111101111111
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000100000000111111101111111) $display("OK");
    else $display("NOT OK 168");
    @(posedge clk)
    
    //slightly less than max subnormal - more than min subnormal
    a =32'b00000000011111111111111110000000; b =32'b10000000000000000111111111111111; 
    //answer should be 00000000011111110111111110000001
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000011111110111111110000001) $display("OK");
    else $display("NOT OK 169");
    @(posedge clk)
    
    //- slightly less than max subnormal + more than min subnormal
    a =32'b10000000011111111111111110000000; b =32'b00000000000000000111111111111111; 
    //answer should be 00000000011111110111111110000001
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000011111110111111110000001) $display("OK");
    else $display("NOT OK 170");
    @(posedge clk)
    
    //- slightly less than max subnormal - more than min subnormal
    a =32'b10000000011111111111111110000000; b =32'b10000000000000000111111111111111; 
    //answer should be 00000000100000000111111101111111
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000100000000111111101111111) $display("OK");
    else $display("NOT OK 171");
    @(posedge clk)
    
    
    //TESTING INTO SUBNORMAL AND INTO INFINITY
    //a little more than min normal - slightly more than min normal
    a =32'b00000000100000000000010000000000; b =32'b10000000100000000000001111000000; 
    //answer should be 00000000000000000000000001000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000000000000000000001000000) $display("OK");
    else $display("NOT OK 172");
    @(posedge clk)
    
    //tiny bit more than min normal - even tinier bit more than min normal
    a =32'b00000000100000000000000000000001; b =32'b10000000100000000000000000000000; 
    //answer should be 00000000000000000000000000000001
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000000000000000000000000001) $display("OK");
    else $display("NOT OK 173");
    @(posedge clk)
    
    //- slightly more than min normal + a little more than min normal
    a =32'b10000000100000000000001111000000; b =32'b00000000100000000000010000000000; 
    //answer should be 00000000000000000000000001000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000000000000000000001000000) $display("OK");
    else $display("NOT OK 174");
    @(posedge clk)
    
    //- even tinier bit more than min normal + tiny bit more than min normal 
    a =32'b10000000100000000000000000000000; b =32'b00000000100000000000000000000001; 
    //answer should be 00000000000000000000000000000001
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000000000000000000000000001) $display("OK");
    else $display("NOT OK 175");
    @(posedge clk)
    
    //- a little more than min normal + slightly more than min normal
    a =32'b10000000100000000000010000000000; b =32'b00000000100000000000001111000000; 
    //answer should be 00000000000000000000000001000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000000000000000000001000000) $display("OK");
    else $display("NOT OK 176");
    @(posedge clk)
    
    //- tiny bit more than min normal + even tinier bit more than min normal
    a =32'b10000000100000000000000000000001; b =32'b00000000100000000000000000000000; 
    //answer should be 00000000000000000000000000000001
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000000000000000000000000001) $display("OK");
    else $display("NOT OK 177");
    @(posedge clk)
    
    //slightly more than min normal - a little more than min normal
    a =32'b00000000100000000000001111000000; b =32'b10000000100000000000010000000000; 
    //answer should be 00000000000000000000000001000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000000000000000000001000000) $display("OK");
    else $display("NOT OK 178");
    @(posedge clk)
    
    //even tinier bit more than min normal - tiny bit more than min normal 
    a =32'b00000000100000000000000000000000; b =32'b10000000100000000000000000000001; 
    //answer should be 00000000000000000000000000000001
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10000000000000000000000000000001) $display("OK");
    else $display("NOT OK 179");
    @(posedge clk)
    
    //very large normal + very large normal 
    a =32'b01111111011111111111111111111111; b =32'b01111111011111111111111111111111; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 32'b01111111100) $display("OK");
    else $display("NOT OK 180");
    @(posedge clk)
    
    //very large normal + very large normal 
    a =32'b01111111011111011100011001011110; b =32'b01111111011111011111110111101111; 
    //answer should be 01111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 32'b01111111100) $display("OK");
    else $display("NOT OK 181");
    @(posedge clk)
    
    //- very large normal - very large normal 
    a =32'b11111111011111111111111111111111; b =32'b11111111011111111111111111111111; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 32'b11111111100) $display("OK");
    else $display("NOT OK 182");
    @(posedge clk)
    
    //- very large normal - very large normal 
    a =32'b11111111011111011100011001011110; b =32'b11111111011111011111110111101111; 
    //answer should be 11111111100XXXXXXXXXXXXXXXXXXXXX
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[31:21] == 32'b11111111100) $display("OK");
    else $display("NOT OK 183");
    @(posedge clk)
    
    
    //EXTRAS
    a =32'b01000000101000000000000000000000; b =32'b11000000110000000000000000000000; 
    //answer should be 10111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b10111111100000000000000000000000) $display("OK");
    else $display("NOT OK 184");
    @(posedge clk)
    
    a =32'b00111111100000000000000000000000; b =32'b00111111100000000000000000000000; 
    //answer should be 01000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000000000000000000000000000000) $display("OK");
    else $display("NOT OK 185");
    @(posedge clk)
    
    a =32'b00111111110000000000000000000000; b =32'b00111111110000000000000000000000; 
    //answer should be 01000000010000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000000010000000000000000000000) $display("OK");
    else $display("NOT OK 186");
    @(posedge clk)
    
    a =32'b00111111111000000000000000000000; b =32'b00111111111000000000000000000000;
    //answer should be 01000000011000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b01000000011000000000000000000000) $display("OK");
    else $display("NOT OK 187");
    @(posedge clk)
    
    a =32'b00111111100000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be X0000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 188");
    @(posedge clk)
    
    a =32'b01000010110010000000000000000000; b =32'b11000010110010000000000000000000; 
    //answer should be X0000000000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c[30:0] == 31'b0000000000000000000000000000000) $display("OK");
    else $display("NOT OK 189");
    @(posedge clk)
    
    a =32'b00111111100000000000000000000001; b =32'b10111111100000000000000000000000;
    //answer should be 00110100000000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00110100000000000000000000000000) $display("OK");
    else $display("NOT OK 190");
    @(posedge clk)
    
    a =32'b01000000000000000000000000000000; b =32'b10111111100000000000000000000000; 
    //answer should be 00111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00111111100000000000000000000000) $display("OK");
    else $display("NOT OK 191");
    @(posedge clk)
    
    a =32'b00111111100000000000000000000000; b =32'b00000000000000000000000000000001;
    //answer should be 00111111100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00111111100000000000000000000000) $display("OK");
    else $display("NOT OK 192");
    @(posedge clk)
    
    a =32'b00000000000000000000000000000001; b =32'b00000000000000000000000000000001;
    //answer should be 00000000000000000000000000000010
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000000000000000000000000010) $display("OK");
    else $display("NOT OK 193");
    @(posedge clk)
    
    a =32'b00000000011111111111111111111111; b =32'b00000000000000000000000000000001; 
    //answer should be 00000000100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000100000000000000000000000) $display("OK");
    else $display("NOT OK 194");
    @(posedge clk)
    
    a =32'b00000000100000000000000000000001; b =32'b00000000000000000000000000000001; 
    //answer should be 00000000100000000000000000000010
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000100000000000000000000010) $display("OK");
    else $display("NOT OK 195");
    @(posedge clk)
    
    a =32'b00000000010000000000000000000000; b =32'b00000000010000000000000000000000; 
    //answer should be 00000000100000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000100000000000000000000000) $display("OK");
    else $display("NOT OK 196");
    @(posedge clk)
    
    a =32'b00000000100000000000000000000000; b =32'b10000000010000000000000000000000; 
    //answer should be 00000000010000000000000000000000
    @(posedge clk); $display("a %b b %b m %b", a, b, c); 
    if(c == 32'b00000000010000000000000000000000) $display("OK");
    else $display("NOT OK 197");
    @(posedge clk)
    
    @(posedge clk)
    
    $finish;
  end

endmodule
