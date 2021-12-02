function PTP_img = ptp(inp)

[rows,columns] = size(inp);
PTP_img = zeros(rows,columns);

for row = 2 : rows - 1   
    for col = 2 : columns - 1    
        centerPixel = inp(row, col);
        pixel7=inp(row-1, col-1) > centerPixel;  %%-1-1  225deg
        pixel6=inp(row-1, col) > centerPixel;    %%-10   180deg
        pixel5=inp(row-1, col+1) > centerPixel;  %%-11   135deg
        pixel4=inp(row, col+1) > centerPixel;    %%01    90deg
        pixel3=inp(row+1, col+1) > centerPixel;  %%11    45deg
        pixel2=inp(row+1, col) > centerPixel;    %%10    0deg  
        pixel1=inp(row+1, col-1) > centerPixel;  %%1-1   315deg 
        pixel0=inp(row, col-1) > centerPixel;    %% 0-1  270deg   
        PTP_img(row, col) = uint8( pixel7 * 2^7 + pixel6 * 2^6 + pixel5 * 2^5 + pixel4 * 2^4 +pixel3 * 2^3 + pixel2 * 2^2 + pixel1 * 2 + pixel0);

    end    
end 

end

