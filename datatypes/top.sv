module top(
  input a, b, sel,
  output y
);
  // reg temp;
  logic temp;

  always@(*)
  begin
    if(sel == 1'b0)
    temp = a;
    else
    temp = b;
  end
  assign y = temp;
endmodule