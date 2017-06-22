function [ out ] = getgbvsmap( scr )

struc=Gscale(scr,6);
[m1,n1]=size(struc(6).img);
markov1=getmarkovtrans(struc(6).img);
activate=geteqdis(markov1,20,m1,n1);
markov2=normgbvs(activate);
out=geteqdis(markov2,20,m1,n1);

end

