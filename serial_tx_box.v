//--------------------------------------------------------------------------------------------------
// UART module
//--------------------------------------------------------------------------------------------------
module serial_tx_box 
(                             
input  wire	      	CLK,		
input  wire       	RST,		
                              
input  wire       	I_STB,       
input  wire [7:0] 	I_DATA,	
output wire       	I_ACK,

output wire       	O_TxD,		
                              
input  wire [15:0] 	CFG_CLK_DIV
);                            
//--------------------------------------------------------------------------------------------------
// Local variables
//--------------------------------------------------------------------------------------------------
wire       f0_stb;
wire       f0_ack;
reg  [7:0] f0_data [31:0];
reg  [5:0] f0_sel;
wire       f0_full;
wire       f0_rdy;
//--------------------------------------------------------------------------------------------------
wire       f1_stb;	
wire       f1_clr;	
reg  [7:0] f1_data;
reg        f1_rdy;
wire       f1_ack;
//--------------------------------------------------------------------------------------------------
reg  [15:0] sc_cntl;
reg  [2:0] sc_cnth;
wire       sc_tic;
wire       sc_lde;
//--------------------------------------------------------------------------------------------------
integer    tx_state;
reg        tx_bit;
wire       tx_ack;
reg  [8:0] tx_reg;
//--------------------------------------------------------------------------------------------------
// output fifo
//--------------------------------------------------------------------------------------------------
assign                             f0_stb = f0_ack; 
//--------------------------------------------------------------------------------------------------
always@(posedge CLK)
 if(f0_stb)
	begin
		f0_data[5'h00] <= I_DATA;
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
 if(RST)                         f0_sel       <=         - 1;
 else if(~f0_ack &&  f1_stb)     f0_sel       <=  f0_sel - 1;
 else if( f0_ack && ~f1_stb)     f0_sel       <=  f0_sel + 1;
//-------------------------------------------------------------------------------------------------
assign                           f0_rdy        = ~f0_sel[5];
assign                           f0_full       =  f0_sel==6'b0_11111;
//-------------------------------------------------------------------------------------------------
assign                           f0_ack        = ~f0_full && I_STB;
assign                           I_ACK         =  f0_ack;
//-------------------------------------------------------------------------------------------------
// registered output
//-------------------------------------------------------------------------------------------------
assign                           f1_stb        = (f1_ack || ~f1_rdy) && f0_rdy;
assign                           f1_clr        =  f1_ack;
//-------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)			   
 if(RST)                         f1_data      <= 0;
 else if(f1_stb)                 f1_data      <= f0_data[f0_sel[4:0]];
// else if(f1_clr)                f1_data      <= 0;
//-------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)			   
 if(RST)                         f1_rdy       <= 0;
 else if(f1_stb)                 f1_rdy       <= f0_rdy;
 else if(f1_clr)                 f1_rdy       <= 0;
//-------------------------------------------------------------------------------------------------
assign                           f1_ack        = tx_ack & f1_rdy;
//--------------------------------------------------------------------------------------------------
// scaler
//--------------------------------------------------------------------------------------------------
assign                           sc_tic   = (sc_cntl==CFG_CLK_DIV);
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
 if(RST)                         sc_cntl <= 1; 
 else if(tx_state==0)            sc_cntl <= 1;
 else if(tx_state==13)           sc_cntl <= 1;
 else                            sc_cntl <= (sc_tic) ? 1 : sc_cntl + 1;
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
 if(RST)                         sc_cnth <= 0; 
 else if(tx_state==0)            sc_cnth <= 0;
 else if(tx_state==13)           sc_cnth <= 0;
 else if(sc_tic)                 sc_cnth <= sc_cnth+1;
//--------------------------------------------------------------------------------------------------
assign                           sc_lde  = sc_tic && (sc_cnth==3'h0);
//--------------------------------------------------------------------------------------------------
// rx control
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
 if(RST)                         tx_state <= 0;
 else case(tx_state)
  0:   	 if( f1_rdy)            tx_state <= 1; 
  1:      if( sc_lde)            tx_state <= 2;  // start bit  
  2:      if( sc_lde)            tx_state <= 3;  // data  bit 0
  3:      if( sc_lde)            tx_state <= 4;  // data  bit 1
  4:      if( sc_lde)            tx_state <= 5;  // data  bit 2
  5:      if( sc_lde)            tx_state <= 6;  // data  bit 3
  6:      if( sc_lde)            tx_state <= 7;  // data  bit 4
  7:      if( sc_lde)            tx_state <= 8;  // data  bit 5
  8:      if( sc_lde)            tx_state <= 9;  // data  bit 6
  9:      if( sc_lde)            tx_state <= 10; // data  bit 7
 10:      if( sc_lde)            tx_state <= 11; // stop  bit 
 11:      if( sc_lde)            tx_state <= 12; // 
 12:      if( sc_lde)            tx_state <= 13; // compensation (1/8 of boud)
 13:      if( f1_rdy)            tx_state <= 1;
     else                        tx_state <= 0;
 endcase
//--------------------------------------------------------------------------------------------------
assign                           tx_ack    = (tx_state==1) && sc_lde && f1_rdy;
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
 if(RST)                         tx_reg   <= 9'h1FF;
 else if(tx_state==1  && sc_lde) tx_reg   <= {f1_data,1'b0};
 else if(tx_state==2  && sc_lde) tx_reg   <= {1'b1,tx_reg[8:1]};
 else if(tx_state==3  && sc_lde) tx_reg   <= {1'b1,tx_reg[8:1]};
 else if(tx_state==4  && sc_lde) tx_reg   <= {1'b1,tx_reg[8:1]};
 else if(tx_state==5  && sc_lde) tx_reg   <= {1'b1,tx_reg[8:1]};
 else if(tx_state==6  && sc_lde) tx_reg   <= {1'b1,tx_reg[8:1]};
 else if(tx_state==7  && sc_lde) tx_reg   <= {1'b1,tx_reg[8:1]};
 else if(tx_state==8  && sc_lde) tx_reg   <= {1'b1,tx_reg[8:1]};
 else if(tx_state==9  && sc_lde) tx_reg   <= {1'b1,tx_reg[8:1]};
 else if(tx_state==10 && sc_lde) tx_reg   <= 9'h1FF;
//--------------------------------------------------------------------------------------------------
// output
//--------------------------------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
 if(RST)                         tx_bit  <= 1'b1; 
 else                            tx_bit  <= tx_reg[0];
//--------------------------------------------------------------------------------------------------
assign                           O_TxD    = tx_bit;
//--------------------------------------------------------------------------------------------------
endmodule