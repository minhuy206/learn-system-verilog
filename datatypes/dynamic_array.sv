module tb;

  int arr[];
  int fixed_arr[30];

  initial begin
    arr = new[5]; // initialize a new arr with 5 ele default value

    for(int i = 0; i < 5; i++) begin
      arr[i] = 5 * i;
    end

    $display("arr: %0p", arr);

    arr = new[30](arr); // redefine a size of array and copy the old arr to new arr

    $display("arr: %0p", arr);

    fixed_arr = arr; // assign dynamic arr for fixed arr but some simulators do not support

    $display("fixed_arr: %0p", fixed_arr);
    
    
    // arr.delete();

    // for(int i = 0; i < 5; i++) begin
    //   arr[i] = 10 * i;
    // end
  end


endmodule