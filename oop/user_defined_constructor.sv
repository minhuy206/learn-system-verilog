class first;

  int data;
  function new(input int data_in = 32); // if do not pass the arg the default value of f1.data is 0. This is a special function so that do not need to add type return like void, int,...
    data = data_in;
  endfunction
endclass

module tb;
  first f1;

  initial begin
    f1 = new(4'b1);
    $display("data: %0d", f1.data);
  end
endmodule
