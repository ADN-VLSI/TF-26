class id_card;

  string   name;
  rand int age;

  local rand int name_length;

  constraint name_length_c {
    name_length >= 5;
    name_length <= 10;
  }

  function void post_randomize();
    for (int i = 0; i < name_length; i++) begin
      name = {name, $urandom_range(65, 90)};
    end
  endfunction

endclass



module class_test;

  initial $display("\033[7;38m TEST STARTED \033[0m");
  final $display("\033[7;38m  TEST ENDED  \033[0m");

  id_card card;

  initial begin
    card = new();
    void'(card.randomize());
    $display("NAME: %s", card.name);
    $display("AGE : %0d", card.age);
    $finish;
  end

endmodule
