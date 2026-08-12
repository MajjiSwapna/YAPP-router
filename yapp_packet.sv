typedef enum bit {
  BAD_PARITY,
  GOOD_PARITY
} parity_t;

class yapp_packet extends uvm_sequence_item;

  rand bit [5:0] length;
  rand bit [1:0] address;
  rand bit [7:0] payload[];
  bit [7:0] parity;
  rand parity_t parity_type;
  rand bit [4:0] packet_delay;

  `uvm_object_utils_begin(yapp_packet)

    `uvm_field_int(length, UVM_DEFAULT)
    `uvm_field_int(address, UVM_DEFAULT)
    `uvm_field_array_int(payload, UVM_DEFAULT)
    `uvm_field_int(parity, UVM_DEFAULT)
    `uvm_field_int(packet_delay, UVM_DEFAULT)
    `uvm_field_enum(parity_t, parity_type, UVM_DEFAULT)

  `uvm_object_utils_end

  function new(input string inst = "yapp_packet");
    super.new(inst);
  endfunction

  constraint addr {address != 'b11;}

  constraint payload_size {payload.size() == length;}

  constraint par_type {
    parity_type dist {
      GOOD_PARITY := 5,
      BAD_PARITY  := 1
    };
  }

  constraint pack_delay {packet_delay < 21;}

  function bit [7:0] calc_parity();
    bit [7:0] parity_byte;
    parity_byte = {address, length};

    foreach (payload[i]) begin
      parity_byte ^= payload[i];
    end
    return parity_byte;
  endfunction

  function void post_randomize();
    if (parity_type == GOOD_PARITY) parity = calc_parity();
    else parity = ~calc_parity();
  endfunction

endclass





