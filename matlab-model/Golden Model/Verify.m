workpath='..\..\work\'; 

a = fopen([workpath 'data\fpga_tb_output.txt'], 'r');
t = fscanf(a ,'%s\n', 500);

descriptorsFPGA = zeros(size(corners_Filter,1), 256);

for i = 1:size(corners_Filter,1)
    each_line = t(i*256-255:i*256);
    zrr = zeros(1,256);
    for m = 1:256
        zrr(m) = str2num(each_line(m));
    end
    descriptorsFPGA(i,:) = zrr;
end
Golden_RBRIEF;
%error(i) = sum(fliplr(zrr) == descriptors(i,:));
% second, remove 000000
des_1 = [];
des_2 = [];

for i = 1:size(descriptorsFPGA,1)
    if str2num(num2str(descriptorsFPGA(i,:), '%d')) ~= 0
        des_1 = [des_1; descriptors(i,:)];
        des_2 = [des_2; descriptorsFPGA(i,:)];
    end
end

error = zeros(1,size(des_1,1));
% last compare

for i = 1:size(des_1,1)
    error(i) = sum(fliplr(des_2(i,:)) == des_1(i,:));
end
figure()
bar(error);
disp(sum(error(:))/size(des_1,1));
