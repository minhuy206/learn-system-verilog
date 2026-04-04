# Deep Copy and Shallow Copy in SystemVerilog

## 1. Shallow Copy (`new` with source object)

A shallow copy duplicates the **handle values** of all fields — primitive fields are copied by value, but nested object handles point to the **same underlying objects**.

### Syntax

```systemverilog
f2 = new f1; // f2 is a shallow copy of f1
```

### Example: flat class (no nested objects)

```systemverilog
class Packet;
  int id;
  bit[7:0] data;
endclass

module tb;
  Packet p1, p2;

  initial begin
    p1 = new();
    p1.id   = 10;
    p1.data = 8'hAB;

    p2 = new p1; // shallow copy

    p2.id = 99;
    $display("p1.id = %0d", p1.id); // 10  — unaffected
    $display("p2.id = %0d", p2.id); // 99
  end
endmodule
```

When the class only contains **primitive fields** (`int`, `bit`, `logic`, etc.), a shallow copy behaves exactly like a deep copy — each object owns its own data.

### Problem: nested objects share the same reference

```systemverilog
class Inner;
  int val;
endclass

class Outer;
  Inner inner_obj;
  int   id;
endclass

module tb;
  Outer o1, o2;

  initial begin
    o1            = new();
    o1.inner_obj  = new();
    o1.inner_obj.val = 5;
    o1.id         = 1;

    o2 = new o1; // shallow copy — o2.inner_obj points to the SAME Inner object

    o2.id = 2;                  // OK: primitive, independent copy
    o2.inner_obj.val = 99;      // modifies the shared object!

    $display("o1.inner_obj.val = %0d", o1.inner_obj.val); // 99 — affected!
    $display("o2.inner_obj.val = %0d", o2.inner_obj.val); // 99
  end
endmodule
```

---

## 2. Deep Copy (custom copy method)

A deep copy creates **new instances for every nested object**, so the original and the copy are fully independent.

### Pattern: implement a `copy()` function in the class

```systemverilog
class Inner;
  int val;

  function Inner copy();
    copy     = new();
    copy.val = this.val;
  endfunction
endclass

class Outer;
  Inner inner_obj;
  int   id;

  function Outer copy();
    copy            = new();
    copy.id         = this.id;
    copy.inner_obj  = this.inner_obj.copy(); // deep copy nested object
  endfunction
endclass

module tb;
  Outer o1, o2;

  initial begin
    o1               = new();
    o1.inner_obj     = new();
    o1.inner_obj.val = 5;
    o1.id            = 1;

    o2 = o1.copy(); // deep copy

    o2.id = 2;
    o2.inner_obj.val = 99;

    $display("o1.inner_obj.val = %0d", o1.inner_obj.val); // 5  — unaffected
    $display("o2.inner_obj.val = %0d", o2.inner_obj.val); // 99
  end
endmodule
```

### Flat class deep copy (from `custom_copy_method.sv`)

For a class with only primitive fields, a custom copy function is straightforward:

```systemverilog
class first;
  int      data = 34;
  bit[7:0] temp = 8'h11;

  function first copy();
    copy      = new();
    copy.data = this.data;
    copy.temp = this.temp;
  endfunction
endclass

module tb;
  first f1, f2;

  initial begin
    f1 = new();
    f2 = f1.copy();
    $display("data: %0d  temp: %0x", f2.data, f2.temp); // 34  11
  end
endmodule
```

---

## 3. Shallow Copy vs Deep Copy — Side-by-Side

```systemverilog
class Node;
  int val;
endclass

class Container;
  Node  node;
  int   id;

  function Container shallow();
    shallow = new this; // built-in shallow copy
  endfunction

  function Container deep();
    deep      = new();
    deep.id   = this.id;
    deep.node = new();        // new instance
    deep.node.val = this.node.val;
  endfunction
endclass

module tb;
  Container c1, c2_shallow, c2_deep;

  initial begin
    c1          = new();
    c1.node     = new();
    c1.node.val = 7;
    c1.id       = 1;

    c2_shallow = c1.shallow();
    c2_deep    = c1.deep();

    // Modify nested object
    c2_shallow.node.val = 100;
    c2_deep.node.val    = 200;

    $display("c1 node val after shallow modify: %0d", c1.node.val); // 100 — shared!
    $display("c1 node val after deep modify:    %0d", c1.node.val); // 100 — still shared with shallow
    // (deep modify does NOT affect c1 because c2_deep has its own node)
  end
endmodule
```

---

## 4. Summary Table

| Feature | Shallow Copy (`new obj`) | Deep Copy (custom method) |
|---|---|---|
| Syntax | `dst = new src;` | `dst = src.copy();` |
| Primitive fields | Independent copy | Independent copy |
| Nested object handles | **Shared** (same object) | **Independent** (new objects) |
| Dynamic arrays / queues | Handle copied, **not contents** | Must copy element by element |
| Effort | None (built-in) | Manual — must implement `copy()` |
| Risk | Unintended aliasing | None if implemented correctly |

---

## 5. When to Use What

| Scenario | Use |
|----------|-----|
| Class has only primitive fields | Shallow copy (`new obj`) is sufficient |
| Class has nested class objects | Deep copy with custom `copy()` method |
| Read-only snapshot (no modification expected) | Shallow copy is safe |
| Independent clone that will be modified | Deep copy |
| Large hierarchy of objects | Deep copy, propagate `copy()` down each level |
