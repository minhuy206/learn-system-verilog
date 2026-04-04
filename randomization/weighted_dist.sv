class first;

  rand bit wr;
  rand bit rd;

  constraint cntrl{
    wr dist {0 := 30, 1 := 70}; // := the percentages are equal for all number in range. Example: [1:3] := 70  -> 1 := 70, 2 := 70 and 3 := 70
    rd dist {0 :/ 30, 1 :/ 70}; // :/ the percentages are divided evenly for all number in range. Example: [1:3] :/ 60 -> 1 := 20, 2:= 20 and 3:= 20
  }

endclass

module tb;

  first f;
  initial begin
    f = new();

    for(int i = 0; i < 10; i++) begin
      f.randomize();
      $display("Value of wr: %0d and rd: %0d", f.wr, f.rd);
    end
  end
endmodule