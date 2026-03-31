module tb;

  bit arr1[8];
  bit arr2[] = {1, 0, 1, 1};
  bit arr3[]; // this will initial an array with size = 0
  bit arr4[] = '{default: 2};
  bit arr5[] = '{6{1}};
  bit arr6[] = '{1, 0, 1, 1};
  initial begin

    $display("Size of arr1:  %0d", $size(arr1)); // 8
    $display("Size of arr2:  %0d", $size(arr2)); // 4

    $display("Value of first ele: %0d", arr1[0]);  // 0
    arr1[1] = 1; 
    $display("Value of first ele: %0d", arr1[1]);  // 1

    $display("Value of all element of arr2:%0p", arr2);  // 1 0 1 1 
  
  end
endmodule