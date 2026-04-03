class first;
  local int data = 34; // local like private in c++, only the method in this class can access the local variables of class

  task set(input int data);
    this.data = data;
  endtask

  function int get();
    return this.data;
  endfunction

  task display();
    $display("Value of data: %0d", data);
  endtask
endclass

class second;
  first f1;

  function new();
    f1 = new();
  endfunction
endclass

module tb;
  second s;

  initial begin
    s = new();

    s.f1.set(123);
    $display("Value of data: %0d", s.f1.get());

  end
endmodule
