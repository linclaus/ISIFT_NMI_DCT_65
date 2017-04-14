clc
clear
f1=imread('lena.jpg');

G = fspecial('gaussian', [5 5], 30);
f2 = imfilter(f1,G,'same');

% f1=imrotate(f1,45,'nearest');
%f2=imread('lena_resize.jpg');
%f2=imrotate(f1,45,'nearest');
% f2=f2+30;
%f2=imrotate(f2,-90,'nearest'); 
%imshow(f2);
%f2=imresize(f2,1.5,'nearest');
%f2=imresize(f1,1.5,'nearest');
image1=im2double(rgb2gray(f1));
image2=im2double(rgb2gray(f2));

[keypt1 desc1]=sift(image1);

[keypt2 desc2]=sift(image2);
cnt=size(keypt1,1);
S=3;
O=3;
sigm=1.6;
[n,d]=knnsearch(desc2,desc1,'k',2);
num=0;
% num=20;
[dist,idx]=sort(d(:,1));
% for i=1:num
%     matchset(i,1)=(idx(i));
%     matchset(i,2)=n(idx(i));
% end
for i=1:cnt
    if d(i,1)/d(i,2)<0.8%&&idx(i)<500
        num=num+1;
        matchset(num,1)=i;
        matchset(num,2)=n(i,1);
    end
end
% save('mt.mat','matchset');
 NMImatch=[keypt1(matchset(:,1),[1 2]) keypt2(matchset(:,2),[1 2]) keypt1(matchset(:,1),5)-keypt2(matchset(:,2),5)];
 matchset=matchset(find(abs(NMImatch(:,5))<0.05),:);
 num=size(matchset,1);

[M1,N1]=size(image1);
[M2,N2]=size(image2);

image=ones(max(M1,M2),N1+N2,3);
image(1:M1,1:N1,:)=im2double(f1);
image(1:M2,N1+1:N1+N2,:)=im2double(f2);
figure;
imshow(image);
hold on
for i=1:num
    t=0:1;
    o1=floor((keypt1(matchset(i,1),3)-1)/O)+1;
    s1=mod(keypt1(matchset(i,1),3)-1,O)+1;
    x1=keypt1(matchset(i,1),2)*2^(o1-1);
    y1=keypt1(matchset(i,1),1)*2^(o1-1);
    o2=floor((keypt2(matchset(i,2),3)-1)/O)+1;
    s2=mod(keypt2(matchset(i,2),3)-1,O)+1;
    x2=keypt2(matchset(i,2),2)*2^(o2-1)+N1;
    y2=keypt2(matchset(i,2),1)*2^(o2-1);
    plot(x1+t*(x2-x1),y1+t*(y2-y1));
    hold on
end
% line=0:1:10;
% for i=1:cnt
%     plot(keypt(i,2)+cos(keypt(i,4))*line,keypt(i,1)+sin(keypt(i,4))*line);hold on
% end
% sita=0:pi/20:2*pi;
% for i=1:cnt
%     plot(keypt(i,2)+2^(keypt(i,3)/S)*sigm*cos(sita),keypt(i,1)+2^(keypt(i,3)/S)*sigm*sin(sita));hold on
% end

