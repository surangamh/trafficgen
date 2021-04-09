module trafficgen_tb();

parameter integer C_S00_AXI_DATA_WIDTH	= 32;
parameter integer C_S00_AXI_ADDR_WIDTH	= 4;

// Parameters of Axi Master Bus Interface M00_AXIS
parameter integer C_M00_AXIS_TDATA_WIDTH	= 32;
parameter integer C_M00_AXIS_START_COUNT	= 32;

reg s00_axi_aclk;	
reg  s00_axi_aresetn;
reg [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr;
reg [2 : 0] s00_axi_awprot;
reg  s00_axi_awvalid;
wire  s00_axi_awready;
reg [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata;
reg [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb;
reg  s00_axi_wvalid;
wire  s00_axi_wready;
wire [1 : 0] s00_axi_bresp;
wire  s00_axi_bvalid;
reg  s00_axi_bready;
reg[C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr;
reg [2 : 0] s00_axi_arprot;
reg  s00_axi_arvalid;
wire  s00_axi_arready;
wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata;
wire [1 : 0] s00_axi_rresp;
wire  s00_axi_rvalid;
reg  s00_axi_rready;

reg m00_axis_aclk;
reg m00_axis_aresetn;
wire  m00_axis_tvalid;
wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata;
wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb;
wire  m00_axis_tlast;
reg  m00_axis_tready;

trafficgen_v1_0 # (.C_S00_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH), 
.C_S00_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH), 
.C_M00_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
.C_M00_AXIS_START_COUNT(C_M00_AXIS_START_COUNT)
) dut(
    .s00_axi_aclk(s00_axi_aclk),
    .s00_axi_aresetn(s00_axi_aresetn),
    .s00_axi_awaddr(s00_axi_awaddr),
    .s00_axi_awprot(s00_axi_awprot),
    .s00_axi_awvalid(s00_axi_awvalid),
    .s00_axi_awready(s00_axi_awready),
    .s00_axi_wdata(s00_axi_wdata),
    .s00_axi_wstrb(s00_axi_wstrb),
    .s00_axi_wvalid(s00_axi_wvalid),
    .s00_axi_wready(s00_axi_wready),
    .s00_axi_bresp(s00_axi_bresp),
    .s00_axi_bvalid(s00_axi_bvalid),
    .s00_axi_bready(s00_axi_bready),
    .s00_axi_araddr(s00_axi_araddr),
    .s00_axi_arprot(s00_axi_arprot),
    .s00_axi_arvalid(s00_axi_arvalid),
    .s00_axi_arready(s00_axi_arready),
    .s00_axi_rdata(s00_axi_rdata),
    .s00_axi_rresp(s00_axi_rresp),
    .s00_axi_rvalid(s00_axi_rvalid),
    .s00_axi_rready(s00_axi_rready),
    
    .m00_axis_aclk(m00_axis_aclk),
    .m00_axis_aresetn(m00_axis_aresetn),
    .m00_axis_tvalid(m00_axis_tvalid),
    .m00_axis_tdata(m00_axis_tdata),
    .m00_axis_tstrb(m00_axis_tstrb),
    .m00_axis_tlast(m00_axis_tlast),
    .m00_axis_tready(m00_axis_tready)
    
);
initial begin
        s00_axi_aclk = 0;
        m00_axis_aclk = 0;
        forever begin
            #10 s00_axi_aclk = ~s00_axi_aclk;
            m00_axis_aclk = ~m00_axis_aclk;
        end
end
initial begin
        s00_axi_aresetn = 0;
        m00_axis_aresetn = 0;
        s00_axi_wstrb = 15;
        #25 s00_axi_aresetn = 1;
        m00_axis_aresetn = 1;
end
//Write channel setup
initial begin
        s00_axi_awvalid = 0;
        #60 s00_axi_awvalid = 1;
        s00_axi_wvalid = 1;
        s00_axi_bready = 1;
        s00_axi_wdata = 1;
        s00_axi_awaddr = 0;
        #40 s00_axi_awvalid = 0;
        s00_axi_wvalid = 0;
        #40 s00_axi_bready = 0;
        
        #60 s00_axi_awvalid = 1;
        s00_axi_wvalid = 1;
        s00_axi_bready = 1;
        s00_axi_wdata = 8;
        s00_axi_awaddr = 4;
        #40 s00_axi_awvalid = 0;
        s00_axi_wvalid = 0;
        #40 s00_axi_bready = 0;
end

//Read channel setup
initial begin
        s00_axi_arvalid = 0;
        s00_axi_araddr = 0;
        #60 s00_axi_rready = 1;
        #340 s00_axi_arvalid = 1;
        #40 s00_axi_arvalid = 0;
        #60 s00_axi_araddr = 4;
        s00_axi_arvalid = 1;
        #40 s00_axi_arvalid = 0;
        #60 s00_axi_araddr = 0;
        s00_axi_arvalid = 1;
        #40 s00_axi_arvalid = 0;
end

// Enable, disable and re-enable output stream using tready
initial begin
        m00_axis_tready = 0;
        #650 m00_axis_tready = 1;
        #550 m00_axis_tready = 0;
        #40 m00_axis_tready = 1;
end
// Disable and then enable the output stream by writing to the slave register
initial begin
        #1500 s00_axi_awvalid = 1;
        s00_axi_wvalid = 1;
        s00_axi_bready = 1;
        s00_axi_wdata = 0;
        s00_axi_awaddr = 0;
        #40 s00_axi_awvalid = 0;
        s00_axi_wvalid = 0;
        #40 s00_axi_bready = 0;
        
        #100 s00_axi_awvalid = 1;
        s00_axi_wvalid = 1;
        s00_axi_bready = 1;
        s00_axi_wdata = 1;
        s00_axi_awaddr = 0;
        #40 s00_axi_awvalid = 0;
        s00_axi_wvalid = 0;
        #40 s00_axi_bready = 0;
end
endmodule

