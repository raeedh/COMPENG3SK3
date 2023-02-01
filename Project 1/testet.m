 k=single(1);
 error(k)=single(1);
 total(k)=single(0);
 while error(k) > single(0.15)
      k = k + 1;
      total(k)=((-1).^(k+1))./k;
      error(k)=abs(total(k)-total(k-1));
 end