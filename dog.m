function [octave gauss]=dog(im,sigm,s,o)
[M,N]=size(im);

k=2^(1/s);
gauss{1}(:,:,1)=gsmooth(im,sigm);  %�����һ����Ӱ˶ȵĸ�˹�任
for i=2:s+3
    gauss{1}(:,:,i)=gsmooth(im,sigm*k^(i-1));%�����һ��������Ӱ˶ȵĸ�˹�任
end
for i=2:o
    gauss{i}(:,:,1)=halvesize(gauss{i-1}(:,:,end+1-s));
    for j=2:s+3
        gauss{i}(:,:,j)=gsmooth(gauss{i}(:,:,1),sigm*k^(j-1));%��������������Ӱ˶ȵĸ�˹�任
    end
end %��������˹�任 gaussΪ��ά�ռ䣬�ֱ��ǵ�n octave ��m scale ��i��j�е�ֵ
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
J=I(1:2:end,1:2:end);%2��ȡһ�У�2��ȡһ��

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