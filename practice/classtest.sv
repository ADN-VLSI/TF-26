class my_class;

  string name;
  rand int a;
  rand int b;
  int c;

  virtual function automatic void print();
    $display("\nClass Name: %s", name);
    $display("a = %0d", a);
    $display("b = %0d", b);
    $display("c = %0d", c);
  endfunction

endclass

class my_class_2 extends my_class;

  rand int d;

  constraint bgkfbokgfrokj {
    a < 20;
    a > 10;
  }

  constraint trhythrhr {b == 2 * a;}

  function automatic void print();
    super.print();
    $display("d = %0d", d);
  endfunction

endclass


module classtest;

  my_class   obj_p;
  my_class_2 obj_c;

  initial begin
    obj_p = new();
    obj_c = new();

    obj_p.name = "Parent Class";
    obj_c.name = "Child Class";

    obj_p.randomize();
    obj_c.randomize();

    obj_p.print();
    obj_c.print();

    obj_p.randomize();
    obj_c.randomize();

    obj_p.print();
    obj_c.print();

    obj_p.randomize();
    obj_c.randomize();

    obj_p.print();
    obj_c.print();

    $finish;
  end

endmodule
