class first;
  int data = 34;
  bit[7:0] temp = 8'h11;
  function first copy();
    copy = new();
    copy.data = this.data;
    copy.temp = this.temp;
  endfunction

endclass
 
module tb;

  first f1; 
  first f2;         

  initial begin
    f1 = new();
    f2 = new();

    f2 = f1.copy();
    $display("data: %0d and temp: %0x", f2.data, f2.temp);
  end

  // initial begin
  //   f1 = new();
  //   f1.data = 45;

  //   f2 = new f1;

  //   $display("%0d", f2.data);

  // end

endmodule