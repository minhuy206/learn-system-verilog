`timescale 1ns/1ps
// module tb;

//   bit a = 0;
//   byte b = 0; // If not assign the value, 2-state will be 0 and 4-state will be X
//   shortint c = 0;
//   int d = 0;
//   longint e = 0;

//   bit [7:0] f = 8'd00000000;
//   bit [15: 0] g = 16'h0000;

//   real h = 0;


//   initial begin
//     a = 1'b0;
//   end
  
// endmodule

// module tb;
//   byte var1 = -126;
//   bit [7:0] var2 = 130;

//   initial begin
//     #10;
//     $display("value of Var: %0d",var1);
//     $display("value of Var2: %0b",var2);
//   end
// endmodule


// module tb;
//   time fix_time = 0;
//   realtime real_time = 0;

//   // $time(); $realtime();
  
//   initial begin
//     #12.25;
//     fix_time = $time();
//     real_time = $realtime();
//     $display("Current simulation time: %0t", fix_time);
//     $display("Current simulation time: %0t", real_time);

//   end
// endmodule

module top(
  input a, b, sel,
  output y
);

  reg temp;

  always@(*)
  begin
    if(sel == 1'b0)
    temp = a;
    else
    temp = b;
  end
  assign y = temp;
endmodule