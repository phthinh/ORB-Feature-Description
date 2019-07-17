workpath='..\..\work\'; 

POS = importdata('orb_descriptor_positions.txt');
POS1 = POS(:,1:2);
POS2 = POS(:,3:4);

x = zeros(512,1);
y = zeros(512,1);
for i = 1:256
    x(2*i-1) = POS1(i,1);
    x(2*i) = POS2(i,1);
    y(2*i-1) = POS1(i,2);
    y(2*i) = POS2(i,2);
end

% Read image
fid = fopen([workpath 'data\image.txt'], 'r');
t = fscanf(fid, '%d\n', 307200);
counter = 1;
im = zeros(480,640);
for i = 1:480
    for j = 1:640
        im(i,j) = t(counter);
        counter = counter + 1;
    end
end
fclose(fid);
% Harris corners
corners = BaseLineHarris(im);
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

%Centroid
m10 = zeros(size(corners_Filter,1),1);
m01 = zeros(size(corners_Filter,1),1);

for ii = 1:size(corners_Filter,1)
    % calculate region in circle, radius is
    for xx = -18:18
        for yy = -18:18
            hor_xx = xx + corners_Filter(ii,1);
            ver_yy = yy + corners_Filter(ii,2);
            m10(ii) = m10(ii) + (xx) * double(im(hor_xx, ver_yy));
            m01(ii) = m01(ii) + (yy) * double(im(hor_xx, ver_yy));
        end
    end
end
% PROP =======================================
Nbit_centroid = 12;

m01_prop = zeros(size(corners_Filter,1), 1);
m10_prop = zeros(size(corners_Filter,1), 1);
for ii = 1:size(corners_Filter,1)
    m01_prop(ii) = truncate_bit(m01(ii), 22,0,Nbit_centroid,0);
    m10_prop(ii) = truncate_bit(m10(ii), 22,0,Nbit_centroid,0);
end

% exact
trigoVec_prop = zeros(size(corners_Filter,1), 2);
for ii = 1:size(corners_Filter,1)
    trigoVec_prop(ii,1) = cos(atan2(m01(ii), m10(ii)));
    trigoVec_prop(ii,2) = sin(atan2(m01(ii), m10(ii)));
end
% =======

rX_exac = zeros(size(corners_Filter,1), 512);
rY_exac = zeros(size(corners_Filter,1), 512);
for ii = 1:size(corners_Filter,1)
        rX_exac(ii,:) = round(x .* trigoVec_prop(ii,1) - y .* trigoVec_prop(ii,2));
        rY_exac(ii,:) = round(x .* trigoVec_prop(ii,2) + y .* trigoVec_prop(ii,1));
end

descriptors = calculate_descriptors(im, corners_Filter, rX_exac + 19, rY_exac+19);
