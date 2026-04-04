class generator;
  randc bit [3:0] a;
  rand bit oe;
  rand bit wr;

  constraint wr_c {
    wr dist {0:=80, 1:=20};
  }

  constraint oe_c{
    oe dist {1:=80, 0:=20};
  }

  constraint wr_oe_c{
    (wr == 1) <-> (oe == 1); // if wr = 1, oe will be 1 and vice versa
  }
endclass

module tb;
  generator g;

  initial begin
    g = new();

    for(int i = 0; i < 10; i++) begin
      assert(g.randomize()) else $display("randomization failed");
      $display("Value of wr: %0b and oe: %0b", g.wr, g.oe);
    end
  end
endmodule