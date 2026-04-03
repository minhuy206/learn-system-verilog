# Pass by Value and Pass by Reference in SystemVerilog

## 1. Pass by Value (Default)

By default, arguments are passed **by value** — a copy is made. Changes inside the task/function do **not** affect the caller.

### input (default direction)

```systemverilog
task automatic print_val(input int x);
  $display("x = %0d", x);
  x = 999; // does NOT affect the caller
endtask

module top;
  initial begin
    int a = 10;
    print_val(a);
    $display("a after call = %0d", a); // a is still 10
  end
endmodule
```

### output

A copy is written back to the caller **when the task/function returns**.

```systemverilog
task automatic compute(input int a, input int b, output int sum);
  sum = a + b;
endtask

module top;
  initial begin
    int result;
    compute(3, 4, result);
    $display("result = %0d", result); // 7
  end
endmodule
```

### inout

The value is copied **in** at the start and copied **out** on return.

```systemverilog
task automatic double_it(inout int val);
  val = val * 2;
endtask

module top;
  initial begin
    int x = 5;
    double_it(x);
    $display("x = %0d", x); // 10
  end
endmodule
```

### Key behavior: output/inout copy-out happens at return

If a task is killed or disabled before it returns, the caller variable is **never updated**.

```systemverilog
task automatic slow_compute(output int result);
  #100;
  result = 42;
endtask

module top;
  initial begin
    int r = 0;
    fork
      slow_compute(r);
    join_none

    #10 disable fork; // task killed before return
    $display("r = %0d", r); // r is still 0
  end
endmodule
```

---

## 2. Pass by Reference (`ref`)

With `ref`, the task/function operates **directly on the caller's variable** — no copy is made. Changes are visible **immediately**.

### Basic ref example

```systemverilog
task automatic increment(ref int val);
  val = val + 1;
  $display("inside: val = %0d", val);
endtask

module top;
  initial begin
    int x = 10;
    increment(x);
    $display("outside: x = %0d", x); // 11
  end
endmodule
```

### ref sees changes in real time

This is the critical difference from `inout`. With `ref`, both sides see updates immediately.

```systemverilog
task automatic monitor_flag(ref bit flag);
  wait (flag == 1);
  $display("Flag was set at time %0t", $time);
endtask

module top;
  bit done;

  initial begin
    fork
      monitor_flag(done);  // watching the actual variable
      begin
        #50 done = 1;      // this change is seen immediately by the task
      end
    join
  end
endmodule
```

With `input`, the task would get a **copy** of `done` (which is 0) and `wait(flag == 1)` would block forever.

### const ref

Use `const ref` to pass by reference **without allowing modification** — useful for large data structures where you want efficiency but no side effects.

```systemverilog
function automatic int sum_array(const ref int arr[100]);
  int total = 0;
  foreach (arr[i])
    total += arr[i];
  // arr[0] = 999; // ERROR: cannot modify const ref
  return total;
endfunction

module top;
  initial begin
    int data[100];
    foreach (data[i]) data[i] = i;
    $display("sum = %0d", sum_array(data)); // 4950
  end
endmodule
```

### Passing arrays by ref vs by value

```systemverilog
// By value: entire array is copied (expensive for large arrays)
task automatic clear_copy(int arr[1000]);
  foreach (arr[i]) arr[i] = 0;
  // caller's array is UNCHANGED
endtask

// By ref: no copy, modifies caller's array directly
task automatic clear_ref(ref int arr[1000]);
  foreach (arr[i]) arr[i] = 0;
  // caller's array IS modified
endtask
```

### Passing objects (class handles)

Class handles are **always passed by value**, but the handle is a pointer — so the object's contents can still be modified.

```systemverilog
class Packet;
  int id;

  function new(int id);
    this.id = id;
  endfunction
endclass

// The handle is copied, but both point to the same object
task automatic modify_packet(Packet p);
  p.id = 99;       // modifies the SAME object
  p = new(0);       // reassigns local copy only — caller's handle unchanged
endtask

// With ref, even the handle itself can be reassigned
task automatic replace_packet(ref Packet p);
  p = new(55);      // caller's handle NOW points to the new object
endtask

module top;
  initial begin
    Packet pkt = new(1);

    modify_packet(pkt);
    $display("after modify: id = %0d", pkt.id);   // 99 (object modified)

    replace_packet(pkt);
    $display("after replace: id = %0d", pkt.id);  // 55 (handle replaced)
  end
endmodule
```

---

## 3. Summary Table

| Direction   | Copy-in | Copy-out | Immediate visibility | Can modify caller |
|-------------|---------|----------|----------------------|-------------------|
| `input`     | Yes     | No       | No                   | No                |
| `output`    | No      | Yes (at return) | No            | Yes (at return)   |
| `inout`     | Yes     | Yes (at return) | No            | Yes (at return)   |
| `ref`       | No      | N/A      | Yes                  | Yes (immediately) |
| `const ref` | No      | N/A      | Yes                  | No                |

---

## 4. Rules and Restrictions

- `ref` arguments require the task/function to be declared `automatic`.
- `ref` arguments must be passed a **variable**, not an expression or literal.
- `ref` cannot be used in modules with `static` lifetime (default for modules).

```systemverilog
// ILLEGAL: ref with static lifetime
task static bad_task(ref int x); // compile error
endtask

// LEGAL: ref with automatic lifetime
task automatic good_task(ref int x);
endtask
```

---

## 5. When to Use What

| Scenario | Use |
|----------|-----|
| Read-only small argument | `input` (default) |
| Return a result | `output` or function return |
| Modify a variable and read its initial value | `inout` |
| Need immediate visibility (e.g., shared flags between threads) | `ref` |
| Large array/struct, read-only | `const ref` |
| Large array/struct, need to modify | `ref` |
| Class object, modify contents | `input` (handle is enough) |
| Class object, replace the handle itself | `ref` |
