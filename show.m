clc
clear
f=imread('lena.jpg');
image=im2double(rgb2gray(f));
[keypt desc]=sift(image);

cnt=size(keypt,1);
S=3;
O=3;
sigm=1.6;
imshow(f);hold on

line=0:1;
save('d2.mat','desc');
save('k2.mat','keypt');
sita=0:pi/20:2*pi;
for i=1:cnt
    o=floor((keypt(i,3)-1)/O)+1;
    s=mod(keypt(i,3)-1,O)+1;
    x=keypt(i,2)*2^(o-1);
    y=keypt(i,1)*2^(o-1);
    sigm0=2^(keypt(i,3)/S)*2^(o-1)*sigm;
    plot(x+10*cos(keypt(i,4))*line,y+10*sin(keypt(i,4))*line);hold on
    plot(x+sigm0*cos(sita),y+sigm0*sin(sita));hold on
end
