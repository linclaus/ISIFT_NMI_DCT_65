function [octave gauss]=dog(im,sigm,s,o)
[M,N]=size(im);

k=2^(1/s);
gauss{1}(:,:,1)=gsmooth(im,sigm);  %求出第一层的子八度的高斯变换
for i=2:s+3
    gauss{1}(:,:,i)=gsmooth(im,sigm*k^(i-1));%求出第一层的其余子八度的高斯变换
end
for i=2:o
    gauss{i}(:,:,1)=halvesize(gauss{i-1}(:,:,end+1-s));
    for j=2:s+3
        gauss{i}(:,:,j)=gsmooth(gauss{i}(:,:,1),sigm*k^(j-1));%求出其余层的所有子八度的高斯变换
    end
end %生成作高斯变换 gauss为四维空间，分别是第n octave 第m scale 第i行j列的值
for i=1:o
    for j=2:s+3
        octave{i}(:,:,j-1)=gauss{i}(:,:,j)-gauss{i}(:,:,j-1);
    end
end
% 
% gauss(:,:,1)=gsmooth(im,sigm/k);
% for i=2:s*o+3
%     gauss(:,:,i)=gsmooth(im,sigm*k^(i-2));
% end
% % octave=gauss;
% for i=1:s*o+2
%     octave(:,:,i)=gauss(:,:,i+1)-gauss(:,:,i);
% end


function img=gsmooth(Im,sigm)
w=fspecial('gaussian',ceil((6*sigm+1)),sigm);
img=imfilter(Im,w);
        
function J = halvesize(I)
J=I(1:2:end,1:2:end);%2行取一行，2列取一列

function J = doubleSize(I)
[M,N]=size(I) ;
J = zeros(2*M,2*N) ;
J(1:2:end,1:2:end) = I ;
J(2:2:end-1,2:2:end-1) = ...
	0.25*I(1:end-1,1:end-1) + ...
	0.25*I(2:end,1:end-1) + ...
	0.25*I(1:end-1,2:end) + ...
	0.25*I(2:end,2:end) ;
J(2:2:end-1,1:2:end) = ...
	0.5*I(1:end-1,:) + ...
    0.5*I(2:end,:) ;
J(1:2:end,2:2:end-1) = ...
	0.5*I(:,1:end-1) + ...
    0.5*I(:,2:end) ;