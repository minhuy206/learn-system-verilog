class first;
  int data;

endclass

module tb;
  first f1;
  first f2;

  initial begin
    f1 = new(); // constructor
    f1.data = 24; // processing
    f2 = new f1; // cp f1 to f2
    $display("f2.data: %0d", f2.data); // 24
    f2.data = 12;
    $display("f2.data: %0d", f2.data); // 12
    $display("f1.data: %0d", f1.data); // 24
    f1.data = 20;
    $display("f2.data: %0d", f2.data); // 12
    $display("f1.data: %0d", f1.data); // 20
  end
endmodule