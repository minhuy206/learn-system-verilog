module tb;
  int arr1[5] = '{1, 2 ,3, 4, 5};
  int arr2[5] = '{1, 2, 3, 4, 5};

  int status;

  initial begin
    status = (arr1 == arr2); // status will be 1 if arr1 equal to arr2 and vice versa
    $display("Status: %0d", status);
  end
endmodule