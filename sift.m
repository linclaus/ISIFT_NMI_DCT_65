% clc
% clear
% f=imread('099.jpg');
% image=im2double(rgb2gray(f));
function [keypt,desc]=sift(image)
sigm=1.6; %高斯核参数
S=3;%Scale
O=3;%Octave
thresh = 0.04 / S / 2;
[octave gauss]=dog(image,sigm,S,O);%生成DOG空间 octave为四维空间，分别是第n octave 第m scale 第i行j列的值

           
[keypt1,cnt1]=local_max(octave,S,O,thresh);%找出全部的极值 cnt表示极值个数，keypt表示第n个关键点位置（去掉了不好的特征点）
for i=1:size(octave,2);
    oct{i}=-octave{i};
end
[keypt2,cnt2]=local_max(oct,S,O,thresh);

keypt=[keypt1;keypt2];
cnt=cnt1+cnt2;
% orientation=zeros(cnt,2,S*O);
% mag=zeros(M,N,S*O);
% angles=zeros(M,N,S*O);
fxx = [-0.5 0 0.5];                 
fyy = [-0.5;0;0.5];   
fxy=[-0.5,0,0;0,0,0;0,0,0.5];
fyx=[0,0,0.5;0,0,0;-0.5,0,0];
for o=1:O
    for s=2:S+1
        Ixx{o}(:,:,s-1)=imfilter(octave{o}(:,:,s),fxx);
        Iyy{o}(:,:,s-1)=imfilter(octave{o}(:,:,s),fyy);
        Ixy{o}(:,:,s-1)=imfilter(octave{o}(:,:,s),fxy);
        Iyx{o}(:,:,s-1)=imfilter(octave{o}(:,:,s),fyx);
        Ix{o}(:,:,s-1)=(Ixx{o}(:,:,s-1)+(Ixy{o}(:,:,s-1)+Iyx{o}(:,:,s-1))/2)/2;
        Iy{o}(:,:,s-1)=(Iyy{o}(:,:,s-1)+(Ixy{o}(:,:,s-1)-Iyx{o}(:,:,s-1))/2)/2;
        mag{o}(:,:,s-1)=sqrt(Ix{o}(:,:,s-1).^2+Iy{o}(:,:,s-1).^2);%求梯度大小和方向
        angles{o}(:,:,s-1)=atan2(Iy{o}(:,:,s-1),Ix{o}(:,:,s-1));
    end
end
nbins=36;

keytmp=[];
for i=1:cnt
    histo=zeros(1,nbins);%柱状图 10度为间隔
    xp=keypt(i,1);
    yp=keypt(i,2);
    o=floor((keypt(i,3)-1)/O)+1;
    s=mod(keypt(i,3)-1,O)+1;
    sigm0=2^((s+1)/S)*sigm;
    sigmw=1.5*sigm0;
    w=3*sigmw;
    wi=ceil(w);
    [M,N,D]=size(octave{o});
    m00=0;
    m10=0;
    m01=0;
    Jm=0;
    for xs = xp - min(wi, xp-1): min((M - 1), xp + wi)
        for ys = yp - min(wi, yp-1) : min((N-1), yp + wi)
            dx=xp-xs;
            dy=yp-ys;
            if dx^2+dy^2<w^2
               wc = exp(-(dx^2 + dy^2)/(2*sigmw^2));
               m00=m00+wc*gauss{o}(xs,ys,s);
               m10=m10+dy*wc*gauss{o}(xs,ys,s);
               m01=m01+dx*wc*gauss{o}(xs,ys,s);
               bin = ceil( nbins *  (angles{o}(xs, ys, s)+pi)/(2*pi) );
               histo(bin) = histo(bin) + wc * mag{o}(xs, ys, s);
            end
        end
    end
    cx=m10/m00;
    cy=m01/m00;
    for xs = xp - min(wi, xp-1): min((M - 1), xp + wi)
        for ys = yp - min(wi, yp-1) : min((N-1), yp + wi)
            dx=xp-xs;
            dy=yp-ys;
            if dx^2+dy^2<w^2
               wc = exp(-(dx^2 + dy^2)/(2*sigmw^2));
               Jm=Jm+((dx-cy)^2+(dy-cx)^2)*wc*gauss{o}(xs,ys,s);
            end
        end
    end    
    NMI=sqrt(Jm)/m00;%转动惯量标准化
    [theta_max,theta]=max(histo);
    theta_indx = find(histo> 0.8 * theta_max);
    if(size(theta_indx, 2)>1)
        continue;
    end
    theta=2*pi * (theta-0.5)/ nbins-pi;
    keypt(i,4)=theta;%求得每个keypoint点的主方向
    keypt(i,5)=NMI;
    keytmp=[keytmp;keypt(i,:)];
end
% plot(keypt(:,2),keypt(:,1),'r.');hold on'
keypt=keytmp;
desc=descriptor(keypt,S,O,sigm,mag,angles);
% for i=1:S*O
%     subplot(O,S,i)
%     imshow(octave(:,:,i));
% end
% n=1;
% for i=1:o
%     for j=1:s+2
%         subplot(o,s+2,n)
%         imshow(octive{i}(:,:,j))
%         n=n+1;
%     end
% end















