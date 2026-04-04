class first;
  int data = 12;

  function void display;
    $display("Value of data: %0d", this.data);
  endfunction

endclass

class second extends first;

  int temp = 34;

  function void add();
    $display("Value after process: %0d", temp + this.data);
  endfunction
endclass


module tb;

  second s;
  initial begin
    s = new();
    $display("Value of data: %0d", s.data);
    s.display();
    $display("Value of temp: %0d", s.temp);
    s.add();
  end

endmodule

