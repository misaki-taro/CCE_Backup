%RGB_YCbCr
clc;
clear all;
close all;

% RGB_data = imread('similarityMatrix.jpg');%相似矩阵
RGB_data = imread('similarity3.jpg');%normalize 后的相似矩阵

R_data =    RGB_data(:,:,1);
G_data =    RGB_data(:,:,2);
B_data =    RGB_data(:,:,3);

%imshow(RGB_data);

[ROW,COL, DIM] = size(RGB_data);

Y_data = zeros(ROW,COL);
Cb_data = zeros(ROW,COL);
Cr_data = zeros(ROW,COL);
Gray_data = RGB_data;

for r = 1:ROW
    for c = 1:COL
        Y_data(r, c) = 0.299*R_data(r, c) + 0.587*G_data(r, c) + 0.114*B_data(r, c);
        Cb_data(r, c) = -0.172*R_data(r, c) - 0.339*G_data(r, c) + 0.511*B_data(r, c) + 128;
        Cr_data(r, c) = 0.511*R_data(r, c) - 0.428*G_data(r, c) - 0.083*B_data(r, c) + 128;
    end
end

Gray_data(:,:,1)=Y_data;
Gray_data(:,:,2)=Y_data;
Gray_data(:,:,3)=Y_data;

figure;
imshow(Gray_data);

%Median Filter      中值滤波
imgn = imnoise(Gray_data,'salt & pepper',0.02); %add noise to image

figure;
imshow(imgn);

Median_Img = Gray_data;
for r = 2:ROW-1
    for c = 2:COL-1
        median3x3 =[imgn(r-1,c-1)    imgn(r-1,c) imgn(r-1,c+1)
                    imgn(r,c-1)      imgn(r,c)      imgn(r,c+1)
                    imgn(r+1,c-1)      imgn(r+1,c) imgn(r+1,c+1)];
        sort1 = sort(median3x3, 2, 'descend');
        sort2 = sort([sort1(1), sort1(4), sort1(7)], 'descend');
        sort3 = sort([sort1(2), sort1(5), sort1(8)], 'descend');
        sort4 = sort([sort1(3), sort1(6), sort1(9)], 'descend');
        mid_num = sort([sort2(3), sort3(2), sort4(1)], 'descend');
        Median_Img(r,c) = mid_num(2);
    end
end

figure;
imshow(Median_Img);

%Robert_Edge_Detect

Median_Img = double(Median_Img);
Robert_Threshold = 15;
Rober_Img = zeros(ROW,COL);
for r = 2:ROW-1
    for c = 2:COL-1
        Robert_x = Median_Img(r+1,c+1) - Median_Img(r,c);
        Robert_y = Median_Img(r+1,c) - Median_Img(r,c+1);
        Robert_Num = abs(Robert_x) + abs(Robert_y);
        %Robert_Num = sqrt(Sobel_x^2 + Sobel_y^2);
        if(Robert_Num > Robert_Threshold)
            Rober_Img(r,c)=0;
        else
            Rober_Img(r,c)=255;
        end
    end
end

figure;
imshow(Rober_Img);