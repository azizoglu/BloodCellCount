 % countCell.m
% -------------------------------------------------------------------
% Gökhan AZİZOĞLU
% Date:    02/01/2021
% -------------------------------------------------------------------
function [count] = countCell(imagePath,colorType)
    close all
    clc
    %% Test Image
    %Data1\1..4.jpg -> Monochrome
    %Data2\1..5.jpg -> Multicoloured
    %% Reading Image
    coloredImage = imread(imagePath);
    %% Single Color
    if strcmp(colorType,'Monochrome') == 1 
        %% Convert Image to Gray 
        [~,~,colorChannel] = size(coloredImage);   
        if colorChannel > 1    
         grayImage = rgb2gray(coloredImage);
        end
        %% Binarize Gray Image
        bwImage = imbinarize(grayImage);
        %% Complement of Gray Image
        bwImage = imcomplement(bwImage);
        %% Enhance Image
        imFill = imfill(bwImage,'holes');
        se = strel('disk',2);
        imOpened = imopen(imFill,se);
        imOpened = bwareaopen(imOpened,100);
        %% Watershed Trasnform for Stacked Cells
        D = bwdist(~imOpened);
        D = -D;
        L = watershed(D);
        imOpened(L==0)=false;
         %% Enhance Watershed Trasformed Image
        se = strel('disk',2);
        imOpened = imopen(imOpened,se);
        imOpened = bwareaopen(imOpened,50);
    end
    %% Multi Color
    if strcmp(colorType,'Multicoloured') == 1    
        %% HSV Color Space
        hsvThMin = 0.35;
        hsvThMax = 1.00;
        
        hsvImage = rgb2hsv(coloredImage);
        grayImage = im2gray(coloredImage);
        bwHSV = (hsvImage(:,:,2) >= hsvThMin ) & (hsvImage(:,:,2) <= hsvThMax);
        bwHSV = imfill(bwHSV,'holes');
        %% CIELAB Color Space
        labThMin = -100;
        labThMax = -25;
        
        labImage = rgb2lab(coloredImage);
        bwLAB = (labImage(:,:,3) >= labThMin ) & (labImage(:,:,3) <= labThMax);
        bwLAB = imfill(bwLAB,'holes');
        %% YCbCr Color Space
        yThMin = 155;
        yThMax = 250;
        
        ycbceImage = rgb2ycbcr(coloredImage);
        bwYCbCr = (ycbceImage(:,:,2) >= yThMin ) & (ycbceImage(:,:,2) <= yThMax);
        bwYCbCr = imfill(bwYCbCr,'holes');
        %% Combine All Color Space
        bwImage = bwHSV>=1 & bwLAB>=1 & bwYCbCr>=1;
         %% Enhance Image
        imFill = imfill(bwImage,'holes');
        se = strel('disk',2);
        imOpened = imopen(imFill,se);
        imOpened = bwareaopen(imOpened,100);
    end
    %% Region Properties
    s = regionprops(imOpened,grayImage,{'Centroid','WeightedCentroid'});
    figure(1);
    imshow(coloredImage);
    title('Tespit Edilen Hücreler'); 
    hold on
    numObj = numel(s);
    for k = 1 : numObj
        plot(s(k).WeightedCentroid(1), s(k).WeightedCentroid(2), 'g*','MarkerSize',10)
        plot(s(k).Centroid(1), s(k).Centroid(2), 'bo','MarkerSize',10)
    end
    hold off
    count=numObj;
    fprintf("Total Cell Count: %d\n",count);
    figure(2);
    subplot(2,2,1);imshow(coloredImage);title('Colored Image');
    subplot(2,2,2);imshow(grayImage);title('Gray Image');
    subplot(2,2,3);imshow(bwImage);title('Before Enhancement');
    subplot(2,2,4);imshow(imOpened);title('After Enhancement');
end