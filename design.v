// Adithyadev Mattada
//----FIFO Module----
//----Design:--------

module fifo( clk, rst, din, dout, wr_en, rd_en, empty, full, counter );
  
  input clk, rst;
  input wr_en, rd_en; //enable.
  input [7:0] din;
  
  output [7:0]dout;
  output [7:0]counter;
  output empty, full; //flags.
  
  reg [7:0] dout;
  reg empty, full;
  reg [7:0] counter;
  reg [3:0] rd_ptr, wr_ptr; //read and write pointers.
  
  reg [7:0] mem[63:0];//64 array of 8-bit memory.
 
  
  always @(counter) begin
    empty = ( counter == 0 );
    full = ( counter == 63 );
  end
  
  
  always @( posedge clk or posedge rst ) begin
    if(rst) //reset is asynchronous.
      counter <= 0;
    else if (( (!full) && wr_en) && ( (!empty) && rd_en ))
      //if trying to read and write at same time.
      counter <= counter;
    else if ( (!full) && wr_en )
      //if write while not full.
      counter <= counter + 1;
    else if ( (!empty) && rd_en )
      //if read while not empty.
      counter <= counter - 1;
  end
  
  always @( posedge clk or posedge rst ) begin //reader
    if(rst)
      dout <= 0;
    else if ( !empty && rd_en )
      dout <= mem[rd_ptr];
    else
      dout <= dout;
  end
  
  always @( posedge clk )begin //writer
    if (!full && wr_en)
      mem[wr_ptr] <= din;
    else
      mem[wr_ptr] <= mem[wr_ptr];
  end
  
   //increment read and write pointers everytime its enabled
  always @( posedge clk or posedge rst ) begin
    if(rst) begin
      rd_ptr <= 0;
      wr_ptr <= 0;
    end
    else begin
    if (!full && wr_en)
      wr_ptr <= wr_ptr + 1;
    else
      wr_ptr <= wr_ptr;
    if ( !empty && rd_en )
      rd_ptr <= rd_ptr + 1;
    else
      rd_ptr <= rd_ptr;
    end
  end
  
  
endmodule
