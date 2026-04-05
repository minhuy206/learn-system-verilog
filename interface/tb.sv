interface add_if;
  logic [3:0] a, b;
  logic [4:0] sum;
  logic clk;

  modport DRV (
  output a,b,
  input sum, clk
  ); // modport declared that the which signal is read-only, which can be written. Output mean that the signal can be written and input means that the signal is read-only
endinterface 

class transaction;
  randc bit [3:0] a, b;
  bit [4:0] sum;

  function void display();
    $display("a: %0d, b: %0d, sum: %0d", this.a, this.b, this.sum);
  endfunction

  virtual function transaction copy();
    copy = new();
    copy.a = this.a;
    copy.b = this.b;
    copy.sum = this.sum;
  endfunction
endclass

class error extends transaction;
  // constraint data_c { a == 0; b == 0;}
  virtual function transaction copy();
    copy = new();
    copy.a = 0;
    copy.b = 0;
    copy.sum = this.sum;
  endfunction
endclass

class generator;
  transaction trans;
  mailbox #(transaction) mbx;
  event done;
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    trans = new();
  endfunction

  task run();
    for (int i = 0; i < 10; i++) begin
      // trans = new(); // this way will create a new bucket for randc because of the new instance of transaction object. So we need to declare a reuse transaction object and use deep copy to avoiding creating new bucket for randc by using this line: mbx.put(trans.copy);
      assert(trans.randomize()) else $display("Randomize Failed");
      mbx.put(trans.copy);
      $display("[GEN]: DATA SENT TO DRIVER");
      trans.display();
      #20;
    end
    -> done;
  endtask 

endclass

class driver;
  virtual add_if.DRV aif;
  mailbox #(transaction) mbx;
  transaction data;
  event next;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();
    forever begin
      mbx.get(data);
      @(posedge aif.clk);
      aif.a <= data.a;
      aif.b <= data.b;
      $display("[DRV]: Interface trigger");
      data.display();
      ->next;
    end
  endtask

endclass

module tb;
  add_if aif();
  driver drv;
  generator gen;
  error err;
  event done;
  mailbox #(transaction) mbx;

  add dut (.b(aif.b), .a(aif.a), .sum(aif.sum), .clk(aif.clk)); // mapping by name

  initial begin
    aif.clk <= 0;
  end

  always #10 aif.clk <= ~aif.clk;
  
  initial begin
    mbx = new();
    err = new();
    drv = new(mbx);
    gen = new(mbx);
    gen.trans = err;
    drv.aif = aif;
    done = gen.done;
  end
  
  initial begin
    fork
      gen.run();
      drv.run();
    join_none
    wait(done.triggered);
    $finish();
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #100;
    $finish();
  end
endmodule
