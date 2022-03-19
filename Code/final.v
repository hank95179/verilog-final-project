module final(start,reset,score_ssd0,score_ssd1,score_ssd2,countdown_ssd0,countdown_ssd1,dot_col,dot_row,kill_row,kill_col,clk,level1, level2, level3,,led);
	input start,reset,clk,level1, level2, level3;
	input [3:0] kill_col;
	output reg[3:0] kill_row;
	output reg[6:0]score_ssd0;
	output reg[6:0]score_ssd1;
	output reg[6:0]score_ssd2;
	output reg[6:0]countdown_ssd0;
	output reg[6:0]countdown_ssd1;
	output reg[15:0] dot_col;
	output reg[7:0] dot_row;
	output reg[9:0]led;
	reg [10:0] SCORE;
	reg [6:0] COUNTDOWN;
	reg ifstart;
	reg [31:0]cnt_div,cnt_dot,cnt_but, cnt_sec;
	reg clk_div,clk_dot, clk_sec;
	reg [15:0]map[7:0];
	reg [2:0]row_count;
	reg [1:0]new;
	reg down1, down2, down3;
	reg [4:0]Z[4:0];
	reg [4:0]O[4:0];
	reg [4:0]M[4:0];
	reg [4:0]B[4:0];
	reg [4:0]I[4:0];
	reg [4:0]E[4:0];
	reg [4:0]G[4:0];
	reg [63:0]ZOMBIE_GO[7:0];
	reg [6:0]COUNT_POW_MA_DAN;
	integer i;
				
	
always@(posedge clk)
    begin
			if(~reset)
			begin
            cnt_div <= 32'b0;
            cnt_dot <= 32'b0;
            //clk_div <= 1'b0;//1hz
            clk_dot <= 1'b0;//5000hz
				SCORE <= 11'd0;
				COUNTDOWN <= 7'd30;
				ifstart<=0;
				dot_row <= 8'd0;
            dot_col <= 16'd0;
            row_count <= 3'd0;
				kill_row <= 3'b0111;
				down1 = 0;
				down2 = 0;
				down3 = 0;
				Z[0] = 5'b11111;
				Z[1] = 5'b00010;
				Z[2] = 5'b00100;
				Z[3] = 5'b01000;
				Z[4] = 5'b11111;
				O[0] = 5'b01110;
				O[1] = 5'b10001;
				O[2] = 5'b10001;
				O[3] = 5'b10001;
				O[4] = 5'b01110;
				M[0] = 5'b10001;
				M[1] = 5'b11011;
				M[2] = 5'b10101;
				M[3] = 5'b10101;
				M[4] = 5'b10101;
				B[0] = 5'b11110;
				B[1] = 5'b10001;						
				B[2] = 5'b11110;
				B[3] = 5'b10001;
				B[4] = 5'b11110;
				I[0] = 5'b11111;
				I[1] = 5'b00100;
				I[2] = 5'b00100;
				I[3] = 5'b00100;
				I[4] = 5'b11111;
				E[0] = 5'b11111;
				E[1] = 5'b10000;
				E[2] = 5'b11111;
				E[3] = 5'b10000;
				E[4] = 5'b11111;
				G[0] = 5'b01110;
				G[1] = 5'b10000;
				G[2] = 5'b10111;
				G[3] = 5'b10001;
				G[4] = 5'b01110;
				ZOMBIE_GO[0] = 64'd0;
				ZOMBIE_GO[1] = 64'd0;
				ZOMBIE_GO[2] = {3'b000,Z[0][4:0],2'b00,O[0][4:0],2'b00,M[0][4:0],2'b00,B[0][4:0],2'b00,I[0][4:0],2'b00,E[0][4:0],7'b0000000,G[0][4:0],2'b00,O[0][4:0],2'b00};
				ZOMBIE_GO[3] = {3'b000,Z[1][4:0],2'b00,O[1][4:0],2'b00,M[1][4:0],2'b00,B[1][4:0],2'b00,I[1][4:0],2'b00,E[1][4:0],7'b0000000,G[1][4:0],2'b00,O[1][4:0],2'b00};
				ZOMBIE_GO[4] = {3'b000,Z[2][4:0],2'b00,O[2][4:0],2'b00,M[2][4:0],2'b00,B[2][4:0],2'b00,I[2][4:0],2'b00,E[2][4:0],7'b0000000,G[2][4:0],2'b00,O[2][4:0],2'b00};
				ZOMBIE_GO[5] = {3'b000,Z[3][4:0],2'b00,O[3][4:0],2'b00,M[3][4:0],2'b00,B[3][4:0],2'b00,I[3][4:0],2'b00,E[3][4:0],7'b0000000,G[3][4:0],2'b00,O[3][4:0],2'b00};
				ZOMBIE_GO[6] = {3'b000,Z[4][4:0],2'b00,O[4][4:0],2'b00,M[4][4:0],2'b00,B[4][4:0],2'b00,I[4][4:0],2'b00,E[4][4:0],7'b0000000,G[4][4:0],2'b00,O[4][4:0],2'b00};	
				ZOMBIE_GO[7] = 64'd0;
			end
			else
			begin
				if(ifstart)
				begin
					if(cnt_div == 49999819) 
					begin
						cnt_div <= 32'b0;
						//clk_div <= ~clk_div;
						COUNTDOWN <= COUNTDOWN - 1;
						if(COUNTDOWN == 0)
						begin
							ifstart <= 0;
							COUNTDOWN <= 7'd30;
						end
					end
					else
					begin
						cnt_div<=cnt_div+32'b1;	
					end
				end
				else
				begin
					if(cnt_sec== 15000000)
					begin
						cnt_sec= 32'b0;
						// controll col to display
						ZOMBIE_GO[2] = {ZOMBIE_GO[2][62:0], ZOMBIE_GO[2][63]};
						ZOMBIE_GO[3] = {ZOMBIE_GO[3][62:0], ZOMBIE_GO[3][63]};
						ZOMBIE_GO[4] = {ZOMBIE_GO[4][62:0], ZOMBIE_GO[4][63]};
						ZOMBIE_GO[5] = {ZOMBIE_GO[5][62:0], ZOMBIE_GO[5][63]};
						ZOMBIE_GO[6] = {ZOMBIE_GO[6][62:0], ZOMBIE_GO[6][63]};
						map[0] = ZOMBIE_GO[0][63:48];
						map[1] = ZOMBIE_GO[1][63:48];  
						map[2] = ZOMBIE_GO[2][63:48];  
						map[3] = ZOMBIE_GO[3][63:48];  
						map[4] = ZOMBIE_GO[4][63:48];  
						map[5] = ZOMBIE_GO[5][63:48];  
						map[6] = ZOMBIE_GO[6][63:48];
						map[7] = ZOMBIE_GO[7][63:48];		
					end
					else
					begin
						cnt_sec<=cnt_sec+32'b1;	
					end

					if(~start)
					begin
						row_count <= 0;
						ifstart <= 1;
						SCORE = 0;
						map[0] = 16'b0011000000000011;
						map[1] = 16'b0011000000000011;
						map[2] = 16'b0000000000000000;
						map[3] = 16'b0000011000011000;
						map[4] = 16'b0000011000011000;
						map[5] = 16'b0000000000000000;
						map[6] = 16'b0000000011000000;
						map[7] = 16'b0000000011000000;
					end
					else
					begin
						if(~level1)
						begin
							COUNTDOWN <= 7'd30;
						end
						else if(~level2)
						begin
							COUNTDOWN <= 7'd60;
						end
						else if(~level3)
						begin
							COUNTDOWN <= 7'd90;
						end
						else
						begin
						end
					end
				end
				if(cnt_dot == 4999)
				begin
					cnt_dot <= 32'b0;
					row_count <= row_count + 1;
					dot_col <= map[row_count];
					case (row_count)
						3'd0: dot_row <= 8'b01111111;
						3'd1: dot_row <= 8'b10111111;
						3'd2: dot_row <= 8'b11011111;
						3'd3: dot_row <= 8'b11101111;
						3'd4: dot_row <= 8'b11110111;
						3'd5: dot_row <= 8'b11111011;
						3'd6: dot_row <= 8'b11111101;
						3'd7: dot_row <= 8'b11111110;
					endcase
					if(ifstart)
					begin
						case({kill_row,kill_col})
						8'b0111_1111: down1 = 0;
						8'b1011_1111: down2 = 0;
						8'b1101_1111: down3 = 0;
						8'b0111_1110: //C
						begin
							if(down1 == 0 && map[0][0] == 1)
							begin
								down1 = 1;
								map[0] = map[0] >> 3;
								map[1] = map[1] >> 3;
								map[2] = map[2] >> 3;
								map[3] = map[3] >> 3;
								map[4] = map[4] >> 3;
								map[5] = map[5] >> 3;
								map[6] = map[6] >> 3;
								map[7] = map[7] >> 3;
								new = cnt_div%3; 
								SCORE <= SCORE +1;
								map[new*3] = map[new*3] + 16'b0011000000000000;
								map[new*3+1] = map[new*3+1] + 16'b0011000000000000;
							end
							else
							begin
							end
						end
						8'b1011_1110: //9
						begin
							if(down2 == 0 && map[3][0] == 1)
							begin
								down2 = 1;
								map[0] = map[0] >> 3;
								map[1] = map[1] >> 3;
								map[2] = map[2] >> 3;
								map[3] = map[3] >> 3;
								map[4] = map[4] >> 3;
								map[5] = map[5] >> 3;
								map[6] = map[6] >> 3;
								map[7] = map[7] >> 3;
								new = cnt_div%3; 
								SCORE <= SCORE +1;
								map[new*3]= map[new*3] + 16'b0011000000000000;
								map[new*3+1] = map[new*3+1] + 16'b0011000000000000;
							end
							else
							begin
							end
						end
						8'b1101_1110: //8
						begin
							if(down3 == 0 && map[6][0] == 1)
							begin
								down3 = 1;
								map[0] = map[0] >> 3;
								map[1] = map[1] >> 3;
								map[2] = map[2] >> 3;
								map[3] = map[3] >> 3;
								map[4] = map[4] >> 3;
								map[5] = map[5] >> 3;
								map[6] = map[6] >> 3;
								map[7] = map[7] >> 3;
								new = cnt_div % 3;
								SCORE <= SCORE + 1;
								map[new*3] = map[new*3] + 16'b0011000000000000;
								map[new*3+1] = map[new*3+1] + 16'b0011000000000000;
							end
							else
							begin
							end
						end
						endcase
						case(kill_row)
						4'b0111: kill_row=4'b1011;
						4'b1011: kill_row=4'b1101;
						4'b1101: kill_row=4'b0111;
						endcase
					end
				end
				else 
					cnt_dot <=cnt_dot +32'b1;
			end
		end

	 
always@(*)
begin

    case(SCORE%10)
        0: score_ssd0=7'b1000000;
        1: score_ssd0=7'b1111001;
        2: score_ssd0=7'b0100100;
        3: score_ssd0=7'b0110000;
        4: score_ssd0=7'b0011001;
        5: score_ssd0=7'b0010010;
        6: score_ssd0=7'b0000010;
        7: score_ssd0=7'b1111000;
        8: score_ssd0=7'b0000000;
        9: score_ssd0=7'b0010000;
	endcase
	case((SCORE/10)%10)
        0: score_ssd1= 7'b1000000;
        1: score_ssd1= 7'b1111001;
        2: score_ssd1= 7'b0100100;
        3: score_ssd1= 7'b0110000;
        4: score_ssd1= 7'b0011001;
        5: score_ssd1= 7'b0010010;
        6: score_ssd1= 7'b0000010;
        7: score_ssd1= 7'b1111000;
        8: score_ssd1= 7'b0000000;
        9: score_ssd1= 7'b0010000;
	endcase
	case((SCORE/100)%10)
        0: score_ssd2= 7'b1000000;
        1: score_ssd2= 7'b1111001;
        2: score_ssd2= 7'b0100100;
        3: score_ssd2= 7'b0110000;
        4: score_ssd2= 7'b0011001;
        5: score_ssd2= 7'b0010010;
        6: score_ssd2= 7'b0000010;
        7: score_ssd2= 7'b1111000;
        8: score_ssd2= 7'b0000000;
        9: score_ssd2= 7'b0010000;
	endcase
end

always@(COUNTDOWN)
begin
	case(COUNTDOWN%10)
			0: countdown_ssd0=7'b1000000;
			1: countdown_ssd0=7'b1111001;
			2: countdown_ssd0=7'b0100100;
			3: countdown_ssd0=7'b0110000;
			4: countdown_ssd0=7'b0011001;
			5: countdown_ssd0=7'b0010010;
			6: countdown_ssd0=7'b0000010;
			7: countdown_ssd0=7'b1111000;
			8: countdown_ssd0=7'b0000000;
			9: countdown_ssd0=7'b0010000;
	endcase
		case((COUNTDOWN/10)%10)
			0: countdown_ssd1= 7'b1000000;
			1: countdown_ssd1= 7'b1111001;
			2: countdown_ssd1= 7'b0100100;
			3: countdown_ssd1= 7'b0110000;
			4: countdown_ssd1= 7'b0011001;
			5: countdown_ssd1= 7'b0010010;
			6: countdown_ssd1= 7'b0000010;
			7: countdown_ssd1= 7'b1111000;
			8: countdown_ssd1= 7'b0000000;
			9: countdown_ssd1= 7'b0010000;
	endcase
end


always@(SCORE)
begin
	if(SCORE == 0)
		led = 10'd0;
	else
	begin
	if(SCORE%20 == 0 && SCORE < 201)
		led[SCORE/20 - 1] <= 1;
	else
	begin
	end
	end
end
endmodule 