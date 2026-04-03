// class method divided into task and function 
// + Task: supports timming control
//    @(posedge clk);
//    #10;
// -> Multiple output port
//
// + Function: do not supports timing control
// -> Do not support output port

class first;

  bit [2:0] data;
  bit [1:0] data2;

endclass

module tb;
  first f;

  initial begin
    f = new(); // class constructor
    f.data = 3'b010;
    f.data2 = 2'b10;
    f = null; // free the memory contains the class
    #1;
    $display("value of data: %0d and data2: %0d", f.data, f.data2);
  end

endmodule


// module top(
//   input a,b,
//   output y
// );
//   reg temp;
//   assign y = a & b;

// endmodule

// module top2(
//   input c,d,
//   output y
// )

//   top dut(c,d,y);

//   dut.temp; // like class access the attribute

// endmodule