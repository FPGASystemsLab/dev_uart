//--------------------------------------------------------------------------------------------------
// UART module
//--------------------------------------------------------------------------------------------------
module serial_rx_box 
(                             
input  wire	      	CLK,		
input  wire       	RST,		
                              
input  wire       	I_RxD,		
                              
output wire       	O_STB,       
output wire [7:0] 	O_DATA,	
input  wire       	O_ACK,

input  wire [15:0] CFG_CLK_DIV
);                            
//--------------------------------------------------------------------------------------------------
// Local variables
//--------------------------------------------------------------------------------------------------
reg  [15:0] sc_cntl;
reg  [2:0] sc_cnth;
wire       sc_tic;
wire       sc_lde;
//--------------------------------------------------------------------------------------------------
wire       f0_stb;
reg  [7:0] f0_data [31:0];
reg  [5:0] f0_sel;
wire       f0_rdy;
//--------------------------------------------------------------------------------------------------
wire       f1_stb;	
wire       f1_clr;	
reg  [7:0] f1_data;
reg        f1_rdy;
wire       f1_ack;
//--------------------------------------------------------------------------------------------------
integer    rx_state;
reg  [3:0] rx_filter;
wire       rx_bit;
reg  [7:0] rx_reg;
//--------------------------------------------------------------------------------------------------
// scaler
//--------------------------------------------------------------------------------------------------
assign                         sc_tic   = (sc_cntl==CFG_CLK_DIV);
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
 if(RST)                       sc_cntl <= 1; 
 else if(rx_state==0)          sc_cntl <= 1;
 else                          sc_cntl <= (sc_tic) ? 1 : sc_cntl + 1;
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
 if(RST)                       sc_cnth <= 0; 
 else if(rx_state==0)          sc_cnth <= 0;
 else if(sc_tic)               sc_cnth <= sc_cnth+1;
//--------------------------------------------------------------------------------------------------
assign                         sc_lde  = sc_tic && (sc_cnth==3'h4);
//--------------------------------------------------------------------------------------------------
// interdomain filter
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
 if(RST)                     rx_filter <= 4'hF;
 else                        rx_filter <= {rx_filter[2:0],I_RxD};
//--------------------------------------------------------------------------------------------------
assign                       rx_bit     = rx_filter[3];
//--------------------------------------------------------------------------------------------------
// rx control
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
 if(RST)                     rx_state <= 0;
 else case(rx_state)
  0:   	 if(!rx_bit)        rx_state <= 1; 
  1:      if( sc_lde)        rx_state <= 2;  // start bit  
  2:      if( sc_lde)        rx_state <= 3;  // data  bit 0
  3:      if( sc_lde)        rx_state <= 4;  // data  bit 1
  4:      if( sc_lde)        rx_state <= 5;  // data  bit 2
  5:      if( sc_lde)        rx_state <= 6;  // data  bit 3
  6:      if( sc_lde)        rx_state <= 7;  // data  bit 4
  7:      if( sc_lde)        rx_state <= 8;  // data  bit 5
  8:      if( sc_lde)        rx_state <= 9;  // data  bit 6
  9:      if( sc_lde)        rx_state <= 10; // data  bit 7
 10:      if( sc_lde)        rx_state <= 11; // stop  bit 
 11:                         rx_state <= 0;
 endcase
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
 if(RST)                        rx_reg   <= 0;
 else if(rx_state==2 && sc_lde) rx_reg   <= {rx_bit,rx_reg[7:1]};
 else if(rx_state==3 && sc_lde) rx_reg   <= {rx_bit,rx_reg[7:1]};
 else if(rx_state==4 && sc_lde) rx_reg   <= {rx_bit,rx_reg[7:1]};
 else if(rx_state==5 && sc_lde) rx_reg   <= {rx_bit,rx_reg[7:1]};
 else if(rx_state==6 && sc_lde) rx_reg   <= {rx_bit,rx_reg[7:1]};
 else if(rx_state==7 && sc_lde) rx_reg   <= {rx_bit,rx_reg[7:1]};
 else if(rx_state==8 && sc_lde) rx_reg   <= {rx_bit,rx_reg[7:1]};
 else if(rx_state==9 && sc_lde) rx_reg   <= {rx_bit,rx_reg[7:1]};
//--------------------------------------------------------------------------------------------------
assign                          f0_stb    = (rx_state==11);
//--------------------------------------------------------------------------------------------------
// output fifo
//--------------------------------------------------------------------------------------------------
always@(posedge CLK)
 if(f0_stb)
	begin
		f0_data[5'h00] <= rx_reg;
		f0_data[5'h01] <= f0_data[5'h00];
		f0_data[5'h02] <= f0_data[5'h01];
		f0_data[5'h03] <= f0_data[5'h02];
		f0_data[5'h04] <= f0_data[5'h03];
		f0_data[5'h05] <= f0_data[5'h04];
		f0_data[5'h06] <= f0_data[5'h05];
		f0_data[5'h07] <= f0_data[5'h06];

		f0_data[5'h08] <= f0_data[5'h07];
		f0_data[5'h09] <= f0_data[5'h08];
		f0_data[5'h0A] <= f0_data[5'h09];
		f0_data[5'h0B] <= f0_data[5'h0A];
		f0_data[5'h0C] <= f0_data[5'h0B];
		f0_data[5'h0D] <= f0_data[5'h0C];
		f0_data[5'h0E] <= f0_data[5'h0D];
		f0_data[5'h0F] <= f0_data[5'h0E];

		f0_data[5'h10] <= f0_data[5'h0F];
		f0_data[5'h11] <= f0_data[5'h10];
		f0_data[5'h12] <= f0_data[5'h11];
		f0_data[5'h13] <= f0_data[5'h12];
		f0_data[5'h14] <= f0_data[5'h13];
		f0_data[5'h15] <= f0_data[5'h14];
		f0_data[5'h16] <= f0_data[5'h15];
		f0_data[5'h17] <= f0_data[5'h16];

		f0_data[5'h18] <= f0_data[5'h17];
		f0_data[5'h19] <= f0_data[5'h18];
		f0_data[5'h1A] <= f0_data[5'h19];
		f0_data[5'h1B] <= f0_data[5'h1A];
		f0_data[5'h1C] <= f0_data[5'h1B];
		f0_data[5'h1D] <= f0_data[5'h1C];
		f0_data[5'h1E] <= f0_data[5'h1D];
		f0_data[5'h1F] <= f0_data[5'h1E];
	end
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST) 
 if(RST)                            f0_sel       <=         - 1;
 else if(~f0_stb &&  f1_stb)        f0_sel       <=  f0_sel - 1;
 else if( f0_stb && ~f1_stb)        f0_sel       <=  f0_sel + 1;
//-------------------------------------------------------------------------------------------------
assign                              f0_rdy        = ~f0_sel[5];
//-------------------------------------------------------------------------------------------------
// registered output
//-------------------------------------------------------------------------------------------------
assign                              f1_stb        = (f1_ack || ~f1_rdy) && f0_rdy;
assign                              f1_clr        =  f1_ack;
//-------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)			   
 if(RST)                            f1_data      <= 0;
 else if(f1_stb)                    f1_data      <= f0_data[f0_sel[4:0]];
 else if(f1_clr)                    f1_data      <= 0;
//-------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)			   
 if(RST)                            f1_rdy       <= 0;
 else if(f1_stb)                    f1_rdy       <= f0_rdy;
 else if(f1_clr)                    f1_rdy       <= 0;
//-------------------------------------------------------------------------------------------------
assign                              O_DATA        = f1_data;
assign                              O_STB         = f1_rdy;
//-------------------------------------------------------------------------------
assign                              f1_ack        = O_ACK & f1_rdy;
//--------------------------------------------------------------------------------------------------
endmodule