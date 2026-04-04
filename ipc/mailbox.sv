class generator;
  int data = 12;
  mailbox mbx; // a FIFO queue, who come first take first

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction

  task run();
    mbx.put(data); // put data into mailbox. This method is blocking, can use try_put() is non-blocking method, just return success or fail. If the mailbox is full, the thread is blocked at this line and wait until mail box have an empty slot then put and continue
    $display("[GEN]: SENT DATA: %0d", data);
  endtask

endclass

class driver;
  int datac = 0;
  mailbox mbx;

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    mbx.get(datac); // get data from mailbox. This method is blocking, can use try_get() is non-blocking method, just return success or fail. If the mail box is empty, the thread is blocked at this line and wait until mailbox have data then get and continue
    $display("[DRV]: RCVD Data: %0d", datac);
  endtask

endclass

module tb;
  generator gen;
  driver drv;
  mailbox mbx;

  initial begin
    mbx = new(); // can pass parameter indicate the number of data could be sent among threads max is 5.
    gen = new(mbx);
    drv = new(mbx);

    gen.mbx= mbx;
    drv.mbx = mbx;

    gen.run();
    drv.run();
  end
endmodule