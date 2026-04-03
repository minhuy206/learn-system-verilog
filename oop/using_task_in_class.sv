class first;

  int data1;
  bit [7:0] data2;
  shortint data3;
  
  function new(input int data1 = 32, input bit [7:0] data2 = 0'h00, input shortint data3 = 0);
    this.data1 = data1;
    this.data2 = data2;
    this.data3 = data3;
  endfunction

  task display();
    $display("Value of data1: %0d, data2: %0d and data3: %0d", this.data1, this.data2, this.data3);
  endtask
endclass

module tb;
  first f1;

  initial begin
    // f1 = new(23, 4, 32);
    // f1 = new(23,, 32); // it will be data1 = 23, data2 = default valu e= 0'h00 and data3 = 32
    f1 = new(.data2(4), .data3(5), .data1(23)); // no need to pass in sequence
    f1.display();
    $display("data1: %0d and data2: %0d and data3: %0d", f1.data1, f1.data2, f1.data3);
  end
endmodule
