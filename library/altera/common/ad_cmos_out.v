// ***************************************************************************
// ***************************************************************************
// Copyright 2014(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_cmos_out (

  // data interface

  tx_clk,
  tx_data_p,
  tx_data_n,
  tx_data_out,

  // delay-data interface

  up_clk,
  up_dld,
  up_dwdata,
  up_drdata,

  // delay-cntrl interface

  delay_clk,
  delay_rst,
  delay_locked);

  // parameters

  parameter   DEVICE_TYPE = 0;
  parameter   SINGLE_ENDED = 0;
  parameter   IODELAY_ENABLE = 0;
  parameter   IODELAY_CTRL = 0;
  parameter   IODELAY_GROUP = "dev_if_delay_group";

  // data interface

  input               tx_clk;
  input               tx_data_p;
  input               tx_data_n;
  output              tx_data_out;

  // delay-data interface

  input               up_clk;
  input               up_dld;
  input       [ 4:0]  up_dwdata;
  output      [ 4:0]  up_drdata;

  // delay-cntrl interface

  input               delay_clk;
  input               delay_rst;
  output              delay_locked;

  // defaults

  assign up_drdata = 5'd0;
  assign delay_locked = 1'b1;

  // instantiations

  generate
  if (DEVICE_TYPE == 0) begin
  alt_ddio_out i_tx_data_oddr (
    .ck (tx_clk),
    .din ({tx_data_p, tx_data_n}),
    .pad_out (tx_data_out));
  end
  endgenerate

  generate
  if (DEVICE_TYPE == 1) begin
  altddio_out #(.width (1), .lpm_hint ("UNUSED")) i_tx_data_oddr (
    .outclock (tx_clk),
    .datain_h (tx_data_p),
    .datain_l (tx_data_n),
    .dataout (tx_data_out),
    .outclocken (1'b1),
    .oe_out (),
    .oe (1'b1),
    .aclr (1'b0),
    .aset (1'b0),
    .sclr (1'b0),
    .sset (1'b0));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************