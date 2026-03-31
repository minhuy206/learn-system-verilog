module ha(
  input a, b, 
  output s, cout
);
  assign s = a ^ b;
  assign cout = a & b;
endmodule

module fa(
  input a, b, cin,
  output s, c
);
// wire t1, t2, t3;
logic t1, t2, t3; // logic type do not allow multiple drivers. Example: a = b then assign a = c

ha ha1(a, b, t1, t2);
ha ha2(cin, t1, s, t3);

assign c = t2 | t3;

endmodule