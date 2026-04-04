class generator;
  
  rand bit [3:0] a, b; // rand or randc. randc means random cyclic
  bit [3:0] y;

  extern constraint data;
  extern function void display();
endclass 

constraint generator::data {
  a inside {[0:3]};
  b inside {[12:15]};
}

function void generator::display();
  $display("Valuue of a: %0d and b: %0d", a,b);
endfunction

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

      assert(g.randomize()) else $display("Randomization failed at %0t", $time);
        g.display();
        #10;
    end
  end
endmodule