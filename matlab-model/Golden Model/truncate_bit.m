function out = truncate_bit(num_original, A_in, B_in, A_out, B_out)

% num_original = -20;
% A_in = 8;
% B_in = 1;
% A_out = 6;
% B_out = 0;

if num_original < 0
    num = -num_original;
else
    num = num_original;
end

d2b = fix(rem(num*pow2(-(A_in-1):B_in),2));

if num_original >= 0
    d2b = d2b;
else
    d2b = ~d2b;
    n = sum(d2b(1:(A_in+B_in)).*2.^[(A_in+B_in-1):-1:0]);
    n = n + 1;
    d2b = fix(rem(n*pow2(-(A_in+B_in-1):0),2));
end

% Cut bit

d2b_new = d2b(1:A_out + B_out);

% convert back
if num_original >= 0
    out = d2b_new*pow2(A_out-1:-1:-B_out).';
else
    d2b_new = ~d2b_new;
    n = sum(d2b_new(1:(A_out+B_out)).*2.^[(A_out+B_out-1):-1:0]);
    n = n + 1;
    d2b = fix(rem(n*pow2(-(A_out+B_out-1):0),2));
    out = -d2b*pow2(A_out-1:-1:-B_out).';
end