function Corner_Index = BaseLineHarris(inputImage)
% inputImage = im;
workpath='..\..\work\'; 

%%FinalCode For BaseLineHarris Previous Supressed 20-6-2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
algorithm = 'HCD';     %Pruning4/BaseLine
simulationType = 'Matlab'       %Functional/GateLevel/Matlab/MatlabOriginal(for ppm files
imageCategory = 'bike'          %graf,bark,bikes,boat,leuven,trees,ubc,wall....any other at the same location
imageNo = 1; 
k = 0.0625;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(strcmp(imageCategory,'graf'))
     Threshold = 30000000000;   %Threshold = 10000000000;
elseif(strcmp(imageCategory,'bark'))
    Threshold = 4000000000; %Threshold = 1000000000;
elseif(strcmp(imageCategory,'bike'))
    Threshold = 9000000000; %Threshold = 1000000000;
elseif(strcmp(imageCategory,'boat'))
    Threshold = 300000000000;   %Threshold = 100000000000;
elseif(strcmp(imageCategory,'leuven'))
    Threshold = 50000000000; %Threshold = 10000000000;
elseif(strcmp(imageCategory,'trees'))
    Threshold = 160000000000;%Threshold = 150000000000;           %Changed from 10 zeros to get 500-1000 corners
elseif(strcmp(imageCategory,'ubc'))
    Threshold = 100000000000;%Threshold = 10000000000;
elseif(strcmp(imageCategory,'wall'))
    Threshold = 50000000000;    %Threshold = 10000000000;
end

outputCoordinateFileAddress = strcat([workpath 'data\'],algorithm,simulationType,'CornerCoordinate_','Output','.txt');

outputImageAddress = strcat([workpath 'data\'],algorithm,simulationType,'Output',imageCategory,'.jpg');
OutputFileId = fopen(outputCoordinateFileAddress,'w');



ImageHeight = size(inputImage,1);
ImageWidth = size(inputImage,2);

sobel_x =  [1 0 -1;
            1 0 -1;
            1 0 -1];
        
sobel_y = [1 1 1;
            0  0  0;
            -1  -1  -1];
        
gaussian = [1 2 1;
            2 4 2;
            1 2 1];

Ix = conv2(inputImage,sobel_x,'same');
Iy = conv2(inputImage,sobel_y,'same');

Ixx = Ix.^2;
Iyy = Iy.^2;
Ixy = Ix.*Iy;

Sxx = conv2(Ixx,gaussian,'same');
Syy = conv2(Iyy,gaussian,'same');
Sxy = conv2(Ixy,gaussian,'same');
NoOfNonZeroR = 0;
numOfRows = size(Sxx, 1);
numOfColumns = size(Sxx, 2);
R = zeros(ImageHeight,ImageWidth);
Corner = zeros(ImageHeight,ImageWidth);

for i=2:numOfRows-1
    for j=2:numOfColumns-1
        M = [Sxx(i,j) Sxy(i,j);
            Sxy(i,j) Syy(i,j)];
        R(i,j) = det(M) - k*(trace(M).^2);
        %RTest(i,j) = R(i,j);
         if (R(i,j) >= Threshold)
          R(i, j) = R(i,j);
          NoOfNonZeroR = NoOfNonZeroR + 1;
         else
             R(i,j)=0;
         end
    end
end

% nonmax suppression
count = 1;
for i=4:size(R,1)-3
    for j=4:size(R,2)-3
        %if(R(i,j)>R(i-1,j)&&R(i,j)>R(i+1,j)&&R(i,j)>R(i,j-1)&&R(i,j)>R(i,j+1)&&R(i,j)>R(i-1,j-1)&&R(i,j)>R(i-1,j+1)&&R(i,j)>R(i+1,j-1)&&R(i,j)>R(i+1,j+1))
        if R(i,j) == max(max(R(i-3:i+3,j-3:j+3))) && R(i,j) > 0 
            Corner(i,j) = 255;
            Corner_Index(count,:) = [j,i]; 
            count = count+1;
        else
            Corner(i,j) = 0;
        end
    end
end

for j=1:size(Corner_Index)
        fprintf(OutputFileId,'%3.3d %3.3d\r\n',Corner_Index(j,2),Corner_Index(j,1));
end
    
outputTitle = strcat('Detected Corners-',imageCategory,num2str(imageNo),'-',algorithm,'-',simulationType);
figure;imshow(uint8(inputImage));hold on;plot(Corner_Index(:,1), Corner_Index(:,2), 'r*');title(outputTitle);
saveas(gcf,outputImageAddress);
fclose(OutputFileId);
% clear all;
% close all;
% clc;
