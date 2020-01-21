function out = str_select(str, spre, spost, npre, npost)
% by Siyu(sywangr@email.arizona.edu)
if ~exist('npre')
    npre = 1;
end
if ~exist('npost')
    npost = 1;
end
str = char(str);
idxpre = strfind(str, spre);
idxpost = strfind(str, spost);
n1 = idxpre(npre) + length(spre);
n2 = idxpost(npost) - 1;
out = str(n1:n2);
end