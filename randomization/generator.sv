class generator;
  
  rand bit [3:0] a, b; // rand or randc. randc means random cyclic
  bit [3:0] y;

  // constraint data_a {a > 3; a < 7; }
  // constraint data_b {b == 3;}
  
  // constraint data {a > 3; a < 7; b > 0;}

  // constraint data {
  //                 a inside {[0:8], [10:11], 15};
  //                 b inside {[3:11]};
  // }
  constraint data {
                  !(a inside {[3:7]}); // skip 3 -> 7 for a
                  !(b inside {[5:9]}); // skip 5 -> 9 for b
  }
  
endclass 

module tb;
  generator g;
  int i = 0;

  initial begin
    g = new();
    for (i=0; i<10; i++) begin
      // status = g.randomize();
      // if(!g.randomize()) begin // randomize return a value 0 or 1 to indicate that if the random successful or not base on the constraint declare in class
      //   $display("Randomization failed at %0t", $time);
      //   $finish();
      // end

      assert(g.randomize()) else begin
        $display("Randomization failed at %0t", $time);
        $finish();
      end
      $display("Value of a: %0d and b: %0d", g.a, g.b);
      #10;
    end
  end
endmodule