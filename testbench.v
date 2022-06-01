// Adithyadev Mattada
//----FIFO Module----
//----Testbench:-----

module sf_tb;
  
  reg clk, rst, wr_en, rd_en;
  reg[7:0] din;
  reg[7:0] temp;
  
  wire [7:0]dout;
  wire [7:0]counter;
  wire full;
  wire empty;
  
  fifo dut( .clk(clk), .rst(rst), .din(din), .dout(dout), .wr_en(wr_en), .rd_en(rd_en), .empty(empty), .full(full), .counter(counter) );
  
  //push task.
  task push (input [7:0]data);
    if (full)
      $display("buffer full - cannot push.");
    else
        begin
          $display("pushed ", data );
          din = data;
          wr_en = 1;
          @(posedge clk);
          #1 wr_en = 0;
        end
  endtask
  
  //pop task
  task pop (output [7:0]data);
    if (empty)
      $display("buffer empty - cannot pop.");
    else
      begin
        rd_en = 1;
        @(posedge clk);
        #1 rd_en = 0;
        data = dout;
        $display("popped ", data);
      end
  endtask
  
 //stimuli 
 initial
   begin
    $dumpvars;
	$dumpfile("dump.vcd");
     
     clk = 0;
     rst = 1;
     
     rd_en = 0;
     wr_en = 0;
     temp = 0;
     din = 0;
     
     #15 rst = 0;
     
     push(1);
     fork            //simultaneous push and pop
       push(2);
       pop(temp);
     join
     push(5);
     push(6);
     push(7);
     push(8);
     push(9);
     push(10);
     pop(temp);
     pop(temp);
     pop(temp);
     push(15);
     pop(temp);
     pop(temp);
     pop(temp);
     push(20);
     pop(temp);
     pop(temp);
     pop(temp);
     pop(temp);
   end
  
  always
    #5 clk = ~clk;
  
     
endmodule
