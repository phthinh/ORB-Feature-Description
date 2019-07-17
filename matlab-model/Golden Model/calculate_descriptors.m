function descriptors = calculate_descriptors2(im, corners, rotatex, rotatey)

descriptors = zeros(size(corners,1), 256);

for ii = 1:size(corners,1)
        for jj = 1:512
            if rotatex(ii,jj) < 1
                rotatex(ii,jj) = 1;
            end
            if rotatey(ii,jj) < 1
                rotatey(ii,jj) = 1;
            end
            if rotatex(ii,jj) > 37
                rotatex(ii,jj) = 37;
            end
            if rotatey(ii,jj) > 37
                rotatey(ii,jj) = 37;
            end
        end
end

for i = 1:size(corners,1)
    patch = im(corners(i,1)-18:corners(i,1)+18,corners(i,2)-18:corners(i,2)+18);
    for j = 1:size(descriptors,2)
        
        % check
%         disp(rotatex(j*2-1));
%         disp(rotatey(j*2-1));
%         disp(rotatex(j*2));
%         disp(rotatey(j*2));
        if patch(rotatex(i,j*2-1), rotatey(i,j*2-1)) < patch(rotatex(i,j*2), rotatey(i,j*2))
            descriptors(i,j) = 1;
        end
    end
end