module tb;

  int arr[10];
  int i = 0;

  initial begin
//     for (i = 0; i < 10; i++) begin
//       arr[i] = i;
//     end
//     $display("arr: %0p", arr);
  

    // foreach(arr[j]) begin
    //   arr[j] = j;
    //   $display("%0d", arr[j]);
    // end


    repeat($size(arr)) begin
      arr[i] = i;
      i++;
    end
    $display("arr: %0p", arr);
  
  end
endmodule

