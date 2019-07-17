function [cos_out, sin_out] = atan2_function(m01, m10, N, BIT_MULTIPLY)
% N is the number of discreate atan values in table
% BIT_MULTIPLY is the number of bits to represent the atan's values.

% Determ4ine max bit so save m01, m10
% % 
% m01 = 345; % y
% m10 = -485; % x

% adjust value of m10, m01 to be always positive and index is the quadrant
if m01 > 0 && m10 <0 % 2nd quadrant
    new = [cos(-pi/2) -sin(-pi/2);sin(-pi/2) cos(-pi/2)] * [m10;m01];
    index = 1;
elseif m01 < 0 && m10 < 0 %% 3rd quadrant
    new = [cos(-pi) -sin(-pi);sin(-pi) cos(-pi)] * [m10;m01];
    index = 2;
elseif m01 <0 && m10 > 0 %% 4th quadrant
    new = [cos(pi/2) -sin(pi/2);sin(pi/2) cos(pi/2)] * [m10;m01];
    index = 3;
elseif m10 == 0 && m01 > 0
    new = [abs(m01);m10];
    index = 4;
elseif m10 == 0 && m01 < 0
    new = [abs(m01); m10];
    index = 5;
elseif m01 == 0 && m10 > 0
    new = [m10; 0];
    index = 6;
elseif m01 == 0 && m10 < 0
    new = [abs(m10); 0];
    index = 7;
else
    new = [m10; m01];
    index = 0;
end
m10_adj = new(1);
m01_adj = new(2);

BIT = 22;
% make sure A + BIT <= BIT_MULTIPLY + BIT
% N = 25;
% BIT_MULTIPLY = 9;

%theta_vec = pi/2 * [0:1:N-1]/N;
theta_vec = pi/2 * [0:1:N-1]/N + pi/(4*N);
%tan_table = zeros(1,N);
%cos_table = zeros(1,N);
%sin_table = zeros(1,N);

%for i = 0:N-1
%    tan_table(i+1) = tan(pi/2 * i/N);
tan_table = tan(theta_vec);
sin_table = sin(theta_vec);
cos_table = cos(theta_vec);
%end
%cos_table(1) = 0.9999;

% the integer part is A, the fraction part is B
B = 64;
max_tan = floor(max(tan_table));

i=1;
while 1
    climax = 2^i;
    if max_tan < climax
        break;
    end
    i = i+1;
end
i = i+1;
A = i-1;



% approximate tan table to BIT_MULTIPLY bits by truncating
% then shift left (BIT_MULTIPLY - A) bits -> constant_table.
constant_table = zeros(1,N);
for i = 1:N
    d2b = fix(rem(tan_table(i) * pow2(-(A-1):B),2)); 
    % the inverse transformation
    b2d = d2b(1:BIT_MULTIPLY) * pow2(BIT_MULTIPLY-1:-1:0).';
    constant_table(i) = b2d;
end

y_table = zeros(1,N);
for i = 1:N
    y_table(i) = fix(constant_table(i) * m10_adj);
end

% formating m01_adj and shift left (BIT_MULTIPLY - A) bits to represent in 22 bits
d2b = fix(rem(m01_adj * pow2(-(BIT-1):0),2)); 

m01_binary = zeros(1,BIT+BIT_MULTIPLY);
m01_binary(BIT+BIT_MULTIPLY-(BIT+BIT_MULTIPLY-A)+1 : BIT+BIT_MULTIPLY-(BIT+BIT_MULTIPLY-A-BIT+1)+1) = d2b;

m01_form = m01_binary*pow2(BIT+BIT_MULTIPLY-1:-1:0).';

% best match finding
error_table = zeros(N,1);
for k = 1:N
    error_table(k) = abs(y_table(k) - m01_form);
end

[m_num, index_num] = min(error_table);

cosx = cos_table(index_num);
sinx = sin_table(index_num);
if index == 0
    cos_out = cosx;
    sin_out = sinx;
elseif index == 1
    cos_out = -sinx;
    sin_out = cosx;
elseif index == 2
    cos_out = -cosx;
    sin_out = -sinx;
elseif index == 3 % first quadrant
    cos_out = sinx;
    sin_out = -cosx;
elseif index == 4
    cos_out = sinx;
    sin_out = cosx;
elseif index == 5
    cos_out = sinx;
    sin_out = -cosx;
elseif index == 6
    cos_out = cosx;
    sin_out = sinx;
elseif index == 7
    cos_out = -cosx;
    sin_out = sinx;
end

%for verification purpose
theta_matlab = atan2(m01,m10);
cos_matlab = cos(theta_matlab);
sin_matlab = sin(theta_matlab);
