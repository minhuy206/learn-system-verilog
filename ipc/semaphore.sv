class first;

  rand int data;
  
  constraint data_c { data < 10; data > 0; }

endclass

class second;
  rand int data;

  constraint data_c { data > 10; data < 20; }

endclass

class main;

  semaphore sem;

  first f;
  second s;

  int data;
  int i = 0;

  task send_first();
    sem.get(1);
    for (i = 0; i < 10; i++) begin
      f.randomize();
      data = f.data;
      $display("First access semaphore and data sent: %0d", f.data);
      #10;
    end
    sem.put(1);
  endtask

  task send_second();
    sem.get(1);
    for (i = 0; i < 10; i++) begin
      s.randomize();
      data = s.data;
      $display("Second access semaphore and data sent: %0d", s.data);
      #10;
    end
    sem.put(1);
  endtask

  task run();
    sem = new(1); // create 1 ticket that allow only one thread run in parallel, if 2 the number of threads will be 2 threads. Like sell ticket for the threads buy. First come first serve. Who take first will can join, if run out of ticket, others thread must waiting for the running thread complete and return the ticket by sem.put()
    f = new();
    s = new();

    fork
      send_first();
      send_second();
    join
  endtask

endclass

module tb;
  
  main m;
  
  initial begin
    m = new();
    m.run(); 
  end
  
  initial begin
    #250;
    $finish();
  end
  
endmodule