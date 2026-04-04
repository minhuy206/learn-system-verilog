class first;
  int data = 12;

  virtual function void display();
    $display("First: value of data: %0d", this.data);
  endfunction

endclass

class second extends first;

  int temp = 34;

  function void add();
    $display("second: value after process: %0d", this.temp + this.data);
  endfunction

  function void display();
    $display("Second: value of data : %0d", this.data);
  endfunction

endclass

module tb;
  first f;
  second s;

  initial begin
    f = new();
    s = new();
    f = s;
    f.display();
  end
endmodule
