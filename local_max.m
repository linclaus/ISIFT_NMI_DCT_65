function [keypt,cnt]=find_max(octave,S,O,thresh)

cnt=0;
k=0.0001;
r=10;
r1=(r+1)^2/r;%threshold
for o=1:O
    for s=2:S+1
        [M,N,D]=size(octave{o});
        for i=20:M-20
            for j=20:N-20
                a=octave{o}(i,j,s);
                if a>thresh+k ...
                    && a>octave{o}(i-1,j-1,s-1)+k && a>octave{o}(i-1,j,s-1)+k && a>octave{o}(i-1,j+1,s-1)+k ...
                    && a>octave{o}(i,j-1,s-1)+k && a>octave{o}(i,j+1,s-1)+k && a>octave{o}(i+1,j-1,s-1)+k ...
                    && a>octave{o}(i+1,j,s-1)+k && a>octave{o}(i+1,j+1,s-1)+k && a>octave{o}(i-1,j-1,s)+k ...
                    && a>octave{o}(i-1,j,s)+k && a>octave{o}(i-1,j+1,s)+k && a>octave{o}(i,j-1,s)+k ...
                    && a>octave{o}(i,j+1,s)+k && a>octave{o}(i+1,j-1,s)+k && a>octave{o}(i+1,j,s)+k ...
                    && a>octave{o}(i+1,j+1,s)+k && a>octave{o}(i-1,j-1,s+1)+k && a>octave{o}(i-1,j,s+1)+k ...
                    && a>octave{o}(i-1,j+1,s+1)+k && a>octave{o}(i,j-1,s+1)+k && a>octave{o}(i,j+1,s+1)+k ...
                    && a>octave{o}(i+1,j-1,s+1)+k && a>octave{o}(i+1,j,s+1)+k && a>octave{o}(i+1,j+1,s+1)+k
                    
                    Dx = 0.5 * (octave{o}(i,j+1,s) - octave{o}(i,j-1,s));%(octave{o}(i,j-1,s) - octave{o}(i,j-1,s))
                    Dy = 0.5 * (octave{o}(i+1,j,s) - octave{o}(i-1,j,s)) ;
                    Ds = 0.5 * (octave{o}(i,j,s+1) - octave{o}(i,j,s-1)) ;
                    
                    Dxx = (octave{o}(i,j+1,s) + octave{o}(i,j-1,s) - 2.0 * octave{o}(i,j,s)) ;
                    Dyy = (octave{o}(i+1,j,s) + octave{o}(i-1,j,s) - 2.0 * octave{o}(i,j,s)) ;
                    Dss = (octave{o}(i,j,s+1) + octave{o}(i,j,s-1) - 2.0 * octave{o}(i,j,s)) ;
                    Dys = 0.25 * ( octave{o}(i+1,j,s+1) + octave{o}(i-1,j,s-1) - octave{o}(i-1,j,s+1) - octave{o}(i+1,j,s-1) ) ;
                    Dxy = 0.25 * ( octave{o}(i+1,j+1,s) + octave{o}(i-1,j-1,s) - octave{o}(i-1,j+1,s) - octave{o}(i+1,j-1,s) ) ;
                    Dxs = 0.25 * ( octave{o}(i,j+1,s+1) + octave{o}(i,j-1,s-1) - octave{o}(i,j-1,s+1) - octave{o}(i,j+1,s-1) ) ;
                    H=[Dxx,Dxy;Dxy,Dyy];
                    if trace(H)^2/det(H)<r1
                        cnt=cnt+1;
                        keypt(cnt,1)=i-1;
                        keypt(cnt,2)=j-1;
                        keypt(cnt,3)=(o-1)*S+s-1;
                        continue;
                    end
                end
            end
        end
    end
end