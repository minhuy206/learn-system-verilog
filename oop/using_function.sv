// Remember that function does not allow timing control
module tb;
  bit [4:0] res = 0;
  bit [3:0] ain = 4'b0100;
  bit [3:0] bin = 4'b0010;

  function bit [4:0] add(input bit [3:0] a = 4'b0100, b = 4'b0010); // default arg for the fnc 
    return a + b;
  endfunction

  function void display_ain_bin();
    $display("Value of ain: %0d and bin: %0d", ain, bin);
  endfunction


  initial begin
    // res = add(4'b0100, 4'b0010);
    display_ain_bin();
    res = add(ain, bin);
    $display("Value of addition: %0d", res); // Value of addition: 6

  end

endmodule