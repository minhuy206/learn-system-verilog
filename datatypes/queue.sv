module tb;

  int arr[$];
  int arr1[$:7];   // max 8 elements
  int j;
  int k;
 
  initial begin
    arr = {1,2,3};
    $display("arr: %0p", arr);

    arr.push_front(0);
    $display("arr: %0p", arr);

    arr.push_back(4);
    $display("arr: %0p", arr);

    arr.insert(2,10);
    $display("arr: %0p", arr);

    j = arr.pop_front();
    $display("arr: %0p", arr);
    $display("Value of j: %0d", j);

    k = arr.pop_back();
    $display("arr: %0p", arr);
    $display("Value of k: %0d", k);

    arr.delete(1);
    $display("arr: %0p", arr);

    arr = {arr, 5};     // like push_back
    arr = {3, arr};     // like push_front
  end

endmodule