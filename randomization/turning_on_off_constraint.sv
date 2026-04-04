class generator;
  randc bit [3:0] raddr, waddr;
  rand bit oe;
  rand bit wr;

  constraint wr_c {
    wr dist {0:=50, 1:=50};
  }

  constraint oe_c{
    oe dist {1:=50, 0:=50};
  }

  constraint wr_oe_c{
    (wr == 1) <-> (oe == 0);
  }

  constraint write_read {
    if(wr == 1)
    {
      waddr inside {[11:15]};
      raddr == 0;
    }
    else {
      waddr == 0;
      raddr inside {[11:15]};
    }
  }
endclass

module tb;
  generator g;

  initial begin
    g = new();

    g.wr_oe_c.constraint_mode(0); // 1 -> constraint is on and 0 -> constraint is off
    $display("Contraint Status oe_c: %0d", g.oe_c.constraint_mode()); // constraint_mode use in a task does not allow to pass a parameter
    for(int i = 0; i < 10; i++) begin
      assert(g.randomize()) else $display("randomization failed");
      $display("Value of wr: %0b and oe: %0b", g.wr, g.oe);
    end
  end
endmodule