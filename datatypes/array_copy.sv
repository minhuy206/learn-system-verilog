module tb;
  int arr1[5];
  int arr2[5];

  initial begin
    for(int i = 0; i < 5; i++) begin
      arr1[i] = 5 * i;
    end

    arr2 = arr1; // copy
    $display("arr2: %0p", arr2);
  end
endmodule