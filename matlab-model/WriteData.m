%addpath('./Golden Model')


image_patch = '..\dataSet\bike\img1.ppm';
workpath='..\work\'; 

mkdir(workpath,'data');
im = imread(image_patch);
im = imresize(im, [480, 640]);

if ndims(im) == 3
    im = rgb2gray(im);
end

% Write data for Golden Model
fid = fopen([workpath 'data\image.txt'], 'w');
% read to a file
for i = 1:size(im,1)
    for j = 1:size(im,2)
        fprintf(fid, '%d\n', im(i,j));
    end
end
fclose(fid);

% Write data for Test in modelSim
fid = fopen([workpath 'data\image.txt'], 'w');
fprintf(fid, '%d\n', 0);
% read to a file
for i = 1:size(im,1)
    for j = 1:size(im,2)
        fprintf(fid, '%d', im(i,j));
        fprintf(fid, '\n');
    end
end
fclose(fid);


% Harris corners
cd('./Golden Model')
corners = BaseLineHarris(double(im));
cd('../')
corners = [corners(:,2), corners(:,1)];
% filter coordinate whose x <= 18 || x >= 463 || y <= 18 || y >= 623
corners_Filter = [];
for i = 1:size(corners,1)
    if (corners(i,1) <= 18 || corners(i,1) >= 463 ...
        || corners(i,2) <= 18 || corners(i,2) >= 623)
    else
        corners_Filter = [corners_Filter; corners(i,:)];
    end
end

% Write Corner into a cornerFile so modelsim could read

fid = fopen([workpath 'data\isCorner.txt'], 'w');
for i = 1:size(corners_Filter,1)
    fprintf(fid, '%d\n', ((corners_Filter(i,1)-1)*640 + corners_Filter(i,2))*2-1);
end
fclose(fid);
