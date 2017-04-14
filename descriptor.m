function desc=descriptor(keypt,S,O,sigm,mag,angles)
cnt=size(keypt,1);
nbp=4;
desc=zeros(cnt,nbp*nbp*5);
for i=1:cnt
    
    o=floor((keypt(i,3)-1)/O)+1;
    s=mod(keypt(i,3)-1,O)+1;
    [M,N,temp]=size(mag{o});
    sigm0=2^((s+1)/S)*sigm;
%     sigm0=2^(keypt(i,3)/S)*sigm;
    sbp=3*sigm0;
    W=floor(sqrt(2)*sbp*(nbp+1)/2+0.5);
    xp=keypt(i,1);
    yp=keypt(i,2);
    theta0=keypt(i,4);
    sin0=sin(theta0);
    cos0=cos(theta0);
    index=0;
    histo=zeros(1,nbp*nbp*8);
    for xs = xp - min(W, xp-1): min((M - 1), xp + W)
        for ys = yp - min(W, yp-1) : min((N-1), yp + W)
            dx=xp-xs;
            dy=yp-ys;
            if dx^2+dy^2<W^2
                theta=angles{o}(xs,ys,s);
                theta=mod((theta-theta0),2*pi);
                nx=(dy*cos0+dx*sin0)/sbp;
                ny=(-dy*sin0+dx*cos0)/sbp;
                nt=theta/pi*4;
                wsigma = nbp/2;
                mags=mag{o}(xs,ys,s);
                wc=exp(-(nx*nx + ny*ny)/(2.0 * wsigma * wsigma));
                for cx=-1.5:1:1.5
                    for cy=-1.5:1:1.5
                        
                        if abs(nx-cx)<1&&abs(ny-cy)<1
                            ki=cx+2.5;
                            kj=cy+2.5;
                            ni1=ceil(nt);
                            ni2=floor(nt);
                            d=(1-abs(nx-cx))*(1-abs(ny-cy));
                            index=(((ki-1)*nbp+kj)-1)*8;
                            if ni1~=ni2
                                
                                dt1=1-(ni1-nt);
                                dt2=1-(-ni2+nt);
                                index1=index+mod(ni1,8)+1;
                                index2=index+ni2+1;
                                histo(index1)=histo(index1)+wc*d*dt1*mags;
                                histo(index2)=histo(index2)+wc*d*dt2*mags;
                            else
                                histo(index+ni1+1)=histo(index+ni1+1)+wc*d*mags;
                            end
                        end
                    end
                end
            end
        end
    end
    dct_sift=[];
    for j=1:16;
        dct_tmp=dct(histo((j-1)*8+1:(j-1)*8+8));
        dct_tmp([end-2:end])=[];
        dct_sift=[dct_sift dct_tmp];
    end
    desc(i,:)=dct_sift;
end
%desc = desc ./ norm(desc);
%indx = desc > 0.2;
%desc(indx) = 0.2;
%desc = desc ./ norm(desc);
                                
                            
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
    