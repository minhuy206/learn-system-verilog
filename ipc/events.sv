// Trigger: ->
// Edge sensitive_blocking @(), level_sensitive_non-blocking wait()

module tb;
  event a;

  initial begin
    #10;
    -> a;
  end

  initial begin
    // @(a); // is wait for event, can be missed if the event have trigger before the @() block is declared
    wait(a.triggered); // like logic compare, if the logic is satisfied (== true) it will run, cannot be missed
    $display("Received event at %0t", $time);
  end
endmodule